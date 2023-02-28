//
//  FeedErrorViewModel.swift
//  EssentialFeediOS
//
//  Created by Tarquinio Teles on 28/02/23.
//

import Foundation

public struct FeedErrorViewModel {
    let message: String?
    
    static var noError: FeedErrorViewModel {
        FeedErrorViewModel(message: nil)
    }
    
    static func error(message: String) -> FeedErrorViewModel {
        FeedErrorViewModel(message: message)
    }
}
