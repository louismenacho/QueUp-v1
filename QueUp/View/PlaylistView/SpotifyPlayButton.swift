//
//  SpotifyPlayButton.swift
//  QueUp
//
//  Created by Louis Menacho on 2/15/22.
//

import UIKit

class SpotifyPlayButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 19.5
        layer.borderWidth = 2.0
        layer.borderColor = UIColor.secondarySystemBackground.cgColor
    }
}
