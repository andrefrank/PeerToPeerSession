//
//  MCSessionBrowserRepresentable.swift
//  PeerToPeerSession
//
//  Created by Andre Frank on 20.02.22.
//

import SwiftUI
import MultipeerConnectivity

/// An UIViewRepresentableController which encapsulates MCBrowserViewController and Delegate methods
///
///   The MCBrowserViewcontroller will be presented by  an default UIViewController
struct MCBrowserSessionRepresentable:UIViewControllerRepresentable {
    //MARK: - Dependencies
    
    ///Show / Dismiss MCBrowserViewController
    @Binding var isActive:Bool
    
    ///MCBrowserViewController required settings
    let serviceType:String
    let session:MCSession
    
    
    /// The MCBrowserViewcontroller to be shown
    @State private var browser:MCBrowserViewController!
    
    func makeUIViewController(context: Context) -> UIViewController {
        // Create MCBrowserViewController on Main thread since changing state
        OperationQueue.main.addOperation {
            browser = MCBrowserViewController(serviceType: serviceType, session: session)
            browser.delegate = context.coordinator
        }
       
        //The ViewController on which MCBrowserViewController will be presented
        let presentingController = UIViewController()
        return presentingController
        
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        //Check if the browser is currently not shown up then present it
        if isActive && !uiViewController.isBeingPresented && browser != nil {
            uiViewController.present(browser, animated: true)
        //Check if user has canceled or confirmed the connection, dismiss the presenting
        // ViewController
        } else if !isActive && uiViewController.isBeingPresented && browser != nil {
            uiViewController.dismiss(animated: true)
        }
    }
    
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent:self)
    }
    
    //MARK: - MCBrowserViewControllerDelegate
    class Coordinator:NSObject,MCBrowserViewControllerDelegate {
        let parent:MCBrowserSessionRepresentable
        
        init(parent:MCBrowserSessionRepresentable){
            self.parent = parent
            super.init()
        }
    
        func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
            parent.isActive=false
            browserViewController.dismiss(animated: true)
            
        }
        
        func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
            parent.isActive=false
            browserViewController.dismiss(animated: true)
        }
    }
}
