//
//  ChatViewController.swift
//  chatApp
//
//  Created by Ajay Vandra on 1/23/20.
//  Copyright © 2020 Ajay Vandra. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework

class ChatViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate{
   
    var messageArray : [Message]=[Message]()

    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageTableview: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    override func viewDidLoad() {
        
        super.viewDidLoad()

        messageTableview.delegate = self
        messageTableview.dataSource = self
        messageTableview.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        configureTableView()
        retrieveMessages()
        
        messageTableview.separatorStyle = .none
        
        messageTextField.delegate = self
    
    }

//    func textFieldDidBeginEditing(_ textField: UITextField) {
//
//        UIView.animate(withDuration: 0.5) {
//            self.heightConstraint.constant = 300
//            self.view.layoutIfNeeded()
//        }
//
//    }
//    func textFieldDidEndEditing(_ textField: UITextField) {
//
//    }

    @IBAction func sendPressed(_ sender: UIButton) {
//        messageTextField.endEditing(true)
        
        messageTextField.isEnabled = false
        sendButton.isEnabled = false
        
        let messageDB = Database.database().reference().child("Messages")
        
        let messageDictionary = ["sender": Auth.auth().currentUser?.email,"MessageBody": messageTextField.text!]
        
        messageDB.childByAutoId().setValue(messageDictionary){
            (error,reference) in
            
            if error != nil{
                print(error!)
            }
            else{
                print("message saved successfully")
                self.messageTextField.isEnabled = true
                self.sendButton.isEnabled = true
                self.messageTextField.text = ""
            }
        }
    }
    
    func retrieveMessages(){
        let messageDB = Database.database().reference().child("Messages")
        
        messageDB.observe(.childAdded) { (snapshot) in
        
                let snapshotValue = snapshot.value as! Dictionary<String,String>
                
                let text = snapshotValue["MessageBody"]!
                let sender = snapshotValue["sender"]!
                
                print(text,sender)
            let message = Message()
            message.messageBody = text
            message.sender = sender
            
            self.messageArray.append(message)
            
            self.configureTableView()
            self.messageTableview.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        cell.senderUsername.text = messageArray[indexPath.row].sender
        cell.avatarImageView.image = UIImage(named: "sunny")
        
        if cell.senderUsername.text == Auth.auth().currentUser?.email as String?{
            cell.avatarImageView.backgroundColor = UIColor.flatSkyBlue()
            cell.messageBackground.backgroundColor = UIColor.flatSkyBlue()
        }else{
            cell.avatarImageView.backgroundColor = UIColor.black
            cell.messageBackground.backgroundColor = UIColor.black
        }
        return cell 
    }
    func configureTableView(){
        messageTableview.rowHeight = UITableView.automaticDimension
        messageTableview.estimatedRowHeight = 120.0
    }
    
    
    
    @IBAction func logoutPressed(_ sender: Any) {
        do{
         try Auth.auth().signOut()
            navigationController?.popViewController(animated: true)

        }
        catch{
            print("problem in signing out")
        }
    }
    
}
