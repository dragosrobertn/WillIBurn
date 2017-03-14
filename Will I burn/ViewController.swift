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
    @IBOutlet weak var timeToburn: UILabel!
    
    let locationManager = CLLocationManager()
    var coords = CLLocationCoordinate2D(latitude: 53.48, longitude: -2.27)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        getLocation()
    }
    
    func getLocation() {
        print("trying to get location")
        if let loc = locationManager.location?.coordinate {
            print(loc.latitude)
            print(loc.longitude)
            coords = loc
            getWeatherData()
        }
    }
    
    func getWeatherData() {
        let urlPath = WeatherURL(lat: String(coords.latitude), long: String(coords.longitude)).getFullURL()
        let url : NSURL = NSURL(string: urlPath)!
        
        let request : NSURLRequest = NSURLRequest(url: url as URL)
        let queue : OperationQueue = OperationQueue()
        
        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: queue, completionHandler: getJSONresult)
        
//        URLSession.getTasksWithCompletionHandler()
    }
    
    func getJSONresult(response : URLResponse?, data: Data?, error: Error?) -> Void{
        do {
            if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
//                print("ASYNC \(jsonResult)")
                if let data = jsonResult["data"] as? Dictionary<String, AnyObject>{
                    if let weather = data["weather"] as? [Dictionary<String, AnyObject>]{
                        if let uv = weather[0]["uvIndex"] as? String {
                            if let uvI = Int(uv) {
//                                self.uvIndex = uvI
                                let minutes = checkTimeToBurn(uvIndex: uvI)
                                
                                timeToburn.text = String("\(minutes) minutes until you burn")
                                
                            }
                        }
                    }
                }
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func checkTimeToBurn(uvIndex:Int) -> Int {
        switch uvIndex {
        case 0...2:
            return 60
        case 3...4:
            return 45
        case 5...6:
            return 30
        case 7...9:
            return 15
        case let x where x >= 10:
            return 10
        default:
            return 0
        }
        
    }
    
    
}

