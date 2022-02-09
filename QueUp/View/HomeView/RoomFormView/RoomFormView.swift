//
//  RoomFormView.swift
//  TurnTune
//
//  Created by Louis Menacho on 11/10/21.
//

import UIKit

protocol RoomFormViewDelegate: AnyObject {
    func roomFormView(_ roomFormView: RoomFormView, selectedSegmentDidChange selectedSegmentIndex: Int)
    func roomFormView(_ roomFormView: RoomFormView, displayNameTextFieldDidChange text: String?)
    func roomFormView(_ roomFormView: RoomFormView, roomCodeTextFieldDidChange text: String?)
    func roomFormView(_ roomFormView: RoomFormView, joinButtonPressed button: UIButton)
    func roomFormView(_ roomFormView: RoomFormView, spotifyButtonPressed button: UIButton)
}

class RoomFormView: UIStackView {
    
    weak var delegate: RoomFormViewDelegate?
    
    @IBOutlet weak var segmentedControl: RoomFormSegmentedControl!
    @IBOutlet weak var displayNameTextField: RoomFormTextField!
    @IBOutlet weak var roomCodeTextField: RoomFormTextField!
    @IBOutlet weak var joinButton: RoomFormButton!
    @IBOutlet weak var spotifyButton: RoomFormButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        displayNameTextField.delegate = self
        roomCodeTextField.delegate = self
        showJoinRoomOptions()
    }

    @IBAction func selectedSegmentDidChange(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            showJoinRoomOptions()
        } else {
            showCreateRoomOptions()
        }
        delegate?.roomFormView(self, selectedSegmentDidChange: sender.selectedSegmentIndex)
    }
    
    @IBAction func displayNameTextFieldDidChange(_ sender: UITextField) {
        joinButton.isEnabled = !displayNameTextField.text!.isEmpty && roomCodeTextField.text!.count == 4
        spotifyButton.isEnabled = !displayNameTextField.text!.isEmpty
        delegate?.roomFormView(self, displayNameTextFieldDidChange: sender.text)
    }
    
    @IBAction func roomCodeTextFieldDidChange(_ sender: UITextField) {
        roomCodeTextField.text = roomCodeTextField.text?.uppercased()
        joinButton.isEnabled = !displayNameTextField.text!.isEmpty && roomCodeTextField.text!.count == 4
        delegate?.roomFormView(self, roomCodeTextFieldDidChange: sender.text)
    }
    
    @IBAction func joinButtonPressed(_ sender: UIButton) {
        delegate?.roomFormView(self, joinButtonPressed: sender)
    }
    
    @IBAction func spotifyButtonPressed(_ sender: UIButton) {
        delegate?.roomFormView(self, spotifyButtonPressed: sender)
    }
    
    private func showJoinRoomOptions() {
        roomCodeTextField.isHidden = false
        joinButton.isHidden = false
        spotifyButton.isHidden = true
        joinButton.isEnabled = !displayNameTextField.text!.isEmpty && roomCodeTextField.text!.count == 4
    }
    
    private func showCreateRoomOptions() {
        roomCodeTextField.isHidden = true
        joinButton.isHidden = true
        spotifyButton.isHidden = false
        spotifyButton.isEnabled = !displayNameTextField.text!.isEmpty
    }
    
    func setRoomCode(_ roomCode: String) {
        roomCodeTextField.text = roomCode
        joinButton.isEnabled = !displayNameTextField.text!.isEmpty && roomCodeTextField.text!.count == 4
    }
    
    func setDisplayName(_ displayName: String) {
        displayNameTextField.text = displayName
        joinButton.isEnabled = !displayNameTextField.text!.isEmpty && roomCodeTextField.text!.count == 4
        spotifyButton.isEnabled = !displayNameTextField.text!.isEmpty
    }
}

extension RoomFormView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // get the current text, or use an empty string if that failed
        let currentText = textField.text ?? ""
        
        // allow only letter characters
        if string.rangeOfCharacter(from: CharacterSet.letters.inverted) != nil {
            return false
        }
        
        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        // make sure the result is under 20 characters if display name text field
        if textField == displayNameTextField {
            return updatedText.count <= 20
        }
        
        // make sure the result is under 4 characters if room ID text field
        if textField == roomCodeTextField {
            return updatedText.count <= 4
        }
        
        return true
    }

}
