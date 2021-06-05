//
//  ViewController.swift
//  Hello-World
//
//  Created by Roberto Perez Cubero on 11/08/16.
//  Copyright © 2016 tokbox. All rights reserved.
//

import UIKit
import OpenTok

// *** Fill the following variables using your own Project info  ***
// ***            https://tokbox.com/account/#/                  ***
// Replace with your OpenTok API key
let kApiKey = "100"
// Replace with your generated session ID
let kSessionId = "1_MX4xMDB-fjE2MjI4NjgzNDY5MjV-aklrOEoxVCtZQmI3a1VrSUtKV2FqYnQ1fn4"
// Replace with your generated token
let kToken = "T1==cGFydG5lcl9pZD0xMDAmc2RrX3ZlcnNpb249dGJwaHAtdjAuOTEuMjAxMS0wNy0wNSZzaWc9MGFlYjQ1OWEyNzMzZjlmYmMxYmFjNTg3YzU0MjJmMzExNzNhOTVlNzpzZXNzaW9uX2lkPTFfTVg0eE1EQi1makUyTWpJNE5qZ3pORFk1TWpWLWFrbHJPRW94VkN0WlFtSTNhMVZyU1V0S1YyRnFZblExZm40JmNyZWF0ZV90aW1lPTE2MjI4NjgzNDcmcm9sZT1tb2RlcmF0b3Imbm9uY2U9MTYyMjg2ODM0Ny4wNDc1MjA3OTY5OTE3NSZleHBpcmVfdGltZT0xNjI1NDYwMzQ3"

let kWidgetHeight = 240
let kWidgetWidth = 320

enum SubscriberState: String {
    case didConnect = "Subscriber connected."
    case didReconnect = "Subscriber did reconnect."
    case failed = "Subscriber failed."
    case notYet = "Waiting for someone."
}

enum PublisherState: String {
    case didConnect = "Publisher connected."
    case destroyed = "Publisher destroyed."
    case failed = "Publisher failed."
    case notYet = "Wait...."
    case startedInit = "Started initilization."
}

class OT: NSObject {

    @Published var subState: SubscriberState = .notYet
    @Published var pubState: PublisherState  = .notYet
    var subscriber: OTSubscriber?
    
    lazy var session: OTSession = {
        return OTSession(apiKey: kApiKey, sessionId: kSessionId, delegate: self)!
    }()
    
    lazy var publisher: OTPublisher = {
        let settings = OTPublisherSettings()
        settings.name = UIDevice.current.name
        settings.audioTrack = true
        settings.videoTrack = true
        pubState = .startedInit
        return OTPublisher(delegate: self, settings: settings)!
    }()
    
 
    
    override  init() {
        super.init()
        //otc_log_enable(2348209)
        doConnect()
    }
    
    func getSessionId() -> String {
        return session.sessionId
    }
    /**
     * Asynchronously begins the session connect process. Some time later, we will
     * expect a delegate method to call us back with the results of this action.
     */
    fileprivate func doConnect() {
        var error: OTError?
        defer {
            processError(error)
        }
        
        session.connect(withToken: kToken, error: &error)
    }
    
    /**
     * Sets up an instance of OTPublisher to use with this session. OTPubilsher
     * binds to the device camera and microphone, and will provide A/V streams
     * to the OpenTok session.
     */
    fileprivate func doPublish() {
        var error: OTError?
        defer {
            processError(error)
        }
  
        session.publish(publisher, error: &error)
       
    }
    
    /**
     * Instantiates a subscriber for the given stream and asynchronously begins the
     * process to begin receiving A/V content for this stream. Unlike doPublish,
     * this method does not add the subscriber to the view hierarchy. Instead, we
     * add the subscriber only after it has connected and begins receiving data.
     */
    fileprivate func doSubscribe(_ stream: OTStream) {
        var error: OTError?
        defer {
            processError(error)
        }
        subscriber = OTSubscriber(stream: stream, delegate: self)
        subscriber?.delegate = self
        session.subscribe(subscriber!, error: &error)
    }
    
    fileprivate func cleanupSubscriber() {
        subscriber?.view?.removeFromSuperview()
        subscriber = nil
    }
    
    fileprivate func cleanupPublisher() {
        publisher.view?.removeFromSuperview()
    }
    
    fileprivate func processError(_ error: OTError?) {

    }
}

// MARK: - OTSession delegate callbacks
extension OT: OTSessionDelegate {
    func sessionDidConnect(_ session: OTSession) {
        print("Session connected")
        doPublish()
    }
    
    func sessionDidDisconnect(_ session: OTSession) {
        print("Session disconnected")
    }
    
    func session(_ session: OTSession, streamCreated stream: OTStream) {
        print("Session streamCreated: \(stream.streamId)")
        if subscriber == nil {
            doSubscribe(stream)
        }
    }
    
    func session(_ session: OTSession, streamDestroyed stream: OTStream) {
        print("Session streamDestroyed: \(stream.streamId)")
        if let subStream = subscriber?.stream, subStream.streamId == stream.streamId {
            cleanupSubscriber()
        }
    }
    
    func session(_ session: OTSession, didFailWithError error: OTError) {
        print("session Failed to connect: \(error.localizedDescription)")
    }
    
    func sessionDidReconnect(_ session: OTSession) {
         print("session did reconnect")
    }
    
}
// MARK: ObservableObject
extension OT: ObservableObject {
    
}
// MARK: - OTPublisher delegate callbacks
extension OT: OTPublisherDelegate {
    func publisher(_ publisher: OTPublisherKit, streamCreated stream: OTStream) {
        print("Publishing")
        pubState = .didConnect
        doSubscribe(stream)
      
    }
    
    func publisher(_ publisher: OTPublisherKit, streamDestroyed stream: OTStream) {
        pubState = .destroyed
        cleanupPublisher()
        if let subStream = subscriber?.stream, subStream.streamId == stream.streamId {
            cleanupSubscriber()
        }
    }
    
    func publisher(_ publisher: OTPublisherKit, didFailWithError error: OTError) {
        pubState = .failed
        print("Publisher failed: \(error.localizedDescription)")
    }
}

// MARK: - OTSubscriber delegate callbacks
extension OT: OTSubscriberDelegate {
    func subscriberDidConnect(toStream subscriberKit: OTSubscriberKit) {
        subState = .didConnect
    }
    
    func subscriber(_ subscriber: OTSubscriberKit, didFailWithError error: OTError) {
        subState = .failed
        print("Subscriber failed: \(error.localizedDescription)")
    }
    func subscriberDidReconnect(toStream subscriber: OTSubscriberKit) {
        subState = .didReconnect
         print("Subscriber did reconnect")
    }
}
