//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Musaad on 11/17/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class AddLocationViewController: UIViewController {
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var shareMediaTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func findingLocationButton(_ sender: Any) {
        
        if locationTextField.text != "" && shareMediaTextField.text != ""{
            Authentication.userPosted.mapString = locationTextField.text!
            Authentication.userPosted.mediaURL = shareMediaTextField.text ?? ""
            performSegue(withIdentifier: "AddLocation", sender: self)
        }
        else {
            ShowAlert.showAlert(title: "Error", message: "The text fields cannot be empty!", vc: self)
        }
        
        
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        
        locationTextField.text = ""
        shareMediaTextField.text = ""
        dismiss(animated: true)
        
    }
    
    
}
