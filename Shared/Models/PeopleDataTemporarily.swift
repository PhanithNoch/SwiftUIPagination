//
//  PeopleDataTemporarily.swift
//  SwiftPagination (iOS)
//
//  Created by Admin on 3/29/21.
//

import Foundation


struct PeopleDataTemp {
    
}

struct Page:Decodable,Identifiable {
    var id: Int = 0
    var first_name: String = ""
    var last_name: String = ""
    var age : String = ""
    var active_date: String = ""
    var created_at: String = ""
    var updated_at:String = ""
}
