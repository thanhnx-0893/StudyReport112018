//
//  ContactCell.swift
//  DragAndDropCellDemo
//
//  Created by Thanh Nguyen Xuan on 11/20/18.
//  Copyright © 2018 None. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {

    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var fullNameLabel: UILabel!
    @IBOutlet private weak var phoneNumberLabel: UILabel!
    @IBOutlet private weak var flowerImageView: UIImageView!
    
    var handleLongPressGesture: (UILongPressGestureRecognizer) -> Void = { _ in }
    var contact: Contact? {
        didSet {
            updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureRecognized(_:)))
        flowerImageView.isUserInteractionEnabled = true
        flowerImageView.addGestureRecognizer(longPressGesture)
    }

    private func updateUI() {
        guard let contact = self.contact else {
            return
        }
        avatarImageView.image = UIImage(named: contact.avatarImage)
        fullNameLabel.text = contact.fullName
        phoneNumberLabel.text = contact.phoneNumber
    }
    
    @objc private func longPressGestureRecognized(_ gesture: UILongPressGestureRecognizer) {
        handleLongPressGesture(gesture)
    }
    
}
