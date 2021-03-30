//
//  PeopleModel.swift
//  SwiftPagination (iOS)
//
//  Created by Admin on 3/29/21.
//

import Foundation

struct PeopleModel: Decodable {
    var data:[People] = [People]()
    var links:Link?
    var meta: Meta?
    
    
}


struct People:Decodable,Identifiable,Equatable {
    var id: Int = 0
    var first_name: String = ""
    var last_name: String = ""
    var age : String = ""
    var active_date: String = ""
    var created_at: String = ""
    var updated_at:String = ""
}


struct Link:Decodable {
    var first:String = ""
    var last: String = ""
    var prev: String?
    var next: String?
    
}

struct Meta:Decodable {
    var current_page:Int = 0
    var from : Int = 0
    var last_page: Int = 0
    var path: String = ""
    var per_page: Int = 0
    var to: Int = 0
    var total: Int = 0
    
}
