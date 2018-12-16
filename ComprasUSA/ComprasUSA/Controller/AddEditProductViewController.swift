//
//  AddEditProductViewController.swift
//  ComprasUSA
//
//  Created by Marcos V. S. Matsuda on 14/12/18.
//  Copyright © 2018 Marcos V. S. Matsuda. All rights reserved.
//

import UIKit
import CoreData

class AddEditProductViewController: UIViewController {
    
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var ivImagemProduto: UIImageView!
    @IBOutlet weak var ivButton: UIButton!
    @IBOutlet weak var tfPurchaseState: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var creditCard: UISwitch!
    @IBOutlet weak var lbAddEdit: UIButton!
    @IBOutlet weak var ivAddImage: UIImageView!
    
    var estado: [State] = []
    var purchasePickerList = [State]()
    var product: Product!
    var statesManager = StatesManager.shared
    
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createToolBar()
        self.tfPrice.keyboardType = .decimalPad
        self.hideKeyboardWhenTappedAround()
        
        if product != nil {
//            title = "Alterar produto"
            ivAddImage.image = nil
            ivButton.setTitle(nil, for: .normal)
            tfName.text = product.name
            ivImagemProduto.image = product.cover as? UIImage
            tfPurchaseState.text = product.states?.name
            tfPrice.text = String(describing: product.price)

            let credit = product.credit_card ? true : false
            creditCard.setOn(credit, animated:true)

            lbAddEdit.setTitle("ALTERAR", for: .normal)

        }else{
            title = "Cadastrar produto"
        }
    }
    
    @IBAction func addEditProduct(_ sender: UIButton) {
    
//
//        title = "Alterar produto"
        if product == nil {
            product = Product(context: context)
            title = "Adicionar produto"
        }

        if (tfName.text ?? "").isEmpty {
            requireAlert(mensagem: "Nome do produto é obrigatório")
            return
        }else{
            product.name = tfName.text
        }

        // validar imagem
        if let image = ivImagemProduto.image {
            product.cover = image
        }else{
            requireAlert(mensagem: "Imagem do produto é obrigatório")
            return
        }

        if !tfPurchaseState.text!.isEmpty {
            
            let state = statesManager.state[pickerView.selectedRow(inComponent: 0)]
            product.states = state

        }else{
            requireAlert(mensagem: "Estado da compra é obrigatório")
            return
        }

        if let price = tfPrice.text {
            if tfPrice.text!.isEmpty {
                requireAlert(mensagem: "Valor do produto é obrigatório")
                return
            }else {
                if let price = Double(price) {
                    product.price =  price
                }
            }
        }
   
        product.credit_card = creditCard.isOn
        do{
            try self.context.save()
            backToViewProductList()
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func backToViewProductList(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func cancel(){
        tfPurchaseState.resignFirstResponder()
    }
    
    @objc func done(){
        tfPurchaseState.text = statesManager.state[pickerView.selectedRow(inComponent: 0)].name
        cancel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        statesManager.loadStates(with: context)

        //Se não houver estado cadastrado, o mesmo sera desabilitado, pois ocorre um bug ao abrir uma lista vazia e clicar em done
        if statesManager.state.count > 0 {
            tfPurchaseState.isUserInteractionEnabled = true
        }else{
            tfPurchaseState.text = nil
            tfPurchaseState.isUserInteractionEnabled = false
        }
    }
    
    func requireAlert(mensagem: String){

        let alert = UIAlertController(title: mensagem, message: nil, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))

        present(alert, animated: true)

    }
    
    @IBAction func addImagemProduto(_ sender: Any) {
        let alert = UIAlertController(title: "Selecionar poster", message: "De onde você quer escolher o poster?", preferredStyle: .actionSheet)

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default) { (action) in
                self.selectPicture(sourceType: .camera)
            }
            alert.addAction(cameraAction)
        }

        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) { (action) in
            self.selectPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libraryAction)

        let photosAction = UIAlertAction(title: "Álbum de fotos", style: .default) { (action) in
            self.selectPicture(sourceType: .savedPhotosAlbum)
        }
        alert.addAction(photosAction)

        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)


        present(alert, animated: true, completion: nil)

    }
    
    
    func selectPicture(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()

        imagePicker.sourceType = sourceType
        imagePicker.delegate = self

        present(imagePicker, animated: true, completion: nil)

    }
    
    
    func createToolBar(){

        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        let btFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.items = [btCancel, btFlexibleSpace, btDone]
        tfPurchaseState.inputView = pickerView
        tfPurchaseState.inputAccessoryView = toolBar
    }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer =     UITapGestureRecognizer(target: self, action:    #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension AddEditProductViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return statesManager.state.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let state = statesManager.state[row]
        return state.name
    }

}

extension AddEditProductViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        ivAddImage.image = nil
        self.ivImagemProduto.image = selectedImage
        self.ivButton.setTitle(nil, for: .normal)
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }

}

