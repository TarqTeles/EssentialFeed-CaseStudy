//
//  SharedTestHelpers.swift
//  EssentialAppTests
//
//  Created by Tarquinio Teles on 16/03/23.
//

import Foundation

func anyNSError() -> NSError{ NSError(domain: "any error", code: 1) }

func anyURL() -> URL {
    URL(string: "https://any-url.com")!
}
