//
//  ContactsViewController.swift
//  DragAndDropCellDemo
//
//  Created by Thanh Nguyen Xuan on 11/20/18.
//  Copyright © 2018 None. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController {

    @IBOutlet weak var contactsTableView: UITableView!
    private var contacts = [Contact]()
    
    private var currentIndexPath: IndexPath? // Lưu indexPath lúc bắt đầu nhấn giữ và sau khi swap
    private var snapShotView: UIView? // Snapshot view của cell được chọn
    private var isCellAnimating = false // Flag animate cell
    private var isCellNeedToShow = false // Flag ẩn hiện cell
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createContacts()
    }
    
    private func createContacts() {
        contacts = [
            Contact(avatarImage: "taylor_swift", fullName: "Taylor Swift", phoneNumber: "+8006546748"),
            Contact(avatarImage: "ed_sheeran", fullName: "Ed Sheeran", phoneNumber: "+8784165786"),
            Contact(avatarImage: "jisoo", fullName: "JISOO", phoneNumber: "+82546578550"),
            Contact(avatarImage: "bruno_mars", fullName: "Bruno Mars", phoneNumber: "+80021024152"),
            Contact(avatarImage: "zayn", fullName: "Zayn", phoneNumber: "+84114578778")
        ]
    }
    
    private func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        let locationInView = gesture.location(in: contactsTableView)
        let indexPath = contactsTableView.indexPathForRow(at: locationInView)
        switch gesture.state {
        case .began:
            beginDragging(at: indexPath, locationInView: locationInView)
        case .changed:
            swapCellIfNeeded(at: indexPath, locationInView: locationInView)
        default:
            cancelDragging()
        }
    }
    
    private func beginDragging(at indexPath: IndexPath?, locationInView: CGPoint) {
        self.currentIndexPath = indexPath
        guard let indexPath = indexPath, let cell = contactsTableView.cellForRow(at: indexPath) else {
            return
        }
        var center = cell.center
        let snapShotView = cell.makeSnapshot()
        self.snapShotView = snapShotView
        snapShotView.center = center
        snapShotView.alpha = 0.0
        contactsTableView.addSubview(snapShotView)
        UIView.animate(withDuration: 0.25, animations: {
            center.y = locationInView.y
            self.isCellAnimating = true
            snapShotView.center = center
            snapShotView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            snapShotView.alpha = 0.98
            cell.alpha = 0.0
        }, completion: { success in
            if success {
                self.isCellAnimating = false
                if self.isCellNeedToShow {
                    self.isCellNeedToShow = false
                    UIView.animate(withDuration: 0.25, animations: {
                        cell.alpha = 1
                    })
                } else {
                    cell.isHidden = true
                }
            }
        })
    }
    
    private func swapCellIfNeeded(at indexPath: IndexPath?, locationInView: CGPoint) {
        guard let indexPath = indexPath,
              let snapShotView = self.snapShotView, let currentIndexPath = self.currentIndexPath else {
            return
        }
        var center = snapShotView.center
        center.y = locationInView.y
        snapShotView.center = center
        if indexPath != currentIndexPath {
            contacts.insert(contacts.remove(at: currentIndexPath.row), at: indexPath.row)
            contactsTableView.moveRow(at: currentIndexPath, to: indexPath)
            self.currentIndexPath = indexPath
        }
    }
    
    private func cancelDragging() {
        guard let currentIndexPath = self.currentIndexPath,
              let cell = contactsTableView.cellForRow(at: currentIndexPath) else {
            return
        }
        if isCellAnimating {
            isCellNeedToShow = true
        } else {
            cell.isHidden = false
            cell.alpha = 0.0
        }
        UIView.animate(withDuration: 0.25, animations: {
            self.snapShotView?.center = cell.center
            self.snapShotView?.transform = .identity
            self.snapShotView?.alpha = 0.0
            cell.alpha = 1.0
        }, completion: { success in
            guard success else {
                return
            }
            self.currentIndexPath = nil
            self.snapShotView?.removeFromSuperview()
            self.snapShotView = nil
        })
    }
    
    @IBAction private func reloadButtonTapped(_ sender: Any) {
        contactsTableView.reloadData()
    }
    
}

extension ContactsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as? ContactCell else {
            return UITableViewCell()
        }
        cell.contact = contacts[indexPath.row]
        cell.handleLongPressGesture = { [weak self] gesture in
            self?.handleLongPressGesture(gesture)
        }
        return cell
    }
    
}

extension ContactsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        contacts.insert(contacts.remove(at: sourceIndexPath.row), at: destinationIndexPath.row)
    }
    
}
