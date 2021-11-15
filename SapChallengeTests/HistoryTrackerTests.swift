//
//  HistoryTrackerTests.swift
//  SapChallengeTests
//
//  Created by Svilen Kirov on 15.11.21.
//

import XCTest
@testable import SapChallenge

class HistoryTrackerTests: XCTestCase {
    
    let userDefaults = UserDefaults.standard
    var historyTracker: HistoryTrackerProtocol!
    var key: String!
    
    override func setUp() {
        super.setUp()
        historyTracker = HistoryTracker()
        historyTracker.clearHistory()
        key = "history"
    }

    func testAddSingleElement() throws {
        historyTracker.addToHistory(term: "Jack")
        XCTAssertEqual(userDefaults.stringArray(forKey: key), ["Jack"], "Expected array with a single element - Jack")
    }
    
    func testClearHistory() throws {
        historyTracker.addToHistory(term: "Jack")
        historyTracker.addToHistory(term: "Jack")
        historyTracker.addToHistory(term: "Jack")
        historyTracker.clearHistory()
        XCTAssertEqual(userDefaults.stringArray(forKey: key), nil, "Expected nil")
    }
    
    func testGetHistory() throws {
        historyTracker.addToHistory(term: "Jack")
        historyTracker.addToHistory(term: "Jack")
        historyTracker.addToHistory(term: "Jack")
        XCTAssertEqual(historyTracker.getHistory(), ["Jack", "Jack", "Jack"], "Expected triple jack array")
    }
}
