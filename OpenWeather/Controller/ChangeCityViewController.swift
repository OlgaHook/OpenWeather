//
//  ChangeCityViewController.swift
//  OpenWeather
//
//  Created by olga.krjuckova on 18/08/2021.
//

import UIKit
//we gonna create our own protocol (delegate to get back to first one ViewController, after enter City Name
protocol ChangeCityDelegate {
    func userEnterCityName(city: String)
}

class ChangeCityViewController: UIViewController {
    //need to declare our Delegate, then add ChangeCityDelegate in WeatherVC
    var delegate: ChangeCityDelegate?
    
    
    @IBOutlet weak var cityTextField: DesignableTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func getWeatherTapped(_ sender: Any) {
        guard let cityName = cityTextField.text  else {return}
        // textfield cant be empty, so we add
        if !cityName.isEmpty{
            delegate?.userEnterCityName(city: cityName)
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    
}
