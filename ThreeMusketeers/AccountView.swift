//
//  AccountView.swift
//  ThreeMusketeers
//
//  Created by Gabriel Push on 1/30/24.
//

import SwiftUI

struct AccountView: View {
    @Binding var usernameText: String
    @Binding var passwordText: String
    var body: some View {
        ZStack {
            VStack() {
                
                Text("Login To TailMate!")
                    .font(.title)
                    .bold()
                    .padding()
                
                Image(systemName: "person.circle")
                        .resizable()
                        .scaledToFit()
                        .padding(50)
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    
                TextField("User Name: ", text: $usernameText)
                    .font(.subheadline)
                    .padding(12)
                    .background(.white)
                    .padding()
                    .shadow(color: .blue, radius: 5)
                    
                
                TextField("Password: ", text: $passwordText)
                    .font(.subheadline)
                    .padding(12)
                    .background(.white)
                    .padding()
                    .shadow(color: .blue, radius: 5)
                
                Image("appleid")
                    .resizable()
                    .scaledToFit()
                    .padding(25)
            }
        }
        
    }
}

#Preview {
    AccountView(usernameText: .constant(""), passwordText: .constant(""))
}
