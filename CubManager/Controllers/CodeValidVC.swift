//
//  AuthVC.swift
//  CubManager
//
//  Created by Admin on 25.05.2020.
//  Copyright © 2020 Nikita. All rights reserved.
//

import UIKit
import FirebaseAuth

class CodeValidVC: UIViewController {

   
    @IBOutlet weak var codeTextView: UITextView!
    @IBOutlet weak var checkCodeButton: UIButton!
    
    var verificationID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupConfig()
    }
    
    private func showContentVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let dvc = storyboard.instantiateViewController(identifier: "ContentVC") as! ContentVC
        self.present(dvc, animated: true, completion: nil)
    }
    
    private func setupConfig() {
        checkCodeButton.alpha = 0.5
        checkCodeButton.isEnabled = false
        
        codeTextView.delegate = self
    }
    
    @IBAction func checkCodeTappped(_ sender: UIButton) {
        guard let code = codeTextView.text else { return }
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: code)
        
        Auth.auth().signIn(with: credential) { (_, error) in
            if error != nil {
                let ac = UIAlertController(title: error?.localizedDescription, message: nil, preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Отмена", style: .cancel)
                ac.addAction(cancel)
                self.present(ac, animated: true, completion: nil)
            } else {
                self.showContentVC()
            }
        }
    }
    
}

extension CodeValidVC: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentCharacterCount = textView.text?.count ?? 0
        if range.length + range.location > currentCharacterCount {
            return false
        }
        let newLength = currentCharacterCount + text.count - range.length
        return newLength <= 6
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text?.count == 6 {
            checkCodeButton.alpha = 1
            checkCodeButton.isEnabled = true
        } else {
            checkCodeButton.alpha = 0.5
            checkCodeButton.isEnabled = false
        }
    }
}
