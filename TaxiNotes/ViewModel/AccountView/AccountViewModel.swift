//
//  AccountViewModel.swift
//  TaxiNotes
//
//  Created by Денис Винокуров on 20.11.2019.
//  Copyright © 2019 Денис Винокуров. All rights reserved.
//

import Foundation
import RealmSwift

var accountViewController = AccountCollectionController()

class AccountViewModel: AccountCollectionViewViewModelType {
     
    private var accountArray: Results<Accounts>!
    private var filteredArray: Results<Accounts>!
    private var arraySmena: Results<Smena>!
    private var openArraySmena: Results<Smena>!
    private var selectedIndexPath: IndexPath?
    
    //Функция получения количества строк
    func numberOfRows() -> Int {
        //let realm = try! Realm()
        accountArray = realm.objects(Accounts.self).sorted(byKeyPath: "nameAccount")
        return accountArray?.count ?? 0
    }
    
    //Функция получения ячейки
    func cellViewModel(forIndexPath indexPath: IndexPath) -> AccountCollectionViewCellViewModelType? {
        var account = Accounts()
        account = accountArray[indexPath.row]
        return AccountCollectionViewCellViewModel(account: account)
    }
    
    //Функция получения IndexPath выбранной ячейки
    func selectRow(atIndexPath indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
    }
    
    //Функция получения IndexPath выбранной ячейки
    func getIndexPathSelectedRow() -> IndexPath {
        return self.selectedIndexPath!
    }
    
    //Функция получения количества записей
    func getCountAccount() -> Int {
        accountArray = realm.objects(Accounts.self).sorted(byKeyPath: "nameAccount")
        return accountArray?.count ?? 0
    }
    
    func closeAllOpenSmena() {
        openArraySmena = realm.objects(Smena.self).filter("endDateSmena == nil")
        while 0 < openArraySmena.count {
            let smena = Smena()
            smena.idAccount = openArraySmena[0].idAccount
            smena.startDateSmena = openArraySmena[0].startDateSmena
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
            smena.endDateSmena = dateFormatter.date(from: dateFormatter.string(from: Date()))!
            smena.id = openArraySmena[0].id
            StorageManager.saveSmena(smena)
        }
    }
    
    func addAlertAccount(editMode: Bool, indexPath: IndexPath?, completion: @escaping (Int) -> ()) -> UIAlertController {
        accountArray = realm.objects(Accounts.self).sorted(byKeyPath: "nameAccount")
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
                textField1.text = self.accountArray[indexPath!.row].nameAccount
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
                textField2.text = String(self.accountArray[indexPath!.row].scoreAccount)
            }
            textField2.font = UIFont.boldSystemFont(ofSize: 17.0)
        })
        
        //Обработчик кнопки добавления записи
        let buttonTitle = editMode == false ? "Добавить учетную запись" : "Сохранить изменения"
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: { action in
            
            //Если первое поле ввода (Наименование учетной записи) не пустое
            let score: String = ((alert.textFields?[1].text!)?.replacingOccurrences(of: ",", with: "."))!
            
            if !(alert.textFields?[0].text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! {
                self.filteredArray = self.accountArray.filter("nameAccount ==[c] %@",alert.textFields?[0].text ?? "")
                if self.filteredArray.count > 0 && !editMode {
                    completion(0)
                } else {
                    let account = Accounts()
                    account.nameAccount = (alert.textFields?[0].text)!
                    account.scoreAccount = Double(score) ?? 0.0
                    if editMode { account.id = self.accountArray[(indexPath?.row)!].id}
                    StorageManager.saveAccount(account)
                    
                    
                    let settings = Settings()
                    self.filteredArray = self.accountArray.filter("nameAccount ==[c] %@",alert.textFields?[0].text ?? "")
                    settings.idAccount = self.filteredArray.first!.id
                    StorageManager.saveSettings(settings)
                    completion(1)
                }
            } else if (alert.textFields?[0].text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! && indexPath == nil {
                completion(3)
            }
            else {
                completion(2)
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .destructive, handler: nil))
        
        return alert
    }
    
    func addDeleteAccountAlert(indexPath: IndexPath, completion: @escaping () -> ()) -> UIAlertController {
        accountArray = realm.objects(Accounts.self).sorted(byKeyPath: "nameAccount")
        let alert = UIAlertController(title: "Подтверждение удаления", message: "Вы действительно хотите удалить учетную запись '\(accountArray[indexPath.row].nameAccount)'?", preferredStyle: UIAlertController.Style.alert)
        var firstBtnTitle = "Ок"
        var styleFirstBtn: UIAlertAction.Style = .cancel
        alert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))
        firstBtnTitle = "Удалить"
        styleFirstBtn = .destructive
        alert.addAction(UIAlertAction(title: firstBtnTitle, style: styleFirstBtn, handler: {action in
            StorageManager.removeAccount(id: self.accountArray[indexPath.row].id)
            completion()
        }))
        
        return alert
    }
    
}
