//
//  HistoryTracker.swift
//  SapChallenge
//
//  Created by Svilen Kirov on 11.11.21.
//

import Foundation

private let historyKey = "history"
class HistoryTracker {
    
    static func addToHistory(term: String) {
        let userDefaults = UserDefaults.standard
        var history: [String] = userDefaults.stringArray(forKey: historyKey) ?? []
        history.append(term)
        userDefaults.set(history, forKey: historyKey)
    }
    
    static func clearHistory() {
        UserDefaults.standard.removeObject(forKey: historyKey)
    }
    
    static func getHistory() -> [String] {
        return UserDefaults.standard.stringArray(forKey: historyKey) ?? []
    }
}
