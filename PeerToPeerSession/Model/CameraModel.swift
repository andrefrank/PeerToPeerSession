//
//  CameraModel.swift
//  PeerToPeerSession
//
//  Created by Andre Frank on 21.02.22.
//

import SwiftUI
import AVFoundation


//MARK: - Camera Model
class CameraModel:NSObject,ObservableObject {
    
    @Published var isTaken:Bool=false
    @Published var session = AVCaptureSession()
    @Published var showAlert:Bool = false
    @Published var previewLayer : AVCaptureVideoPreviewLayer!
    @Published var previewVideoImage:UIImage!
    @Published var orientation:UIDeviceOrientation = .unknown
    
    
    let output = AVCaptureVideoDataOutput()
    private let outputQueue = DispatchQueue(label: "com.cameraOutput.serialQueue")
    
    func checkCameraAuthorization() {
       let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
          setupCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { success in
                if success {
                    self.setupCamera()
                }
            }
            
        case .denied:
            self.showAlert.toggle()
        default:
            return
        }
        
    }
    
    
   private func setupCamera(){
        do {
            session.beginConfiguration()
            let device = AVCaptureDevice.default(.builtInDualWideCamera, for: .video, position: .back)
            
            
            let input = try AVCaptureDeviceInput(device: device!)
            
            
            if self.session.canAddInput(input){
                self.session.addInput(input)
            }
            
            if session.canAddOutput(output){
                self.session.addOutput(output)
                self.output.setSampleBufferDelegate(self, queue:outputQueue)
            }
            
            session.commitConfiguration()
            
        } catch {
            
            print(error.localizedDescription)
        }
    }
    
    
    func updateCameraOrientation(){
        //Change previewLayer orientation
        if let previewLayerConnection = previewLayer.connection, previewLayerConnection.isVideoOrientationSupported {
            previewLayerConnection.videoOrientation = AVCaptureVideoOrientation(orientation)
        
        }
        
        //Change video orientation
        if let captureSessionConnection = session.connections.first, captureSessionConnection.isVideoOrientationSupported {
            captureSessionConnection.videoOrientation = AVCaptureVideoOrientation(orientation)
        }
    
        previewLayer.frame = UIScreen.main.bounds
    
    }
    
    var previewImageSize:CGSize {
        var width:CGFloat=0
        var height:CGFloat=0
        
        if orientation == .portrait || orientation == .portraitUpsideDown || orientation == .unknown {
            height = previewLayer.frame.height / 3
            width = height * previewLayer.frame.width / previewLayer.frame.height
            
            
        } else if orientation == .landscapeLeft || orientation == .landscapeRight {
            
            width = previewLayer.frame.width / 3
            height = width * previewLayer.frame.height / previewLayer.frame.width
            
        }
        
        return CGSize(width: width, height: height)
    }
    
}

//MARK: - AVCaptureVideoData Delegate
extension CameraModel:AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
            DispatchQueue.main.async { [weak self] in
                if let image = sampleBuffer.imageWithCGImage() {
                    self?.previewVideoImage = image.rotate(respect: UIDevice.current.orientation)
            }
          }
    }
}


