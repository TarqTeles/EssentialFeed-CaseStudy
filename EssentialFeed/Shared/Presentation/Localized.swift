//
//  Localized.swift
//  EssentialFeedTests
//
//  Created by Tarquinio Teles on 02/03/23.
//

import Foundation

final class Localized {
    static var bundle: Bundle {
        Bundle(for: Localized.self)
    }
}

extension Localized {
    enum Feed {
        static var table: String { "Feed" }

        static var title: String {
            NSLocalizedString(
                "FEED_VIEW_TITLE",
                tableName: table,
                bundle: bundle,
                comment: "Title for the feed view")
        }
    }
    
    enum Shared {
        static var table: String { "Shared" }

        static var loadError: String {
            NSLocalizedString(
                "GENERIC_CONNECTION_ERROR",
                tableName: table,
                bundle: bundle,
                comment: "Error message displayed when we can't load the resource from the server")
        }
    }
}
