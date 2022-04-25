//
//  UnitTestingClassViewModel.swift
//  SwiftThinkingAdvanced
//
//  Created by Kyungyun Lee on 24/04/2022.
//

import Foundation
import SwiftUI
import Combine

class UnitTestingClassViewModel : ObservableObject {
    
    @Published var isPremium : Bool
    @Published var dataArray : [String] = []
    @Published var selectedItem : String? = nil
    let dataService : NewDataServiceProtocol
    var cancellables = Set<AnyCancellable>()
    
    init(isPremium : Bool, dataService : NewDataServiceProtocol) {
        self.isPremium = isPremium
        self.dataService = dataService
    }
    
    func addItem(item : String) {
        guard !item.isEmpty else {return}
        self.dataArray.append(item)
    }
    
    func selectedItem(item : String) {
        if let x = dataArray.first(where: {$0 == item}) {
            selectedItem = x
        } else {
            selectedItem = nil
        }
    }
    
    func saveItem(item : String) throws {
        guard !item.isEmpty else {
            throw dataError.noData
        }
        
        if let x = dataArray.first(where: {$0 == item}) {
            print("Save item here!! \(x)")
        } else {
            throw dataError.itemNotFound
        }
    }
    
    enum dataError : LocalizedError {
        case noData
        case itemNotFound
    }
    
    func downloadWithEscaping() {
        dataService.downloadItemsWithEscaping { returnedItems in
            self.dataArray = returnedItems
        }
    }
    
    func downloadWithCombine() {
        dataService.downloadItemsWithCombine()
            .sink { _ in
                
            } receiveValue: { returnedItems in
                self.dataArray = returnedItems
            }
            .store(in: &cancellables)

    }
    
}
