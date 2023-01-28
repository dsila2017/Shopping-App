//
//  ViewController.swift
//  Shopping App
//
//  Created by David on 1/17/23.
//

import UIKit
import Network

class ViewController: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    var checkConnection = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UserDefaults.standard.removeAllDataForAllkeys()
        
        self.monitoringNetwork()
        initialSetup()
        
        
    }
    
    func initialSetup() {
        
        self.emailTF.delegate = self
        self.emailTF.layer.masksToBounds = true
        self.emailTF.layer.cornerRadius = 14
        self.emailTF.textContentType = .emailAddress
        self.emailTF.keyboardType = .emailAddress
        self.emailTF.returnKeyType = .done
        self.emailTF.accessibilityLabel = "Registration"
        self.emailTF.layer.borderWidth = 0.5
        self.emailTF.clearButtonMode = .always
        
        self.passwordTF.delegate = self
        self.passwordTF.layer.masksToBounds = true
        self.passwordTF.layer.cornerRadius = 14
        self.passwordTF.textContentType = .password
        self.passwordTF.layer.borderWidth = 0.5
        self.passwordTF.clearButtonMode = .always
    }
    
    func showAlert() {
        let alert = UIAlertController(title: nil, message: "ჩატვირთვა...", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    func showInternetAlert() {
        let alert = UIAlertController(title: "კავშირის პრობლემა", message: "გთხოვთ შეამოწმოთ ინტერნეტთან კავშირი", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Action", style: .default, handler: { _ in
//                print("Alert 1 action pressed")
//            }))
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        
        present(alert, animated: true)
    }
    
    func monitoringNetwork() {
        
        let monitor = NWPathMonitor(requiredInterfaceType: .wiredEthernet)
        monitor.pathUpdateHandler = { path in
           if path.status == .satisfied {
              
               self.checkConnection = true
           } else {
               
               self.checkConnection = false
           }
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)

        
    }
    
    @IBAction func signIn(_ sender: UIButton) {
        
        self.monitoringNetwork()
        if checkConnection == true {
            print(checkConnection)
            
            if emailTF.text?.isValidEmail() == true {
                
                if passwordTF.text != "" {
                    
                    showAlert()
                    DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                        
                        self.dismiss(animated: true)
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(identifier: "ViewController2") as! ViewController2
                        
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                } else {
                    passwordTF.layer.borderWidth = 2
                    passwordTF.layer.borderColor = UIColor.red.cgColor
                    passwordTF.shake()
                }
                
            } else {
                
                emailTF.layer.borderWidth = 2
                emailTF.layer.borderColor = UIColor.red.cgColor
                emailTF.shake()
                
                if passwordTF.text == "" {
                    passwordTF.layer.borderWidth = 2
                    passwordTF.layer.borderColor = UIColor.red.cgColor
                    passwordTF.shake()
                }
            }
        } else {
            showInternetAlert()
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
        emailTF.layer.borderWidth = 0.5
        passwordTF.layer.borderColor = .none
        passwordTF.layer.borderWidth = 0.5
    }
}
