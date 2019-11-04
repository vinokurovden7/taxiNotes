//
//  AccountCollectionController.swift
//  TaxiNotes
//
//  Created by Денис Винокуров on 28.10.2019.
//  Copyright © 2019 Денис Винокуров. All rights reserved.
//

import UIKit
import RealmSwift

let reuseIdentifier = "AccountNameCell"
private var accountArray: Results<Accounts>!
private var filteredArray: Results<Accounts>!
private var arraySmena: Results<Smena>!


class AccountCollectionController: UICollectionViewController{
    @IBOutlet var myCollectionView: UICollectionView!
    @IBOutlet weak var addAccountBtn: UIBarButtonItem!
    
    private var yellowColor = UIColor(displayP3Red: 255/255, green: 250/255, blue: 139/255, alpha: 255/255)
    private var arrayBarButtons: [UIBarButtonItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arrayBarButtons.append(addAccountBtn)
        accountArray = realm.objects(Accounts.self).sorted(byKeyPath: "nameAccount")
        Variables.sharedVariables.changeThemeCollectionViewControlle(viewController: self, arrayBarButtons: arrayBarButtons)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        myCollectionView.reloadData()
        Variables.sharedVariables.changeThemeCollectionViewControlle(viewController: self, arrayBarButtons: arrayBarButtons)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        myCollectionView.reloadData()
        Variables.sharedVariables.changeThemeCollectionViewControlle(viewController: self, arrayBarButtons: arrayBarButtons)
    }
    
