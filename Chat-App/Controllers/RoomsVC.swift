//
//  RoomsVC.swift
//  Chat-App
//
//  Created by ME-MAC on 6/29/23.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RoomsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var newRoomTxt: UITextField!
    @IBOutlet weak var roomsTableView: UITableView!
    
    var rooms = [Room]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        roomsTableView.dataSource = self
        roomsTableView.delegate = self
        
        observeRooms()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser == nil {
            presentLoginScreen()
        }
    }
    
    func presentLoginScreen() {
        let formVC = self.storyboard?.instantiateViewController(withIdentifier: "FormVC") as! FormVC
        present(formVC, animated: true)
    }
 
    func observeRooms() {
        var roomsRef: DatabaseReference!
        roomsRef = Database.database().reference()
        
        roomsRef.child("rooms").observe(.childAdded) { [weak self] snapshot in
            guard let strongSelf = self else {
                return
            }
            
            if let dataArray = snapshot.value as? [String: Any] {
                if let roomName = dataArray["roomName"] as? String {
                    let room = Room.init(roomName: roomName, roomId: snapshot.key)
                    strongSelf.rooms.append(room)
                    strongSelf.roomsTableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let room = rooms[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "roomCell", for: indexPath)
        cell.textLabel?.text = room.roomName
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatRoomVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatRoomVC") as! ChatRoomVC
        chatRoomVC.room = rooms[indexPath.row]
        self.navigationController?.pushViewController(chatRoomVC, animated: true)
    }
    
    @IBAction func logoutBtnTapped(_ sender: Any) {
        try! Auth.auth().signOut()
        
        presentLoginScreen()
    }
    
    @IBAction func creatRoomBtnTapped(_ sender: Any) {
        guard let userId = Auth.auth().currentUser?.uid, let roomName = newRoomTxt.text, !roomName.isEmpty else {
            return
        }
        
        newRoomTxt.resignFirstResponder()
        
        var databaseRef: DatabaseReference!
        databaseRef = Database.database().reference()
        
        let room = databaseRef.child("rooms").childByAutoId()
        let roomData: [String: Any] = ["creatorId": userId, "roomName": roomName]
        room.setValue(roomData) { [weak self] error, ref in
            guard let strongSelf = self else {
                return
            }
            
            if error == nil {
                strongSelf.newRoomTxt.text = ""
            }
        }
    }
}
