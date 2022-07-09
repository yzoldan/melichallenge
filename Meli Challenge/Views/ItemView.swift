//
//  ItemView.swift
//  Meli Challenge
//
//  Created by Yoav Zoldan on 08-07-2022.
//

import SwiftUI

struct ItemView: View {
    
    var item: Item
    
    var body: some View {
        VStack {
            Text(item.title)
                .padding()
        }
    }
}

struct ItemView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ItemView(item: Item.mock)
        }
    }
}
