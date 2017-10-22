//
//  ProductRegisterViewController.swift
//  ComprasUSA
//
//  Created by Lia Tiemy on 30/09/17.
//  Copyright © 2017 FIAP. All rights reserved.
//

import UIKit
import CoreData

class ProductRegisterViewController: UIViewController {
    @IBOutlet weak var tfProduct: UITextField!
    @IBOutlet weak var tfState: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var ivPhoto: UIImageView!
    @IBOutlet weak var sCard: UISwitch!
    @IBOutlet weak var btRegister: UIButton!
    
    //PickerView que será usado como entrada para o textField de Gênero
    var pickerView: UIPickerView!
    
    var product: Product!
    var smallImage: UIImage!
    
    var fetchedResultController: NSFetchedResultsController<State>!
    
    //Objeto que servirá como fonte de dados para alimentar o pickerView
    var dataSource:[State] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if product != nil {
            tfProduct.text = product.product
            tfPrice.text = "\(product.price)"
            sCard.isOn = product.card
            if let state = product.state {
                tfState.text = state.state
            }
            if let image = product.photo as? UIImage {
                ivPhoto.image = image
            }
            // colocando o botao atualizar:
            btRegister.setTitle("Atualizar", for: .normal)
        }
        
        pickerView = UIPickerView() //Instanciando o UIPickerView
        pickerView.backgroundColor = .white
        pickerView.delegate = self  //Definindo seu delegate
        pickerView.dataSource = self  //Definindo seu dataSource
        
        //delegate dos textview para que o teclado abaixe qdo clicar na tecla return
        tfPrice.delegate = self
        tfProduct.delegate = self
        
        
        //Criando uma toobar que servirá de apoio ao pickerView. Através dela, o usuário poderá
        //confirmar sua seleção ou cancelar
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        
        //O botão abaixo servirá para o usuário cancelar a escolha de gênero, chamando o método cancel
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        
        let btSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        //O botão done confirmará a escolha do usuário, chamando o método done.
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.items = [btCancel, btSpace, btDone]
        
        //Aqui definimos que o pickerView será usado como entrada do extField
        tfState.inputView = pickerView
        
        //Definindo a toolbar como view de apoio do textField (view que fica acima do teclado)
        tfState.inputAccessoryView = toolbar
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadStates()
        if product != nil {
            if let state = product.state {
                tfState.text = state.state
            }
        }
    }
    
    //O método cancel irá esconder o teclado e não irá atribuir a seleção ao textField
    @objc func cancel() {
        
        //O método resignFirstResponder() faz com que o campo deixe de ter o foco, fazendo assim
        //com que o teclado (pickerView) desapareça da tela
        tfState.resignFirstResponder()
    }
    
    //O método done irá atribuir ao textField a escolhe feita no pickerView
    @objc func done() {
        
        if dataSource.count > 0{
        //Abaixo, recuperamos a linha selecionada na coluna (component) 0 (temos apenas um component
        //em nosso pickerView)
        tfState.text = dataSource[pickerView.selectedRow(inComponent: 0)].state
        
        //Agora, gravamos esta escolha no UserDefaults
        UserDefaults.standard.set(tfState.text!, forKey: "sate")
        cancel()
        }else {
            cancel()
        }
        
    }
    
    // MARK: - IBActions
    @IBAction func addPhoto(_ sender: UIButton) {
        //Criando o alerta que será apresentado ao usuário
        let alert = UIAlertController(title: "Selecionar poster", message: "De onde você quer escolher o poster?", preferredStyle: .actionSheet)
        
        //Verificamos se o device possui câmera. Se sim, adicionamos a devida UIAlertAction
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default, handler: { (action: UIAlertAction) in
                self.selectPicture(sourceType: .camera)
            })
            alert.addAction(cameraAction)
        }
        
        //As UIAlertActions de Biblioteca de fotos e Álbum de fotos também são criadas e adicionadas
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libraryAction)
        
