//
//  Crop.swift
//  ChampLOL
//
//  Created by Chung Tran on 9/22/17.
//  Copyright © 2017 Chung Tran. All rights reserved.
//

import UIKit

// MARK: - Crop Image Aspect Fill

extension UIImage {
    func cropIfNeed(aspectFillToSize size: CGSize) -> UIImage? {
        guard self.size != size else {return self}
        UIGraphicsBeginImageContextWithOptions(size, false , 0.0)
        let rect = CGRect(origin: CGPoint.zero, size: size)
        self.draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

// MARK: - CGSize compaire

extension CGSize {
    static func != (first: CGSize, second: CGSize) -> Bool {
        return first.width != second.width || first.height != second.height
    }
}
