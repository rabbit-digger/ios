//
//  ContentView.swift
//  rdp-ios
//
//  Created by space on 2022/3/6.
//

import SwiftUI
import Alamofire

struct ContentView: View {
    @State var text: String?
    @State var counter: Int = 0
    var rdp: RDPWrapper? = try? RDPWrapper.init(config: """
server:
  socks5:
    type: socks5
    bind: 0.0.0.0:10800
""")
    
    func viewDidLoad() {
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Hello, world! Count \(counter). Text: \(text ?? "No data")")
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
        AF.request("https://httpbin.org/get").responseString { response in
            debugPrint(response)
            self.text = try? response.result.get()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
