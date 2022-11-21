//
//  ManagedFeedImage.swift
//  EssentialFeed
//
//  Created by Tarquinio Teles on 04/11/22.
//

import CoreData

@objc(ManagedFeedImage)
class ManagedFeedImage: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var imageDescription: String?
    @NSManaged var location: String?
    @NSManaged var url: URL
    @NSManaged var cache: ManagedCache
}

extension ManagedFeedImage {
    static func images(from feed: [LocalFeedImage], in context: NSManagedObjectContext) -> NSOrderedSet {
        NSOrderedSet(array: feed.map { local in
            let managed = ManagedFeedImage(context: context)
            managed.id = local.id
            managed.imageDescription = local.description
            managed.location = local.location
            managed.url = local.url
            
            return managed
        })
    }
    
    var local: LocalFeedImage {
        LocalFeedImage(id: self.id, description: self.imageDescription, location: self.location, url: self.url)
    }
}
