//
//  MapTabViewController.swift
//  OnTheMap
//
//  Created by Nathalie Cesarino on 07/03/22.
//

import Foundation
import UIKit
import MapKit

class MapTabViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var mapView: MKMapView!
    
    var studentsLocationList: [StudentLocation] { return
        StudentLocationModel.studentsLocationList
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationActions()
        getStudentsLocationList()
        mapView.delegate = self
    }
    
    // MARK: Methods
    
    func setNavigationActions() {
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(getStudentsLocationList))
        let addPinButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewLocation))
        self.navigationItem.rightBarButtonItems = [addPinButton, refreshButton]
        // Logout Button
        let logoutButton = UIBarButtonItem()
        logoutButton.title = "LOGOUT"
        logoutButton.target = self
        logoutButton.action = #selector(logout)
        self.navigationItem.leftBarButtonItem = logoutButton
    }
    
    @objc func logout() {
        UdacityClient.logout {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func getStudentsLocationList() {
        UdacityClient.getStudentLocation(completion: handleStudentsLocationListResponse(studentsLocationList:error:))
    }
    
    func handleStudentsLocationListResponse(studentsLocationList: [StudentLocation], error: Error?) {
        if let error = error {
            print(error)
            showFailure(message: "Unable to load locations. Try again.")
        } else {
            StudentLocationModel.updateStudentsLocationList(updatedList: studentsLocationList)
            mapView.addAnnotations(StudentLocationModel.studentsLocationAnnotations)
        }
    }
    
    @objc func addNewLocation() {
        let postLocationVC = (storyboard?.instantiateViewController(identifier: "PostLocation"))!
        present(postLocationVC, animated: true, completion: nil)
    }
    
    // Handling failures
    func showFailure(message: String) {
        let alertVC = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}

extension MapTabViewController: MKMapViewDelegate {
    
    // Placing pins
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    // Tapping on a pin redirects to url
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle! {
                UIApplication.shared.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
}
