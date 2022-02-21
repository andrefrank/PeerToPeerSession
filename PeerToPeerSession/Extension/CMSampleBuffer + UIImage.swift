//
//  CMSampleBuffer + UIImage.swift
//  PeerToPeerSession
//
//  Created by Andre Frank on 21.02.22.
//

import UIKit
import AVFoundation


extension CMSampleBuffer {
    func image(orientation: UIImage.Orientation = .up, scale: CGFloat = 1.0) -> UIImage? {
          if let buffer = CMSampleBufferGetImageBuffer(self) {
              let ciImage = CIImage(cvPixelBuffer: buffer)
              
              return UIImage(ciImage: ciImage, scale: scale, orientation: orientation)
          }

          return nil
    }
    
    func imageWithCGImage(orientation: UIImage.Orientation = .up, scale: CGFloat = 1.0) -> UIImage? {
          if let buffer = CMSampleBufferGetImageBuffer(self) {
              let ciImage = CIImage(cvPixelBuffer: buffer)

              let context = CIContext(options: nil)

              guard let cg = context.createCGImage(ciImage, from: ciImage.extent) else {
                  return nil
              }
              
              let image = UIImage(cgImage: cg, scale: scale, orientation: orientation)
              return image
          }

          return nil
      }
    
}

          
