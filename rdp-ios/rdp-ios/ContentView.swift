//
//  ContentView.swift
//  rdp-ios
//
//  Created by space on 2022/3/6.
//

import SwiftUI

struct ContentView: View {
    @State var counter: Int = 0
    var rdp: RDPWrapper? = try? RDPWrapper.init(config: """
server:
  socks5:
    type: socks5
    bind: 0.0.0.0:10800
""")
    
    init() {
        RDPWrapper.setup_stdout_logger()
        print("init");
    }
  
    var body: some View {
        VStack(alignment: .leading) {
            Text("Hello, world! Count \(counter)")
                .padding()
            Button("+1", action: {
                self.counter += 1
            })
            Button("-1", action: {
                self.counter -= 1
            })
            Button("Click me!", action: onClick)
        }
    }
    
    func onClick() {
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
