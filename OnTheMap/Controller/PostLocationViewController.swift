//
//  InformationPostingView.swift
//  OnTheMap
//
//  Created by Nathalie Cesarino on 07/03/22.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

class PostLocationViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var locationTextField: LoginTextField!
    @IBOutlet weak var mediaURLTextField: LoginTextField!
    // MARK: Life Cycle
    
    // MARK: Methods
    
    @IBAction func FindLocation(_ sender: Any) {
        let postLocationMapVC = storyboard?.instantiateViewController(withIdentifier: "SeeInMap") as! PostLocationMapViewController
        navigationController?.pushViewController(postLocationMapVC, animated: true)
    }
    
}
