//
//  Petrole.swift
//  FuelBuddyTest
//
//  Created by Sergey Sokhach on 28.04.17.
//  Copyright © 2017 FinApp. All rights reserved.
//

import UIKit

class Petrole: NSObject {
    var title: String = ""
    var cost: String = "0 ₽"
    var time: String = ""
    var icon: String = ""
    var adress: String = ""
    var latitude: Double = 0
    var longitude: Double = 0
    var distance: Double = 0
    
    override init() {
        super.init()
    }
    
    init (title: String, cost: String, time: String, icon: String, adress: String, distance: Double) {
        self.title = title
        self.cost = cost
        self.time = time
        self.icon = icon
        self.adress = adress
        self.distance = distance
    }
    
    init (title: String, cost: String, time: String, icon: String, adress: String, distance: Double, lat: Double, long: Double) {
        self.title = title
        self.cost = cost
        self.time = time
        self.icon = icon
        self.adress = adress
        self.distance = distance
        self.latitude = lat
        self.longitude = long
    }
    
    func setCoordinate(lat: Double, long: Double) {
        self.latitude = lat
        self.longitude = long
    }
}
