//
//  RemindersListScreen.swift
//  TestTarget
//
//  Created by rzakhar on 10.08.2019.
//

import XCTest

final class RemindersListScreen: Screen {
    
    private var editButton: XCUIElement { return app.buttons["Edit"] }
    private var doneButton: XCUIElement { return app.buttons["Done"] }
    private var remindersTable: XCUIElement { return app.tables.element }
    private var remindersCells: XCUIElementQuery { return remindersTable.cells }
    private let deleteButtonLabel = "Delete"
    private var listsStackButton: XCUIElement { return app.buttons["Stack of other lists"] }
    
    @discardableResult
    func checkRemindersCells(_ expectedCells: [(name: String, date: String, notes: String)]) -> Self {
        XCTContext.runActivity(named: "Check reminders count") { _ in
            let remindersCount = remindersCells.count
            
            XCTAssertEqual(expectedCells.count, remindersCount, "Unexpected count of reminders")
        }
        
        var cellIndex = 0
        
        for (name, date, notes) in expectedCells {
            XCTContext.runActivity(named: "Check reminder #\(cellIndex + 1): \(name) - \(date) - \(notes)") { _ in

                let cell = remindersCells.element(boundBy: cellIndex)
                let cellTitle = cell.buttons.element.label
                
                XCTAssertEqual(cellTitle, name, "Unexpected name of cell \(cellIndex)")
                
                if date != "" {
                    let cellDateSubtitle = cell.staticTexts.firstMatch.label
                    
                    XCTAssertTrue(cellDateSubtitle.contains(date),
                                  "Unable to see correct date subtitle \(date) of cell \(cellIndex)")
                }
                
                if notes != "" {
                    let cellNoteSubtitle = cell.staticTexts.lastMatch.label

                    XCTAssertEqual(cellNoteSubtitle, notes, "Unexpected notes of cell \(cellIndex)")
                }
                
                cellIndex += 1
            }
        }
        
        return self
    }
    
    @discardableResult
    func deleteReminder(index: Int) -> Self {
        let remindersCount = remindersCells.count

        let reminderCell = remindersCells.element(boundBy: index)
        XCTContext.runActivity(named: "Delete reminder #\(index + 1) – \(reminderCell.label)") { _ in

            editButton.tap()
            reminderCell.buttons.firstMatch.tap()
            reminderCell.buttons[deleteButtonLabel].tap()
            doneButton.tap()
            let updatedRemindersCount = remindersCells.count
            XCTAssertEqual(updatedRemindersCount,
                           remindersCount - 1,
                           "Reminders counter did not decrease")
        }
        
        return self
    }
    
    @discardableResult
    func deleteAllReminders() -> Self {
        let remindersCount = remindersCells.count
        
        if remindersCount > 0 {
            XCTContext.runActivity(named: "Delete all reminders") { _ in
                for _ in (1...remindersCount) {
                    let firstReminderCell = remindersCells.firstMatch
                    firstReminderCell.swipeLeft()
                    firstReminderCell.buttons[deleteButtonLabel].tap()
                }
                
                let updatedRemindersCount = remindersCells.count
                
                XCTAssertEqual(updatedRemindersCount, 0, "Reminders count is not equal to 0")
            }
        }
        
        return self
    }
    
    @discardableResult
    func openListsStackScreen() -> Self {
        XCTContext.runActivity(named: "Open lists stack screen") { _ in
            listsStackButton.tap()
        }
        
        return self
    }
}
