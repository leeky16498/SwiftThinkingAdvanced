//
//  UITestingClass.swift
//  SwiftThinkingAdvanced
//
//  Created by Kyungyun Lee on 25/04/2022.
//

class UITestingClassViewModel : ObservableObject {
    let placeholder : String = "Add your name.."
    @Published var textFieldtext : String = ""
    @Published var currentUserIsSignedIn : Bool = false
    
    func signUpButtonPressed() {
        guard !textFieldtext.isEmpty else {return}
        currentUserIsSignedIn = true
    }
    
}

import SwiftUI

struct UITestingClass: View {
    
    @StateObject private var vm = UITestingClassViewModel()
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue,.black]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            ZStack {
                if vm.currentUserIsSignedIn {
                    SignedInHomeView()
                        .frame(maxWidth : .infinity, maxHeight: .infinity)
                        .transition(.move(edge: .trailing))
                }
                
                if !vm.currentUserIsSignedIn {
                    signUpLayer
                        .frame(maxWidth : .infinity, maxHeight: .infinity)
                        .transition(.move(edge: .leading))
                }
            }
        }
    }
}

struct UITestingClass_Previews: PreviewProvider {
    static var previews: some View {
        UITestingClass()
    }
}

extension UITestingClass {
    private var signUpLayer : some View {
        VStack{
            TextField(vm.placeholder, text: $vm.textFieldtext)
                .font(.headline)
                .padding()
                .background(.white)
                .cornerRadius(10)
            Button(action: {
                withAnimation {
                    vm.signUpButtonPressed()
                }
            }, label: {
                Text("Sign up")
                    .font(.headline)
                    .padding()
                    .background(.white)
                    .cornerRadius(10)
                    .accessibilityIdentifier("SignUpButton")
                //이 모디파이어가 테스트 간 버튼명을 대신한다.
            })
        }
        .padding()
    }
}

struct SignedInHomeView : View {
    
    @State private var showAlert : Bool = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Button(action: {
                    showAlert.toggle()
                }, label: {
                    Text("show welcome alert")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth : .infinity)
                        .background(.red)
                        .cornerRadius(10)
                })
                .alert(isPresented: $showAlert) {
                    return Alert(title: Text("Welcome to app!"))
                }
                
                NavigationLink(destination: {
                    Text("Destination")
                }, label: {
                    Text("Navigate")
                        .font(.headline)
                        .padding()
                        .foregroundColor(.white)
                        .frame(maxWidth : .infinity)
                        .background(.blue)
                        .cornerRadius(10)
                })
            }
            .padding()
            .navigationTitle("Welcome")
        }
    }
}
