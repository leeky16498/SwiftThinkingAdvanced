//
//  CloudKitPushNotificationClass.swift
//  SwiftThinkingAdvanced
//
//  Created by Kyungyun Lee on 27/04/2022.
//

import SwiftUI
import CloudKit

struct CloudKitPushNotificationClass: View {
    
    @StateObject var vm = CloudKitPushNotificationClassViewModel()
    
    var body: some View {
        VStack(spacing: 40) {
            Button(action:  {
                vm.requestNotificationPermission()
            }, label: {
                Text("Request notification persmission")
            })
            
            Button(action:  {
                vm.subscribeToNotification()
            }, label: {
                Text("Subscribe to noficitations")
            })
            
            Button(action:  {
                vm.unsubscribeToNotifications()
            }, label: {
                Text("Unsubscribe to notifications")
            })
        }
    }
}

struct CloudKitPushNotificationClass_Previews: PreviewProvider {
    static var previews: some View {
        CloudKitPushNotificationClass()
    }
}

class CloudKitPushNotificationClassViewModel : ObservableObject {
    func requestNotificationPermission() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            if let error = error {
                print(error)
            } else if success {
                print("Notification permission success!")
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("Notification failed")
            }
        }
    }
    
    func subscribeToNotification() {
        
        let predicate = NSPredicate(value: true)
        
        let subscription = CKQuerySubscription(recordType: "Fruits", predicate: predicate, subscriptionID: "fruit_added_to_database", options: .firesOnRecordCreation)
        
        let notification = CKSubscription.NotificationInfo()
        notification.title = "There is a new fruit!"
        notification.alertBody = "Open the app to check your fruit!"
        notification.soundName = "default"
        
        subscription.notificationInfo = notification
        
        CKContainer.default().publicCloudDatabase.save(subscription) { returnedSubscription, returnedError in
            if let error = returnedError {
                print(error)
            } else {
                print("Successfully subscribed to notifications!")
            }
        }
    }
    
    func unsubscribeToNotifications() {
        
//        CKContainer.default().publicCloudDatabase.fetchAllSubscriptions(completionHandler: <#T##([CKSubscription]?, Error?) -> Void#>)
        CKContainer.default().publicCloudDatabase.delete(withSubscriptionID: "fruit_added_to_database") { returnedID, returnedError in
            if let error = returnedError {
                print(error)
            } else {
                print("Successfully unsubscribed")
            }
        }
    }
}
