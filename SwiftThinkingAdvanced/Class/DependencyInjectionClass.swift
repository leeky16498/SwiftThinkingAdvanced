//
//  DependencyInjectionClass.swift
//  SwiftThinkingAdvanced
//
//  Created by Kyungyun Lee on 23/04/2022.
//

import SwiftUI
import Combine

//Problems with singleton
//1. singleton's are global
//2. Can't customize the init!
//3. Can't swap out service
//위의 문제들을 해결해 주는 것이 Dependency Injection이다.

protocol NewDataServiceProtocol {
    func downloadItemsWithEscaping(completion : @escaping (_ items : [String]) -> ())
    func downloadItemsWithCombine() -> AnyPublisher<[String], Error>
}

class newDataService : NewDataServiceProtocol {
    
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
//Unit Testing 파트

struct PostsModel : Identifiable, Codable {
    let userId : Int
    let id : Int
    let title : String
    let body : String
}

class ProductionDataService {
    
//    static let instance = ProductionDataService()
    //싱글톤 패턴은 디자인 패턴인데 해당 인스턴스를 하나만 생성해서 참조하게 할 때 사용하게 된다.
    
    let url : URL = URL(string: "https://jsonplaceholder.typicode.com/posts")!

    func getData() -> AnyPublisher<[PostsModel], Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map({$0.data})
            .decode(type: [PostsModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

class MockDataService : DataServiceProtocol {
    
    let testData : [PostsModel] = [
        PostsModel(userId : 1, id : 2, title : "3", body : "one")
    ]
    
    func getData() -> AnyPublisher<[PostsModel], Error> {
        Just(testData)
            .tryMap({$0})
            .eraseToAnyPublisher()
    }
}

protocol DataServiceProtocol {
    func getData() -> AnyPublisher<[PostsModel], Error>
}

class DependencyInjectionViewModel : ObservableObject {
    
    @Published var dataArray : [PostsModel] = []
    var cancellables = Set<AnyCancellable>()
    let dataService : ProductionDataService
    
    init(dataService : ProductionDataService) {
//        self.loadPosts()
        self.dataService = dataService
    }
    
    private func loadPosts() {
        dataService.getData()
            .sink { _ in
                
            } receiveValue: { [weak self]returnedPost in
                self?.dataArray = returnedPost
            }
            .store(in: &cancellables)

    }
}

struct DependencyInjectionClass: View {
    
    @StateObject private var vm : DependencyInjectionViewModel
    
    init(dataService : ProductionDataService) {
        _vm = StateObject(wrappedValue: DependencyInjectionViewModel(dataService: dataService))
    }
    //다음과 같이 서로간의 연관성을 주입해주는 것이다. 생성자를 통해서.
    //그리고 프로퍼티 래퍼로 감싸진 프로퍼티에 대해 초기화 할 시에는 _(언더바)를 통해서 해준다.
    
    var body: some View {
        ScrollView {
            VStack(alignment : .leading) {
                ForEach(vm.dataArray) {item in
                    Text(item.title)
                }
            }
        }
    }
}

//struct DependencyInjectionClass_Previews: PreviewProvider {
//    static var previews: some View {
//        DependencyInjectionClass()
//    }
//}
