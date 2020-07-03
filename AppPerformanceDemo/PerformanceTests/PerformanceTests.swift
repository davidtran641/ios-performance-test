//
//  PerformanceTests.swift
//  PerformanceTests
//
//  Created by Tran Duc on 7/3/20.
//

import XCTest

class PerformanceTests: XCTestCase {
  private var app: XCUIApplication!

  override func setUpWithError() throws {
    continueAfterFailure = false
    app = XCUIApplication()
  }

  override func tearDownWithError() throws {
    app = nil
  }

  func testLaunchPerformance() throws {
    if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
      measure(metrics: [XCTApplicationLaunchMetric()]) {
        XCUIApplication().launch()
      }
    }
  }

  func testScroll() {
    app.launch()

  }
}
