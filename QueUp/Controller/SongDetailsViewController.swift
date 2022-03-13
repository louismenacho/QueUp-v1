//
//  SongDetailsViewController.swift
//  QueUp
//
//  Created by Louis Menacho on 3/12/22.
//

import UIKit

class SongDetailsViewController: UIViewController {
    
    var song: Song!
    var isCurrentUserHost = false

    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var playOnSpotifyButton: SpotifyPlayButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        albumImageView.sd_setImage(with: URL(string: song.artworkURL), placeholderImage: UIImage(systemName: "image"))
        albumLabel.text = song.album
        titleLabel.text = song.name
        artistLabel.text = song.artist
        playOnSpotifyButton.isHidden = !isCurrentUserHost
    }
    

    @IBAction func playOnSpotifyPressed(_ sender: SpotifyPlayButton) {
        UIApplication.shared.open(URL(string: song.spotifyURI)!, options: [:], completionHandler: nil)
    }

}
