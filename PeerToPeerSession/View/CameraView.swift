//
//  CameraView.swift
//  PeerToPeerSession
//
//  Created by Andre Frank on 20.02.22.
//

import SwiftUI
import AVFoundation

//MARK: - Camera View

struct CameraView:View {
    @StateObject var cameraModel = CameraModel()
    
    var body: some View {
        ZStack {
            CameraPreviewView(cameraModel: cameraModel)
                .ignoresSafeArea(.all, edges: .all)
                .onOrientationChange { _ in
                    cameraModel.orientation = UIDevice.current.orientation
                    cameraModel.updateCameraOrientation()
                }
            VStack {
                
                HStack {
                    Spacer()
                if cameraModel.previewVideoImage != nil {
                    Image(uiImage: cameraModel.previewVideoImage)
                    .resizable()
                    .frame(width: cameraModel.previewImageSize.width, height: cameraModel.previewImageSize.height)
                    .border(Color.red, width: 2)
                }
                Spacer()
                    
                if cameraModel.isTaken {
                    
                   // HStack {
                       // Spacer()
                        
                        Button {
                            cameraModel.isTaken.toggle()
                        } label: {
                                Image(systemName: "arrow.triangle.2.circlepath.camera")
                                .padding()
                                .foregroundColor(Color.black)
                                .background(Color.white)
                                .clipShape(Circle())
                            }
                           // .padding()
                    //}
                    
                }
                    
                
             }
                
                Spacer()
                
              HStack {
                if cameraModel.isTaken {
                    Button {
                        cameraModel.isTaken.toggle()
                    } label: {
                       Text("Save")
                            .foregroundColor(Color.black)
                            .fontWeight(.semibold)
                            .padding(.vertical,10)
                            .padding(.horizontal,20)
                           .background(Color.white)
                            .clipShape(Capsule())
                        } .padding(.leading)
                   
                       Spacer()
                       
                    } else {
                        Button {
                            cameraModel.isTaken.toggle()
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 65,height: 65)
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                                    .frame(width: 75)
                            }
                        }
                    }//Else
                }
              .frame(height: 75)
                //HStack
            }
            .onAppear {
                cameraModel.checkCameraAuthorization()
            }
            //VStack
        }
    }
}



//MARK: - Main View
struct MainView : View {
    var body: some View {
        CameraView()
    }
}


struct CameraView_Preview:PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

