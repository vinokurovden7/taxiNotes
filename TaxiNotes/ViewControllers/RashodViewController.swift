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
private var globalAlert: UIAlertController?

class RashodViewController: UIViewController {

    @IBOutlet weak var addRashodBtnItem: UIBarButtonItem!
    @IBOutlet weak var logoutBtn: UIBarButtonItem!
    @IBOutlet weak var addFuelRashodBtnItem: UIBarButtonItem!
    @IBOutlet weak var myTableViewRashod: UITableView!
    
    var datePicker:UIDatePicker = UIDatePicker()
    var pickerView = UIPickerView()
    private var arrayBarButtons: [UIBarButtonItem] = []
    var pickOption = ["Бензин", "Дизель", "Газ"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrayBarButtons.append(addRashodBtnItem)
        arrayBarButtons.append(logoutBtn)
        arrayBarButtons.append(addFuelRashodBtnItem)
        Variables.sharedVariables.changeThemeViewController(viewController: self, arrayBarButtons: arrayBarButtons)
        //Настройка компонента DatePicker
        datePicker.datePickerMode = .dateAndTime
        datePicker.addTarget(self, action: #selector(RashodViewController.dateChanged(datePicker:)), for: .valueChanged)
        //Настройка компонента Picker
        pickerView.delegate = self
        
        arrayRashod = realm.objects(Rashod.self).filter("idAccount == %@",Variables.sharedVariables.idAccount).sorted(byKeyPath: "dateRashod")
        navigationItem.title = Variables.sharedVariables.currentAccountName
        
    }
    
    //Изменение темы
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        Variables.sharedVariables.changeThemeViewController(viewController: self, arrayBarButtons: arrayBarButtons)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.myTableViewRashod.reloadData()
    }

    //Обрабочик кнопки добавления расхода
    @IBAction func addRashodBtnAction(_ sender: UIBarButtonItem) {
        alertAddRashod(editMode: false, indexPath: nil, nameRashod: nil)
    }
    
    //Диалогове окно добавления расхода
    func alertAddRashod(editMode: Bool, indexPath: IndexPath?, nameRashod: String?){
        //Показать алерт добавления новой учетной записи
        let alertTitle = editMode == false ? "Добавление записи" : "Редактирование записи"
        let alert = UIAlertController(title: alertTitle, message: nil, preferredStyle: .alert)
        //Настройка строки для ввода наименования расхода
        alert.addTextField(configurationHandler: { textField1 in
            textField1.clearButtonMode = .whileEditing
            textField1.autocapitalizationType = .sentences
            textField1.keyboardType = .default
            textField1.placeholder = "Название расхода"
            textField1.textAlignment = .center
            textField1.borderStyle = UITextField.BorderStyle.roundedRect
            if indexPath != nil {
                textField1.text = arrayRashod[indexPath!.row].nameRashod
            } else if nameRashod != nil{
                textField1.inputView = self.pickerView
                self.pickerView.selectRow(0, inComponent: 0, animated: true)
                textField1.text = self.pickOption[self.pickerView.selectedRow(inComponent: 0)]
                globalAlert = alert
            }
            textField1.font = UIFont.boldSystemFont(ofSize: 17.0)
        })
        
        //Настройка строки для ввода суммы расхода
        alert.addTextField(configurationHandler: { textField2 in
            textField2.placeholder = "Сумма"
            textField2.textAlignment = .center
            textField2.borderStyle = UITextField.BorderStyle.roundedRect
            textField2.keyboardType = .decimalPad
            textField2.clearButtonMode = .whileEditing
            if indexPath != nil {
                textField2.text = String(arrayRashod[indexPath!.row].summRashod)
            }
            if nameRashod != nil{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    textField2.becomeFirstResponder()
                }
            }
            textField2.font = UIFont.boldSystemFont(ofSize: 17.0)
        })
        
