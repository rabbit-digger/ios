//
//  rdp_iosApp.swift
//  rdp-ios
//
//  Created by space on 2022/3/6.
//

import SwiftUI

@main
struct rdp_iosApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    init() {
        RDPWrapper.setup_stdout_logger()
        triggerLocalNetworkPrivacyAlert()
    }
}
