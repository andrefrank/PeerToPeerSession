//
//  UIImage + Rotate.swift
//  PeerToPeerSession
//
//  Created by Andre Frank on 21.02.22.
//

import UIKit


extension UIImage {

    func rotate(respect deviceOrientation:UIDeviceOrientation) -> UIImage {
    var rotatedImage = UIImage()
    
    switch deviceOrientation
    {
        case .portrait:
        rotatedImage = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation:.leftMirrored)
        case .landscapeLeft:
            rotatedImage = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: .up)
        case .landscapeRight:
            rotatedImage = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: .downMirrored)
    case .portraitUpsideDown:
        rotatedImage = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: .down)
    default:
            rotatedImage = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: .leftMirrored)
    }
    
    
    return rotatedImage
    }
}
                                   
                                   
             
