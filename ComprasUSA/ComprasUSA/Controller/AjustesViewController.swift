//
//  AjustesViewController.swift
//  ComprasUSA
//
//  Created by Marcos V. S. Matsuda on 14/12/18.
//  Copyright © 2018 Marcos V. S. Matsuda. All rights reserved.
//

import UIKit
import CoreData

class AjustesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dollarQuotation: UITextField!
    @IBOutlet weak var taxOnFinancialOrder: UITextField!
    
    var labelEmptyTable = UILabel()
    var fetchedStatesResultsController: NSFetchedResultsController<State>!
    
    let config = Configuration.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadStates()
        
        configure(textField: dollarQuotation)
        configure(textField: taxOnFinancialOrder)
        
        //atualizacao do settings bundle
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "Refresh"), object: nil, queue: nil) { (notification) in
            self.formatView()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
        //carrega os valores de settings
        formatView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //ao esconder teclado, atualizo a settingsbundle
        getValuesTextField()
        dollarQuotation.resignFirstResponder()
        taxOnFinancialOrder.resignFirstResponder()
    }
    
    func getValuesTextField(){
            
        if let value = dollarQuotation.text {
            config.cotacao = Double(value) ?? 0.0
        }
    
        if let value = taxOnFinancialOrder.text {
            config.iof = Double(value) ?? 0.0
        }
    }
    
    func configure(textField: UITextField) {
        textField.delegate = self
    }
    
    
    
    func formatView(){
        dollarQuotation.text = String(describing: config.cotacao)
        taxOnFinancialOrder.text = String(describing: config.iof)
    }
    
    func loadStates(){
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        fetchedStatesResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)

        fetchedStatesResultsController.delegate = self

        do{
            try fetchedStatesResultsController.performFetch()
        }catch{
            print(error.localizedDescription)
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func requireAlert(mensagem: String){

        let alert = UIAlertController(title: mensagem, message: nil, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))

        present(alert, animated: true)

    }
    
    @IBAction func changeDollarCotation(_ sender: UITextField) {
        
    }
    
    @IBAction func changeTaxOnFinancialOrder(_ sender: UITextField) {
        
    }
    
    
    @IBAction func addEstado(_ sender: Any) {
        showAlert(state: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = fetchedStatesResultsController.fetchedObjects?.count ?? 0
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_states", for: indexPath)
        guard let state = fetchedStatesResultsController.fetchedObjects?[indexPath.row] else { return cell }

        cell.textLabel?.text = state.name
        cell.detailTextLabel?.text = "\(state.tribute)%"
        return cell

    }
    
    func showAlert(state: State?){

        let title = state == nil ? "Adicionar" : "Editar"

        let alert = UIAlertController(title: title + " estado", message: nil, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))

        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Nome do estado"
            if let name = state?.name {
                textField.text = name
            }
        })

        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Imposto"
            if let tribute = state?.tribute {
                textField.text = String(format:"%f", tribute)
            }
        })


        alert.addAction(UIAlertAction(title: title, style: .default, handler: { (action) in

            let state = state ?? State(context: self.context)
            if let stateField = alert.textFields?.first, !(stateField.text?.isEmpty)!{
                state.name = stateField.text
            }else{
                self.requireAlert(mensagem: "Nome do estado é obrigatório")
                self.context.rollback()
                return
            }

            if let taxField = alert.textFields?.last, !(taxField.text?.isEmpty)!{
                let tributeValue = alert.textFields?.last?.text
                state.tribute = tributeValue?.toDouble() ?? 0.0
            }else{
                self.requireAlert(mensagem: "Imposto é obrigatório")
                self.context.rollback()
                return
            }

            do {
                try self.context.save()
                self.loadStates()
            } catch {
                print(error.localizedDescription)
            }

        }))
        present(alert, animated: true)

    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let product = fetchedStatesResultsController.fetchedObjects?[indexPath.row] else {return}
            context.delete(product)
            do{
                try context.save()
            }catch{
                print(error.localizedDescription)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let state = fetchedStatesResultsController.object(at: indexPath)
        showAlert(state: state)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    

}

extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}

extension AjustesViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break;
        default:
            tableView.reloadData()
        }
    }
    
}
