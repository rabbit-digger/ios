//
//  ContentView.swift
//  rdp-ios
//
//  Created by space on 2022/3/6.
//

import SwiftUI
import Alamofire

struct ContentView: View {
    var manager = VPNManager.shared()
    let pub = NotificationCenter.default
        .publisher(for: NSNotification.Name.NEVPNStatusDidChange)
    
    @State var isVPNOn: Bool = false
    
    func viewDidLoad() {
        manager.loadVPNPreference() { error in
            guard error == nil else {
                fatalError("load VPN preference failed: \(error.debugDescription)")
            }
            self.updateStatus()
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Button("获取联网权限!", action: request)
            Toggle("启动 rabbit-digger-pro", isOn: $isVPNOn )
                .onChange(of: isVPNOn) { _v in
                    toggle()
                }
        }.onReceive(pub) { (output) in
            self.updateStatus()
        }
    }
    
    func toggle() {
        manager.enableVPNManager() { error in
            guard error == nil else {
                fatalError("enable VPN failed: \(error.debugDescription)")
            }
            self.manager.toggleVPNConnection() { error in
                guard error == nil else {
                    fatalError("toggle VPN connection failed: \(error.debugDescription)")
                }
            }
        }
    }
    
    func updateStatus() {
        self.isVPNOn = (manager.manager.connection.status != .disconnected &&
                        manager.manager.connection.status != .disconnecting &&
                        manager.manager.connection.status != .invalid)
    }
    
    
    func request() {
        AF.request("https://httpbin.org/get").responseString { response in
            debugPrint(response)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
