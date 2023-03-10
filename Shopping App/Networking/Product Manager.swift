//
//  Product Manager.swift
//  Shopping App
//
//  Created by David on 1/17/23.
//

import Foundation

class ProductManager {
    
    static var shared = ProductManager()
    
    func getProductData(urlString: String){
        
        NetworkManager.shared.getData(string: urlString) { (data: ProductModel?, error) in
            
            
            if let error {
                DispatchQueue.main.async {
                    print (error)
                }
            }
            
            guard let data else{
                DispatchQueue.main.async {
                    print (error)
                }
                return
            }
            DispatchQueue.main.async {
            }
            
        }
    }
}
