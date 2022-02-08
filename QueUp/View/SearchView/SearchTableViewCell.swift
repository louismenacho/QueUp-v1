//
//  SearchTableViewCell.swift
//  TurnTune
//
//  Created by Louis Menacho on 11/17/21.
//

import UIKit
import SDWebImage

protocol SearchTableViewCellDelegate: AnyObject {
    func searchTableViewCell(addButtonPressedFor cell: SearchTableViewCell)
}

class SearchTableViewCell: UITableViewCell {
    
    weak var delegate: SearchTableViewCellDelegate?
    
    var searchResultItem = SearchResultItem() {
        didSet {
            albumImageView.sd_setImage(with: URL(string: searchResultItem.song.artworkURL), placeholderImage: UIImage(systemName: "image"))
            songTitleLabel.text = searchResultItem.song.name
            artistNamesLabel.text = searchResultItem.song.artist
            searchResultItem.isAdded ? select() : deselect()
        }
    }
    
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var artistNamesLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        delegate?.searchTableViewCell(addButtonPressedFor: self)
    }
    
    func select() {
        addButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        addButton.isUserInteractionEnabled = false
    }
    
    func deselect() {
        addButton.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        addButton.isUserInteractionEnabled = true
    }
}
