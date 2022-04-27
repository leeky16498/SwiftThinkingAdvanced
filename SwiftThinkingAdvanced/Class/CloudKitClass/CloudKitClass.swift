//
//  CloudKitClass.swift
//  SwiftThinkingAdvanced
//
//  Created by Kyungyun Lee on 26/04/2022.
//

import SwiftUI
import CloudKit

struct CloudKitClass: View {
    
    @StateObject var vm = CloudKitClassViewModel()
    
    var body: some View {
        VStack {
            Text("Is singed in : \(vm.isSingedIntoCloud.description.uppercased())")
            Text(vm.error)
            Text("username : \(vm.username)")
            Text("permission : \(vm.permissionStatus.description)")
        }
    }
}

struct CloudKitClass_Previews: PreviewProvider {
    static var previews: some View {
        CloudKitClass()
    }
}

class CloudKitClassViewModel : ObservableObject {
    
    @Published var isSingedIntoCloud : Bool = false
    @Published var error : String = ""
    @Published var username : String = ""
    @Published var permissionStatus : Bool = false
    
    init() {
        getiCloudStatus() //icloud 접속
        requestPermission() // icloud접속 권한 가져오기
        fetchIcloudUserRecordID() // 유저 정보 가져오기
    }
    
    private func getiCloudStatus() {
        CKContainer.default().accountStatus { [weak self] returnedStatus, returnedError in
                switch returnedStatus {
                case .couldNotDetermine:
                    self?.error = CloudKitError.iCloudAccountNotDetermined.localizedDescription
                case .available:
                    self?.isSingedIntoCloud = true // icloud에 접속이 된 상태 나머진, 다 에러와 관련된 케이스이다.
                case .restricted:
                    self?.error = CloudKitError.iCloudAccountRestricted.localizedDescription
                case .noAccount:
                    self?.error = CloudKitError.iCloudAccountNotFound.localizedDescription
                case .temporarilyUnavailable:
                    self?.error = CloudKitError.iCloudAccountUnknown.localizedDescription
                }

        }
    }
    
    enum CloudKitError : LocalizedError {
        case iCloudAccountNotFound
        case iCloudAccountNotDetermined
        case iCloudAccountRestricted
        case iCloudAccountUnknown
    }
    
    func requestPermission() {
        CKContainer.default().requestApplicationPermission([.userDiscoverability]) { [weak self] returnedStatus, returnedError in
            DispatchQueue.main.async {
                if returnedStatus == .granted {
                    self?.permissionStatus = true
                }
            }
        }
    }
    
    func fetchIcloudUserRecordID() {
        CKContainer.default().fetchUserRecordID { [weak self] returnedID, returnedError in
            if let id = returnedID {
                self?.discoverIcloudUser(id: id)
            }
        }
    }
    
    func discoverIcloudUser(id : CKRecord.ID) {
        CKContainer.default().discoverUserIdentity(withUserRecordID: id) { [weak self] returnedIdentity, returnedError in
            DispatchQueue.main.async {
                if let name = returnedIdentity?.nameComponents?.givenName {
                    self?.username = name
                }
            }
        }
    }
}
