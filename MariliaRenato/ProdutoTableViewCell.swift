//
//  ProdutoTableViewCell.swift
//  ComprasUSA
//
//  Created by Lia Tiemy on 30/09/17.
//  Copyright © 2017 FIAP. All rights reserved.
//

import UIKit

class ProdutoTableViewCell: UITableViewCell {
    @IBOutlet weak var ivPhoto: UIImageView!
    @IBOutlet weak var lbProductName: UILabel!
    @IBOutlet weak var lbStateName: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var tfCartao: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
