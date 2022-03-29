//
//  PostLocationViewController.swift
//  OnTheMap
//
//  Created by Nathalie Cesarino on 07/03/22.
//

import UIKit
import CoreLocation
import MapKit

class PostLocationViewController: UIViewController, CLLocationManagerDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var navBarSearch: UINavigationItem!
    @IBOutlet weak var mediaURLTextField: TextField!
    let locationManager = CLLocationManager()
    var resultSearchController: UISearchController? = UISearchController()
    @IBOutlet weak var locationsTableView: UITableView!
    var matchingItems: [MKMapItem] = []
    let reuseId = "LocationCellId"
    var searchBar: UISearchBar?
    var selectedLocation: MKMapItem? = nil
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationsTableView.delegate = self
        locationsTableView.dataSource = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        resultSearchController!.searchResultsUpdater = self
        self.searchBar = resultSearchController!.searchBar
        searchBar!.sizeToFit()
        searchBar!.placeholder = "Search Address"
        navBarSearch.titleView = resultSearchController?.searchBar
        definesPresentationContext = true
        mediaURLTextField.backgroundColor = UIColor.clear
        
        // CANCEL BUTTON
        let barButtonItem = UIBarButtonItem()
        barButtonItem.title = "CANCEL"
        barButtonItem.target = self
        barButtonItem.action = #selector(cancel)
        self.navigationItem.leftBarButtonItem = barButtonItem
    }
    
    // MARK: Methods
    
    @IBAction func FindLocation(_ sender: Any) {
        // Was location selected?
        guard let locationSelected = self.selectedLocation else {
            self.showFailure(message: "Please, select an address")
            return
        }
        
        let postLocationMapVC = storyboard?.instantiateViewController(withIdentifier: "SeeInMap") as! PostLocationMapViewController
        postLocationMapVC.inputLocation = locationSelected
        postLocationMapVC.inputMediaURL = mediaURLTextField.text
        navigationController?.pushViewController(postLocationMapVC, animated: true)
    }
    
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    // Presenting alert message if error
    func showFailure(message: String) {
        let alertVC = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}

// MARK: Table View Setup
extension PostLocationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.matchingItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
        let selectedItem = matchingItems[indexPath.row].placemark.title
        cell.textLabel?.text = selectedItem
        cell.detailTextLabel?.text = ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = matchingItems[indexPath.row]
        searchBar?.text = location.placemark.title
        self.selectedLocation = location
    }
}

// MARK: SearchBar Setup
extension PostLocationViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBarText = searchController.searchBar.text
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        let search = MKLocalSearch(request: request)
        activityIndicator.startAnimating()
        search.start { response, error in
            guard let response = response else {
                debugPrint(error!)
                self.activityIndicator.stopAnimating()
                return
            }
            self.matchingItems = response.mapItems
            self.locationsTableView.reloadData()
        }
    }
}

// When user edits location, it clears the selected location
extension PostLocationViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.selectedLocation = nil
    }
}
