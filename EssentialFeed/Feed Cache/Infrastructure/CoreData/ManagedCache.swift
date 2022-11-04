//
//  ManagedCache.swift
//  EssentialFeed
//
//  Created by Tarquinio Teles on 04/11/22.
//

import CoreData

@objc(ManagedCache)
internal class ManagedCache: NSManagedObject {
    @NSManaged internal var timestamp: Date
    @NSManaged internal var feed: NSOrderedSet
}

extension ManagedCache {
    internal static func find(in context: NSManagedObjectContext) throws -> ManagedCache? {
        let request = NSFetchRequest<ManagedCache>(entityName: ManagedCache.entity().name!)
        request.returnsObjectsAsFaults = false
        return try context.fetch(request).first
    }
    
    internal static func newUniqueInstance(in context: NSManagedObjectContext) throws -> ManagedCache {
        try ManagedCache.find(in: context).map(context.delete)
        return ManagedCache(context: context)
    }
    
    internal var localFeed: [LocalFeedImage] {
        feed
            .compactMap { ($0 as? ManagedFeedImage)?.local }
    }
}
