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
    
    @IBOutlet weak var creditsLabel: UILabel!
    
    var credits: Int?
    
    var totals = [IndexPath: Int]()
    
    var array = [productsArray]()
    var imageDict = [String: UIImage]()
    
    var filteredArray = [productsArray]()
    
    var newDict = [Int: Int]()
    var newTotalArray = [Int]()
    var newTotalNumber = 0
    
    var delegate: updateQuantity?
    
    @IBAction func nextButton(_ sender: UIButton) {
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if self.credits! >= Int(self.totalNumber.text!)! {
            
            delegate?.passDatax(array: newDict)
            print("Updating")
            
            updateValue()
            self.credits! -= Int(self.totalNumber.text!) ?? 1
            print(self.credits)
            UserDefaults.standard.credits = self.credits!
            let vc = storyboard.instantiateViewController(withIdentifier:  "SuccessVC") as? SuccessVC
            vc?.delegate = self
            
            
            self.present(vc!, animated: true)
        } else {
            let vc = storyboard.instantiateViewController(withIdentifier: "ErrorVC") as? ErrorVC
            
            
            self.present(vc!, animated: true)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.value(forKey: UserDefaults.UserDefaultsKeys1.credits.rawValue) == nil {
            print("NILLLLLL")
            UserDefaults.standard.credits = 10000000
            self.credits = UserDefaults.standard.credits
        } else {
            print("NOT nill")
            self.credits = UserDefaults.standard.credits
        }
        print(UserDefaults.standard.credits)
        for i in array {
            if filteredArray.contains(where: {$0.id == i.id}) {
                
            }
            else {
                filteredArray.append(i)
            }
        }
        
        self.creditsLabel.text = "Credits: \(UserDefaults.standard.credits)"
        
        totalPrice.text = "total price"
        fee.text = "fee"
        delivery.text = "delivery"
        total.text = "TOTAL:"
        
        feeNumber.text = "\(50)"
        deliveryNumber.text = "Free"
        
        updateValue()
        
        self.table3.dataSource = self
        self.table3.delegate = self
        let nib = UINib(nibName: "SecondaryCell", bundle: nil)
        self.table3.register(nib, forCellReuseIdentifier: "SecondaryCell")
    }
    
    func updateValue() {
        self.totalNumber.text = String((Int(self.feeNumber.text ?? "") ?? 0) + (Int(self.deliveryNumber.text ?? "") ?? Int(0)) + self.newTotalNumber)
    }
    
}

extension ViewController3: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.filteredArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table3.dequeueReusableCell(withIdentifier: "SecondaryCell", for: indexPath) as! SecondaryCell
        
        //cell.productName.text = "Hello"
        cell.delegate = self
        cell.brandNameVC3.text = filteredArray[indexPath.row].brand
        cell.imageVC3.image = self.imageDict[self.filteredArray[indexPath.row].images.first ?? "Error"]
        cell.quantityVC3.text = "\(self.newDict[filteredArray[indexPath.row].id] ?? 0)"
        cell.subtotalVC3.text = "\(filteredArray[indexPath.row].price * (self.newDict[filteredArray[indexPath.row].id] ?? 0))"
        
        cell.total[indexPath] = Int("\(filteredArray[indexPath.row].price * (self.newDict[filteredArray[indexPath.row].id] ?? 0))") ?? 0
        
        cell.delegate?.passData(dict: cell.total)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
}

protocol Passer {
    func passData(dict: [IndexPath: Int])
}

extension ViewController3: Passer {
    func passData(dict: [IndexPath : Int]) {
        
        self.totals = dict
        
        for i in self.totals {
            self.newTotalArray.append(i.value)
        }
        
        let withoutDuplicates = Array(Set(self.newTotalArray))
        self.newTotalNumber = withoutDuplicates.reduce(0, +)
        self.totalPriceNumber.text = "\(self.newTotalNumber)"
        
        self.updateValue()
    }
}

protocol backToMain{
    func back()
}

extension ViewController3: backToMain {
    func back() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ViewController2") as? ViewController2
        
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
}

extension UserDefaults {
    enum UserDefaultsKeys1: String, CaseIterable {
        
        case credits
        
    }
    
    var credits: Int {
        
        get {
            UserDefaults.standard.integer(forKey: UserDefaults.UserDefaultsKeys1.credits.rawValue) as! Int
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaults.UserDefaultsKeys1.credits.rawValue)
        }
    }
    
}
