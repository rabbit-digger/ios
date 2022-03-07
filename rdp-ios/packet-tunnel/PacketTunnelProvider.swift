//
//  PacketTunnelProvider.swift
//  packet-tunnel
//
//  Created by space on 2022/3/7.
//

import Foundation
import NetworkExtension

var conf: String = """
server:
  socks5:
    type: socks5
    bind: 0.0.0.0:10800
"""

class PacketTunnelProvider: NEPacketTunnelProvider {
    private var rdp: RDPWrapper?
    override func startTunnel(options: [String : NSObject]?, completionHandler: @escaping (Error?) -> Void) {
        let tunnelNetworkSettings = createTunnelSettings()
        setTunnelNetworkSettings(tunnelNetworkSettings) { [weak self] error in
            let tunFd = self?.packetFlow.value(forKeyPath: "socket.fileDescriptor") as! Int32
            let confWithFd = conf.replacingOccurrences(of: "REPLACE-ME-WITH-THE-FD", with: String(tunFd))

            // The CA is used by OpenSSl.
            // You may download a CA from https://curl.se/docs/caextract.html
            var certPath = Bundle.main.executableURL?.deletingLastPathComponent()
            setenv("SSL_CERT_DIR", certPath?.path, 1)
            certPath?.appendPathComponent("cacert.pem")
            setenv("SSL_CERT_FILE", certPath?.path, 1)
            DispatchQueue.global(qos: .userInteractive).async {
                signal(SIGPIPE, SIG_IGN)
                do {
                    self?.rdp = try RDPWrapper.init(config: confWithFd)
                } catch {
                    print("failed to init rdp: \(error)")
                }
            }
            completionHandler(nil)
        }
    }
    
    override func stopTunnel(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    override func handleAppMessage(_ messageData: Data, completionHandler: ((Data?) -> Void)?) {
        // Add code here to handle the message.
        if let handler = completionHandler {
            handler(messageData)
        }
    }
    
    override func sleep(completionHandler: @escaping () -> Void) {
        // Add code here to get ready to sleep.
        completionHandler()
    }
    
    override func wake() {
        // Add code here to wake up.
    }
    
    func createTunnelSettings() -> NEPacketTunnelNetworkSettings  {
        let newSettings = NEPacketTunnelNetworkSettings(tunnelRemoteAddress: "240.0.0.10")
        newSettings.ipv4Settings = NEIPv4Settings(addresses: ["240.0.0.1"], subnetMasks: ["255.255.255.0"])
        newSettings.ipv4Settings?.includedRoutes = [NEIPv4Route.`default`()]
        newSettings.proxySettings = nil
        newSettings.dnsSettings = NEDNSSettings(servers: ["223.5.5.5", "8.8.8.8"])
        newSettings.mtu = 1500
        return newSettings
    }
}
