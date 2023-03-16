//
//  XCTestCase+MemoryLeaksTracker.swift
//  EssentialAppTests
//
//  Created by Tarquinio Teles on 16/03/23.
//

import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock({ [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        })
    }
}
