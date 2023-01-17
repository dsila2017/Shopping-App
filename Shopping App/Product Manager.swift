//
//  Product Manager.swift
//  Shopping App
//
//  Created by David on 1/17/23.
//

import Foundation

class ProductManager {
    
    func getProductData(urlString: String){
        
        NetworkManager.shared.getData(string: urlString) { (data: [ProductModel]?, error) in
            
            if let error {
                print (error)
            }
            
            guard let data else{
                print(error)
                return
            }
            
            print("We have got data")
            
        }
    }
}
