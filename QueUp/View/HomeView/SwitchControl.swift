//
//  SwitchControl.swift
//  TurnTune
//
//  Created by Louis Menacho on 11/12/21.
//

import UIKit

protocol SwitchControlDelegate: AnyObject {
    func switchControl(_ switchControl: SwitchControl, didToggle isOn: Bool)
}

class SwitchControl: UIControl {
    
    weak var delegate: SwitchControlDelegate?
    
    var isOn: Bool = true

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var centerXConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height/2
        thumbImageView.layer.cornerRadius = thumbImageView.frame.height/2
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesBegan")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesEnded")
        toggle()
    }
    
    func toggle() {
        isOn.toggle()
        UIView.animate(withDuration: 0.3) { [self] in
            centerXConstraint.constant *= -1
            layoutIfNeeded()
        }
        delegate?.switchControl(self, didToggle: isOn)
    }
    
    func setOn(_ on : Bool) {
        if isOn != on {
            toggle()
        }
    }
    
    func setThumbImage(_ image: UIImage?) {
        thumbImageView.image = image
    }
}
