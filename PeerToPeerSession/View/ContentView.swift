//
//  ContentView.swift
//  PeerToPeerSession
//
//  Created by Andre Frank on 19.02.22.
//

import SwiftUI


struct ContentView: View {
    @EnvironmentObject var model:ContentViewModel
    @State private var showInvite:Bool=false
    
    var body: some View {
        NavigationView {
          
           
            VStack(spacing:15) {

                Spacer()
                
                Button {
                    model.advertise()
                } label: {
                    Text("Advertise")
                }.font(.title)
                
                
                Button {
                   // model.invite()
                    withAnimation(.easeInOut(duration: 2.0)) {
                        self.showInvite.toggle()
                    }
                } label: {
                    Text("Invite")
                }.font(.title)
                
                Button {
                    model.stopConnection()
                } label: {
                    Text("Stop Connection")
                }.font(.title)
                
                Spacer()
                
                if showInvite {
                    MCBrowserSessionRepresentable(isActive: $showInvite, serviceType: model.serviceType, session: model.session!)
                }
                
                StateView(state: model.sessionState)

            }
            .transition(.asymmetric(insertion: .slide, removal: .slide))
            .navigationTitle("MultipeerConnect")
            
        }
    }
}

struct StateView:View {
    let state:String
    var body: some View {
        Text(state)
        .background(Color.clear)
        .font(.headline)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ContentViewModel())
    }
}
