//
//  ContentView.swift
//  OT_HelloWorld_SwiftUI
//
//  Created by Jaideep Shah on 7/2/20.
//  Copyright © 2020 Jaideep Shah. All rights reserved.
//

import SwiftUI

struct PublisherView: UIViewRepresentable {
    var ot : OT
    init(openTok:OT) {
        ot = openTok
    }
    func makeUIView(context: Context) -> UIView {
        return ot.publisher.view!
       }
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
    
}

//struct SubscriberView: UIViewRepresentable {
//    var ot : OT
//    init(openTok:OT) {
//        ot = openTok
//    }
//    func makeUIView(context: Context) -> UIView {
//        if ot.subscriber != nil {
//            return ot.subscriber!.view!
//        }
//        return UIView()
//       }
//    func updateUIView(_ uiView: UIView, context: Context) {
//        uiView = ot.subscriber!.view!
//    }
//
//}

struct ContentView: View  {
    var ot = OT()
  
    var body: some View {
        VStack {
            Text("Publisher").bold()
            PublisherView(openTok: ot)
                .frame(width: 300, height: 400, alignment: .center)
            .clipShape(Capsule())
            
            
           
            
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
