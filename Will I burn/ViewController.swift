//
//  ViewController.swift
//  Will I burn
//
//  Created by Dragos Neagu on 13/03/2017.
//  Copyright © 2017 Dragos Neagu. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var coords = CLLocationCoordinate2D(latitude: 53.48, longitude: -2.27)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Location changed")
        
        if status == .authorizedAlways {
            getLocation()
        }
        else if status == .denied {
            let alert = UIAlertController(title: "Error", message: "You need to enable location services for this app to work correctly. Please go to settings to allow this app to access your location", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func getLocation(){
        if let loc = locationManager.location?.coordinate {
            coords = loc
        }
    }
}

