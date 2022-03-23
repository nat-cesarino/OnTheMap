//
//  TableTabViewController.swift
//  OnTheMap
//
//  Created by Nathalie Cesarino on 14/03/22.
//

import Foundation
import UIKit

class TableTabViewController: UITableViewController {
    
    // MARK: Properties
    
    var cellReuse = "reuseCell"
    var studentsLocationList: [StudentLocation] { return
        StudentLocationModel.studentsLocationList
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationActions()
        getStudentsLocationList()
    }
    
    // MARK: Methods
    
    func setNavigationActions() {
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(getStudentsLocationList))
        let addPinButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewLocation))
        self.navigationItem.rightBarButtonItems = [addPinButton, refreshButton]
    }
    
    @objc func getStudentsLocationList() {
        UdacityClient.getStudentLocation(completion: handleStudentsLocationListResponse(studentsLocationList:error:))
    }
    
    func handleStudentsLocationListResponse(studentsLocationList: [StudentLocation], error: Error?) {
        if let error = error {
            print(error)
            // Show failure func
        } else {
            StudentLocationModel.updateStudentsLocationList(updatedList: studentsLocationList)
            tableView.reloadData()
        }
    }
    
    @objc func addNewLocation() {
        let postLocationVC = (storyboard?.instantiateViewController(identifier: "PostLocation"))!
        present(postLocationVC, animated: true, completion: nil)
    }
    
    // MARK: TableView Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentsLocationList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuse, for: indexPath)
        let studentLocation = studentsLocationList[indexPath.row]
        cell.textLabel?.text = "\(studentLocation.firstName) \(studentLocation.lastName)"
        cell.detailTextLabel?.text = "\(studentLocation.mediaURL)"
        cell.imageView?.image = UIImage(named: "icon_pin")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studentLocation = studentsLocationList[indexPath.row]
        let url = studentLocation.mediaURL
        
        UIApplication.shared.open(URL(string: url)!, completionHandler: nil)
    }
    
    // lock the navigation bar while scrolling
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}
