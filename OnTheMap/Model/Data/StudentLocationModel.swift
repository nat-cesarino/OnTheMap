//
//  StudentLocationModel.swift
//  OnTheMap
//
//  Created by Nathalie Cesarino on 16/03/22.
//

import Foundation
import MapKit

class StudentLocationModel {
    
    static var studentsLocationList = [StudentLocation]()
    static var studentsLocationAnnotations = [MKPointAnnotation]()
    
    class func updateStudentsLocationList(updatedList: [StudentLocation]) {
        studentsLocationList = updatedList
        updateAnnotations()
    }
    
    class func updateAnnotations() {
        for student in studentsLocationList {
            let lat = CLLocationDegrees(student.latitude)
            let long = CLLocationDegrees(student.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = student.firstName
            let last = student.lastName
            let mediaURL = student.mediaURL
            let annotation = MKPointAnnotation()
            
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            annotation.coordinate = coordinate
            studentsLocationAnnotations.append(annotation)
        }
    }
}
