//
//  RashodViewModel.swift
//  TaxiNotes
//
//  Created by Денис Винокуров on 20.11.2019.
//  Copyright © 2019 Денис Винокуров. All rights reserved.
//

import UIKit
import RealmSwift

var rashodVC: RashodViewController?

class RashodViewModel: RashodViewModelType {
    
    private var selectedIndexPath: IndexPath?
    var pickOption = ["Бензин", "Дизель", "Газ"]
    
    private var globalAlert = UIAlertController()
    
    var rashodVC = RashodViewController()
    
    var arrayRashod = realm.objects(Rashod.self).filter("idAccount == %@",Variables.sharedVariables.idAccount).sorted(byKeyPath: "dateRashod")
    
    func alertAddRashod(editMode: Bool, indexPath: IndexPath?, nameRashod: String?, datePicker: UIDatePicker, pickerView: UIPickerView, complection: @escaping (Int) -> ()) -> UIAlertController {
        
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
                textField1.text = self.arrayRashod[indexPath!.row].nameRashod
            } else if nameRashod != nil{
                textField1.inputView = pickerView
                pickerView.selectRow(0, inComponent: 0, animated: true)
                textField1.text = self.pickOption[pickerView.selectedRow(inComponent: 0)]
                self.globalAlert = alert
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
                textField2.text = String(self.arrayRashod[indexPath!.row].summRashod)
            }
            if nameRashod != nil{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.03) {
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
                textField3.inputView = datePicker
                textField3.clearButtonMode = .whileEditing
                if indexPath != nil {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
                    textField3.text = dateFormatter.string(from: self.arrayRashod[indexPath!.row].dateRashod)
                    datePicker.setDate(self.arrayRashod[indexPath!.row].dateRashod, animated: true)
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
                    rashod.id = self.arrayRashod[(indexPath?.row)!].id
                    if !(alert.textFields?[2].text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! {
                        rashod.dateRashod = datePicker.date
                        rashod.clearDateRashod = Variables.sharedVariables.reomveTimeFrom(date: datePicker.date)
                    } else {
                        rashod.dateRashod = self.arrayRashod[(indexPath?.row)!].dateRashod
                        rashod.clearDateRashod = Variables.sharedVariables.reomveTimeFrom(date: self.arrayRashod[(indexPath?.row)!].dateRashod)
                    }
                }
                StorageManager.saveRashod(rashod)
                complection(0)                
            } else {
                complection(1)
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .destructive, handler: nil))
        self.globalAlert = alert
        
        return alert
        
    }
    
    func addInformationAlert(title: String, message: String, complection: @escaping () -> ()) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ок", style: UIAlertAction.Style.cancel, handler: {action in
            complection()
        }))
        return alert
    }
    
    func addDeleteRashodAlert(indexPath: IndexPath, complection: @escaping () -> ()) -> UIAlertController {
        arrayRashod = realm.objects(Rashod.self).filter("idAccount == %@",Variables.sharedVariables.idAccount).sorted(byKeyPath: "dateRashod")
        let alert = UIAlertController(title: "Подтверждение удаления", message: "Вы действительно хотите удалить запись '\(arrayRashod[indexPath.row].nameRashod)'?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: {action in
            StorageManager.deleteRashod(id: self.arrayRashod[indexPath.row].id)
            complection()
        }))
        
        return alert
    }
    
    func cloneRashod(indexPath: IndexPath, complection: @escaping () -> ()) {
        arrayRashod = realm.objects(Rashod.self).filter("idAccount == %@",Variables.sharedVariables.idAccount).sorted(byKeyPath: "dateRashod")
        let rashod = Rashod()
        rashod.nameRashod = arrayRashod[indexPath.row].nameRashod
        rashod.summRashod = arrayRashod[indexPath.row].summRashod
        rashod.idAccount = arrayRashod[indexPath.row].idAccount
        rashod.dateRashod = arrayRashod[indexPath.row].dateRashod
        rashod.clearDateRashod = Variables.sharedVariables.reomveTimeFrom(date: arrayRashod[indexPath.row].dateRashod)
        StorageManager.saveRashod(rashod)
        complection()
    }
    
    func numberOfRows() -> Int {
        arrayRashod = realm.objects(Rashod.self).filter("idAccount == %@",Variables.sharedVariables.idAccount).sorted(byKeyPath: "dateRashod")
        return arrayRashod.count
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> RashodViewCellViewModelType? {
        arrayRashod = realm.objects(Rashod.self).filter("idAccount == %@",Variables.sharedVariables.idAccount).sorted(byKeyPath: "dateRashod")
        var rashod = Rashod()
        rashod = arrayRashod[indexPath.row]
        return RashodCellViewModel(rashod: rashod)
    }
    
    func selectRow(atIndexPath indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
    }
    
    func getCountRashod() -> Int {
        arrayRashod = realm.objects(Rashod.self).filter("idAccount == %@",Variables.sharedVariables.idAccount).sorted(byKeyPath: "dateRashod")
        return arrayRashod.count
    }
    
    func getAlert() -> UIAlertController {
        return globalAlert
    }
    
    func getPickOption(row: Int) -> String {
        return pickOption[row]
    }
    
    func getPickOptionCount() -> Int {
        return pickOption.count
    }
    
    //Функция получения IndexPath выбранной ячейки
    func getIndexPathSelectedRow() -> IndexPath {
        return self.selectedIndexPath!
    }
    
}
