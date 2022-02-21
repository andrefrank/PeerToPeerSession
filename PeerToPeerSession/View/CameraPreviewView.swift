//
//  CameraPreviewView.swift
//  PeerToPeerSession
//
//  Created by Andre Frank on 21.02.22.
//

import SwiftUI
import AVFoundation


//MARK: - CameraPreview View
struct CameraPreviewView:UIViewRepresentable {
    @ObservedObject var cameraModel:CameraModel
    
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        
        cameraModel.previewLayer = AVCaptureVideoPreviewLayer(session: cameraModel.session)
        cameraModel.previewLayer.frame = view.frame
        cameraModel.previewLayer.videoGravity = .resizeAspectFill
        
        view.layer.addSublayer(cameraModel.previewLayer)
        
        cameraModel.session.startRunning()
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

