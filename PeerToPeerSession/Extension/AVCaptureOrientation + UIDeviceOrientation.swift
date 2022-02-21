//
//  AVCaptureOrientation + UIDeviceOrientation.swift
//  PeerToPeerSession
//
//  Created by Andre Frank on 21.02.22.
//

import UIKit
import AVFoundation

extension AVCaptureVideoOrientation {
    
    init (_ deviceOrientation:UIDeviceOrientation) {
        switch deviceOrientation {
        case .portrait:
            self = AVCaptureVideoOrientation.portrait
        case .landscapeLeft:
            self = AVCaptureVideoOrientation.landscapeRight
        case .landscapeRight:
            self = AVCaptureVideoOrientation.landscapeLeft
        case .portraitUpsideDown:
            self = AVCaptureVideoOrientation.landscapeLeft
        default:
            self = AVCaptureVideoOrientation.portrait
        }
    }
}

