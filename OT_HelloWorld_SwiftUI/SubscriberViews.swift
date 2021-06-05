//
//  SubscriberView.swift
//  OT_HelloWorld_SwiftUI
//
//  Created by Jaideep Shah on 6/4/21.
//  Copyright © 2021 Jaideep Shah. All rights reserved.
//

import SwiftUI
import OpenTok

struct SubscriberView {
    @ObservedObject var ot : OT

    init(openTok:OT) {
        ot = openTok
    }
}
extension SubscriberView : View {
    var body: some View {
        if ot.subState == .none {
            Image("defaultAvatar")
                .frame(width: 100, height: 100, alignment: .center)
            } else {
                UISubscriberView(openTok: ot)
            }
      
        }
}

struct UISubscriberView: UIViewRepresentable {
    var ot : OT
    
    init(openTok:OT) {
           ot = openTok
    }
    func makeUIView(context: Context) -> UIView {
        ot.subscriber!.view!
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

