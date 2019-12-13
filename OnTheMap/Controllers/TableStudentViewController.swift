//
//  TableStudentViewController.swift
//  OnTheMap
//
//  Created by Musaad on 11/17/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class TableStudentViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UdacityMapClient.getLocations(url: UdacityMapClient.EndPoint.recentLocations(100).url, completion: showingAnnotationsTable(data:error:))
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        
        UdacityMapClient.loggingOut
            {
                
                DispatchQueue.main.async {
                    self.dismiss(animated: true)
                }
                
        }
        
    }
    
    
    
    @IBAction func addtoMapAction(_ sender: Any) {
        self.performSegue(withIdentifier: "AddLocation", sender: self)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Authentication.userList.count
    }
    
    func showingAnnotationsTable(data: StudentLocation?, error: Error?){
        if let data = data{
            Authentication.userList.removeAll()
            for user in data.results{
                Authentication.userList.append(user)
            }
            tableView.reloadData()
        }
        else{
            ShowAlert.showAlert(title: "Error", message: "Downloading student locations failed!", vc: self)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell")!
        cell.imageView?.image = UIImage(named: "icon_pin")
        cell.textLabel?.text = Authentication.userList[indexPath.row].firstName
            + " " + Authentication.userList[indexPath.row].lastName
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        guard let url = URL(string: Authentication.userList[indexPath.row].mediaURL)
            
            else { return }
        
        UIApplication.shared.open(url)
    }
    
}
