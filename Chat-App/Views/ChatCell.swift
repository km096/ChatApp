//
//  ChatCell.swift
//  Chat-App
//
//  Created by ME-MAC on 6/29/23.
//

import UIKit

class ChatCell: UITableViewCell {

    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var chatTextView: UITextView!
    @IBOutlet weak var chatStack: UIStackView!
    @IBOutlet weak var chatTextBubble: UIView!
    
    enum bubleType {
        case incoming
        case outgoing
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        chatTextBubble.layer.cornerRadius = 10
    }

    func setMessageData(message: Message) {
        userNameLbl.text = message.senderName
        chatTextView.text = message.messageText
    }
    
    func setBubbleType(type: bubleType) {
        if type == .incoming {
            chatStack.alignment = .leading
            chatTextBubble.backgroundColor = #colorLiteral(red: 0.7499189377, green: 0.7618390918, blue: 0.769818306, alpha: 0.7975022272)
        } else {
            chatStack.alignment = .trailing
            chatTextBubble.backgroundColor = #colorLiteral(red: 0.2326456606, green: 0.7939537764, blue: 0.4384539723, alpha: 0.7669228054)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


}
