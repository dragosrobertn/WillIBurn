//
//  Constants.swift
//  Will I burn
//
//  Created by Dragos Neagu on 13/03/2017.
//  Copyright © 2017 Dragos Neagu. All rights reserved.
//

import Foundation

struct WeatherURL {
    private let baseURL = "https://api.worldweatheronline.com/premium/v1/weather.ashx"
    private let key = "&key=92982cb5bc664fe88a0105237171303"
    private let numDayForecast = "&num_of_days=1"
    private let format = "&format=json"
    private var coordstr = ""
    
    init(lat: String, long: String) {
        self.coordstr = "?q=\(lat),\(long)"
    }
    
    func getFullURL() -> String {
        return baseURL + coordstr + key + numDayForecast + format
    }
}
