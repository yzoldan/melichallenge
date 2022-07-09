//
//  ItemCollectionViewCell.swift
//  Meli Challenge
//
//  Created by Yoav Zoldan on 08-07-2022.
//

import UIKit
import SDWebImage

class ItemCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "ItemCollectionViewCell"
    static let idealHeight: CGFloat = 350
    static let idealWidth: CGFloat = 200
    
    private var item: Item!
    private var padding: CGFloat = 12
    private var widthWithPadding: CGFloat {
        return contentView.width - (2 * padding)
    }
    override var isSelected: Bool {
        didSet {
            UIView.animate(withDuration: 0.1) {
                self.backgroundColor = self.isSelected ? .secondarySystemBackground : .clear
            } completion: { _ in }
        }
    }
    
    // MARK: - Views
    
    lazy private var productImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.image = .productPlaceholder
        return imageView
    }()
    
    lazy private var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 3
        label.font = .preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    lazy private var priceLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 1
        label.font = .preferredFont(forTextStyle: .title1)
        return label
    }()
    
    lazy private var installmentsLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 1
        label.textColor = .greenBrandColor
        label.font = .preferredFont(forTextStyle: .caption1)
        return label
    }()
    
    lazy private var shippingLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .greenBrandColor
        label.numberOfLines = 1
        label.font = .boldSystemFont(ofSize: UIFont.systemFontSize)
        return label
    }()

    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        addSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews() {
        contentView.addSubview(productImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(installmentsLabel)
        contentView.addSubview(shippingLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        productImageView.frame = CGRect(x: 2,
                                        y: 2,
                                        width: contentView.width - 4,
                                        height: 150)
        titleLabel.frame = CGRect(x: padding,
                                  y: productImageView.bottom + padding,
                                  width: widthWithPadding,
                                  height: 80)
        priceLabel.frame = CGRect(x: padding,
                                  y: titleLabel.bottom + padding,
                                  width: widthWithPadding ,
                                  height: 20)
        installmentsLabel.frame = CGRect(x: padding,
                                         y: priceLabel.bottom + padding,
                                         width: widthWithPadding,
                                         height: 20)
        shippingLabel.frame = CGRect(x: padding,
                                     y: installmentsLabel.bottom + padding,
                                     width: widthWithPadding,
                                     height: 20)
    }
    
    func configure(with item: Item) {
        self.item = item
        productImageView.sd_setImage(with: item.thumbnailURL, placeholderImage: .productPlaceholder)
        titleLabel.text = item.title
        priceLabel.text = item.price.toCurrency(currencyCode: item.currency_id)
        installmentsLabel.text = item.installments.description
        shippingLabel.text = item.shipping.free_shipping ? "Envío gratis" : nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        item = nil
        productImageView.image = .productPlaceholder
        titleLabel.text = nil
        priceLabel.text = nil
        installmentsLabel.text = nil
        shippingLabel.text = nil
    }
    
    // MARK: - Methods

    
}
