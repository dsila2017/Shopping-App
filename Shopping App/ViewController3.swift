//
//  ViewController3.swift
//  Shopping App
//
//  Created by David on 1/23/23.
//

import UIKit

class ViewController3: UIViewController {
    
    @IBOutlet weak var table3: UITableView!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var fee: UILabel!
    @IBOutlet weak var delivery: UILabel!
    @IBOutlet weak var total: UILabel!
    
    @IBOutlet weak var totalPriceNumber: UILabel!
    @IBOutlet weak var feeNumber: UILabel!
    @IBOutlet weak var deliveryNumber: UILabel!
    @IBOutlet weak var totalNumber: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        totalPrice.text = "total price"
        fee.text = "fee"
        delivery.text = "delivery"
        total.text = "TOTAL:"
        
        self.table3.dataSource = self
        self.table3.delegate = self
        let nib = UINib(nibName: "SecondaryCell", bundle: nil)
        self.table3.register(nib, forCellReuseIdentifier: "SecondaryCell")
    }
    
}

extension ViewController3: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table3.dequeueReusableCell(withIdentifier: "SecondaryCell", for: indexPath) as! SecondaryCell
        
        //cell.productName.text = "Hello"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
}
