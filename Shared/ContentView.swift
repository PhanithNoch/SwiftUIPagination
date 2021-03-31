//
//  ContentView.swift
//  Shared
//
//  Created by Admin on 3/29/21.
//

import SwiftUI

struct ContentView: View {
    //1.
    @ObservedObject var networkManager = NetworkManager()
    @State var searchController = ""
    @State private var isEditing = false
    @State var currentScrool = ""
    
    var body: some View {
        ScrollView {
            
            VStack{
                HStack{
                    TextField("Search",text:$searchController).textFieldStyle(RoundedBorderTextFieldStyle()).onTapGesture {
                        self.isEditing = true
                    }
                    Button(action: {
                        if isEditing && searchController != "" {
                          
                            networkManager.searchPeople(query: searchController,currentScrool: "")
                            
                        }
                        else{
                            networkManager.performRequest()
                        }
                    }, label: {
                        Text("Search")
                    }).transition(.move(edge: .trailing))
                    .animation(.default)
                }
                HStack(alignment:.center){
                    Text("\(networkManager.people.meta?.current_page ?? 0 )" )
                    Text("/")
                    Text("\(networkManager.people.meta?.last_page ?? 0)")
                }
                
                ForEach(networkManager.people.data, id:\.id){ person in
                    VStack{
                        
                        CardRow(person: person)
                    }
                    
                }
                
            }.padding()
            
            .onAppear(perform: {
                
                networkManager.performRequest()
                
            })
        }.gesture(
            DragGesture().onChanged { value in
                if value.translation.height > 0 {
//                    print("Scroll down")
                    currentScrool = "down"
                    if searchController == ""{
                        networkManager.getByPage(currentScrool: "down")
                    }
                    else{
                        networkManager.searchPeople(query: searchController,currentScrool: currentScrool)
                    }
                    
                } else {
//                    print("Scroll up")
                    currentScrool = "up"
                    if searchController == ""{
                        networkManager.getByPage(currentScrool: "up")
                    }
                    else{
                        networkManager.searchPeople(query: searchController,currentScrool: currentScrool)
                    }
                }
            }
        )
    }
    
    var alert: Alert {
        Alert(title: Text("Message"), message: Text("Record Deleted"), dismissButton: .default(Text("Close")))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

