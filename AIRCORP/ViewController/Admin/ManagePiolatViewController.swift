//
//  ManagePiolatViewController.swift
//  AIRCORP
//
//  Created by Vijay Rathore on 03/02/24.
//

import UIKit

class ManagePiolatViewController : UIViewController {
    @IBOutlet weak var noPilotsAvailable: UILabel!
    @IBOutlet weak var addView: UIView!
    var pilotModels = Array<PilotModel>()
    var allPilotModels = Array<PilotModel>()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    override func viewDidLoad() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isEditing = true
        
        addView.layer.cornerRadius = 8
        addView.dropShadow()
        addView.isUserInteractionEnabled = true
        addView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addViewClicked)))

        getAllPilots { pilotModels in
        
            self.allPilotModels.removeAll()
            self.allPilotModels.append(contentsOf: pilotModels ?? [])
            
            self.filter()
            
          
        }
        
    }
    
    func filter(){
        if self.segment.selectedSegmentIndex == 0 {
            let pilots = self.allPilotModels.filter { $0.canFly == VehicleMode.HELICOPTER }
            self.pilotModels.removeAll()
            self.pilotModels.append(contentsOf: pilots)
        }
        else {
            let pilots = self.allPilotModels.filter { $0.canFly == VehicleMode.PLANE }
            self.pilotModels.removeAll()
            self.pilotModels.append(contentsOf: pilots)
        }
        self.tableView.reloadData()
    }
    
    @IBAction func segmentChange(_ sender: UISegmentedControl) {
        filter()
    }
    
    @objc func addViewClicked() {
        performSegue(withIdentifier: "addPilotSeg", sender: nil)
    }
    @objc func cellClicked(gest : MyGesture){
        performSegue(withIdentifier: "editPiloSeg", sender: self.pilotModels[gest.index])
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editPiloSeg" {
            if let VC = segue.destination as? EditPilotViewController{
                if let pilotModel = sender as? PilotModel {
                    VC.pilotModel = pilotModel
                    
                }
            }
        }
        else if segue.identifier == "addPilotSeg" {
            if let VC = segue.destination as? AddPilotViewController {
                VC.totalPilot = self.allPilotModels.count
            }
        }
    }
}
extension ManagePiolatViewController  : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.noPilotsAvailable.isHidden = pilotModels.count > 0 ? true : false
        return pilotModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "pilotCell", for: indexPath) as? PilotsTableViewCell {
            
            let pilotModel = pilotModels[indexPath.row]
            cell.mEmail.text = pilotModel.email ?? ""
            cell.mName.text = pilotModel.name ?? ""
            cell.mView.layer.cornerRadius = 8
            cell.mProfile.layer.cornerRadius = 8
            
            cell.licenceDaysLeft.text = "\(self.daysBetweenDates(currentDate: Date(), futureDate: pilotModel.ratingExpireDate ?? Date())) D"
            cell.medicalDaysLeft.text = "\(self.daysBetweenDates(currentDate: Date(), futureDate: pilotModel.medicalExpireDate ?? Date())) D"
            
            cell.mView.isUserInteractionEnabled = true
            let mygest = MyGesture(target: self, action: #selector(cellClicked(gest: )))
            mygest.index = indexPath.row
            cell.mView.addGestureRecognizer(mygest)
            
            if let path = pilotModel.profileImage, !path.isEmpty {
                cell.mProfile.sd_setImage(with: URL(string: path), placeholderImage: UIImage(named: "profile-placeholder"))
            }
            
            return cell
        }
        return PilotsTableViewCell()
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // Reorder your data source array based on this
        let movedObject = self.pilotModels[sourceIndexPath.row]
        pilotModels.remove(at: sourceIndexPath.row)
       pilotModels.insert(movedObject, at: destinationIndexPath.row)

        // Save the new order to Firestore
        for (index, item) in pilotModels.enumerated() {
            // Assuming each item has an ID to identify it in Firestore
            let docRef =   FirebaseStoreManager.db.collection("Pilots").document(item.id!)
            docRef.updateData(["orderIndex": index])
        }
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
