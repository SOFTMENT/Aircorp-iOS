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
        
           if let url = URL(string: "https://www.wral.com/apps/mobile_endpoint.php?action=interactive_radar&device=&device_info=%7B%22platform%22%3A%22ios%22%2C%22platform_version%22%3A%22-1%22%2C%22manufacturer%22%3A%22Apple%22%2C%22model%22%3A%22iPhone%22%2C%22app_name%22%3A%22WRAL%20Weather%22%2C%22app_version%22%3A%2223%22%2C%22build_number%22%3A23%2C%22display_width%22%3A390%2C%22display_height%22%3A844%2C%22display_density%22%3A%22xhigh%22%2C%22ldf%22%3A2%2C%22is_tablet%22%3Afalse%2C%22location%22%3A%7B%22latitude%22%3A%2222.71810671680903%22%2C%22longitude%22%3A%2275.90889377064335%22%2C%22accuracy%22%3A50.443359375%7D%7D&height=844&hurricane_mode=false&icontrol_preview=1&latitude=22.71810671680903&longitude=75.90889377064335&menuItems=1102&zoomLevel=12") {
               let request = URLRequest(url: url)
               webView.load(request)
           }
    }
    
    @objc func backViewClicked(){
        self.dismiss(animated: true)
    }
}
