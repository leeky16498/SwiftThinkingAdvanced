//
//  NewMockDataService.swift
//  SwiftThinkingAdvanced
//
//  Created by Kyungyun Lee on 25/04/2022.
//

import SwiftUI
import Combine
import Foundation

protocol NewDataServiceProtocol {
    func downloadItemsWithEscaping(completion : @escaping (_ items : [String]) -> ())
    func downloadItemsWithCombine() -> AnyPublisher<[String], Error>
}

class newMockDataService : NewDataServiceProtocol {
    
    let items : [String]
    
    init(items : [String]?) {
        self.items = items ?? ["One", "Two", "Three"]
    }
    
    func downloadItemsWithEscaping(completion : @escaping (_ items : [String]) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
            completion(self.items)
        }
    }
    
    func downloadItemsWithCombine() -> AnyPublisher<[String], Error> {
        Just(items)
            .tryMap({ publishedItems in
                guard !publishedItems.isEmpty else {
                    throw URLError(.badServerResponse)
                }
                return publishedItems
            })
            .eraseToAnyPublisher()
    }
}
