//
//  RoundedButton.swift
//  ComprasUSA
//
//  Created by Lia Tiemy on 30/09/17.
//  Copyright © 2017 FIAP. All rights reserved.
//

import UIKit

@IBDesignable class RoundedButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet{
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = .black{
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }
    
    
}

