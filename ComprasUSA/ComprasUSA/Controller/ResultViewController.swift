//
//  ResultViewController.swift
//  ComprasUSA
//
//  Created by Marcos V. S. Matsuda on 15/12/18.
//  Copyright © 2018 Marcos V. S. Matsuda. All rights reserved.
//

import UIKit
import CoreData

class ResultViewController: UIViewController {
    
    @IBOutlet weak var lbTotalReal: UILabel!
    @IBOutlet weak var lbTotalDollar: UILabel!
    
    let config = Configuration.shared
    var iofPrice: Double!
    var dollarCotation: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //se tiver uma atualizacao do settings bundle
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "Refresh"), object: nil, queue: nil) { (notification) in
            self.formatView()            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        formatView()
        calculate()
    }
    
    func formatView(){
        dollarCotation = config.cotacao
        iofPrice = config.iof
    }
    
    public func calculate(){
        
        var products  = [Product]()

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        do {

            products = try managedContext.fetch(fetchRequest) as! [Product]
            calculateDollar( products: products )
            calculateReal( products: products )

        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func calculateReal(products: [Product]){
        
        var sumReal: Double = 0.0
        
        for product in products {

            //tributo por estado
            let productTribute = product.states?.tribute as! Double

            let taxState = (productTribute != 0.0 ? productTribute/100 : 0)+1
            let iof = ( (iofPrice != 0.0 ? iofPrice/100 : 0) + 1 )

            if product.credit_card {

                sumReal += product.price * iof * taxState

            }else{

                sumReal += product.price
            }
        }

        lbTotalReal.text = String(format:"%.2f", dollarCotation * sumReal)
        
    }
    
    func calculateDollar(products: [Product]){
        
        let prices = products.map({ (products: Product) -> Double in
            products.price
        })

        let total = prices.reduce(0, +)

        lbTotalDollar.text = String(format:"%.2f", total)
    }
}
