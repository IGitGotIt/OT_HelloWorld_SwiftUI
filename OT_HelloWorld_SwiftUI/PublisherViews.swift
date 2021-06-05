//
//  PublisherView.swift
//  OT_HelloWorld_SwiftUI
//
//  Created by Jaideep Shah on 6/4/21.
//  Copyright © 2021 Jaideep Shah. All rights reserved.
//

import SwiftUI
import OpenTok

struct PublisherView {
    @ObservedObject var ot : OT
    
    init(openTok:OT) {
        ot = openTok
    }
}
extension PublisherView : View {
    var body: some View {
        Text("Publisher")
            .bold()
        if ot.pubState == .none {
            Image("defaultAvatar")
                .frame(width: 100, height: 100, alignment: .center)
        } else {
            UIPublisherView(openTok: ot)
        }
        
    }
}


struct UIPublisherView: UIViewRepresentable {
    var ot : OT
    init(openTok:OT) {
        ot = openTok
    }
    func makeUIView(context: Context) -> UIView {
        ot.publisher.view!
        
    }
    func updateUIView(_ uiView: UIView, context: Context) {

    }
    

}

