//
//  MapViewModule.swift
//  CubManager
//
//  Created by Admin on 25.05.2020.
//  Copyright © 2020 Nikita. All rights reserved.
//

import UIKit
import MapKit

class MapViewModule: UIView {
    
    let locationManager = CLLocationManager()
    
//    //MARK: - Проверка включена ли служба геолокации
//    func checkLocationEnabled() {
//        if CLLocationManager.locationServicesEnabled(){
//            setupLocationManager()
//        } else {
//            let alert = UIAlertController(title: "У вас выключена служба геолокации", message: "Хотите включить", preferredStyle: .alert)
//
//            let settingsAction = UIAlertAction(title: "Настройки", style: .default) { (alert) in
//                if let url = URL(string: "App-Prefs:root=LOCATION_SERVICES") {
//                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                }
//            }
//
//            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
//
//            alert.addAction(settingsAction)
//            alert.addAction(cancelAction)
//            present(alert, animated: true)
//        }
//    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
}



extension MapViewModule: CLLocationManagerDelegate {
    
}
