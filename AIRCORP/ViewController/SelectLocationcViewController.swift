//
//  SelectLocationcViewController.swift
//  AIRCORP
//
//  Created by Vijay Rathore on 01/02/24.
//

import UIKit

class SelectLocationcViewController : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var topTitle: UILabel!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var fromToCode : Int?
    var delegate : LocationCallback?
    var airportModels = Array<AirportModel>()
    
    
    override func viewDidLoad() {
    
        
        if let fromToCode = fromToCode, delegate != nil {
            
            DispatchQueue.global(qos: .userInteractive).async {
                if let allAirports = self.getAirports() {
                    DispatchQueue.main.async {
                        self.airportModels.append(contentsOf: Array(allAirports.prefix(50)))
                    
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
                        self.searchTF.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
                        
                    }
                    
                   
                }
            }
          
            
          
            
        }
        else {
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
        }
      

    }
    
    @objc func textFieldDidChange(textField : UITextField){
        guard let query = textField.text, !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            DispatchQueue.main.async {
                self.airportModels.removeAll()
                if let allAirports = self.getAirports() {
                    self.airportModels.append(contentsOf: Array(allAirports.prefix(50)))
                }
                self.tableView.reloadData()
            }
            return
        }
        
        DispatchQueue.global(qos: .userInteractive).async {
            if let allAirports = self.getAirports() {
                
                let filteredAirports = allAirports.filter { airport in
                    
                    return airport.name!.lowercased().contains(query.lowercased())
                }
                
                DispatchQueue.main.async {
                    self.airportModels.removeAll()
                    self.airportModels.append(contentsOf: filteredAirports)
                    
                    
                    self.tableView.reloadData()
                }
            }
        }
     
    }
    
    @objc func backViewClicked(){
        self.dismiss(animated: true)
    }
    
    @objc func cellClicked(value : MyGesture){
        
        self.dismiss(animated: true) {
            let airportModel = self.airportModels[value.index]
            self.delegate?.didLocationSelected(fromToCode: self.fromToCode!, airportModel: airportModel)
        }
    }
    
}
extension SelectLocationcViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return airportModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "airportModelCell", for: indexPath) as? AirportTableViewCell {
            
            let airportModel = airportModels[indexPath.row]
            
            cell.mName.text = airportModel.name ?? "N/A"
            cell.mICAOCode.text = airportModel.ident ?? "N/A"
            cell.mShortName.text = airportModel.municipality ?? "N/A"
            
            cell.mView.isUserInteractionEnabled = true
            let myGesture = MyGesture(target: self, action: #selector(cellClicked(value: )))
            myGesture.index = indexPath.row
            cell.mView.addGestureRecognizer(myGesture)
            
           
            return cell
        }
        
        return AirportTableViewCell()
    }
    
    
    
}
