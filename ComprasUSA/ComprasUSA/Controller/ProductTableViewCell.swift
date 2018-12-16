//
//  ProductTableViewCell.swift
//  ComprasUSA
//
//  Created by Marcos V. S. Matsuda on 14/12/18.
//  Copyright © 2018 Marcos V. S. Matsuda. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var ImageProduct: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func prepare(with product: Product){
        lbName.text = product.name ?? ""
        lbPrice.text = "US$ \( String(describing: product.price) )"
        ImageProduct.image = product.cover as? UIImage
    }

}
