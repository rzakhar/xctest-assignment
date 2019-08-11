//
//  NewReminderScreen.swift
//  TestTarget
//
//  Created by rzakhar on 10.08.2019.
//

import XCTest

final class NewReminderScreen: Screen {
    
    private var doneButton: XCUIElement { return app.navigationBars.buttons["Done"] }
    private var reminderNameTextView: XCUIElement { return app.textViews.firstMatch }
    private var alarmButton: XCUIElement { return app.staticTexts["Alarm"] }
    private var dateSwitch: XCUIElement { return app.switches["Remind me on a day"] }
    private var dayWheel: XCUIElement { return app.pickerWheels.firstMatch }
    private var reminderNotesTextView: XCUIElement { return app.textViews.lastMatch }
    
    enum NamedTimeIntervalsSinceNow: TimeInterval {
        case yesterday = -86400 // -1 * 60 * 60 * 24
        case today = 0
        case tomorrow = 86400
    }
    
    enum PriorityLabel: String {
        case none = "None"
        case low = "Low"
        case medium = "Medium"
        case high = "High"
    }
    
    @discardableResult
    func setName(_ name: String) -> Self {
        XCTContext.runActivity(named: "Set name to \(name)") { _ in
            reminderNameTextView.typeText(name)
        }
        
        return self
    }
    
    @discardableResult
    func setDate(_ interval: NamedTimeIntervalsSinceNow) -> Self {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        let date = Date.init(timeIntervalSinceNow: interval.rawValue)
        let dateStringValue = dateFormatter.string(from: date)
        
        XCTContext.runActivity(named: "Set date to \(dateStringValue)") { _ in
            dateSwitch.tap()
            alarmButton.tap()
            dayWheel.adjust(toPickerWheelValue: dateStringValue)
        }
        
        return self
    }
    
    @discardableResult
    func saveReminder() -> Self {
        XCTContext.runActivity(named: "Save reminder") { _ in
            doneButton.tap()
        }
        
        return self
    }
    
    @discardableResult
    func setPriority(_ priority: PriorityLabel) -> Self {
        let priorityValue = priority.rawValue
        
        XCTContext.runActivity(named: "Set priority to \(priorityValue)") { _ in
            app.segmentedControls.buttons[priorityValue].tap()
        }
        
        return self
    }
    
    @discardableResult
    func setNotes(_ notes: String) -> Self {
        XCTContext.runActivity(named: "Set notes to \(notes)") { _ in
            reminderNotesTextView.tap()
            reminderNotesTextView.typeText(notes)
        }
        
        return self
    }
}
