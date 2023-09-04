//
//  DropboxTestUITests.swift
//  DropboxTestUITests
//
//  Created by Alexander Sokolenko on 02.09.2023.
//

import XCTest
@testable import DropboxTest

final class DropboxTestUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        
        XCTAssertFalse(XCUIApplication().buttons[NSLocalizedString("Authorize", comment: "")].exists, "Open the app and authorize before running UI tests")
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor func testExample() async throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        XCTAssert(app.buttons[NSLocalizedString("Reload", comment: "")].exists)
        XCTAssert(app.buttons[NSLocalizedString("Log out", comment: "")].exists)
        var cells = app.descendants(matching: .cell).allElementsBoundByIndex
        while cells.count == 0 {
            try! await Task.sleep(for: Duration.seconds(1))
            cells = app.descendants(matching: .cell).allElementsBoundByIndex
        }
        for cell in cells {
            cell.tap()
            let infoButton = app.buttons[NSLocalizedString("Info", comment: "")]
            XCTAssert(infoButton.exists)
            while !infoButton.isEnabled {
                try! await Task.sleep(for: Duration.seconds(1))
            }
            infoButton.tap()
            let alert = app.alerts.element
            XCTAssert(alert.exists)
            XCTAssert(alert.staticTexts[NSLocalizedString("File info", comment: "")].exists)
            alert.buttons[NSLocalizedString("OK", comment: "")].tap()
            let backButton = app.buttons["Back"]
            XCTAssert(backButton.exists)
            backButton.tap()
        }
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
