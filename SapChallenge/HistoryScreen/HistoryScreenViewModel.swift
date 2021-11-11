//
//  HistoryScreenViewModel.swift
//  SapChallenge
//
//  Created by Svilen Kirov on 11.11.21.
//

import Foundation

class HistoryScreenViewModel {
    
    var previousSearches: [String] = ["Abra", "Kadabra", "Kadastra"]
    var searchesCount: Int {
        previousSearches.count
    }
}
