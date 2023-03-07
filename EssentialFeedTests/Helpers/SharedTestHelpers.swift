//
//  SharedTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Tarquinio Teles on 27/10/22.
//

import Foundation


func anyURL() -> URL { URL(string: "http://any-url.com")! }

func anyNSError() -> NSError{ NSError(domain: "any error", code: 1) }

func anyData() -> Data { Data("any data".utf8) }

