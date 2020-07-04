//
//  ContentView.swift
//  OT_HelloWorld_SwiftUI
//
//  Created by Jaideep Shah on 7/2/20.
//  Copyright © 2020 Jaideep Shah. All rights reserved.
//

import SwiftUI
import OpenTok

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

struct SubscriberView: UIViewRepresentable {
  
  var ot : OT
       init(openTok:OT) {
           ot = openTok
       }
    func makeUIView(context: Context) -> UIView {
        
        return ot.subscriber?.view! ?? UIView()
    }
    func updateUIView(_ uiView: UIView, context: Context) {

       
    }

}

struct ContentView: View  {
   @ObservedObject var ot = OT()
    
    var body: some View {
        VStack {
            Text("Publisher").bold()
            PublisherView(openTok: ot)
                .frame(width: 100, height: 150, alignment: .center)
            .clipShape(Capsule())
            Divider()
            if ot.subscriber == nil {
                Text("Waiting for someone")
            }  else {
                Text("Subscriber").bold()
                SubscriberView(openTok: ot)
                    .frame(width: 100, height: 120, alignment: .center)
                    .clipShape(Circle())
                
            }
            Spacer()
            
            //s.frame(width: 100, height: 150, alignment: .center)
                    
            
           
            
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
