//
//  UIViewController+CoreData.swift
//  ComprasUSA
//
//  Created by Lia Tiemy on 30/09/17.
//  Copyright © 2017 FIAP. All rights reserved.
//

import CoreData
import UIKit

extension UIViewController {
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    var context: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
}

