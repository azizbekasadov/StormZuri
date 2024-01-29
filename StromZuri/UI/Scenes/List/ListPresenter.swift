//
//  ListPresenter.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 27/01/24.
//

import Foundation

protocol ListPresentationLogic: AnyObject {
    var count: Int { get }
    var listItems: [ListItem] { get }
    var sortingType: SortingType { get }
    
    func initViews(_ request: ListModels.InitData.Request)
    func fetchData(_ request: ListModels.FetchData.Request)
    func fetchSortedData(_ request: ListModels.SortData.Request)
}

final class ListPresenter {
    private let dataProvider: ListDataProvider
    private let listAdapter: ListItemAdapter
    private(set) var stations: [StationDTO] = []
    
    private var pageSize: Int = 50
    private var currentPage = 1
    private var isLoadingPage: Bool = false
    
    private(set) var sortingType: SortingType = .dsc
    
    private let store = StationsStore.shared
    
    weak var view: ListDisplayLogic?
    
    init(dataProvider: ListDataProvider, listAdapter: ListItemAdapter, view: ListDisplayLogic?) {
        self.dataProvider = dataProvider
        self.listAdapter = listAdapter
        self.view = view
        
        self.store.delegate = self
    }
    
    var count: Int {
        listItems.count
    }
    
    var listItems: [ListItem] = []
}

extension ListPresenter: StationsStoreDelegate {
    func fetchRecords(_ stations: [StationDTO]) {
        self.stations = stations
        self.loadMoreData(stations)
        self.view?.fetchData(.init(stations: self.listItems))
    }
}

extension ListPresenter: ListPresentationLogic {
    func initViews(_ request: ListModels.InitData.Request) {
        view?.initViews(.init())
    }
    
    func fetchData(_ request: ListModels.FetchData.Request) {
        dataProvider.fetchData { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                    self.stations = success
                    self.loadMoreData(success)
                    self.view?.fetchData(.init(stations: self.listItems))
                case .failure(let failure):
                    self.view?.receivedError(.init(error: failure))
                }
            }
        }
    }
    
    func fetchSortedData(_ request: ListModels.SortData.Request) {
        self.sortingType = self.sortingType.toggle()
        
        let data = stations.sorted(by: self.sortingType)
        
        currentPage = 1
        loadMoreData(data)
        self.view?.fetchSortedData(.init(stations: self.listItems))
    }
    
    private func loadMoreData(_ stations: [StationDTO]) {
        let startIndex = (currentPage - 1) * pageSize
        let endIndex = min(currentPage * pageSize, self.stations.count)
        let newData = Array(stations[startIndex..<endIndex])
        let listItems = listAdapter.convert(newData)
        
        self.listItems = listItems
        
        currentPage += 1
    }
}
