//
//  HistoryScreenViewModel.swift
//  SapChallenge
//
//  Created by Svilen Kirov on 11.11.21.
//

import Foundation

class HistoryScreenViewModel {
    
    private var previousSearches: [String]
    private var historyTracker: HistoryTracker
    
    init(historyTracker: HistoryTracker = HistoryTracker.sharedInstance) {
        self.historyTracker = historyTracker
        previousSearches = historyTracker.getHistory()
    }
    
    var getSearchHistory: [String] {
        previousSearches.reversed()
    }
    
    var searchesCount: Int {
        previousSearches.count
    }
}
