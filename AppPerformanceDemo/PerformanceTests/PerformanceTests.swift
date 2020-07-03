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
    let options  = XCTMeasureOptions()
    options.iterationCount = 6
    measure(metrics: [XCTApplicationLaunchMetric()], options: options) {
      XCUIApplication().launch()
    }
    
  }

  func testScroll() {
    app.launch()
    let itemListView = app.tables.firstMatch

    let options  = XCTMeasureOptions()
    options.invocationOptions =  [.manuallyStop]

    measure(metrics: [XCTOSSignpostMetric.scrollDecelerationMetric], options: options) {

      itemListView.swipeUp(velocity: .fast)
      stopMeasuring()
      itemListView.swipeDown(velocity: .fast)

    }

  }
}
