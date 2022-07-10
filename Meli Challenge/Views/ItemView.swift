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
    var validPictures: Pictures {
        pictures.filter({ $0.isValid })
    }
    var validAttributes: Attributes {
        item.attributes.filter({ $0.isValid })
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                Text("\(item.conditionDescription) | \(item.sold_quantity) vendidos")
                    .foregroundColor(.secondary)
                    .font(.caption)
                    .padding([.top])
                Text(item.title)
                TabView {
                    ForEach(validPictures) { picture in
                        VStack {
                            pictureView(for: picture)
                            Spacer(minLength: 25)
                        }
                    }
                }
                .frame(height: 250, alignment: .center)
                .tabViewStyle(PageTabViewStyle())
                Text(item.price.toCurrency(currencyCode: item.currency_id))
                    .font(.title)
                Group {
                    Text("en ") +
                    Text(item.installments.description)
                        .foregroundColor(Color(uiColor: .greenBrandColor))
                        .font(.headline)
                }
                .padding([.bottom], 8)
                Text("Características")
                    .font(.title2)
                    .padding([.bottom], 8)
                ForEach(validAttributes) { att in
                    HStack(alignment: .center, spacing: 8) {
                        Text(att.name ?? "")
                            .font(.callout)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: 135, alignment: .leading)
                        Divider()
                        Text(att.value_name ?? "")
                    }
                }
                Spacer()
            }
        }
        .padding([.leading, .trailing])
        .onAppear {
            setupAppearance()
        }
    }
    
    private func setupAppearance() {
        UIPageControl.appearance().currentPageIndicatorTintColor = .black
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
    }
    
    private func pictureView(for picture: Picture) -> some View {
        return WebImage(url: picture.getUrl())
            .resizable()
            .placeholder(Image(uiImage: .productPlaceholder))
            .scaledToFit()
    }
}

struct ItemView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ItemView(item: Item.mock, pictures: [Picture.mock, Picture.mock, Picture.mock])
        }
    }
}
