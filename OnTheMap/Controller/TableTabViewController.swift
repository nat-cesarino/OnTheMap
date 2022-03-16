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
    
    @IBOutlet var tableTabView: UITableView!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var addPinButton: UIBarButtonItem!
    var cellReuse = "reuseCell"
    var studentLocation = [StudentLocation]()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableTabView.delegate = self
        tableTabView.dataSource = self
        UdacityClient.getStudentLocation(completion: { ( StudentData, error) in
            self.studentLocation = StudentData
            self.tableTabView.reloadData()
        })
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = studentLocation[indexPath.row]
        let url = student.mediaURL
        
        UIApplication.shared.open(URL(string: url)!, completionHandler: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(studentLocation.count)
        return studentLocation.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuse, for: indexPath)
        let student = studentLocation[indexPath.row]
        cell.textLabel?.text = student.firstName + student.lastName
        cell.imageView?.image = UIImage(named: "icon_pin")
        return cell
    }
}
