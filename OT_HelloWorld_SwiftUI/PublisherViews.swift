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
        if ot.pubState == .notYet {
            Image("defaultAvatar")
                .resizable()
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
        if let view = ot.publisher.view {
            return view
        }
        // will happen only if pubstate = .notYet
        return UIImageView(image: UIImage(named: "closeXBlue"))
    }
    func updateUIView(_ uiView: UIView, context: Context) {

    }
    

}

