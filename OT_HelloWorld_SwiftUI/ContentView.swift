//
//  ContentView.swift
//  OT_HelloWorld_SwiftUI
//
//  Created by Jaideep Shah on 7/2/20.
//  Copyright © 2020 Jaideep Shah. All rights reserved.
//

import SwiftUI
import OpenTok



struct ContentView: View  {
    @StateObject var ot : OT
    
    var body: some View {
        VStack {
            Header()
            PublisherView(openTok:ot)
            SubscriberView(openTok:ot)
        
        HStack {
            Button(action: {
                      print("button pressed")

                    }) {
                        Image("videoIconPub")
                        .resizable()
                    }
          }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(ot: OT())
    }
}
