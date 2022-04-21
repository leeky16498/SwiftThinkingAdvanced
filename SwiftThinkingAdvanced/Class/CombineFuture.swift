//
//  CombineFuture.swift
//  SwiftThinkingAdvanced
//
//  Created by Kyungyun Lee on 22/03/2022.
//

import SwiftUI
import Combine
//download with Combine
//download with @escaping closure
//convert @escaping closure to combine

class FutureViewModel : ObservableObject {
    
    @Published var title : String = "Starting title"
    
    let url = URL(string: "http://www.google.com")!
    var cancellable = Set<AnyCancellable>()
    
    init() {
        
    }
    
    func download() { // fake download
//        getCombinePublisher()
        getFuturePublisher()
            .sink { _ in

            } receiveValue: { [weak self] returnedValue in
                self?.title = returnedValue
            }
//            .store(in: &cancellable)
//        getEscapingClosure { [weak self] value, error in
//            self?.title = value
//        } // 탈출 클로저가 있는 메소드를 컴바인에 사용할 수 있다.
    }
    
    func getCombinePublisher() -> AnyPublisher<String, URLError> {
        URLSession.shared.dataTaskPublisher(for: url)
            .timeout(1, scheduler: DispatchQueue.main)
            .map { _ in
                return "new value"
            }
            .eraseToAnyPublisher()
    }
    
    func getEscapingClosure(completionHandler : @escaping (_ value : String, _ error : Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completionHandler("new Value2", nil)
        }
        .resume()
    }
    
    func getFuturePublisher() -> Future<String, Error> {
        return Future { promise in
            self.getEscapingClosure { value, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(value))
                }
            }
        }
    }
    
    func doSomething(completion : @escaping(_ value : String) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now()+4) {
            completion("new string")
        }
    }
    
    func doSomethingIntheFuture() -> Future<String, Never> {
        Future { promise in
            self.doSomething { value in
                promise(.success(value))
            }
        }
    }
}

struct CombineFuture: View {
    
    @StateObject var vm = FutureViewModel()
    
    var body: some View {
        Text(vm.title)
    }
}

struct CombineFuture_Previews: PreviewProvider {
    static var previews: some View {
        CombineFuture()
    }
}
