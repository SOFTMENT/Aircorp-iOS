//
//  RadarViewController.swift
//  AIRCORP
//
//  Created by Vijay Rathore on 16/02/24.
//

import UIKit
import WebKit

class RadarViewController : UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        self.loadURL(link: "https://www.flightradar24.com/data/aircraft/g-oott#")
    }
    
    func loadURL(link : String){
        if let url = URL(string: link) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    @IBAction func valueChange(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.loadURL(link: "https://www.flightradar24.com/data/aircraft/g-oott#")
        }
        else {
            self.loadURL(link: "https://www.flightradar24.com/data/aircraft/n936ct#")
        }
        
    }
    
}
