//
//  AirCraftViewController.swift
//  AIRCORP
//
//  Created by Vijay Rathore on 03/02/24.
//

import UIKit

class AirCraftViewController : UIViewController {
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var noAircraftAvailable: UILabel!
    var aircraftModels = Array<AircraftModel>()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        
        addView.isUserInteractionEnabled = true
        addView.dropShadow()
        addView.layer.cornerRadius = 8
        addView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addViewClicked)))
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getAllAircrafts { aircraftModels, error in
            self.aircraftModels.removeAll()
            self.aircraftModels.append(contentsOf: aircraftModels ?? [])
           
            self.tableView.reloadData()
        }
    }
    
    
    @objc func certificateDownloadClicked(gest : MyGesture){
        guard let url = URL(string: gest.value!) else { return}
        UIApplication.shared.open(url)
    }
    
    @objc func addViewClicked(){
        performSegue(withIdentifier: "addAircraftSeg", sender: nil)
    }
    
    @objc func cellClicked(value : MyGesture){
        performSegue(withIdentifier: "updateAircraftSeg", sender: self.aircraftModels[value.index])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "updateAircraftSeg" {
            if let VC = segue.destination as? UpdateAircraftViewController {
                if let aircraftModel = sender as? AircraftModel {
                    VC.aircraftModel = aircraftModel
                }
            }
        }
    }
}

extension AirCraftViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        noAircraftAvailable.isHidden = aircraftModels.count > 0 ? true : false
       
        return aircraftModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "aircraftCell", for: indexPath) as? AircraftTableViewCell {
            
            let aircraftModel = self.aircraftModels[indexPath.row]
            cell.aircraftPic.layer.cornerRadius = 8
            if let path = aircraftModel.picture , !path.isEmpty {
                cell.aircraftPic.sd_setImage(with: URL(string: path), placeholderImage: UIImage(named: "placeholder"))
            }
            cell.aircraftNumber.text = aircraftModel.aircraftNumber ?? ""
            cell.nextServiceDate.text = "Next Service : \(self.convertDateToString(aircraftModel.nextServiceDate ?? Date()))"
            cell.annualDate.text = "Annual : \(self.convertDateToString(aircraftModel.annualDate ?? Date()))"
            
            cell.docDownloadBtn.isUserInteractionEnabled = true
            let downloadGest = MyGesture(target: self, action: #selector(certificateDownloadClicked(gest: )))
            downloadGest.value = aircraftModel.certificateDoc
            cell.docDownloadBtn.addGestureRecognizer(downloadGest)
            
            cell.mView.isUserInteractionEnabled = true
            let gest = MyGesture(target: self, action: #selector(cellClicked(value: )))
            gest.index = indexPath.row
            cell.mView.addGestureRecognizer(gest)
          
            return cell
        }
        return AircraftTableViewCell()
    }
    
}
