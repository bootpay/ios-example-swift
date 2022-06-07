//
//  WebAppController.swift
//  pgTestSwift
//
//  Created by Taesup Yoon on 2022/06/07.
//


import UIKit
import Bootpay

class WebAppController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        // Do any additional setup after loading the view, typically from a nib.
        setUIWebView()
    }
    
    func setUIWebView() {
        let webview = BootpayWebView()
        
        var topPadding = CGFloat(0)
        var bottomPadding = CGFloat(0)
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            topPadding = window?.safeAreaInsets.top ?? CGFloat(0)
            bottomPadding = window?.safeAreaInsets.bottom ?? CGFloat(0)
        }
        
        webview.frame = CGRect(x: 0,
                               y: topPadding,
                               width: UIScreen.main.bounds.width,
                               height: UIScreen.main.bounds.height - topPadding - bottomPadding)
        webview.webview.frame = CGRect(x: 0,
                               y: 0,
                               width: UIScreen.main.bounds.width,
                               height: UIScreen.main.bounds.height - topPadding - bottomPadding)
        
        if let url = URL(string: "https://d-cdn.bootapi.com/test/payment/") {
            webview.webview.load(URLRequest(url: url))
        }
        
        self.view.addSubview(webview)
    }
}

