//
//  UserInfoVC.swift
//  CubManager
//
//  Created by Admin on 25.05.2020.
//  Copyright © 2020 Nikita. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class UserInfoVC: UIViewController {

    
    @IBOutlet private weak var firstNameTextField: UITextField!
    @IBOutlet private weak var secondNameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField?
    
    @IBOutlet private weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupConfig()
    }
    
    func checkValid() -> String? {
        if firstNameTextField.text == "" ||
            secondNameTextField.text == "" ||
            firstNameTextField.text == nil ||
            secondNameTextField.text == nil {
            return "Пожалуйста заполните обязательные поля"
        } else {
            return nil
        }
    }
    
    private func setupConfig() {
        errorLabel.alpha = 0
    }
    
    //создает в базе данных в директории users документ и присваивает ему имя уникального идентификатора созданного при первой авторизации через телефон
    //далее добавляет в документ данные из textfield'ов
    private func addDataToDB() {
        if emailTextField?.text == nil {
            emailTextField?.text = ""
        }
        let db = Firestore.firestore()
        db.collection("user").document(Auth.auth().currentUser!.uid).setData([
            "firstName" : firstNameTextField.text!,
            "secondName" : secondNameTextField.text!,
            "email" : emailTextField!.text!
        ]) { (error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let okButton = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true)
            }
        }
    }

    @IBAction func continueButtonTapped(_ sender: UIButton) {
        if checkValid() != nil {
            errorLabel.alpha = 1
            errorLabel.text = checkValid()
        } else {
            errorLabel.alpha = 0
            addDataToDB()
            
        }
    }
    
}

