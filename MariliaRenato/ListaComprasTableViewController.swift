//
//  ListaComprasTableViewController.swift
//  ComprasUSA
//
//  Created by Lia Tiemy on 30/09/17.
//  Copyright © 2017 FIAP. All rights reserved.
//

import UIKit
import CoreData

class ListaComprasTableViewController: UITableViewController {
    
    var label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 22))
    var fetchedResultController: NSFetchedResultsController<Product>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 106
        tableView.rowHeight = UITableViewAutomaticDimension
        label.text = "Sua lista está vazia"
        label.textAlignment = .center
        label.textColor = .black
        
        loadProducts()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == "edit" {
            if let vc = segue.destination as? ProductRegisterViewController {
                if let index = tableView.indexPathForSelectedRow{
                    vc.product = fetchedResultController.object(at: index)
                }
            }
        }
    }
    

    func loadProducts() {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "product", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        do {
            try fetchedResultController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = fetchedResultController.fetchedObjects?.count {
            tableView.backgroundView = (count == 0) ? label : nil
            return count
        } else {
            tableView.backgroundView = label
            return 0
        }
    }

    //Método que define a célula que será apresentada em cada linha
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "produtcCell", for: indexPath) as! ProdutoTableViewCell
        let product = fetchedResultController.object(at: indexPath)
        cell.lbProductName.text = "Produto:  " + product.product!
        
        if product.card == true {
            cell.tfCartao.text = "Sim"
        } else{
            cell.tfCartao.text = "Nao"
        }
        cell.lbPrice.text = "Preço:  " + "\(product.price)"
        
        if let image = product.photo as? UIImage {
            cell.ivPhoto.image = image
        } else {
            cell.ivPhoto.image = nil
        }
        
        if let state = product.state{
            if let stateName = state.state {
                cell.lbStateName.text =  "Estado da Compra:  " + stateName
            }
        } else {
            cell.lbStateName.text = nil
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let product = fetchedResultController.object(at: indexPath)
            context.delete(product)
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension ListaComprasTableViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}




