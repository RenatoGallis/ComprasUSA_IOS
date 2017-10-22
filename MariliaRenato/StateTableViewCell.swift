//
//  StateTableViewCell.swift
//  ComprasUSA
//
//  Created by Lia Tiemy on 10/10/17.
//  Copyright © 2017 FIAP. All rights reserved.
//

import UIKit

class StateTableViewCell: UITableViewCell {

    @IBOutlet weak var tfEstado: UILabel!
    
    @IBOutlet weak var tfTaxa: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