    //Нажатие на ячейку
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Variables.sharedVariables.currentAccountName = accountArray[indexPath.row].nameAccount
        Variables.sharedVariables.scoreAccount = Double(accountArray[indexPath.row].scoreAccount)
        Variables.sharedVariables.idAccount = accountArray[indexPath.row].id
        DispatchQueue.main.async(){
            self.performSegue(withIdentifier: "mainScreen", sender: self)
        }
    }
    @IBAction func addAccountAction(_ sender: UIBarButtonItem) {
        alertAddAccount(editMode: false, indexPath: nil)
    }
    
    func alertAddAccount(editMode: Bool, indexPath: IndexPath?){
        //Показать алерт добавления новой учетной записи
        let alertTitle = editMode == false ? "Добавление учетной записи" : "Редактирование учетной записи"
        let alert = UIAlertController(title: alertTitle, message: nil, preferredStyle: .alert)
        
        //Настройка строки для ввода наименования учетной записи
        alert.addTextField(configurationHandler: { textField1 in
            textField1.placeholder = "Название"
            textField1.textAlignment = .center
            textField1.borderStyle = UITextField.BorderStyle.roundedRect
            textField1.keyboardType = .default
            textField1.clearButtonMode = .whileEditing
            textField1.autocapitalizationType = .sentences
            if indexPath != nil{
              textField1.text = accountArray[indexPath!.row].nameAccount
            }
            textField1.font = UIFont.boldSystemFont(ofSize: 17.0)
        })
        
        //Настройка строки для ввода счета учетной записи
        alert.addTextField(configurationHandler: { textField2 in
            textField2.placeholder = "Балланс"
            textField2.textAlignment = .center
            textField2.borderStyle = UITextField.BorderStyle.roundedRect
            textField2.keyboardType = .decimalPad
            textField2.clearButtonMode = .whileEditing
            if indexPath != nil {
                textField2.text = String(accountArray[indexPath!.row].scoreAccount)
            }
            textField2.font = UIFont.boldSystemFont(ofSize: 17.0)
        })
        
        //Обработчик кнопки добавления записи
        let buttonTitle = editMode == false ? "Добавить учетную запись" : "Сохранить изменения"
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: { action in
            
            //Если первое поле ввода (Наименование учетной записи) не пустое
            let score: String = ((alert.textFields?[1].text!)?.replacingOccurrences(of: ",", with: "."))!
            if !(alert.textFields?[0].text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! {
                filteredArray = accountArray.filter("nameAccount ==[c] %@",alert.textFields?[0].text ?? "")
                if filteredArray.count > 0 && !editMode {
                    self.addInformationAlert(title: "Уведомление", message: "Такая учетная запись уже существует")
                } else {
                    let account = Accounts()
                    account.nameAccount = (alert.textFields?[0].text)!
                    account.scoreAccount = Double(score) ?? 0.0
                    if editMode { account.id = accountArray[(indexPath?.row)!].id}
                    StorageManager.saveAccount(account)
                    self.myCollectionView.reloadData()
                    
                    let settings = Settings()
                    filteredArray = accountArray.filter("nameAccount ==[c] %@",alert.textFields?[0].text ?? "")
                    settings.idAccount = filteredArray.first!.id
                    StorageManager.saveSettings(settings)
                }
            } else {
              self.addAlertOk(title: "Уведомление", message: "Заполните название учетной записи", isRemove: false, indexPath: indexPath, editMode: editMode)
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .destructive, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    //Создание уведомления
    func addAlertOk(title: String, message: String, isRemove: Bool, indexPath: IndexPath?, editMode: Bool?){
        let editRadiusAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        var firstBtnTitle = "Ок"
        var styleFirstBtn: UIAlertAction.Style = .cancel
        if isRemove {
            editRadiusAlert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))
            firstBtnTitle = "Удалить"
            styleFirstBtn = .destructive
        }
        editRadiusAlert.addAction(UIAlertAction(title: firstBtnTitle, style: styleFirstBtn, handler: {action in
            
            if !isRemove {
                self.alertAddAccount(editMode: editMode ?? false, indexPath: indexPath)
            }
            else {
                guard let indexPath = indexPath else {return}
                StorageManager.removeAccount(id: accountArray[indexPath.row].id)
                self.myCollectionView.deleteItems(at: [indexPath])
            }
        }))
        
        self.present(editRadiusAlert, animated: true, completion: nil)
    }
    
    //Создание уведомления
    func addInformationAlert(title: String, message: String){
        let editRadiusAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        editRadiusAlert.addAction(UIAlertAction(title: "Ок", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(editRadiusAlert, animated: true, completion: nil)
    }
    
    //Нажите на любое пустое место на экране
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

extension AccountCollectionController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return accountArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AccountCollectionCell
        cell.nameAccountLabel.text = accountArray[indexPath.row].nameAccount
        cell.scoreAccountLabel.text = "Балланс: \(String(accountArray[indexPath.row].scoreAccount)) ₽"
        arraySmena = realm.objects(Smena.self).filter("endDateSmena == nil and idAccount == %@",accountArray[indexPath.row].id)
        if arraySmena.count > 0 {
            cell.startSmenaIndicatior.isHidden = false
        } else {
            cell.startSmenaIndicatior.isHidden = true
        }
        
        switch traitCollection.userInterfaceStyle {
            case .light, .unspecified:
                cell.contentView.backgroundColor = .black
                cell.nameAccountLabel.textColor = yellowColor
                cell.startSmenaIndicatior.tintColor = yellowColor
                cell.scoreAccountLabel.textColor = .white
            break
            case .dark:
                cell.contentView.backgroundColor = yellowColor
                cell.nameAccountLabel.textColor = .black
                cell.startSmenaIndicatior.tintColor = .black
                cell.scoreAccountLabel.textColor = .gray
                break
        @unknown default:
            fatalError()
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { actions -> UIMenu? in
            
            let deleteAction = UIAction(title: "Удалить", image: UIImage(systemName: "trash"), identifier: nil, attributes: .destructive) { action in
                self.addAlertOk(title: "Подтверждение удаления", message: "Вы действительно хотите удалить учетную запись '\(accountArray[indexPath.row].nameAccount)'?", isRemove: true, indexPath: indexPath, editMode: false)
            }
            
            let editAction = UIAction(title: "Редактировать", image: UIImage(systemName: "square.and.pencil"), identifier: nil) { action in
                self.alertAddAccount(editMode: true, indexPath: indexPath)
            }
            return UIMenu(__title: "", image: nil, identifier: nil, children:[editAction,deleteAction])
        }
        return configuration
    }
    
}
