//
//  EssentialFeed:EssentialFeed:Feed API:Helpers:HTTPURLResponse+StatusCode.swift
//  EssentialFeed
//
//  Created by Tarquinio Teles on 07/03/23.
//

import Foundation

extension HTTPURLResponse {
    private static var OK_200: Int { 200 }
    
    var isOK: Bool {
        statusCode == HTTPURLResponse.OK_200
    }
}
