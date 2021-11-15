//
//  HistoryTracker.swift
//  SapChallenge
//
//  Created by Svilen Kirov on 11.11.21.
//

import Foundation

private let historyKey = "history"

protocol HistoryTrackerProtocol: AnyObject {
    func addToHistory(term: String)
    func clearHistory()
    func getHistory() -> [String]
}

class HistoryTracker {
    static let sharedInstance = HistoryTracker()
}

extension HistoryTracker: HistoryTrackerProtocol {
    
    func addToHistory(term: String) {
        let userDefaults = UserDefaults.standard
        var history: [String] = userDefaults.stringArray(forKey: historyKey) ?? []
        history.append(term)
        userDefaults.set(history, forKey: historyKey)
    }
    
    func clearHistory() {
        UserDefaults.standard.removeObject(forKey: historyKey)
    }
    
    func getHistory() -> [String] {
        return UserDefaults.standard.stringArray(forKey: historyKey) ?? []
    }
}
