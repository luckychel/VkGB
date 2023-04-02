//
//  LoginVkViewController.swift
//  homeWork_1
//
//  Created by Admin on 23.10.2018.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit
import WebKit

class LoginVkViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var customIndicatorView: CustomIndicator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testSort()
        loadVK()
        setCustoms()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.showIndicator()
        }
    }
    
    
    private func testSort() {
        var arr = [TestClass]()
        arr.append(TestClass(id: 0, name: ""))
        arr.append(TestClass(id: 1, name: "Tree"))
        arr.append(TestClass(id: 2, name: " "))
        arr.append(TestClass(id: 3, name: "home"))
        arr = arr.sorted(by: { $0.name.lowercased() < $1.name.lowercased()})
        for row in arr {
            print ("\(row.id) \(row.name)\n")
        }
    }
    
    class TestClass {
        var id = -1
        var name = ""
        
        init(id: Int, name: String) {
            self.id = id
            self.name = name
        }
    }
    
    
    private func setCustoms() {
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.tintColor = UIColor.white
        navigationBarAppearance.barTintColor = UIColor.vkColor
    }
    
    
    private func showIndicator() {
        customIndicatorView.isHidden = false
        customIndicatorView.startAnimating()
    }
    
    
    private func stopIndicator() {
        customIndicatorView.isHidden = true
        customIndicatorView.stopAnimating()
    }
    
    
    private func loadVK() {webView.navigationDelegate = self
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "51396167"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "\(262150+8192)"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.87")
        ]
        
        let request = URLRequest(url: urlComponents.url!)
        
        webView.navigationDelegate = self
        webView.load(request)
    }


}

extension LoginVkViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.stopIndicator()
        }
    }
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        stopIndicator()
        
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment  else {
            decisionHandler(.allow)
            return
        }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        print ("my_params: \(params)")
        
        if let token = params["access_token"] {
            Session.instance.token = token
            FirebaseService.instance.addUser()
            print("access_token = \(token)")
        }
        if let userId = params["user_id"] {
            Session.instance.userId = Int(userId) ?? -1
            print("user_id = \(userId)")
        }
        
        decisionHandler(.cancel)
        
        performSegue(withIdentifier: "showMain", sender: nil)
    }

}
