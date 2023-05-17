//
//  CombineHelpers.swift
//  EssentialApp
//
//  Created by Tarquinio Teles on 27/03/23.
//

import Foundation
import Combine
import EssentialFeed

public extension HTTPClient {
    typealias Publisher = AnyPublisher<(Data, HTTPURLResponse), Error>
    
    func getPublisher(url: URL) -> Publisher {
        var task: HTTPClientTask?
        
        return Deferred {
            Future { completion in
                task = self.get(from: url, completion: completion)
            }
        }
        .handleEvents(receiveCancel: { task?.cancel() })
        .eraseToAnyPublisher()
    }
}

public extension Paginated {
    init(items: [Item], loadMorePublisher: (() -> AnyPublisher<Self, Error>)?) {
        self.init(items: items, loadMore: loadMorePublisher.map { publisher in
            return { completion in
                publisher()
                    .subscribe(Subscribers.Sink(
                    receiveCompletion: { result in
                        if case let .failure(error) = result {
                            completion(.failure(error))
                        }
                    },
                    receiveValue: { result in
                        completion(.success(result))
                    })
                )
            }
        })
    }
    
    var loadMorePublisher: (() -> AnyPublisher<Self, Error>)? {
        guard let loadMore = self.loadMore else { return nil }
        
        return {
            Deferred {
                Future(loadMore)
            }.eraseToAnyPublisher()
        }
    }
}

public extension LocalFeedLoader {
    typealias Publisher = AnyPublisher<[FeedImage], Error>
    
    func loadPublisher() -> Publisher {
        return Deferred {
            Future(self.load)
        }.eraseToAnyPublisher()
    }
}

public extension FeedImageDataLoader {
    typealias Publisher = AnyPublisher<Data, Error>
    
    func loadImageDataPublisher(from url: URL) -> Publisher {
        
        return Deferred {
            Future { completion in
                completion(Result {
                    try self.loadImageData(from: url)
                })
            }
        }.eraseToAnyPublisher()
    }
}

extension Publisher {
    func caching(to cache: FeedCache) -> AnyPublisher<Output, Failure> where Output == [FeedImage] {
        return handleEvents(receiveOutput: cache.saveIgnoringResult)
            .eraseToAnyPublisher()
    }
    
    func caching(to cache: FeedCache) -> AnyPublisher<Output, Failure> where Output == Paginated<FeedImage> {
        return handleEvents(receiveOutput: cache.saveIgnoringResult)
        .eraseToAnyPublisher()
    }
}

private extension FeedCache {
    func saveIgnoringResult(feed: [FeedImage]) {
        self.save(feed: feed) { _ in }
    }
    
    func saveIgnoringResult(page: Paginated<FeedImage>) {
        self.save(feed: page.items) { _ in }
    }
}

extension Publisher where Output == Data {
    func caching(to cache: FeedImageDataCache, using url: URL) -> AnyPublisher<Output, Failure> {
        return handleEvents(receiveOutput: { data in
            cache.saveIgnoringResult(data, for: url)
        }).eraseToAnyPublisher()
    }
}

private extension FeedImageDataCache {
    func saveIgnoringResult(_ data: Data, for url: URL) {
        try? self.save(data, for: url)
    }
}


extension Publisher {
    func fallback(to fallbackPublisher: @ escaping () -> AnyPublisher<Output, Failure>)
    -> AnyPublisher<Output, Failure> {
        self.catch { _ in fallbackPublisher() }.eraseToAnyPublisher()
    }
}

extension Publisher {
    func dispatchingOnMainQueue() -> AnyPublisher<Output, Failure> {
        receive(on: DispatchQueue.immediateWhenOnMainQueueScheduler).eraseToAnyPublisher()
    }
}

extension DispatchQueue {
    static var immediateWhenOnMainQueueScheduler: ImmediateWhenOnMainQueueScheduler {
        ImmediateWhenOnMainQueueScheduler.shared
    }
    
    struct ImmediateWhenOnMainQueueScheduler: Scheduler {
        typealias SchedulerTimeType = DispatchQueue.SchedulerTimeType
        typealias SchedulerOptions = DispatchQueue.SchedulerOptions
        
        var now: DispatchQueue.SchedulerTimeType {
            DispatchQueue.main.now
        }
        
