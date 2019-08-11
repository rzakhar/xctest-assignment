//
//  Extensions.swift
//  TestTarget
//
//  Created by rzakhar on 11.08.2019.
//

import XCTest

extension XCUIElementQuery {
    /// The last element that matches the query.
    var lastMatch: XCUIElement {
        return self.element(boundBy: self.count - 1)
    }
}
