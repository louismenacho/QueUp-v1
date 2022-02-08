//
//  MemberTableViewCell.swift
//  TurnTune
//
//  Created by Louis Menacho on 11/20/21.
//

import UIKit

class MemberTableViewCell: UITableViewCell {

    var member = Member() {
        didSet {
            imageView?.image = UIImage(systemName: member.isHost ? "person.fill" : "person")
            textLabel?.text = member.displayName
        }
    }
}
