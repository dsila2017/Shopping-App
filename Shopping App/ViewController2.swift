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
    
    @IBOutlet weak var mainQuantityLabel: UILabel!
    @IBOutlet weak var mainTotalLabel: UILabel!
    
    @IBAction func clearNetwork(_ sender: UIButton) {
    }
    
    
    @IBAction func nextButton(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ViewController3") as? ViewController3
        
        vc?.imageDict = self.imageDict
        vc?.newDict = self.dict4
        vc?.delegate = self
        
        vc?.array = self.filteredArray3
        
//        for i in self.filteredArray3{
//            if dict4.contains(where: {$0.key == i.id}){
//                self.filteredArray4.append(i)
//                UserDefaults.standard.filteredArray4 = self.filteredArray4
//            }
//        }
//        if UserDefaults.standard.object(forKey: UserDefaults.UserDefaultsKeys.filteredArray4.rawValue) == nil {
//            UserDefaults.standard.filteredArray4 = self.filteredArray4
//            vc?.array = self.filteredArray4
//        } else {
//            vc?.array = self.filteredArray4
//        }
        //self.present(vc!, animated: true)
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    var array = [ProductModel]()
    var filteredArray = [
        [productsArray]
    ]()
    
    //var filteredArray2 = [productsArray: IndexPath]()
    
    var filteredArray3 = [productsArray]()
    var filteredArray4 = [productsArray]()
    
    
    var imageDict = [String: UIImage]()
    
    var mainQuantity = 0
    var mainTotal = 0
    
    var imageArray = [[String: Data]]()
    
    
    var dict4 = [Int: Int]()
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
        
        if UserDefaults.standard.object(forKey: UserDefaults.UserDefaultsKeys.filteredArray3.rawValue) != nil {
            
            self.filteredArray3 = UserDefaults.standard.filteredArray3
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //UserDefaults.standard.removeAllDataForAllkeys()
        
        
        
        self.mainQuantityLabel.text = "\(mainQuantity)"
        self.table.delegate = self
        self.table.dataSource = self
        let nib = UINib(nibName: "MainCell", bundle: nil)
        self.table.register(nib, forCellReuseIdentifier: "MainCell")
        
        if UserDefaults.standard.object(forKey: UserDefaults.UserDefaultsKeys.productData.rawValue) == nil {
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
                    
                    UserDefaults.standard.objectArray = [data]
                    self.array = [data]
                    
                    print("GOT FROM NETWORK")
                    
                    self.table.reloadData()
                    
                    for i in (self.array.first?.products)! {
                        
                        
                        if self.filteredArray.contains(where: {$0.contains(where: {$0.category == i.category})}) {
                            
                        } else {
                            self.filteredArray.append((self.array.first?.products.filter {$0.category == i.category})!)
                        }
                    }
                    
                    for i in 0...(self.array.first?.products.count)!-1 {
                        self.downloadImage(url: (self.array.first?.products[i].images.first)!)
                    }
                    
                }
            }
        }
        else {
            
            self.array = UserDefaults.standard.objectArray
            
            print("GOT FROM LOCAL")
            
            self.table.reloadData()
            
            for i in (self.array.first?.products)! {
                
                
                if self.filteredArray.contains(where: {$0.contains(where: {$0.category == i.category})}) {
                    
                } else {
                    self.filteredArray.append((self.array.first?.products.filter {$0.category == i.category})!)
                }
            }
            
            for i in self.array[0].products {
                self.downloadImage(url: (i.images.first)!)
            }
        }
        
    }
    
    func downloadImage(url: String) {
        
        if UserDefaults.standard.object(forKey: UserDefaults.UserDefaultsKeys.productPhotos.rawValue) == nil {
            
            guard let newUrl = URL(string: url) else {return}
            let session = URLSession(configuration: .default)
            
            let downloadPicture = session.dataTask(with: newUrl) { (data, response, error) in
                
                if let error {
                    print(error)
                } else {
                    
                    if let response = response as? HTTPURLResponse {
                        
                        if let imageData = data {
                            
                            DispatchQueue.main.async {
                                
                                UserDefaults.standard.photoArray = imageData
                                self.imageDict[url] = UIImage(data: imageData)!
                                
                                self.imageArray.append([url : imageData])
                                UserDefaults.standard.imageDict = self.imageArray
                                
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
        } else {
            
            DispatchQueue.main.async {
                
                for i in UserDefaults.standard.imageDict{
                    if i.contains(where: {$0.key == url}){
                        
                        self.imageDict[url] = UIImage(data: i.first(where: {$0.key == url})!.value)
                        self.table.reloadData()
                    }
                }
            }
            
        }
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
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath) as! MainCell
        
        cell.layer.borderWidth = 2.0
        cell.layer.cornerRadius = 14.0
        cell.layer.borderColor = UIColor.lightGray.cgColor
        
        cell.delegate = self
        cell.index = indexPath
        //cell.brandLabel.text = array.first?.products[indexPath.row].brand
        cell.brandLabel.text = self.filteredArray[indexPath.section][indexPath.row].brand
        cell.stockLabel.text = "stock : \((self.filteredArray[indexPath.section][indexPath.row].stock))"
        //print(self.filteredArray[indexPath.section][indexPath.row].stock)
        cell.priceLabel.text = "price: \((self.filteredArray[indexPath.section][indexPath.row].price))"
        //cell.quantityLabel.text = "\(cell.dict[indexPath] ?? 0)"
        
        cell.quantityLabel.text = "\(self.dict4[self.filteredArray[indexPath.section][indexPath.row].id] ?? 0)"
        
        cell.productImage.image = self.imageDict[self.filteredArray[indexPath.section][indexPath.row].images.first ?? "Error"]
        
        
        cell.maxQ = self.filteredArray[indexPath.section][indexPath.row].stock
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 139.0
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    }
    
    
}

protocol passData {
    func plusQuantity()
    func minusQuantity()
    func indexPlus(index: IndexPath, quantity: Int)
    func indexMinus(index: IndexPath, quantity: Int)
}

extension ViewController2: passData{
    
    
    func indexPlus(index: IndexPath, quantity: Int) {
        //self.filteredArray2?.updateValue(index, forKey: filteredArray[index.section][index.row])
        if UserDefaults.standard.object(forKey: UserDefaults.UserDefaultsKeys.filteredArray3.rawValue) == nil {
            print("nilling")
            self.filteredArray3.append(filteredArray[index.section][index.row])
            UserDefaults.standard.filteredArray3 = self.filteredArray3
        } else {
            print("nonononon")
            self.filteredArray3 = UserDefaults.standard.filteredArray3
            self.filteredArray3.append(filteredArray[index.section][index.row])
            UserDefaults.standard.filteredArray3 = self.filteredArray3
        }
        
        //self.filteredArray2[filteredArray[index.section][index.row]] = index
        self.mainTotal += self.filteredArray[index.section][index.row].price
        self.mainTotalLabel.text = "\(self.mainTotal)"
        
        self.dict4[filteredArray[index.section][index.row].id] = quantity
        
        self.dict4 = self.dict4.filter{$0.value > 0}
        
        
        
    }
    
    func indexMinus(index: IndexPath, quantity: Int) {
        self.mainTotal -= self.filteredArray[index.section][index.row].price
        self.mainTotalLabel.text = "\(self.mainTotal)"
        self.dict4[filteredArray[index.section][index.row].id] = quantity
        //self.filteredArray3.append(filteredArray[index.section][index.row])
        
        self.dict4 = self.dict4.filter{$0.value > 0}
        
    }
    
    func plusQuantity() {
        self.mainQuantity += 1
        self.mainQuantityLabel.text = "\(mainQuantity)"
        
    }
    
    func minusQuantity() {
        if self.mainQuantity > 0 {
            self.mainQuantity -= 1
            self.mainQuantityLabel.text = "\(mainQuantity)"
            
        }
    }
}

extension UserDefaults {
    
    enum UserDefaultsKeys: String, CaseIterable {
        case productData
        case productPhotos
        case mainQ
        case filteredArray3
        case filteredArray4
        case dict
        case imageDict
        
    }
    
    var objectArray: [ProductModel] {
        
        get {
            let decoded = try? JSONDecoder().decode([ProductModel].self, from: UserDefaults.standard.object(forKey: UserDefaults.UserDefaultsKeys.productData.rawValue) as! Data)
            
            return decoded!
        }
        set {
            let encode = try? JSONEncoder().encode(newValue)
            UserDefaults.standard.set(encode, forKey: UserDefaults.UserDefaultsKeys.productData.rawValue)
            
        }
    }
    
    var photoArray: Data {
        
        get {
            let decoded = try? JSONDecoder().decode(Data.self, from: UserDefaults.standard.object(forKey: UserDefaults.UserDefaultsKeys.productPhotos.rawValue) as! Data)
            
            return decoded!
        }
        set {
            let encode = try? JSONEncoder().encode(newValue)
            UserDefaults.standard.set(encode, forKey: UserDefaults.UserDefaultsKeys.productPhotos.rawValue)
            
        }
    }
    
    var mainQ: Int? {
        
        get {
            Int(string(forKey: UserDefaults.UserDefaultsKeys.mainQ.rawValue) ?? "")
        }
        
        set {
            set(newValue, forKey: UserDefaults.UserDefaultsKeys.mainQ.rawValue)
        }
    }
    
    var filteredArray3: [productsArray] {
        
        get {
            let decoded = try? JSONDecoder().decode([productsArray].self, from: UserDefaults.standard.object(forKey: UserDefaults.UserDefaultsKeys.filteredArray3.rawValue) as! Data)
            
            return decoded!
        }
        set {
            let encode = try? JSONEncoder().encode(newValue)
            UserDefaults.standard.set(encode, forKey: UserDefaults.UserDefaultsKeys.filteredArray3.rawValue)
            
        }
    }
    
    var filteredArray4: [productsArray] {
        
        get {
            let decoded = try? JSONDecoder().decode([productsArray].self, from: UserDefaults.standard.object(forKey: UserDefaults.UserDefaultsKeys.filteredArray4.rawValue) as! Data)
            
            return decoded!
        }
        set {
            let encode = try? JSONEncoder().encode(newValue)
            UserDefaults.standard.set(encode, forKey: UserDefaults.UserDefaultsKeys.filteredArray4.rawValue)
            
        }
    }
    
    var dict: [Int : Int] {
        
        get {
            let decoded = try? JSONDecoder().decode([Int : Int].self, from: UserDefaults.standard.object(forKey: UserDefaults.UserDefaultsKeys.dict.rawValue) as! Data)
            
            return decoded!
        }
        set {
            let encode = try? JSONEncoder().encode(newValue)
            UserDefaults.standard.set(encode, forKey: UserDefaults.UserDefaultsKeys.dict.rawValue)
            
        }
    }
    
    var imageDict: [[String: Data]] {
        
        get {
            let decoded = try? JSONDecoder().decode([[String: Data]].self, from: UserDefaults.standard.object(forKey: UserDefaults.UserDefaultsKeys.imageDict.rawValue) as! Data)
            
            return decoded!
        }
        set {
            let encode = try? JSONEncoder().encode(newValue)
            UserDefaults.standard.set(encode, forKey: UserDefaults.UserDefaultsKeys.imageDict.rawValue)
            
        }
    }
    
    
    
    func removeAllDataForAllkeys() {
        UserDefaultsKeys.allCases.map { UserDefaults.standard.removeObject(forKey: $0.rawValue) }
    }
}

protocol updateQuantity {
    func passDatax(array :[Int: Int])
}

extension ViewController2: updateQuantity {
    func passDatax(array : [Int: Int]) {
        for i in self.array[0].products {
            for p in array {
                if i.id == p.key {
                    
                    i.stock -= p.value
                    UserDefaults.standard.objectArray = self.array
                }
            }
        }
    }
}

