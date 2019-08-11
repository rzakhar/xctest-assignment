//
//  TestClass.swift
//  TestTarget
//
//  Created by rzakhar on 11.08.2019.
//

import XCTest

class TestClass: XCTestCase {
    let app = XCUIApplication(bundleIdentifier: "com.apple.reminders")
    
    var stepsChain: Screen!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        stepsChain = Screen(of: app)

        XCTContext.runActivity(named: "Open the app and clean it") { _ in
            app.launch()
            
            stepsChain
                .on(RemindersListsStackScreen.self)
                .openRemindersListScreen()
                .on(RemindersListScreen.self)
                .deleteAllReminders()
                .openListsStackScreen()
        }
    }

    override func tearDown() {
        stepsChain = nil
        app.terminate()
        super.tearDown()
    }

    func testScenario() {
        let reminder1Name = "Reminder 1"
        let reminder2Name = "Reminder 2"
        let reminder3Name = "Reminder 2"
        let reminder3Notes = "Hello, experts!"
        var remindersDetails = [(name: reminder1Name, date: "Yesterday", notes: ""),
                                (name: reminder2Name, date: "Tomorrow", notes: ""),
                                (name: reminder3Name, date: "", notes: reminder3Notes)]
        
        XCTContext.runActivity(named: "Create Reminder #1") { _ -> Void in
            stepsChain
                .on(RemindersListsStackScreen.self)
                .openNewReminderScreen()
                .on(NewReminderScreen.self)
                .setName(reminder1Name)
                .setDate(.yesterday)
                .saveReminder()
        }
        XCTContext.runActivity(named: "Create Reminder #1") { _ -> Void in
            stepsChain
                .on(RemindersListsStackScreen.self)
                .openNewReminderScreen()
                .on(NewReminderScreen.self)
                .setName(reminder2Name)
                .setDate(.tomorrow)
                .setPriority(.low)
                .saveReminder()
        }
        XCTContext.runActivity(named: "Create Reminder #3") { _ -> Void in
            stepsChain
                .on(RemindersListsStackScreen.self)
                .openNewReminderScreen()
                .on(NewReminderScreen.self)
                .setName(reminder3Name)
                .setNotes(reminder3Notes)
                .saveReminder()
        }
        XCTContext.runActivity(named: "Check saved reminders") { _ -> Void in
            stepsChain
                .on(RemindersListsStackScreen.self)
                .openRemindersListScreen()
                .on(RemindersListScreen.self)
                .checkRemindersCells(remindersDetails)
        }
        XCTContext.runActivity(named: "Check deleting reminders") { _ -> Void in
            stepsChain
                .on(RemindersListScreen.self)
                .deleteReminder(index: 1)
            remindersDetails.remove(at: 1)
            stepsChain
                .on(RemindersListScreen.self)
                .checkRemindersCells(remindersDetails)
                .on(RemindersListScreen.self)
                .deleteAllReminders()
        }
    }
}
