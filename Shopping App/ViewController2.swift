//
//  ViewController2.swift
//  Shopping App
//
//  Created by David on 1/17/23.
//

import UIKit

class ViewController2: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var table: UITableView!
    
    @IBAction func nextButton(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ViewController3") as? ViewController3
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    var array = [ProductModel]()
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.table.delegate = self
        self.table.dataSource = self
        let nib = UINib(nibName: "MainCell", bundle: nil)
        self.table.register(nib, forCellReuseIdentifier: "MainCell")
        
        ProductManager.shared.getProductData(urlString: "https://dummyjson.com/products")
        NetworkManager.shared.getData(string: "https://dummyjson.com/products") { (data: ProductModel?, error) in
            
            if let error {
                print(error)
                return
            }
            
            guard let data else {
                return
            }
            DispatchQueue.main.async {
                self.array.append(data)
                self.table.reloadData()
                print(self.array.first?.products.count)
            }
            
        }
    }
    
}

extension ViewController2: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return array.first?.products.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath) as! MainCell
        
        cell.index = indexPath
        cell.brandLabel.text = array.first?.products[indexPath.row].brand
        cell.stockLabel.text = "stock : \((array.first?.products[indexPath.row].stock) ?? 0)"
        cell.priceLabel.text = "price: \((array.first?.products[indexPath.row].price) ?? 0)"
        cell.quantityLabel.text = "\(cell.dict[indexPath] ?? 0)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 139.0
    }
}
