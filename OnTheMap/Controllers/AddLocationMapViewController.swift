//
//  AddLocationMapViewController.swift
//  OnTheMap
//
//  Created by Musaad on 11/17/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import MapKit

class AddLocationMapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var annotationView: MKAnnotationView?
    var pointAnnotations: MKPointAnnotation?
    
    
    override func viewDidLoad() {
        activityIndicator.isHidden = false
        super.viewDidLoad()
        self.getLocation()
    }
    
    
    func updatingLocation(latitude: Double, longitude: Double){
        Authentication.userPosted.latitude = latitude
        Authentication.userPosted.longitude = longitude
    }
    
    
    func getLocation(){
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(Authentication.userPosted.mapString) { (placemarks, error) in
            self.activityIndicator.isHidden = true
            if error != nil{
                ShowAlert.showAlert(title: "Error", message: "Something happened while getting the location, try again.", vc: self)
                
            }
            else if let placemarks = placemarks{
                if placemarks.count > 0{
                    self.updatingLocation(latitude: (placemarks[0].location?.coordinate.latitude)!, longitude: (placemarks[0].location?.coordinate.longitude)!)
                    DispatchQueue.main.async {
                        pinLocation()
                    }
                }
                
            }
        }
        
        
        func pinLocation() {
            
            self.pointAnnotations = MKPointAnnotation()
            self.pointAnnotations!.coordinate = CLLocationCoordinate2D(latitude: Authentication.userPosted.latitude, longitude: Authentication.userPosted.longitude)
            self.pointAnnotations!.title = Authentication.userPosted.mapString
            self.pointAnnotations!.subtitle = Authentication.userPosted.mediaURL
            
            self.mapView.addAnnotation(self.pointAnnotations!)
            self.mapView.setRegion(MKCoordinateRegion(center: self.pointAnnotations!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)), animated: false)
        }
        
        
        
        
        func pointMapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let reuseId = "userPins"
            self.annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
            if self.annotationView == nil{
                self.annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            }
            if annotation is MKUserLocation{
                return nil
            }
            self.annotationView?.canShowCallout = true
            self.annotationView?.isDraggable = true
            
            return self.annotationView
        }
        
        func viewMapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
            let location = view.annotation?.coordinate
            Authentication.userPosted.latitude = location!.latitude
            Authentication.userPosted.longitude = location!.longitude
            self.updatingLocation(latitude: location!.latitude, longitude: location!.longitude)
        }
    }
    
    func locationAlerting(success: Bool, error: Error?){
        
        if success{
            ShowAlert.showAlert(title: "Success", message: "You have been added to the map!", vc: self)
        }
            
        else{
            ShowAlert.showAlert(title: "Error", message: "You haven't been added to the map. Try again!", vc: self)
        }
    }
    
    @IBAction func doneButtonAction(_ sender: Any) {
        UdacityMapClient.postLocation(completion: locationAlerting(success:error:))
        
        
    }
    
    
}
    

