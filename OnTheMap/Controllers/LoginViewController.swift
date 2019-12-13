//
//  OnTheMap
//
//  Created by Musaad on 11/14/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicator.stopAnimating()
    }
    
    
    @IBAction func loginButtonAction(_ sender: Any) {
        activityIndicator.startAnimating()
        
        
        if emailTextField.text != "" && passwordTextField.text != ""
        {
            UdacityMapClient.requestSession(username: emailTextField.text!, password: passwordTextField.text!) { (success, error) in
                
                if success{
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "toMap", sender: self)
                        self.activityIndicator.stopAnimating()
                    }
                }
                    
                    
                else
                {
                    ShowAlert.showAlert(title: "Error", message: error!.localizedDescription, vc: self)
                    self.activityIndicator.stopAnimating()
                    return
                }
            }
        }
        
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        
        guard let url = URL(string: "https://www.udacity.com/account/auth#!/signup") else {
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    
}
