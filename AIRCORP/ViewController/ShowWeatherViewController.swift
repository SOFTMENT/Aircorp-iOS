//
//  ShowWeatherViewController.swift
//  AIRCORP
//
//  Created by Vijay Rathore on 02/02/24.
//

import UIKit
import WebKit


class ShowWeatherViewController : UIViewController {
    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
       
        backView.layer.cornerRadius = 8
        backView.dropShadow()
        backView.isUserInteractionEnabled = true
        backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backViewClicked)))
        
           if let url = URL(string: "https://www.windy.com/EGAA?54.658,-7.424,8") {
               let request = URLRequest(url: url)
               webView.load(request)
           }
    }
    
    @objc func backViewClicked(){
        self.dismiss(animated: true)
    }
}
