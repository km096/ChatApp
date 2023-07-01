//
//  ChatRoomVC.swift
//  Chat-App
//
//  Created by ME-MAC on 6/29/23.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ChatRoomVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var chatTxt: UITextField!
    @IBOutlet weak var chatTableView: UITableView!
    
    var room: Room?
    var chatMessages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatTableView.delegate = self
        chatTableView.dataSource = self
//        containerView.bindToKeyboard()
        observeMessages()
        title = room?.roomName
    }
    
    func observeMessages() {
        guard let roomId = room?.roomId else {
            return
        }
        
        var messageRef: DatabaseReference!
        messageRef = Database.database().reference()
        
        messageRef.child("rooms").child(roomId).child("messages").observe(.childAdded) { [weak self] snapshot in
            guard let strongSelf = self else {
                return
            }
            
            if let data = snapshot.value as? [String: Any] {
                guard let senderName = data["senderName"] as? String,
                      let messageText = data["msgText"] as? String,
                      let userId = data["senderId"] as? String else {
                          return
                      }
                
                let message = Message.init(messageKey: snapshot.key, senderName: senderName, messageText: messageText, userId: userId)
        
                strongSelf.chatMessages.append(message)
                strongSelf.chatTableView.reloadData()
                strongSelf.chatTableView.scrollToRow(at: IndexPath(row: strongSelf.chatMessages.count - 1, section: 0), at: .bottom, animated: true)
               
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        let message = chatMessages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as! ChatCell
        cell.setMessageData(message: message)
        if message.userId == Auth.auth().currentUser?.uid {
            cell.setBubbleType(type: .outgoing)
        } else {
            cell.setBubbleType(type: .incoming)
        }

        return cell
    }
    
    @IBAction func sendBtnTapped(_ sender: Any) {
        guard let chatText = chatTxt.text, !chatText.isEmpty else {
            return
        }
        
        self.sendMessage(text: chatText) { isSuccess in
            if isSuccess {
                self.chatTxt.text = ""
                self.chatTxt.resignFirstResponder()
            }
        }
    }
    
    func sendMessage(text: String, completion: @escaping (_ isSuccess: Bool) -> ()) {
        
        guard let userId = Auth.auth().currentUser?.uid, let roomId = room?.roomId else {
            return
        }
        
        var roomRef: DatabaseReference!
        roomRef = Database.database().reference()
        
        let room = roomRef.child("rooms").child(roomId)
        let newMessageRef = room.child("messages").childByAutoId()
        
        self.getUsernameWithId(id: userId) { [weak self] username in
            guard let strongSelf = self else {
                return
            }
            if let userName = username {
                let messageData: [String: Any] = ["senderName": userName, "msgText": text, "senderId": userId, "date": ServerValue.timestamp()]
                newMessageRef.setValue(messageData) { [weak self] error, ref in
                    guard let strongSelf = self else {
                        return
                    }
                    
                    if error == nil {
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            }
        }
    }
    
    func getUsernameWithId(id: String, completion: @escaping (_ username: String?) -> ()) {
        
        var databaseRef: DatabaseReference!
        databaseRef = Database.database().reference()
        
        let user = databaseRef.child("users").child(id)
        
        user.child("username").observeSingleEvent(of: .value) { snapshot in
            if let userName = snapshot.value as? String {
                completion(userName)
            } else {
                completion(nil)
            }
        }
    }
        
    
}

