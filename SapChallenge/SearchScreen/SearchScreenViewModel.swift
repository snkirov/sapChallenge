//
//  SearchScreenViewModel.swift
//  SapChallenge
//
//  Created by Svilen Kirov on 10.11.21.
//

import Foundation
import TwoWayBondage

class SearchScreenViewModel {
    
    var imageData = Observable<[ImageData]>()
    var isInitialyLoading = Observable<Bool>()
    var currentPage = 0
    var maxPages = 0
    var term = ""
    
    var imagesCount: Int {
        imageData.value?.count ?? 0
    }
    
    private weak var repository: RepositoryProtocol!
    private weak var historyTracker: HistoryTrackerProtocol!
    
    init(repository: RepositoryProtocol = Repository.sharedInstance,
         historyTracker: HistoryTrackerProtocol = HistoryTracker.sharedInstance) {
        self.repository = repository
        self.historyTracker = historyTracker
    }
    
    func searchBy(term: String) {
        self.term = term
        imageData.value = []
        guard term != "" else { return }
        historyTracker.addToHistory(term: term)
        isInitialyLoading.value = true
        repository.getImages(byTerm: term) { [weak self] response in
            guard let strongSelf = self else { return }
            strongSelf.currentPage = response?.page ?? 0
            strongSelf.maxPages = response?.pages ?? 0
            strongSelf.imageData.value = response?.photo
            strongSelf.isInitialyLoading.value = false
        }
    }
    
    func loadNextPage() {
        guard currentPage < maxPages else { return }
        currentPage += 1
        repository.getPageFor(term: term, currentPage) { [weak self] imageData in
            guard let imageData = imageData else { return }
            self?.imageData.value?.append(contentsOf: imageData)
        }
    }
    
    func getImageData(for index: Int) -> ImageData? {
        guard index < imagesCount else { return nil }
        return imageData.value?[index]
    }
    
    func clearHistory() {
        historyTracker.clearHistory()
    }
}
