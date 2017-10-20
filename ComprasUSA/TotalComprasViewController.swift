//
//  TotalComprasViewController.swift
//  ComprasUSA
//
//  Created by Lia Tiemy on 10/13/17.
//  Copyright © 2017 FIAP. All rights reserved.
//

import UIKit
import CoreData

class TotalComprasViewController: UIViewController {

    @IBOutlet weak var tfDolar: UILabel!
    @IBOutlet weak var tfReal: UILabel!
    var dataSource: [Product] = []
    var product: Product!
    var lbDolar: Double = 0.0
    var lbReal: Double = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lbDolar = 0.0
        lbReal = 0.0
        resgataProdutos()
        tfDolar.text = "\(lbDolar)"
        tfReal.text = String(format: "%.2f", lbReal)
    }

    func resgataProdutos() {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "product", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            dataSource = try context.fetch(fetchRequest)
            calculaDolarReal()
        } catch {
            print(error.localizedDescription)
        }
    }

    func calculaDolarReal(){
    var cotacao: Double = 1
        cotacao = UserDefaults.standard.double(forKey: "cotacao")
        for product in dataSource {
            lbDolar += product.price
            
            //Se a compra foi com cartao
            var iof: Double = 1
            if product.card == true{
                iof = 1 + UserDefaults.standard.double(forKey: "iof")/100
            }
            
            //valor do imposto
            var imposto: Double = 1
            if let state = product.state {
                imposto = 1 + (state.tax)/100
            }
            
            lbReal += product.price * imposto * iof * cotacao

            
        }
    }
}