        if editMode {
            //Настройка строки для редактирования даты записи расхода
            alert.addTextField(configurationHandler: { textField3 in
                textField3.placeholder = "Дата"
                textField3.textAlignment = .center
                textField3.borderStyle = UITextField.BorderStyle.roundedRect
                textField3.font = UIFont.boldSystemFont(ofSize: 17.0)
                textField3.inputView = self.datePicker
                textField3.clearButtonMode = .whileEditing
                if indexPath != nil {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd.MM.yyyy hh:mm"
                    textField3.text = dateFormatter.string(from: arrayRashod[indexPath!.row].dateRashod)
                    self.datePicker.setDate(arrayRashod[indexPath!.row].dateRashod, animated: true)
                }
            })
        }
        
        //Обработчик кнопки добавления записи
        let buttonTitle = editMode == false ? "Добавить запись" : "Сохранить изменения"
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: { action in
            
            //Если первое поле ввода (Наименование учетной записи) не пустое
            let score: String = ((alert.textFields?[1].text!)?.replacingOccurrences(of: ",", with: "."))!
            if !(alert.textFields?[0].text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! {
                
                let rashod = Rashod()
                rashod.nameRashod = (alert.textFields?[0].text)!
                rashod.summRashod = Double(score) ?? 0.0
                rashod.idAccount = Variables.sharedVariables.idAccount
                if editMode {
                    rashod.id = arrayRashod[(indexPath?.row)!].id
                    if !(alert.textFields?[2].text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! {
                        rashod.dateRashod = self.datePicker.date
                        rashod.clearDateRashod = Variables.sharedVariables.reomveTimeFrom(date: self.datePicker.date)
                    } else {
                        rashod.dateRashod = arrayRashod[(indexPath?.row)!].dateRashod
                        rashod.clearDateRashod = Variables.sharedVariables.reomveTimeFrom(date: arrayRashod[(indexPath?.row)!].dateRashod)
                    }
                }
                StorageManager.saveRashod(rashod)
                self.myTableViewRashod.reloadData()
                
            } else {
                self.addAlertOk(title: "Уведомление", message: "Заполните название расхода", isRemove: false, indexPath: indexPath, editMode: editMode)
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .destructive, handler: nil))
        globalAlert = alert
        self.present(alert, animated: true)
    }
    
    //Обработчик события изменения даты в DatePicker
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy hh:mm"
        //Если в режиме редактирования второе поле (конечная дата)
        if ((globalAlert?.textFields![2].isEditing)!){
            globalAlert?.textFields![2].text = dateFormatter.string(from: datePicker.date)
        }
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
                self.alertAddRashod(editMode: editMode ?? false, indexPath: indexPath, nameRashod: nil)
            }
            else {
                guard let indexPath = indexPath else {return}
                StorageManager.deleteRashod(id: arrayRashod[indexPath.row].id)
                self.myTableViewRashod.deleteRows(at: [indexPath], with: .middle)
            }
        }))
        
        self.present(editRadiusAlert, animated: true, completion: nil)
    }
  
    //Настройка свайпов по ячейке
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .none
        options.transitionStyle = .border
        return options
    }
    
    //Свайпы по ячейке
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        if orientation == .right {
        
            let editRashod = SwipeAction(style: .destructive, title: "Редатировать", handler: {(action, indexPath) -> Void in
                self.alertAddRashod(editMode: true, indexPath: indexPath, nameRashod: nil)
            })
            editRashod.hidesWhenSelected = true
            editRashod.backgroundColor = UIColor.init(red: 10/255, green: 91/255, blue: 255/255, alpha: 255/255)
            editRashod.image = UIImage(systemName: "square.and.pencil")
            editRashod.textColor = UIColor.white
            editRashod.font = UIFont.boldSystemFont(ofSize: 10.0)

            let deleteRashod = SwipeAction(style: .destructive, title: "Удалить", handler: {(action, indexPath) -> Void in
                self.addAlertOk(title: "Подтверждение удаления", message: "Вы действительно хотите удалить запись '\(arrayRashod[indexPath.row].nameRashod)'?", isRemove: true, indexPath: indexPath, editMode: false)
            })
            deleteRashod.hidesWhenSelected = true
            deleteRashod.backgroundColor = UIColor.init(red: 252/255, green: 30/255, blue: 28/255, alpha: 255/255)
            deleteRashod.textColor = UIColor.white
            deleteRashod.font = UIFont.boldSystemFont(ofSize: 10.0)
            deleteRashod.image = UIImage(systemName: "trash")
            
            return [deleteRashod, editRashod]
        } else {
            let cloneRashod = SwipeAction(style: .destructive, title: "Создать копию", handler: {(action, indexPath) -> Void in
                let rashod = Rashod()
                rashod.nameRashod = arrayRashod[indexPath.row].nameRashod
                rashod.summRashod = arrayRashod[indexPath.row].summRashod
                rashod.idAccount = arrayRashod[indexPath.row].idAccount
                rashod.dateRashod = arrayRashod[indexPath.row].dateRashod
                rashod.clearDateRashod = Variables.sharedVariables.reomveTimeFrom(date: arrayRashod[indexPath.row].dateRashod)
                StorageManager.saveRashod(rashod)
                self.myTableViewRashod.reloadData()
            })
            cloneRashod.hidesWhenSelected = true
            cloneRashod.backgroundColor = UIColor.init(red: 71/255, green: 186/255, blue: 251/255, alpha: 255/255)
            cloneRashod.image = UIImage(systemName: "doc.on.doc")
            cloneRashod.textColor = UIColor.white
            cloneRashod.font = UIFont.boldSystemFont(ofSize: 10.0)
            
            return [cloneRashod]
        }
    }
    
    //Обработчик кнопки добавления расхода
    @IBAction func fuelAddRashod(_ sender: UIBarButtonItem) {
        alertAddRashod(editMode: false, indexPath: nil, nameRashod: "Топливо")
    }
    
    //Изменение значения picker
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if ((globalAlert?.textFields![0].isEditing)!){
            globalAlert?.textFields![0].text = pickOption[row]
        }
    }
    
}

