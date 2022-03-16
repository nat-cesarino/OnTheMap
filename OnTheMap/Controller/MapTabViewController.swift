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
    @IBOutlet weak var addPinButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    var studentLocation: [StudentLocation] = []
    var annotations = [MKPointAnnotation]()
    
    // MARK: Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        reloadInputViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
    }
    
    // MARK: Methods
    
    
    
}

extension MapTabViewController: MKMapViewDelegate {
    
    // Here I create a view with a "right callout accessory view". Similar to cellForRowAtIndexPath method in TableViewDataSource.
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
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle! {
                UIApplication.shared.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
}
