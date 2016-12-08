//
//  UIView+Extension.swift
//  SamuraiTransition
//
//  Created by Takahiro Nishinobu on 2016/12/08.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import Foundation

public extension UIView {
    
    public func snapshotImage(afterScreenUpdate: Bool) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
        drawHierarchy(in: bounds, afterScreenUpdates: afterScreenUpdate)
        let snapshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshotImage
    }
    
    public func snapshotView(rect: CGRect, afterScreenUpdate: Bool) -> UIView? {
        
        guard let snapshotImage = snapshotImage(afterScreenUpdate: afterScreenUpdate) else {
            return nil
        }
        
        let scale = UIScreen.main.scale
        let frame = CGRect(x: rect.origin.x * scale, y: rect.origin.y * scale, width: rect.width * scale, height: rect.height * scale)
        let imgRef = snapshotImage.cgImage?.cropping(to: frame)
        let image = UIImage(cgImage: imgRef!, scale: scale, orientation: snapshotImage.imageOrientation)
        let imageView = UIImageView(frame: rect)
        imageView.image = image
        return UIImageView(image: image)
        
    }
}
