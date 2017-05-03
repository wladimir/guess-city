//
//  SocketHelper.swift
//  Cityzen
//
//  Created by Vladimir Cirkovic on 4/28/17.
//  Copyright © 2017 Vladimir Cirkovic. All rights reserved.
//

import Foundation
import SocketIO

class SocketHelper {
    var socket: SocketIOClient?
    var resetAck: SocketAckEmitter?

    init(playerId: String) {
        socket = SocketIOClient(socketURL: URL(string: "http://localhost:5000")!,
                                config: [.log(true),
                                         .connectParams(["ping_interval":5000, "name":playerId])]) // log in

        addHandlers()
    }

    func connect() {
        socket?.connect()
    }

    func disconnect() {
        socket?.disconnect()
    }

    private func addHandlers() {
        socket?.on("userConnectUpdate") { (data, ack) -> Void in
            NotificationCenter.default.post(name: Notification.Name("aaa"), object: data[0] as! [String: AnyObject])
        }

        socket?.on("connect") {data, ack in
        }

        socket?.on("disconnect") {data, ack in
        }

        socket?.on("answer") {data, ack in
            if let cur = data[0] as? Double {
                self.socket?.emitWithAck("canAnswer", cur).timingOut(after: 2) {data in
                    self.socket?.emit("sendAnswer", ["amount": cur + 2.50])
                }

                ack.with("Got your currentAmount", "dude")
            }
        }

        socket?.on("error") {data, ack in
            print("error")
        }

        socket?.on("startGame") {[weak self] data, ack in
            self?.handleStart()
            return
        }

        socket?.on("playerMove") {[weak self] data, ack in
            if let name = data[0] as? String, let x = data[1] as? Int, let y = data[2] as? Int {
                self?.handlePlayerMove(name: name, coord: (x, y))
            }
        }

        socket?.on("win") {[weak self] data, ack in
            if let name = data[0] as? String, let typeDict = data[1] as? NSDictionary {
                self?.handleWin(name: name, type: typeDict)
            }
        }

        socket?.on("gameReset") {[weak self] data, ack in
            let alert = UIAlertController(title: "Play Again?", message: "Do you want to play another round?", preferredStyle: .alert)

            let okButton = UIAlertAction(title: "Yes", style: .default, handler: { (UIAlertAction) in
                self!.resetAck?.with(false)
            })

            alert.addAction(okButton)
            //self!.present(alert, animated: true, completion: nil)
        }

        // socket?.onAny {print("Got event: \($0.event), with items: \($0.items ?? [])")}

    }

    func handleWin(name: String, type: NSDictionary) {

    }
    
    func handleStart() {
        
    }
    
    func handlePlayerMove(name: String, coord: (Int, Int) ) {
        
    }
}
