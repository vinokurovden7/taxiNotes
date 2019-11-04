//
//  RashodViewController.swift
//  TaxiNotes
//
//  Created by Денис Винокуров on 03.11.2019.
//  Copyright © 2019 Денис Винокуров. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

private var arrayRashod: Results<Rashod>!

class RashodViewController: UIViewController {

    @IBOutlet weak var myTableViewRashod: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        arrayRashod = realm.objects(Rashod.self).filter("idAccount == %@",Variables.sharedVariables.idAccount).sorted(byKeyPath: "dateRashod")
        navigationItem.title = Variables.sharedVariables.currentAccountName
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.myTableViewRashod.reloadData()

    }

    @IBAction func addRashodBtnAction(_ sender: UIBarButtonItem) {
        alertAddRashod(editMode: false, indexPath: nil)
    }
    
    //Диалогове окно добавления расхода
    func alertAddRashod(editMode: Bool, indexPath: IndexPath?){
        //Показать алерт добавления новой учетной записи
        let alertTitle = editMode == false ? "Добавление записи" : "Редактирование записи"
        let alert = UIAlertController(title: alertTitle, message: nil, preferredStyle: .alert)
        
        //Настройка строки для ввода наименования учетной записи
        alert.addTextField(configurationHandler: { textField1 in
            textField1.placeholder = "Название расхода"
            textField1.textAlignment = .center
            textField1.keyboardType = .default
            textField1.clearButtonMode = .whileEditing
            textField1.autocapitalizationType = .sentences
            if indexPath != nil{
              textField1.text = arrayRashod[indexPath!.row].nameRashod
            }
            textField1.font = UIFont.boldSystemFont(ofSize: 17.0)
        })
        
        //Настройка строки для ввода счета учетной записи
        alert.addTextField(configurationHandler: { textField2 in
            textField2.placeholder = "Сумма"
            textField2.textAlignment = .center
            textField2.keyboardType = .numberPad
            textField2.clearButtonMode = .whileEditing
            if indexPath != nil {
                textField2.text = String(arrayRashod[indexPath!.row].summRashod)
            }
            textField2.font = UIFont.boldSystemFont(ofSize: 17.0)
        })
        
        //Обработчик кнопки добавления записи
        let buttonTitle = editMode == false ? "Добавить запись" : "Сохранить изменения"
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: { action in
            
            //Если первое поле ввода (Наименование учетной записи) не пустое
            let score: String = (alert.textFields?[1].text!)!
            if !(alert.textFields?[0].text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! ||  !(alert.textFields?[1].text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)!{
                
                let rashod = Rashod()
                rashod.nameRashod = (alert.textFields?[0].text)!
                rashod.summRashod = Double(score) ?? 0.0
                rashod.idAccount = Variables.sharedVariables.idAccount
                if editMode { rashod.id = arrayRashod[(indexPath?.row)!].id}
                StorageManager.saveRashod(rashod)
                self.myTableViewRashod.reloadData()
                
            } else {
                self.addAlertOk(title: "Уведомление", message: "Заполните название расхода", isRemove: false, indexPath: indexPath, editMode: editMode)
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
                self.alertAddRashod(editMode: editMode ?? false, indexPath: indexPath)
            }
            else {
                guard let indexPath = indexPath else {return}
                StorageManager.deleteRashod(id: arrayRashod[indexPath.row].id)
                self.myTableViewRashod.deleteRows(at: [indexPath], with: .middle)
            }
        }))
        
        self.present(editRadiusAlert, animated: true, completion: nil)
    }
  
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .none
        options.transitionStyle = .border
        return options
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        if orientation == .right {
        
            let seeDogAction = SwipeAction(style: .destructive, title: "Редатировать", handler: {(action, indexPath) -> Void in
                
            })
            seeDogAction.hidesWhenSelected = true
            seeDogAction.backgroundColor = UIColor.init(red: 10/255, green: 91/255, blue: 255/255, alpha: 255/255)
            seeDogAction.image = UIImage(systemName: "square.and.pencil")
            seeDogAction.textColor = UIColor.white
            seeDogAction.font = UIFont.boldSystemFont(ofSize: 10.0)

            let goPlanAction = SwipeAction(style: .destructive, title: "Удалить", handler: {(action, indexPath) -> Void in
                
            })
            goPlanAction.hidesWhenSelected = true
            goPlanAction.backgroundColor = UIColor.init(red: 252/255, green: 30/255, blue: 28/255, alpha: 255/255)
            goPlanAction.textColor = UIColor.white
            goPlanAction.font = UIFont.boldSystemFont(ofSize: 10.0)
            goPlanAction.image = UIImage(systemName: "trash")
            
            return [goPlanAction, seeDogAction]
        } else {
            return nil
        }
    }
}

extension RashodViewController: UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayRashod.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rashodCell") as! RashodViewCell
        
        cell.delegate = self
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy hh:mm"
        
        cell.dateRashodLabel.text = dateFormatter.string(from: arrayRashod[indexPath.row].dateRashod)
        cell.nameRashodLabel.text = arrayRashod[indexPath.row].nameRashod
        cell.summRashodLabel.text = "\(arrayRashod[indexPath.row].summRashod) ₽"
        
        return cell
    }
    
    
}
