//
//  ViewController.swift
//  WeatherApp
//
//  Created by 4eenah on 8/9/20.
//  Copyright © 2020 Tleugazy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
        
    @IBOutlet weak var labelCity: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var labelTemperature: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        let urlString = "http://api.weatherstack.com/current?access_key=7eee7ee733166593dfd1c1c993b7c33e&query=\(searchBar.text!)"
        
        let url = URL(string: urlString)
        
        var locationName: String?
        var temperature: Double?
        var errorHasOcured: Bool  = false
        
        let task = URLSession.shared.dataTask(with: url!) {[weak self]
            (data,response,error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: AnyObject]
                
                if let _ = json["error"] {
                    errorHasOcured = true
                }
                
                if let location = json["location"] {
                    locationName = location["name"] as? String
                }
                if let current = json["current"] {
                    temperature = current["temperature"] as? Double
                }
                DispatchQueue.main.async {
                    if errorHasOcured {
                        self?.labelCity.text = "Error has ocured"
                        self?.labelTemperature.isHidden = true
                    } else {
                        self?.labelCity.text = locationName
                        self?.labelTemperature.text = "\(temperature!)"
                        self?.labelTemperature.isHidden = false
                    }
                }
            }
            catch let jsonError {
                print(jsonError)
            }
        }
        task.resume()
        
    }
}

