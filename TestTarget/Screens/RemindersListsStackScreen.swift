//
//  RemindersListsStackScreen.swift
//  TestTarget
//
//  Created by rzakhar on 10.08.2019.
//

import XCTest

final class RemindersListsStackScreen: Screen {

    private var addButton: XCUIElement { return app.buttons["Add"] }
    private var newReminderButton: XCUIElement { return app.sheets.buttons["Reminder"] }
    private var remindersButton: XCUIElement { return app.buttons["Reminders"] }
    
    @discardableResult
    func openNewReminderScreen() -> Self {
        XCTContext.runActivity(named: "Open new reminder screen") { _ in
            addButton.tap()
            newReminderButton.tap()
        }
        
        return self
    }
    
    @discardableResult
    func openRemindersListScreen() -> Self {
        XCTContext.runActivity(named: "Open reminders list screen") { _ in
            if addButton.exists {
                remindersButton.tap()
            }
        }
        
        return self
    }
}
