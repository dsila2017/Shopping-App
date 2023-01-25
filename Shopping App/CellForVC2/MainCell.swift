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
    
    var quanity = 0
    var dict = [IndexPath: Int]()
    var index = IndexPath()
    
    @IBAction func plusButton(_sender: UIButton) {
        plus()
    }
    @IBAction func minusButton(_sender: UIButton) {
        minus()
    }
    
    func plus() {
        quanity += 1
        dict[index] = quanity
        
        self.quantityLabel.text = "\(quanity)"
    }
    
    func minus() {
        if quanity > 0 {
            quanity -= 1
            dict[index] = quanity
            self.quantityLabel.text = "\(quanity)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.stockLabel.text = "stock: "
        self.priceLabel.text = "price: "
        self.quantityLabel.text = ""
        self.quantityLabel.text = "\(quanity)"
        
    }
    
    override func prepareForReuse() {
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
