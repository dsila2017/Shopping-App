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
        
        self.present(vc!, animated: true)
        //self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    var array = [ProductModel]()
    var filteredArray = [
        [productsArray]
    ]()
    var imageDict = [String: UIImage]()
    
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
                
                for i in (self.array.first?.products)! {
                
                    
                    if self.filteredArray.contains(where: {$0.contains(where: {$0.category == i.category})}) {
                        print("x")
                        
                    } else {
                        print(i.category)
                        self.filteredArray.append((self.array.first?.products.filter {$0.category == i.category})!)
                    }
                }
                
                for i in 0...(self.array.first?.products.count)!-1 {
                    self.downloadImage(url: (self.array.first?.products[i].images.first)!)
                }
            }
        }
    }
    
    func downloadImage(url: String) {
        
        guard let newUrl = URL(string: url) else {return}
        let session = URLSession(configuration: .default)

        let downloadPicture = session.dataTask(with: newUrl) { (data, response, error) in
            
            if let error {
                print(error)
            } else {
                
                if let response = response as? HTTPURLResponse {
                    
                    if let imageData = data {
                        
                        DispatchQueue.main.async {
                            self.imageDict[url] = UIImage(data: imageData)!
                            self.table.reloadData()
                        }
                    } else {
                        print("Couldn't get image: Image is nil")
                    }
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
        }.resume()
    }
}

extension ViewController2: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return self.filteredArray[section].first?.category
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.filteredArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.filteredArray[section].count
        //return array.first?.products.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath) as! MainCell
        
        cell.layer.borderWidth = 2.0
        cell.layer.cornerRadius = 14.0
        cell.layer.borderColor = UIColor.lightGray.cgColor
        
        cell.index = indexPath
        //cell.brandLabel.text = array.first?.products[indexPath.row].brand
        cell.brandLabel.text = self.filteredArray[indexPath.section][indexPath.row].brand
        cell.stockLabel.text = "stock : \((self.filteredArray[indexPath.section][indexPath.row].stock))"
        cell.priceLabel.text = "price: \((self.filteredArray[indexPath.section][indexPath.row].price))"
        cell.quantityLabel.text = "\(cell.dict[indexPath] ?? 0)"
        cell.productImage.image = self.imageDict[self.filteredArray[indexPath.section][indexPath.row].images.first ?? "Error"]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 139.0
    }
}
