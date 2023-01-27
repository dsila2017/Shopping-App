//
//  MainCell.swift
//  Shopping App
//
//  Created by David on 1/23/23.
//

import UIKit

class MainCell: UITableViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    
    var quantity = 0
    var dict = [IndexPath: Int]()
    var index = IndexPath()
    
    var dict2 = [Int: Int]()
    
    var delegate: passData?
    
    var maxQ = 0
    
    @IBAction func plusButton(_sender: UIButton) {
        if quantity < maxQ {
            plus()
            delegate?.plusQuantity()
            delegate?.indexPlus(index: index, quantity: quantity)
        }
    }
    @IBAction func minusButton(_sender: UIButton) {
        
        if quantity > 0{
            minus()
            delegate?.minusQuantity()
            delegate?.indexMinus(index: index, quantity: quantity)
        }
    }
    
    func plus() {
        //if quantity < 10 {
            quantity += 1
            //dict[index] = quanity
            
            self.quantityLabel.text = "\(quantity)"
        //}
    }
    
    func minus() {
        if quantity > 0 {
            quantity -= 1
            //dict[index] = quantity
            self.quantityLabel.text = "\(quantity)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.quantity = 0
        self.stockLabel.text = "stock: "
        self.priceLabel.text = "price: "
        self.quantityLabel.text = ""
        self.quantityLabel.text = "\(quantity)"
        
    }
    
    override func prepareForReuse() {
        
        self.quantity = 0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
