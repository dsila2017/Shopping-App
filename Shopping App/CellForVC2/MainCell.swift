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
    
    @IBAction func plusButton(_sender: UIButton) {
        quanity += 1
        self.quantityLabel.text = "\(quanity)"
    }
    @IBAction func minusButton(_sender: UIButton) {
        if quanity > 0 {
            quanity -= 1
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
