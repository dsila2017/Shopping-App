//
//  SecondaryCell.swift
//  Shopping App
//
//  Created by David on 1/24/23.
//

import UIKit

class SecondaryCell: UITableViewCell {

    @IBOutlet weak var imageVC3: UIImageView!
    @IBOutlet weak var brandNameVC3: UILabel!
    @IBOutlet weak var quantityVC3: UILabel!
    @IBOutlet weak var subtotalVC3: UILabel!
    
    var delegate: Passer?
    var total = [IndexPath: Int]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
