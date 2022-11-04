//
//  ManagedFeedImage.swift
//  EssentialFeed
//
//  Created by Tarquinio Teles on 04/11/22.
//

import CoreData

@objc(ManagedFeedImage)
internal class ManagedFeedImage: NSManagedObject {
    @NSManaged internal var id: UUID
    @NSManaged internal var imageDescription: String?
    @NSManaged internal var location: String?
    @NSManaged internal var url: URL
    @NSManaged internal var cache: ManagedCache
}

extension ManagedFeedImage {
    internal static func images(from feed: [LocalFeedImage], in context: NSManagedObjectContext) -> NSOrderedSet {
        NSOrderedSet(array: feed.map { local in
            let managed = ManagedFeedImage(context: context)
            managed.id = local.id
            managed.imageDescription = local.description
            managed.location = local.location
            managed.url = local.url
            
            return managed
        })
    }
    
    internal var local: LocalFeedImage {
        LocalFeedImage(id: self.id, description: self.imageDescription, location: self.location, url: self.url)
    }
}
