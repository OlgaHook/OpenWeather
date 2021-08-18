//
//  ViewController.swift
//  OpenWeather
//
//  Created by olga.krjuckova on 17/08/2021.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation



class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
    
    
    
    @IBOutlet weak var weatherIcon: UIImageView!
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    
    //from corelocation
    let weatherDataModel = WeatherDataModel()
    //creating core location manager
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //accesing delegate inside of location manager
        locationManager.delegate = self
        //assign 100 m to save device battery consum.
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        //inside of Info.plist need to be added 3 more features to acces our core location (we add privacy)
        
        
    }
    
    //MARK: -CLLocationManager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //its gonna be our last location
        let location = locations[locations.count - 1]
        
        if location .horizontalAccuracy > 0 {
            //device battery save purpose-> stopUpdating
            locationManager.stopUpdatingLocation()
            //here  simulator coordinates (privacy)
            print("Longitude:\(location.coordinate.longitude), Latitude: \(location.coordinate.latitude).")
            
            //for presenting GetWeatherData func (need to be created)
            let longitude = String(location.coordinate.longitude)
            let latitude = String(location.coordinate.latitude)
            //params, based on let latitude and let longitude
            
            let params:[String:String] = ["lat": latitude, "lon" : longitude, "appid": weatherDataModel.apiId]
            getWeatherData(url: weatherDataModel.apiUrl, params: params)
        }
        
    }
    
    func getWeatherData(url:String, params:[String:String]){
        //use alamofire
        AF.request(url, method: .get, parameters: params).responseJSON { response in
            
            if response.value != nil{
                //value forces(!) bcs we are insed IF
                let weatherJSON: JSON = JSON(response.value!)
                print("weatherJSON: ", weatherJSON)
                self.updateWeatherData(json: weatherJSON)
            }else{
                self.cityNameLabel.text = "Weather is unavaliable 🤨"
            }
        }
        
    }
    //populating data
    func updateWeatherData(json: JSON){
        if let tempResult = json["main"]["temp"].double{
            weatherDataModel.temp = Int(tempResult - 273)
            weatherDataModel.city = json["name"].stringValue
            //condition update for weather icon. 0 means - inside first array
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            updateUI()
            
        }else{
            //cntr +cmd + space -> to add emoji
            self.cityNameLabel.text = "Weather is unavaliable 🤨"
        }
    }
    //presenting populated (updateWeatherData) data
    func updateUI(){
        cityNameLabel.text = weatherDataModel.city
        tempLabel.text = "\(weatherDataModel.temp)º"
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
        
        
    }
    
    func userEnterCityName(city: String) {
        print(city)
        //to update city info at initial VC. "q" from GET row(see Postman
        let params: [String: String] = ["q": city, "appid":weatherDataModel.apiId]
        getWeatherData(url: weatherDataModel.apiUrl, params: params)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "city"{
            let vc = segue.destination as! ChangeCityViewController
            //delegate previously assignet in ChangeCity-> created new protocol
            vc.delegate = self
        }
    }
    
}

