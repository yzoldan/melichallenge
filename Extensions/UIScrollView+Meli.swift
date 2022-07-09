//
//  UIScrollView+Meli.swift
//  Meli Challenge
//
//  Created by Yoav Zoldan on 08-07-2022.
//

import Foundation
import UIKit

extension UIScrollView {
    
    var reachedBottom: Bool {
        return (contentOffset.y >= (contentSize.height - frame.size.height))
    }
}
