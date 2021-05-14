//
//  AuthViewController.swift
//  whatToWatch
//
//  Created by Maksim Lipenko on 27.04.21.
//

import UIKit
import WebKit

class AuthViewController: UIViewController, WKNavigationDelegate {

    private let webView: WKWebView = {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        let webView = WKWebView(frame: .zero, configuration: config)
        
        return webView
    }()
    
    public var completionHandler: ((Bool) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign In"
        view.backgroundColor = .systemBackground
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        //request a requestToken
        AuthManager.shared.createRequestToken() {
            //send user to the TMDb signin page
            DispatchQueue.main.async {
                guard let url = AuthManager.shared.signInURL else {
                    return
                }
                print(url.absoluteURL)
                self.webView.load(URLRequest(url: url))
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else {
            return
        }

        // Create session id
        if url.pathComponents.last == "allow" {
            AuthManager.shared.requestCreateSession() { [weak self] success in
                DispatchQueue.main.async {
                    self?.dismiss(animated: true, completion: nil)
                    self?.completionHandler?(success)
                }
            }
        }
    }
}
