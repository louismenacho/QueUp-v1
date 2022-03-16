//
//  InstructionsViewController.swift
//  QueUp
//
//  Created by Louis Menacho on 3/13/22.
//

import UIKit

class InstructionsViewController: UIViewController {

    @IBOutlet weak var gifImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "spotify.clear.queue", withExtension: "gif")!)
        gifImageView.image = UIImage.sd_image(withGIFData: imageData)
    }
    
    @IBAction func goToSpotifyButtonPressed(_ sender: SpotifyPlayButton) {
        UIApplication.shared.open(URL(string: "spotify://")!, options: [:], completionHandler: nil)
    }
    
}
