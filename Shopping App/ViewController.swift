//
//  ViewController.swift
//  Shopping App
//
//  Created by David on 1/17/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
        
        
    }
    
    func initialSetup() {
        
        emailTF.delegate = self
        self.emailTF.layer.masksToBounds = true
        self.emailTF.layer.cornerRadius = 14
        self.emailTF.textContentType = .emailAddress
        self.emailTF.keyboardType = .emailAddress
        self.emailTF.returnKeyType = .done
        self.emailTF.accessibilityLabel = "Registration"
        self.emailTF.layer.borderWidth = 0.5
        self.emailTF.clearButtonMode = .always
        
        self.passwordTF.layer.masksToBounds = true
        self.passwordTF.layer.cornerRadius = 14
        self.passwordTF.textContentType = .password
        passwordTF.layer.borderWidth = 0.5
        self.passwordTF.clearButtonMode = .always
    }
    
    @IBAction func signIn(_ sender: UIButton) {
        
        if emailTF.text?.isValidEmail() == true {
            
            if passwordTF.text != "" {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "ViewController2") as! ViewController2
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        } else {
            
            emailTF.layer.borderWidth = 4
            emailTF.layer.borderColor = UIColor.red.cgColor
            emailTF.shake()
        }
    }
    
    
}

extension String {
    
    func isValidEmail() -> Bool {
        
        let regex = try! NSRegularExpression(pattern: "^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,3})$", options: .caseInsensitive)
        let valid = regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
        print("Email validation \(valid)")
        return valid
    }
}

extension UIView {
    func shake() {
        
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.x"
        animation.values = [0, 10, -10, 10, -10, 10, 0]
        //animation.keyTimes = [0, 0.16, 0.5, 0.83, 1]
        animation.duration = 0.4
        
        animation.isAdditive = true
        layer.add(animation, forKey: "shake")
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        emailTF.layer.borderColor = .none
    }
}
