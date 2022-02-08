//
//  PlaylistTableViewCell.swift
//  TurnTune
//
//  Created by Louis Menacho on 11/14/21.
//

import UIKit
import SDWebImage

class PlaylistTableViewCell: UITableViewCell {

    var playlistItem = PlaylistItem() {
        didSet {
            albumImageView.sd_setImage(with: URL(string: playlistItem.song.artworkURL), placeholderImage: UIImage(systemName: "image"))
            songTitleLabel.text = playlistItem.song.name
            artistNamesLabel.text = playlistItem.song.artist
            addedByMemberLabel.text = "Added by @"+playlistItem.addedBy.displayName
        }
    }
    
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var artistNamesLabel: UILabel!
    @IBOutlet weak var addedByMemberLabel: UILabel!
    
}
