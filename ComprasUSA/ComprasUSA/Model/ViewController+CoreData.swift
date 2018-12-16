//
//  ViewController+CoreData.swift
//  ComprasUSA
//
//  Created by Marcos V. S. Matsuda on 14/12/18.
//  Copyright © 2018 Marcos V. S. Matsuda. All rights reserved.
//

import UIKit
import CoreData

extension UIViewController {
    var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
}
