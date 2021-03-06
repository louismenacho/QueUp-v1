//
//  UIViewController+Alert.swift
//  TurnTune
//
//  Created by Louis Menacho on 1/5/22.
//

import Foundation

extension UIViewController {
    
    func presentAlert(title: String, message: String? = nil, style: UIAlertController.Style = .alert, actionTitle: String, actionStyle: UIAlertAction.Style = .cancel, action: ((UIAlertAction) -> Void)? = nil )
    {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: style)
            alert.addAction(UIAlertAction(title: actionTitle, style: actionStyle, handler: action))

            self.present(alert, animated: true) {
                if style == .actionSheet {
                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissAlertController))
                    alert.view.superview?.subviews[0].addGestureRecognizer(tapGesture)
                }
            }
        }
    }
    
    func presentAlert(title: String, message: String? = nil, style: UIAlertController.Style = .alert, actions: [(title: String, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)?)] )
    {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: style)
            actions.forEach { action in
                alert.addAction(UIAlertAction(title: action.title, style: action.style, handler: action.handler))
            }
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
 
