//
//  ContentViewModel.swift
//  PeerToPeerSession
//
//  Created by Andre Frank on 19.02.22.
//

import SwiftUI
import MultipeerConnectivity


class ContentViewModel:NSObject,ObservableObject {
    
    @Published var sessionState:String="Not connected"
    
     let serviceType = "af-peer"
    private (set) var session:MCSession?
    private var peerID:MCPeerID!
    private var nearbyAdvertiser:MCNearbyServiceAdvertiser?
    private var nearbyPeer:MCPeerID?
  //  private var nearbyBrowser:MCNearbyServiceBrowser?
    
    
    
    
    override init(){
        peerID = MCPeerID(displayName: UIDevice.current.name)
        session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
       
        // nearbyBrowser = MCNearbyServiceBrowser(peer: peerID, serviceType: serviceType)
        
        super.init()
        
        
        session?.delegate = self
    }
    
    func invite(){
        guard let session = session else {
            return
        }

        let browserController = MCBrowserViewController(serviceType: serviceType, session: session)
        browserController.delegate = self
        presentingController?.present(browserController, animated: true)
    }
    
    var presentingController:UIViewController?{
       return UIApplication.shared.connectedScenes.filter {
            $0.activationState == .foregroundActive
       }.compactMap { scene in
           scene as? UIWindowScene
       }.first?.windows
        .filter({ window in
            window.isKeyWindow
        }).first?.rootViewController
    }
    
    
    func advertise(){
       nearbyAdvertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo:nil, serviceType: serviceType)
        nearbyAdvertiser?.delegate = self
        nearbyAdvertiser?.startAdvertisingPeer()
    }
    
    func stopConnection(){
        session?.disconnect()
    }
}

extension ContentViewModel:MCSessionDelegate {
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
        Task {
            await MainActor.run {
                var stateText:String=""
                
                switch state {
                    case .notConnected:
                      stateText = "Not connected"
                    
                    case .connecting:
                    stateText = "Try to connect to\(peerID.displayName)"
                    case .connected:
                    
                    stateText = "Connected to \(peerID.displayName)"
                    
                    //Stop advertising after a peer has been accept a connection.
                    //This will force  1 one by 1 connection
                   
                    //nearbyAdvertiser?.stopAdvertisingPeer()
                  
                default:
                    stateText = "Unknown state"
                }
                
                self.sessionState = stateText
            }
        }
    }
    
 //   func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
        
 //   }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
    }
}

extension ContentViewModel:MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("Call invitation handler")
         invitationHandler(true,session)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print("Did not start advertising")
    }
}

extension ContentViewModel:MCBrowserViewControllerDelegate {
    //Use this delegate method to accept only one connection
    func browserViewController(_ browserViewController: MCBrowserViewController, shouldPresentNearbyPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) -> Bool {
        print("discovering Peers")
        return true
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        browserViewController.dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        browserViewController.dismiss(animated: true, completion: nil)
    }
}
