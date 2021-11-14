//
//  HistoryScreenViewModel.swift
//  SapChallenge
//
//  Created by Svilen Kirov on 11.11.21.
//

import Foundation

class HistoryScreenViewModel {
    
    var previousSearches: [String] = HistoryTracker.getHistory()
    
    var getSearchHistory: [String] {
        previousSearches.reversed()
    }
    
    var searchesCount: Int {
        previousSearches.count
    }
}
