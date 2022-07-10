//
//  ItemView.swift
//  Meli Challenge
//
//  Created by Yoav Zoldan on 08-07-2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct ItemView: View {
    
    var item: Item
    var pictures: Pictures
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(item.conditionDescription) | \(item.sold_quantity) vendidos")
                .foregroundColor(.secondary)
                .font(.caption)
                .padding([.top])
            Text(item.title)
            WebImage(url: item.thumbnailURL)
                .resizable()
                .placeholder(Image(uiImage: .productPlaceholder))
                .scaledToFit()
                .frame(height: 200, alignment: .center)
                .frame(maxWidth: .infinity)
            Text(item.price.toCurrency(currencyCode: item.currency_id))
                .font(.title)
            Group {
                Text("en ") +
                Text(item.installments.description)
                    .foregroundColor(Color(uiColor: .greenBrandColor))
                    .font(.headline)
            }
            Spacer()
        }
        .padding([.leading, .trailing])
    }
}

struct ItemView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ItemView(item: Item.mock, pictures: [Picture.mock, Picture.mock, Picture.mock])
        }
    }
}
