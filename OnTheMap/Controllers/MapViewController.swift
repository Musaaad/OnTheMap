//
//  OnTheMap
//
//  Created by Musaad on 11/17/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    var annotationView: MKAnnotationView?
    var annotations: [MKAnnotation] = []
    var clickURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UdacityMapClient.getLocations(url: UdacityMapClient.EndPoint.recentLocations(100).url, completion: showingAnnotations(data:error:))
        mapView.delegate = self
    }
    
    func pointAnnotations(){
        
        for stuLocation in Authentication.userList{
            let annotation = MKPointAnnotation()
            annotation.title = "\(stuLocation.firstName) \(stuLocation.lastName)"
            annotation.subtitle = stuLocation.mediaURL
            annotation.coordinate = CLLocationCoordinate2D(latitude: stuLocation.latitude, longitude: stuLocation.longitude)
            annotations.append(annotation)
        }
    }
    
    func showingAnnotations (data: StudentLocation?, error: Error?){
        
        
        if let data = data{
            Authentication.userList.removeAll()
            for user in data.results{
                Authentication.userList.append(user)
            }
            self.pointAnnotations()
            self.mapView.removeAnnotations(self.annotations)
            self.mapView.addAnnotations(self.annotations)
        }
        else{
            
            ShowAlert.showAlert(title: "Error", message: "Downloading student locations failed!", vc: self)
            
        }
    }
    
    
    @IBAction func refreshButtonAction(_ sender: Any) {
        
        UdacityMapClient.getLocations(url: UdacityMapClient.EndPoint.recentLocations(100).url, completion: showingAnnotations(data:error:))
    }
    
    
    @IBAction func logoutButtonAction(_ sender: Any) {
        
        UdacityMapClient.loggingOut
            {
                
                DispatchQueue.main.async {
                    self.dismiss(animated: true)
                }
                
        }
    }
    
    
    @IBAction func addToMap(_ sender: Any) {
        self.performSegue(withIdentifier: "AddLocation", sender: self)
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "studentPins"
        annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        if annotationView == nil{
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        }
        if annotation is MKUserLocation{
            return nil
        }
        annotationView?.canShowCallout = true
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(openingURL(_:)))
        clickURL = (view.annotation?.subtitle)! ?? ""
        view.addGestureRecognizer(gesture)
    }
    
    @objc func openingURL (_ sender: UITapGestureRecognizer){
        guard let url = URL(string: clickURL) else { return }
        UIApplication.shared.open(url)
    }
    
}