        var minimumTolerance: DispatchQueue.SchedulerTimeType.Stride {
            DispatchQueue.main.minimumTolerance
        }
        
        static let shared = Self()

         private static let key = DispatchSpecificKey<UInt8>()
         private static let value = UInt8.max

         private init() {
             DispatchQueue.main.setSpecific(key: Self.key, value: Self.value)
         }

         private func isMainQueue() -> Bool {
             DispatchQueue.getSpecific(key: Self.key) == Self.value
         }

        func schedule(options: DispatchQueue.SchedulerOptions?, _ action: @escaping () -> Void) {
            guard isMainQueue() else {
                return DispatchQueue.main.schedule(options: options, action)
            }
            action()
        }
        
        func schedule(after date: DispatchQueue.SchedulerTimeType,
                      tolerance: DispatchQueue.SchedulerTimeType.Stride,
                      options: DispatchQueue.SchedulerOptions?,
                      _ action: @escaping () -> Void
        ) {
            DispatchQueue.main.schedule(after: date, tolerance: tolerance, options: options, action)
        }
        
        func schedule(after date: DispatchQueue.SchedulerTimeType,
                      interval: DispatchQueue.SchedulerTimeType.Stride,
                      tolerance: DispatchQueue.SchedulerTimeType.Stride,
                      options: DispatchQueue.SchedulerOptions?,
                      _ action: @escaping () -> Void
        ) -> Cancellable {
            DispatchQueue.main.schedule(after: date,
                                        interval: interval,
                                        tolerance: tolerance,
                                        options: options,
                                        action)
        }
    }
}

typealias AnyDispatchQueueScheduler = AnyScheduler<DispatchQueue.SchedulerTimeType, DispatchQueue.SchedulerOptions>

extension AnyDispatchQueueScheduler {
    static var immediateOnMainQueue: Self {
        DispatchQueue.immediateWhenOnMainQueueScheduler.eraseToAnyScheduler()
    }
}

extension Scheduler {
    func eraseToAnyScheduler() -> AnyScheduler<SchedulerTimeType, SchedulerOptions> {
        AnyScheduler(self)
    }
}

struct AnyScheduler<SchedulerTimeType: Strideable, SchedulerOptions>: Scheduler
where SchedulerTimeType.Stride: SchedulerTimeIntervalConvertible {
    
    private let _now: () -> SchedulerTimeType
    private let _minimumTolerance: () -> SchedulerTimeType.Stride
    private let _schedule: (SchedulerOptions?, @escaping () -> Void) -> Void
    private let _scheduleAfter: (SchedulerTimeType,
                                 SchedulerTimeType.Stride,
                                 SchedulerOptions?,
                                 @escaping () -> Void) -> Void
    private let _scheduleAfterInterval: (SchedulerTimeType,
                                         SchedulerTimeType.Stride,
                                         SchedulerTimeType.Stride,
                                         SchedulerOptions?,
                                         @escaping () -> Void) -> Cancellable

    init<S>(_ scheduler: S) where SchedulerTimeType == S.SchedulerTimeType,
    SchedulerOptions == S.SchedulerOptions, S: Scheduler {
        self._now = { scheduler.now }
        self._minimumTolerance = { scheduler.minimumTolerance }
        self._schedule = scheduler.schedule(options:_:)
        self._scheduleAfter = scheduler.schedule(after:tolerance:options:_:)
        self._scheduleAfterInterval = scheduler.schedule(after:interval:tolerance:options:_:)
    }
    
    var now: SchedulerTimeType { _now() }

    var minimumTolerance: SchedulerTimeType.Stride { _minimumTolerance() }

    func schedule(options: SchedulerOptions?, _ action: @escaping () -> Void) {
        _schedule(options, action)
    }

    func schedule(after date: SchedulerTimeType,
                  tolerance: SchedulerTimeType.Stride,
                  options: SchedulerOptions?,
                  _ action: @escaping () -> Void
    ) {
        _scheduleAfter(date, tolerance, options, action)
    }

    func schedule(after date: SchedulerTimeType,
                  interval: SchedulerTimeType.Stride,
                  tolerance: SchedulerTimeType.Stride,
                  options: SchedulerOptions?,
                  _ action: @escaping () -> Void
    ) -> Cancellable {
        _scheduleAfterInterval(date, interval, tolerance, options, action)
    }

}
