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
    init() {
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
        
        //Use this if NavigationBarTitle is with Large Font
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        //Use this if NavigationBarTitle is with displayMode = .inline
//        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.red]
        
        //        UINavigationBar.appearance().backgroundColor = .blue
    }
    var body: some View {
            ScrollView {
        
                    VStack{
                        TextField("Search",text:$searchController)
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
                      print("Scroll down")
                    networkManager.getByPage(currentScrool: "down")
                    
                   } else {
                      print("Scroll up")
                    networkManager.getByPage(currentScrool: "up")
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

