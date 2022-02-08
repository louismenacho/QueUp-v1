//
//  ActivityIndicatorView.swift
//  TurnTune
//
//  Created by Louis Menacho on 1/6/22.
//

import UIKit

class ActivityIndicatorView: UIActivityIndicatorView {
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        center = CGPoint(x: frame.midX, y: frame.midY)
        layer.backgroundColor = UIColor(white: 0, alpha: 0.5).cgColor
        style = .large
    }
    
    override func startAnimating() {
        DispatchQueue.main.async {
            super.startAnimating()
        }
    }
    
    override func stopAnimating() {
        DispatchQueue.main.async {
            super.stopAnimating()
        }
    }
}
