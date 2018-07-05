//
//  ViewController.swift
//  Test
//
//  Created by v.sova on 05.07.2018.
//  Copyright © 2018 v.sova. All rights reserved.
//

import UIKit
import WebKit
import SafariServices

class ViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    var safari: SFSafariViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        webView.navigationDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func click(_ sender: Any) {

//        let request = URLRequest.init(url: URL.init(string: "https://unsplash.com/oauth/authorize?client_id=9417a72a347dc86d1e80f67d9f4a16fabc269159380d7826e5954ee74a589810&redirect_uri=urn:ietf:wg:oauth:2.0:oob&response_type=code&scope=public+read_user")!)
//
//        webView.load(request)
//        APIUnsplash.autorization()
    }
}


extension ViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
        print(webView.url)
        APIUnsplash.login((webView.url?.lastPathComponent)!)
    }
}
