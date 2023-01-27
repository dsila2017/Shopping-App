//
//  SuccessVC.swift
//  Shopping App
//
//  Created by David on 1/24/23.
//

import UIKit

class SuccessVC: UIViewController {
    
    var delegate: backToMain?
    
    @IBAction func backButton(_ sender: UIButton) {
        
        delegate?.back()
        self.dismiss(animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
