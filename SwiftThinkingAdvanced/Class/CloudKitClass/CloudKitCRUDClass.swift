//
//  CloudKitCRUDClass.swift
//  SwiftThinkingAdvanced
//
//  Created by Kyungyun Lee on 26/04/2022.
//

import SwiftUI
import CloudKit

struct CloudKitCRUDClass: View {
    
    @StateObject var vm = CloudKitCRUDViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                header
                textField
                button
                
                List {
                    ForEach(vm.fruits, id : \.self) { fruit in
                        HStack {
                            Text(fruit.name)
                            
                            if let url = fruit.imageUrl, let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width : 50, height : 50)
                            }
                        }
                        .onTapGesture {
                            vm.updateItems(fruit: fruit)
                        }
                    }
                    .onDelete(perform: vm.deleteItem)
                }
                .listStyle(.plain)
            }
            .padding()
            .navigationBarHidden(true)
        }
    }
}

struct CloudKitCRUDClass_Previews: PreviewProvider {
    static var previews: some View {
        CloudKitCRUDClass()
    }
}

extension CloudKitCRUDClass {
    private var header : some View {
        Text("CloudKit CRUD ☁️☁️☁️")
            .font(.headline)
            .underline()
    }
    
    private var textField : some View {
        TextField("Add something", text: $vm.text)
            .frame(height : 55)
            .padding(.leading)
            .background(.gray.opacity(0.4))
            .cornerRadius(10)
    }
    
    private var button : some View {
        Button(action: {
            vm.addButtonPressed()
            vm.fetchItems()
        }, label: {
            Text("add".uppercased())
                .frame(maxWidth : .infinity)
                .frame(height : 55)
                .background(.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
        })
    }
}

class CloudKitCRUDViewModel : ObservableObject {
    
    @Published var text : String = ""
    @Published var fruits : [FruitModel] = []
    
    init() {
        fetchItems()
    }
    
    func addButtonPressed() {
        guard !text.isEmpty else {return}
        addItem(name: text)
    }
    
    private func addItem(name : String) {
        let newFruit = CKRecord(recordType: "Fruits")
        newFruit["name"] = name // 딕셔너리 key, value값을 생성
        
        guard
            let image = UIImage(named: "theRock"),
            let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("theRock.jpg"),
            let data = image.jpegData(compressionQuality: 1.0) else {return}
        
        do {
            try data.write(to: url)
            let asset = CKAsset(fileURL: url)
            newFruit["image"] = asset
        } catch {
            print(error)
        }
        

        
        saveItem(record: newFruit)//아이템을 데이터 베이스에 저장
    }
    
    private func saveItem(record : CKRecord) {
        CKContainer.default().publicCloudDatabase.save(record) { [weak self] returnedRecord, returnedError in
            print("Record : \(returnedRecord)")
            print("Error : \(returnedError)")
            
            DispatchQueue.main.async {
                self?.text = ""
                self?.fetchItems() //리프레쉬 구간
            }
        } // icloud에 저장
    }
    
    func fetchItems() {
        
        let predicate = NSPredicate(value: true)
//        let predicate = NSPredicate(format: "name = %@", argumentArray: ["Orange"]) // 커스텀 필터링이 가능하다. 지금은 orange라는 이름을 가진 친구만 리턴하도록 옵션을 부여한 상태.
        let query = CKQuery(recordType: "Fruits", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        let queryOperation = CKQueryOperation(query: query)
//        queryOperation.resultsLimit = 2 // 결과를 가장 앞에 2개만 리턴한다. 리밋을 안주면 최대 100개를 리턴한다.
        
        var returnedItems : [FruitModel] = []
        
        queryOperation.recordMatchedBlock = { (returnedRecordID, returnedResult) in
            switch returnedResult {
            case .success(let record):
                guard let name = record["name"] as? String else {return}
                let imageAsset = record["image"] as? CKAsset
                let imageUrl = imageAsset?.fileURL
                returnedItems.append(FruitModel(name: name, imageUrl: imageUrl, record: record))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        queryOperation.queryResultBlock = { [weak self] returnedResult in
            print("ReturnedResult : \(returnedResult)")
            DispatchQueue.main.async {
                self?.fruits = returnedItems // 여기에 sort를 먹여서 처리 가능하다. 문제없다.
            }
        }
        addOperations(operation: queryOperation)
    }
    
    func addOperations(operation : CKDatabaseOperation) {
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    func updateItems(fruit : FruitModel) {
        let record = fruit.record
        record["name"] = "New NAME!!"
        saveItem(record: record)
    }
    
    func deleteItem(indexSet : IndexSet) {
        guard let index = indexSet.first else {return}
        let fruit = fruits[index]
        let record = fruit.record
        
        CKContainer.default().publicCloudDatabase.delete(withRecordID: record.recordID) { [weak self] returnedRecordId, returnedError in
            DispatchQueue.main.async {
                self?.fruits.remove(at: index)
            }
        }
    }
}

struct FruitModel : Hashable {
    let name : String
    let imageUrl : URL?
    let record : CKRecord
}
