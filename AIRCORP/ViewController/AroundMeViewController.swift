//
//  AroundMeViewController.swift
//  AIRCORP
//
//  Created by Vijay Rathore on 29/01/24.
//

import UIKit
import MapKit


class AroundMeViewController : UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    var airportModels = Array<AirportModel>()

    override func viewDidLoad() {

        DispatchQueue.global(qos: .userInteractive).async {
            if let allAirports = self.getAirports() {
                DispatchQueue.main.async {
                    self.airportModels.append(contentsOf: allAirports)
                    self.loadAnotation()
                }
            }
        }
    }

    
    @objc func locatonViewCliced(value : MyGesture){
        let model = airportModels[value.index]
        self.showOpenMapPopup(latitude: Double(model.latitude_deg!)! , longitude: Double(model.longitude_deg!)!)
    }
    
    
    
    func showOpenMapPopup(latitude : Double, longitude : Double){
        let alert = UIAlertController(title: "Open in maps", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Apple Maps", style: .default, handler: { action in
            
            let coordinate = CLLocationCoordinate2DMake(latitude,longitude)
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
            mapItem.name = "Shop Location"
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
        }))
        
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            
            alert.addAction(UIAlertAction(title: "Google Maps", style: .default, handler: { action in
                
                UIApplication.shared.open(URL(string:"comgooglemaps://?center=\(latitude),\(longitude)&zoom=14&views=traffic&q=\(latitude),\(longitude)")!, options: [:], completionHandler: nil)
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
  

    
    func loadAnotation() {
        var i = 0
        for model in airportModels {
            let annotation =  CustomAnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: Double(model.latitude_deg!)!, longitude: Double(model.longitude_deg!)!)
            annotation.title = model.name!
            annotation.subtitle = model.ident!
            annotation.position = i
        
         
            
        

            mapView.addAnnotation(annotation)
            if model.ident == "EGAA" {
                let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters:100000,longitudinalMeters: 100000)
                mapView.setRegion(region, animated: true)
                
            }
            
            i = i + 1
        }
        
      
    }
    
   
 
 
}
extension AroundMeViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        view.endEditing(true)
        return true
    }
    
}



class CustomAnotation : MKPointAnnotation {
    
    var position : Int = 0
    
}


