//
//  InfoView.swift
//  Slot-Machine
//
//  Created by Abdelrahman Shehab on 16/04/2023.
//

import SwiftUI

struct InfoView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            LogoView()
            
            Spacer()
            
            Form {
                Section {
                    FormRowView(firstItem: "Application", secondItem: "Slot Machine")
                    FormRowView(firstItem: "Platforms", secondItem: "iPhone, iPad, Mac")
                    FormRowView(firstItem: "Developer", secondItem: "Shehab")
                    FormRowView(firstItem: "Engineer", secondItem: "Abdelrahman Shehab")
                    FormRowView(firstItem: "Music", secondItem: "Dan Lebowitz")
                    FormRowView(firstItem: "Website", secondItem: "swiftuimasterclass.com")
                    FormRowView(firstItem: "Copyright", secondItem: "© All rights reserved.")
                    FormRowView(firstItem: "Version", secondItem: "1.0.1")
                } header: {
                    Text("About the Application")
                }// HEADER
            }//: FORM
            .font(.system(.body, design: .rounded))
        }//: VSTACK
        .padding(.top, 40)
        .overlay(
            Button(action: {
                audioPlayer?.stop()
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "xmark.circle")
                    .font(.title)
            })//: BUTTON
            .padding(.top, 30)
            .padding(.trailing, 30)
            .accentColor(Color.secondary)
            , alignment: .topTrailing
        )
        .onAppear {
            playSound(sound: "background-music", type: "mp3")
        }
    }
}

struct FormRowView: View {
    var firstItem: String
    var secondItem: String
    
    var body: some View {
        HStack {
            Text(firstItem).foregroundColor(.gray)
            Spacer()
            Text(secondItem)
        }
    }
}
struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
