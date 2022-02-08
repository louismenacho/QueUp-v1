//
//  RoomFormSegmentedControl.swift
//  TurnTune
//
//  Created by Louis Menacho on 1/3/22.
//

import UIKit

class RoomFormSegmentedControl: UISegmentedControl {

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height/2
        layer.borderColor = UIColor.secondarySystemBackground.cgColor
        layer.borderWidth = 2
        clipsToBounds = true
    }
}
