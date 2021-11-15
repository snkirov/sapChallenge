//
//  HistoryScreenViewModel.swift
//  SapChallenge
//
//  Created by Svilen Kirov on 11.11.21.
//

import Foundation

class HistoryScreenViewModel {
    
    private var previousSearches: [String]
    private weak var historyTracker: HistoryTrackerProtocol!
    
    init(historyTracker: HistoryTrackerProtocol = HistoryTracker.sharedInstance) {
        self.historyTracker = historyTracker
        previousSearches = historyTracker.getHistory()
    }
    
    var getSearchHistory: [String] {
        previousSearches.reversed()
    }
    
    var searchesCount: Int {
        previousSearches.count
    }
    
    func clearHistory() {
        historyTracker.clearHistory()
        previousSearches = []
    }
}
