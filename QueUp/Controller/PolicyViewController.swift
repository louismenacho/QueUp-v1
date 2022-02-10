//
//  PolicyViewController.swift
//  QueUp
//
//  Created by Louis Menacho on 2/10/22.
//

import UIKit
import WebKit

class PolicyViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://louismenacho.github.io/QueUp/policy/privacy.html")!
        webView.load(URLRequest(url: url))
    }
    
    @IBAction func closeWebViewButtonPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
}
