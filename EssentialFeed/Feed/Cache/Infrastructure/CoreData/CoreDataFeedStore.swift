//
//  CoreDataFeedStore.swift
//  EssentialFeed
//
//  Created by Tarquinio Teles on 03/11/22.
//

import CoreData

public final class CoreDataFeedStore {
    private static let modelName = "FeedStore"
    private static let model = NSManagedObjectModel
        .with(name: modelName, in: Bundle(for: CoreDataFeedStore.self))
    
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    enum LoadingError: Swift.Error {
        case modelNotFound
        case failedToLoadPersistentStores(Swift.Error)
    }
    
    public init(storeURL: URL) throws {
        guard let model = CoreDataFeedStore.model else {
            throw LoadingError.modelNotFound
        }
        
        do {
            container = try NSPersistentContainer.load(name: Self.modelName,
                                                       model: model,
                                                       url: storeURL)
            context = container.newBackgroundContext()
        } catch {
            throw LoadingError.failedToLoadPersistentStores(error)
        }
    }
    
    func performAsync(_ action: @escaping (NSManagedObjectContext) -> Void) {
        let context = self.context
        context.perform { action(context) }
    }
}
