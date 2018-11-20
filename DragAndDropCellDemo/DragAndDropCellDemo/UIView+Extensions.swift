//
//  UIView+Extensions.swift
//  DragAndDropCellDemo
//
//  Created by Thanh Nguyen Xuan on 11/20/18.
//  Copyright © 2018 None. All rights reserved.
//

import UIKit

extension UIView {
    
    func makeSnapshot() -> UIView {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return UIView()
        }
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let snapshot = UIImageView(image: image)
        // Tạo style cho snapshot view nổi bật hơn
        snapshot.layer.masksToBounds = false
        snapshot.layer.cornerRadius = 0.0
        snapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        snapshot.layer.shadowRadius = 5.0
        snapshot.layer.shadowOpacity = 0.4
        return snapshot
    }

}
