//
//  ViewController.swift
//  Test
//
//  Created by v.sova on 05.07.2018.
//  Copyright © 2018 v.sova. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SignInViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var indicatorView: UIView!
    
    let disposeBag = DisposeBag()
    
    var userViewModel: UserViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let request = URLRequest.init(url: URL.init(string: Urls.authorize.urlString())!)
        webView.loadRequest(request)
    }
}

extension SignInViewController: UIWebViewDelegate {

    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {

        guard let url = request.url else {
            return false
        }
        
        if url.absoluteString.hasPrefix("https://google.com") {
            
            webView.removeFromSuperview()
            
            let queryItems = URLComponents.init(string: url.absoluteString)
            let codeItem = queryItems?.queryItems?.filter({$0.name == "code"}).first
            
            guard let code = codeItem?.value else {
                
                return false
            }

            indicatorView.isHidden = false
            if userViewModel == nil { userViewModel = UserViewModel.init() }
            userViewModel?.getAccessToken(code).debug().subscribe(onNext: { (token) in

                self.userViewModel?.accessToken.accept(token)
                self.dismiss(animated: true, completion: nil)
                
            }, onError: { (error) in
                self.dismiss(animated: true, completion: nil)
                
            }).disposed(by: disposeBag)
            
        }
        
        return true
    }
}
