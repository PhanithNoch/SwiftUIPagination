//
//  CardRow.swift
//  SwiftPagination (iOS)
//
//  Created by Admin on 3/29/21.
//

import SwiftUI

struct CardRow: View {
    var person = People()
    var body: some View {
        HStack(alignment:.center,spacing:10){
            Image("Logo React")
            VStack(alignment:.leading){
                Text(person.first_name).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                Text(person.last_name).font(.caption)
            }
            Spacer()
            Text(person.created_at).font(.system(size:12 ))

        }
    }
}

struct CardRow_Previews: PreviewProvider {
    static var previews: some View {
        CardRow()
    }
}
