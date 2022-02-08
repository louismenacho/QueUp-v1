//
//  UIViewController+Alert.swift
//  TurnTune
//
//  Created by Louis Menacho on 1/5/22.
//

import Foundation

extension UIViewController {
    
    func presentAlert(
        title: String,
        message: String? = nil,
        style: UIAlertController.Style = .alert,
        actionTitle: String,
        actionStyle: UIAlertAction.Style = .cancel,
        action: ((UIAlertAction) -> Void)? = nil )
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        alert.addAction(UIAlertAction(title: actionTitle, style: actionStyle, handler: action))
        DispatchQueue.main.async {
            self.present(alert, animated: true) {
                if style == .actionSheet {
                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissAlertController))
                    alert.view.superview?.subviews[0].addGestureRecognizer(tapGesture)
                }
            }
        }
    }
    
    @objc func dismissAlertController() {
        dismiss(animated: true)
    }
}
 
