//
//  PostLocationMapViewController.swift
//  OnTheMap
//
//  Created by Nathalie Cesarino on 16/03/22.
//

import Foundation
import UIKit
import MapKit

class PostLocationMapViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: Properties:
    
    @IBOutlet weak var mapView: MKMapView!
    var inputLocation: MKMapItem?
    var inputMediaURL: String?
    
    // MARK: Life Cycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        placePin()
        zoomInMapRegion()
    }
    
    // MARK: Methods:
    
    // Setting the region around the student input location
    func zoomInMapRegion() {
        let coordinate = (self.inputLocation?.placemark.coordinate)!
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func placePin() {
        let placemark = self.inputLocation!.placemark as MKPlacemark
        mapView.addAnnotation(placemark)
    }
    
    // When finishButton is tapped functions below are/might be invoked
    // Posting location to the server
    @IBAction func finishPostingLocationButton(_ sender: Button) {
        let placemark = self.inputLocation!.placemark as MKPlacemark
        UdacityClient.postLocation(studentLocation: placemark, mediaURL: self.inputMediaURL!, completion: handlePostLocation(success:error:))
    }
    
    // Handling the request of posting location
    func handlePostLocation(success: Bool, error: Error?) {
        if success {
            dismiss(animated: true, completion: nil)
        } else {
            showFailure(message: "Unaible to add new location. Try again.")
        }
    }
    
    // Presenting alert message if error
    func showFailure(message: String) {
        let alertVC = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}