//        let photosAction = UIAlertAction(title: "Álbum de fotos", style: .default) { (action: UIAlertAction) in
//            self.selectPicture(sourceType: .savedPhotosAlbum)
//        }
//        alert.addAction(photosAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
}
    
    @IBAction func addProduct(_ sender: UIButton) {
        if(product != nil){
            //atualizacao do produto
            if((tfProduct.text! == "") || (tfPrice.text! == "") || (tfState.text! == "") || (ivPhoto.image == nil)){
                self.showAlert()
            }else {
                addProduct()
            }
        }else{
            //novo produto
            if((tfProduct.text! == "") || (tfPrice.text! == "") || (tfState.text! == "") || (smallImage == nil)){
                self.showAlert()
            }
            else{
                //if product == nil {
                product = Product(context: context)
                //}
                addProduct()
            }
        }
        
    }
    
    func addProduct(){
        product.product = tfProduct.text!
        product.price = Double(tfPrice.text!)!
        product.card = sCard.isOn
        var selectState: State?
        selectState = dataSource[pickerView.selectedRow(inComponent: 0)]
        if let state = selectState {
            product.state = state
        }
        
        if smallImage != nil {
            product.photo = smallImage
        }
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        self.navigationController?.popViewController(animated: true)
    }
        // Menssagem para validar se o pessoal insere todos os campos:
        func showAlert() {
            let alert = UIAlertController(title: "Atenção!", message: "Todos os campos devem ser preenchidos!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    // MARK:  Methods
    func selectPicture(sourceType: UIImagePickerControllerSourceType) {
        //Criando o objeto UIImagePickerController
        let imagePicker = UIImagePickerController()
        
        //Definimos seu sourceType através do parâmetro passado
        imagePicker.sourceType = sourceType
        
        //Definimos a MovieRegisterViewController como sendo a delegate do imagePicker
        imagePicker.delegate = self
        
        //Apresentamos a imagePicker ao usuário
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func selectState(_ sender: UITextField) {
        loadStates()
    }
    
    func loadStates() {
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "state", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            dataSource = try context.fetch(fetchRequest)
            //tableView.reloadData()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
}

extension ProductRegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //O método abaixo nos trará a imagem selecionada pelo usuário em seu tamanho original
   @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String: AnyObject]?) {
        
        //Iremos usar o código abaixo para criar uma versão reduzida da imagem escolhida pelo usuário
        let smallSize = CGSize(width: 300, height: 280)
        UIGraphicsBeginImageContext(smallSize)
        image.draw(in: CGRect(x: 0, y: 0, width: smallSize.width, height: smallSize.height))
        
        //Atribuímos a versão reduzida da imagem à variável smallImage
        smallImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        ivPhoto.image = smallImage //Atribuindo a imagem à ivPoster
        
        //Aqui efetuamos o dismiss na UIImagePickerController, para retornar à tela anterior
        dismiss(animated: true, completion: nil)
    }
}



extension ProductRegisterViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //Retornando o texto recuperado do objeto dataSource, baseado na linha selecionada
        return dataSource[row].state
    }
}

extension ProductRegisterViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1    //Usaremos apenas 1 coluna (component) em nosso pickerView
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count //O total de linhas será o total de itens em nosso dataSource
    }
}
// MARK: - UITableViewDelegate
extension ProductRegisterViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Excluir") { (action: UITableViewRowAction, indexPath: IndexPath) in
            let state = self.dataSource[indexPath.row]
            self.context.delete(state)
            try! self.context.save()
            self.dataSource.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "Editar") { (action: UITableViewRowAction, indexPath: IndexPath) in
            //let state = self.dataSource[indexPath.row]
            tableView.setEditing(false, animated: true)
            //self.showAlert(type: .edit, category: state)
        }
        editAction.backgroundColor = .blue
        return [editAction, deleteAction]
    }
}

// MARK: - UITableViewDelegate
extension ProductRegisterViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let state = dataSource[indexPath.row]
        cell.textLabel?.text = state.state
        return cell
    }
}

extension ProductRegisterViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //dataSource.reloadData()
    }
}

extension ProductRegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


