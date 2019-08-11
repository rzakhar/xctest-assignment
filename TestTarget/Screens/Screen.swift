//
//  Screen.swift
//  TestTarget
//
//  Created by rzakhar on 10.08.2019.
//

import XCTest

class Screen {
    
    let app: XCUIApplication
    
    required init(of app: XCUIApplication) {
        self.app = app
    }
    
    func on<T: Screen>(_ screen: T.Type) -> T {
        if self is T {
            
            return self as! T
        } else {
            
            return screen.init(of: app)
        }
    }
}
