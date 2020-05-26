//
//  ViewController.swift
//  CubManager
//
//  Created by Admin on 21.05.2020.
//  Copyright © 2020 Nikita. All rights reserved.
//

import UIKit
import MapKit
import FirebaseAuth

class ContentVC: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var authButton: UIButton!
    
    var name: String = "Никита"
    var number: String = "+12345678910"
    
    @IBOutlet weak var userLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.authButton.titleLabel?.textAlignment = .center //убрать в настройку общей конфигурации и вызывать оттуда
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
    
    
    
}

