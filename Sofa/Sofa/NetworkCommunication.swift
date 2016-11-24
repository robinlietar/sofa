//
//  NetworkCommunication.swift
//  Sofa
//
//  Created by Robin Lietar on 16/11/2016.
//  Copyright © 2016 Sofa. All rights reserved.
//

import Foundation

class NetworkCommunication : NSObject, StreamDelegate
{
    
    let serverAddress: CFString = "localhost" as CFString
    let serverPort: UInt32 = 8000
    
    private var inputStream : InputStream!
    public var outputRead : String!
    private var outputStream : OutputStream!

    public var currentVC : String!

    override init(){
        print("Start")
        super.init()
        initNetwork()
        //return nil
    }

func initNetwork() {
    var readStream:  Unmanaged<CFReadStream>?
    var writeStream: Unmanaged<CFWriteStream>?
    
    CFStreamCreatePairWithSocketToHost(nil, self.serverAddress, self.serverPort, &readStream, &writeStream)
    self.inputStream = readStream!.takeRetainedValue()
    self.outputStream = writeStream!.takeRetainedValue()
    
    self.inputStream.delegate = self
    self.outputStream.delegate = self
    
    self.inputStream.schedule(in: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
    self.outputStream.schedule(in: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
    
    self.inputStream.open()
    self.outputStream.open()
}

func sendString (message: String){
    print("mess")
    print(message)
    let encodedDataArray = [UInt8](message.utf8)
    outputStream.write(encodedDataArray, maxLength: encodedDataArray.count)
}

func stream(_ handlestream: Stream, handle eventCode: Stream.Event) {
    print("stream event")
    switch (eventCode){
    case Stream.Event.errorOccurred:
        NSLog("ErrorOccurred")
        break
    case Stream.Event.endEncountered:
        NSLog("EndEncountered")
        break
        /*case Stream.Event.none:
         NSLog("None")
         break*/
    case Stream.Event.hasBytesAvailable:
        NSLog("HasBytesAvaible")
        var buffer = [UInt8](repeating: 0, count: 4096)
        if ( handlestream == inputStream){
            
            while (inputStream.hasBytesAvailable){
                let len = inputStream.read(&buffer, maxLength: buffer.count)
                if(len > 0){
                    let output = NSString(bytes: &buffer, length: buffer.count, encoding: String.Encoding.utf8.rawValue)
                    if (output != ""){
                        NSLog("server said: %@", output!)
                        outputRead = output as String!
                        sendBackOutput(_out: output as! String)
                                            }
                }
            }
        }
        break
        /*case Stream.Event.allZeros:
         NSLog("allZeros")
         break*/
    case Stream.Event.openCompleted:
        NSLog("OpenCompleted")
        break
    case Stream.Event.hasSpaceAvailable:
        NSLog("HasSpaceAvailable")
        break
    default:
        break
    }
    
}
    func sendBackOutput(_out: String){
        
        let index = _out.index(_out.startIndex, offsetBy: 1)
        let outputFirst = _out.substring(to: index)
        
        if (outputFirst == "1"){
            let notificationName = Notification.Name(self.currentVC + ".ConnexionSucceeded")
            NotificationCenter.default.post(name: notificationName, object: nil)
        }
//        else if (outputFirst == "["){
//            let notificationName = Notification.Name(self.currentVC + ".ConnexionSucceeded")
//            NotificationCenter.default.post(name: notificationName, object: nil)
//        }

        else {
            let notificationName = Notification.Name(self.currentVC + ".ConnexionFailed")
            NotificationCenter.default.post(name: notificationName, object: nil)
        }
        let notificationName = Notification.Name(self.currentVC)
        NotificationCenter.default.post(name: notificationName, object: nil)

    }
    
}
