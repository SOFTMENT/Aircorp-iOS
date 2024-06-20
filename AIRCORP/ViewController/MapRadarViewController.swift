//
//  MapRadarViewController.swift
//  AIRCORP
//
//  Created by Vijay Rathore on 16/02/24.
//

import UIKit


class MapRadarViewController  : UIViewController {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var radarContainer: UIView!
    @IBOutlet weak var mapContainer: UIView!
    override func viewDidLoad() {
        let normalTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let selectedTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 35/255, green: 50/255, blue: 81/255, alpha: 1)]
        
        
        segmentControl.setTitleTextAttributes(normalTextAttributes, for: .normal)
        segmentControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)
    }
    
    @IBAction func valueChange(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            mapContainer.isHidden = false
            radarContainer.isHidden = true
        }
        else {
            mapContainer.isHidden = true
            radarContainer.isHidden = false
        }
        
    }
    
    
}
