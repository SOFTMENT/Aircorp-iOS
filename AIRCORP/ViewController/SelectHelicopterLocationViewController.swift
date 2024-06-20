//
//  SelectHelicopterLocationViewController.swift
//  AIRCORP
//
//  Created by Vijay Rathore on 11/02/24.
//

import UIKit

class SelectHelicopterLocationViewController : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var topTitle: UILabel!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var fromToCode : Int?
    var delegate : GoogleLocationCallback?
    var places : [Place] = []
    var latitude : Double = 0.0
    var longitude : Double = 0.0
    var isLocationSelected : Bool = false
    
    
    override func viewDidLoad() {
        
        
        if let fromToCode = fromToCode, delegate != nil {
            
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.showsVerticalScrollIndicator = false
            self.tableView.reloadData()
            
            self.backView.layer.cornerRadius = 8
            self.backView.dropShadow()
            self.backView.isUserInteractionEnabled = true
            self.backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.backViewClicked)))
            
            self.searchTF.setLeftIcons(icon: UIImage(systemName: "magnifyingglass")!)
            
            if fromToCode == 1 {
                self.topTitle.text = "Select Departure"
            }
            else {
                self.topTitle.text = "Select Destination"
            }
            
            self.searchTF.delegate = self
            self.searchTF.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
            
        
            
          
            
        }
        else {
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
        }
      

    }
    
    
    @objc func textFieldDidChange(textField : UITextField){
        guard let query = textField.text, !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            self.places.removeAll()
        
            self.tableView.reloadData()
            return
        }
        
        
        GooglePlacesManager.shared.findPlaces(query: query ) { result in
            switch result {
            case .success(let places) :
                self.places = places
                print(self.places)
                self.tableView.reloadData()
                break
            case .failure(let error) :
                print(error)
            }
        }
    }
    
    @objc func locationCellClicked(myGesture : MyGesture){
        tableView.isHidden = true
        view.endEditing(true)
    

        var place = places[myGesture.index]
    
        GooglePlacesManager.shared.resolveLocation(for: place) { result in
            switch result {
            case .success(let coordinates) :
                
                let words = place.name!.split(separator: ",")
                if let firstWord = words.first?.trimmingCharacters(in: .whitespaces) {
                    place.shortName = firstWord
                }
                
                place.latitude = coordinates.latitude
                place.longitude = coordinates.longitude
                self.dismiss(animated: true) {
                    self.delegate?.didLocationSelected(fromToCode: self.fromToCode!, placeModel: place)
                }
                
                break
            case .failure(let error) :
                print(error)
                
            }
        }
    }
    
  
    
    @objc func backViewClicked(){
        self.dismiss(animated: true)
    }
    

    
}
extension SelectHelicopterLocationViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if places.count > 0 {
            tableView.isHidden = false
        }
        else {
            tableView.isHidden = true
        }
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "placescell", for: indexPath) as? GooglePlacesCell {
            
            
            cell.name.text = places[indexPath.row].name ?? "Something Went Wrong"
            cell.mView.isUserInteractionEnabled = true
            
            let myGesture = MyGesture(target: self, action: #selector(locationCellClicked(myGesture:)))
            myGesture.index = indexPath.row
            cell.mView.addGestureRecognizer(myGesture)
            
         
            return cell
        }
        
        return GooglePlacesCell()
    }
    
    
    
}

