//
//  PolicyViewController.swift
//  QueUp
//
//  Created by Louis Menacho on 2/10/22.
//

import UIKit
import WebKit

class PolicyViewController: UIViewController {
    
    private static var policyWebView: WKWebView = {
        let url = URL(string: "https://louismenacho.github.io/QueUp/policy/privacy.html")!
        let webView = WKWebView()
        webView.load(URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData))
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PolicyViewController.policyWebView.frame = view.bounds
        PolicyViewController.policyWebView.navigationDelegate = self
        view.insertSubview(PolicyViewController.policyWebView, at: 0)
    }
    
    @IBAction func closeWebViewButtonPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
}

extension PolicyViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard
            let url = navigationAction.request.url,
            let scheme = url.scheme else {
                decisionHandler(.cancel)
                return
            }
        
        if (scheme.lowercased() == "mailto") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }
}
