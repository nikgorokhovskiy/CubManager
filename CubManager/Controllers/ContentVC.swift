//
//  ViewController.swift
//  CubManager
//
//  Created by Admin on 21.05.2020.
//  Copyright © 2020 Nikita. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import FirebaseAuth
import SwiftEntryKit

class ContentVC: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var authButton: UIButton!
    //временные переменные
    var name: String = "Никита"
    var number: String = "+12345678910"
    var coordinateOfUser: CLLocationCoordinate2D?
    
    @IBOutlet weak var userLabel: UILabel!
    
    let locationManager = CLLocationManager() //менеждер карты основные функции которого ниже в расширении
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.authButton.titleLabel?.textAlignment = .center //убрать в настройку общей конфигурации и вызывать оттуда
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationEnabled()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        DispatchQueue.main.async {
            if Auth.auth().currentUser?.uid != nil {
                self.authButton.backgroundColor = .red
                self.authButton.titleLabel?.text = "Выйти"
                
                self.userLabel.text = Auth.auth().currentUser?.phoneNumber
                
            } else {
                self.userLabel.text = "Пользователь не авторизован"
            }
        }
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
            self.authButton.backgroundColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
            self.authButton.titleLabel?.text = "Авторизация"
            self.userLabel.text = "Пользователь не авторизован"
        } catch {
            
        }
    }
    
    func showPhoneNumberVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let dvc = storyboard.instantiateViewController(withIdentifier: "PhoneNumberVC") as! PhoneNumberVC
        self.present(dvc, animated: true, completion: nil)
    }

    
    @IBAction func authTapped(_ sender: UIButton) {
        if Auth.auth().currentUser?.uid != nil {
            logOut()
        } else {
            showPhoneNumberVC()
        }
    }
    
    @IBAction func optionalButtonTapped(_ sender: UIButton) {
        handleShowPopUp()
    }
    
    
    
}

//MARK: - PopUP menu

extension ContentVC {
    
    func setupAttributes() -> EKAttributes {
        var attributes = EKAttributes.bottomToast
        //время отображения
        attributes.displayDuration = .infinity //постоянное
        //затемнение фона
        attributes.screenBackground = .color(
            color: .init(
                light: UIColor(white: 100.0/255.0, alpha: 0.3),
                dark: UIColor(white: 50.0/255.0, alpha: 0.3)
            )
        )
        //тени
        attributes.shadow = .active(
            with: .init(
                color: .black,
                opacity: 0.3,
                radius: 8
            )
        )
        //фон и скругления углов вью
        attributes.entryBackground = .color(color: .standardBackground)
        attributes.roundCorners = .all(radius: 25)
        
        //действие при нажатии за приделами всплывающего окна
        attributes.screenInteraction = .dismiss
        //действия при нажатии в пределах всплывающего окна
        attributes.entryInteraction = .absorbTouches
        //возможность перемещения всплывающего окна
        attributes.scroll = .enabled(
            swipeable: true,
            pullbackAnimation: .jolt
        )
        //аттрибуты появления всплывающего окна
        attributes.entranceAnimation = .init(
            translate: .init(
                duration: 0.7,
                spring: .init(damping: 1, initialVelocity: 0)
            ),
            scale: .init(
                from: 1.05,
                to: 1,
                duration: 0.4,
                spring: .init(damping: 1, initialVelocity: 0)
            )
        )
        //аттрибуты закрытия всплывающего окна
        attributes.exitAnimation = .init(
            translate: .init(duration: 0.2)
        )
        attributes.popBehavior = .animated(
            animation: .init(
                translate: .init(duration: 0.2)
            )
        )
        //расстояние под алертом
        attributes.positionConstraints.verticalOffset = -35
        //прочее
        attributes.statusBar = .dark
        
        return attributes
    }
    
    func setupMessage() -> EKPopUpMessage {
        
        let image = UIImage(named: "2216337 - direction lo")
        let title = "Awesome!"
        let description =
        """
        You are using SwiftEntryKit, \
        and this is a customized alert \
        view that is floating at the bottom.
        """
        
        let themeImage = EKPopUpMessage.ThemeImage(image: EKProperty.ImageContent(image: image!, size: CGSize(width: 60, height: 60), tint: .black, contentMode: .scaleAspectFit))
        
        let titleLabel = EKProperty.LabelContent(text: title, style: .init(
            font: UIFont.systemFont(ofSize: 24),
            color: .black,
            alignment: .center
            )
        )
        
        let descriptionLabel = EKProperty.LabelContent(text: description, style: .init(
            font: UIFont.systemFont(ofSize: 16),
            color: .black,
            alignment: .center
            )
        )
        
        let button = EKProperty.ButtonContent(
            label: .init(
                text: "Got it!",
                style: .init(
                    font: UIFont.systemFont(ofSize: 16),
                    color: .black
                )
            ),
            backgroundColor: .init(UIColor.systemOrange),
            highlightedBackgroundColor: .clear
        )
        
        let message = EKPopUpMessage(themeImage: themeImage, title: titleLabel, description: descriptionLabel, button: button) {
            SwiftEntryKit.dismiss()
        }
        
        return message
    }
    
    @objc func handleShowPopUp() {
        print(#function)
        SwiftEntryKit.display(entry: MenuPopUpView(with: setupMessage()), using: setupAttributes())
        
    }
    
    
}

//MARK: - Map setup

extension ContentVC: CLLocationManagerDelegate {
   
    //проверка доступа к службе геолокации, вызывается когда карта подгрузилась в фунции wiewDidAppear
    func checkLocationEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            setupMapManager()
            checkAccessToGeolocation()
        } else { //если геолокация выключена
            showAlertLocation(
                title: "На Вашем устройстве выключена служба геолокации",
                message: "Хотите включить?",
                url: URL(string: "App-Prefs:root=LOCATION_SERVICES")
            )
        }
    }
    
    //настройка параметров
    func setupMapManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy  = kCLLocationAccuracyBest //точность определения местоположения
    }
    
    //получение разрешения пользования для определения его геопозиции
    func checkAccessToGeolocation() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
            break
        case .denied:
            showAlertLocation(
                title: "Необходимо разрешить определение Вашего местопложения, иначе приложение не сможет определить где вы находитесь",
                message: "Хотите исправить?",
                url: URL(string: UIApplication.openSettingsURLString)
            )
            break
        case .restricted:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            break
            
        }
    }
    //вызов оповещения
    func showAlertLocation(title: String, message: String?, url: URL?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Настройки", style: .default) { (alert) in
            if let url = url {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        cancelAction.titleTextColor = UIColor.red //см расширение для UIAlertAction
        
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    //MARK: - LOCATION MANAGER DELEGATE
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: 500, longitudinalMeters: 500)
            mapView.setRegion(region, animated: true)
            guard let currentLocation: CLLocationCoordinate2D = manager.location?.coordinate else { return }
            coordinateOfUser = currentLocation //передача текущего местоположения
            print("\(coordinateOfUser?.longitude) \(coordinateOfUser?.latitude)")
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkAccessToGeolocation()
    }
}


//Расширение для кнопки оповещения, необходимое для перекрашивания текста кнопки
extension UIAlertAction {
    var titleTextColor: UIColor? {
        get {
            return self.value(forKey: "titleTextColor") as? UIColor
        } set {
            self.setValue(newValue, forKey: "titleTextColor")
        }
    }
}