extension RashodViewController: UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickOption.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickOption[row]
    }
    
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
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
       let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { actions -> UIMenu? in
            
            let deleteAction = UIAction(title: "Удалить", image: UIImage(systemName: "trash"), identifier: nil, attributes: .destructive) { action in
               self.addAlertOk(title: "Подтверждение удаления", message: "Вы действительно хотите удалить запись '\(arrayRashod[indexPath.row].nameRashod)'?", isRemove: true, indexPath: indexPath, editMode: false)
            }
            
            let editAction = UIAction(title: "Редактировать", image: UIImage(systemName: "square.and.pencil"), identifier: nil) { action in
                self.alertAddRashod(editMode: true, indexPath: indexPath, nameRashod: nil)
            }
        
            let cloneRashod = UIAction(title: "Создать копию", image: UIImage(systemName: "doc.on.doc"), identifier: nil) { action in
                let rashod = Rashod()
                rashod.nameRashod = arrayRashod[indexPath.row].nameRashod
                rashod.summRashod = arrayRashod[indexPath.row].summRashod
                rashod.idAccount = arrayRashod[indexPath.row].idAccount
                rashod.dateRashod = arrayRashod[indexPath.row].dateRashod
                rashod.clearDateRashod = Variables.sharedVariables.reomveTimeFrom(date: arrayRashod[indexPath.row].dateRashod)
                StorageManager.saveRashod(rashod)
                self.myTableViewRashod.reloadData()
            }
        
            let moreActions = UIMenu(__title: "Еще...", image: UIImage(systemName: "ellipsis"), identifier: nil, children:[cloneRashod])
            return UIMenu(__title: "", image: nil, identifier: nil, children:[editAction,deleteAction, moreActions])
        }
        return configuration
    }
    
}
