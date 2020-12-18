//
//  SmenaViewModel.swift
//  TaxiNotes
//
//  Created by Денис Винокуров on 20.11.2019.
//  Copyright © 2019 Денис Винокуров. All rights reserved.
//

import UIKit
import RealmSwift

var smenaViewController = SmenaViewController()

class SmenaViewModel: SmenaViewModeType {
    
    //MARK: Private properties:
    private var arrayZakaz = realm.objects(Zakaz.self)
    private var filteredArraySmena = realm.objects(Smena.self).filter("endDateSmena == nil and idAccount == %@",Variables.sharedVariables.idAccount)
    private var settingsArray = realm.objects(Settings.self).filter("idAccount == %@",Variables.sharedVariables.idAccount)
    
    //MARK: View controller func:
    //Начало и окончание смены
    func startStopSmena() {
        DispatchQueue.global(qos: .userInteractive).sync {
            if !Variables.sharedVariables.startedSmena {
                let smena = Smena()
                smena.idAccount = Variables.sharedVariables.idAccount
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
                smena.startDateSmena = dateFormatter.date(from: dateFormatter.string(from: Date()))!
                smena.endDateSmena = nil
                StorageManager.saveSmena(smena)
            } else {
                self.filteredArraySmena = realm.objects(Smena.self).filter("endDateSmena == nil and idAccount == %@",Variables.sharedVariables.idAccount)
                
                if self.filteredArraySmena.count > 0 {
                    let smena = Smena()
                    smena.idAccount = Variables.sharedVariables.idAccount
                    smena.startDateSmena = self.filteredArraySmena.first!.startDateSmena
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
                    smena.endDateSmena = dateFormatter.date(from: dateFormatter.string(from: Date()))!
                    smena.id = self.filteredArraySmena.first!.id
                    StorageManager.saveSmena(smena)
                }
            }
        }
    }
    
    func wheel(summa: Double) {
        DispatchQueue.global(qos: .userInteractive).sync {
            self.filteredArraySmena = realm.objects(Smena.self).filter("endDateSmena == nil and idAccount == %@",Variables.sharedVariables.idAccount)
            if self.filteredArraySmena.count > 0 {
                let zakaz = Zakaz()
                zakaz.dateZakaz = Date()
                zakaz.clearDateZakaz = Variables.sharedVariables.reomveTimeFrom(date: Date())
                zakaz.idAccount = Variables.sharedVariables.idAccount
                zakaz.idSmena = self.filteredArraySmena.first!.id
                zakaz.summaZakaz = summa
                zakaz.typeZakaz = 3
                
                StorageManager.saveZakaz(zakaz)
            }
        }
    }
    
    func percentZakaz(summa: Double) {
        DispatchQueue.global(qos: .userInteractive).sync {
            settingsArray = realm.objects(Settings.self).filter("idAccount == %@",Variables.sharedVariables.idAccount)
            filteredArraySmena = realm.objects(Smena.self).filter("endDateSmena == nil and idAccount == %@",Variables.sharedVariables.idAccount)
            if filteredArraySmena.count > 0 {
                
                let currentScore = Variables.sharedVariables.scoreAccount
                let settingsScore = settingsArray.first!.percentZakaz
                let itog = String(format: "%.2f", currentScore - (summa/100 * Double(settingsScore)))
                Variables.sharedVariables.scoreAccount = Double(itog)!
                
                let account = Accounts()
                account.nameAccount = Variables.sharedVariables.currentAccountName
                account.scoreAccount = Double(itog)!
                account.id = Variables.sharedVariables.idAccount
                StorageManager.saveAccount(account)
                
                //scoreAccountLabel.text = "На счету: \(Variables.sharedVariables.scoreAccount) ₽"
                
                let zakaz = Zakaz()
                zakaz.dateZakaz = Date()
                zakaz.clearDateZakaz = Variables.sharedVariables.reomveTimeFrom(date: Date())
                zakaz.idAccount = Variables.sharedVariables.idAccount
                zakaz.idSmena = filteredArraySmena.first!.id
                zakaz.summaZakaz = summa
                zakaz.typeZakaz = 2
                
                StorageManager.saveZakaz(zakaz)
            }
        }
    }
    
    func zakaz(summa: Double) {
        DispatchQueue.global(qos: .userInteractive).sync {
            settingsArray = realm.objects(Settings.self).filter("idAccount == %@",Variables.sharedVariables.idAccount)
            filteredArraySmena = realm.objects(Smena.self).filter("endDateSmena == nil and idAccount == %@",Variables.sharedVariables.idAccount)
            if filteredArraySmena.count > 0 {
                
                let currentScore = Variables.sharedVariables.scoreAccount
                let settingsScore = settingsArray.first!.summZakaz
                Variables.sharedVariables.scoreAccount = currentScore - settingsScore
                
                let account = Accounts()
                account.nameAccount = Variables.sharedVariables.currentAccountName
                account.scoreAccount = currentScore - settingsScore
                account.id = Variables.sharedVariables.idAccount
                StorageManager.saveAccount(account)
                
                let zakaz = Zakaz()
                zakaz.dateZakaz = Date()
                zakaz.clearDateZakaz = Variables.sharedVariables.reomveTimeFrom(date: Date())
                zakaz.idAccount = Variables.sharedVariables.idAccount
                zakaz.idSmena = filteredArraySmena.first!.id
                zakaz.summaZakaz = summa
                zakaz.typeZakaz = 1
                
                StorageManager.saveZakaz(zakaz)
            }
        }
    }
    
    func beznal(summa: Double) {
        DispatchQueue.global(qos: .userInteractive).sync {
            settingsArray = realm.objects(Settings.self).filter("idAccount == %@",Variables.sharedVariables.idAccount)
            filteredArraySmena = realm.objects(Smena.self).filter("endDateSmena == nil and idAccount == %@",Variables.sharedVariables.idAccount)
            if filteredArraySmena.count > 0 {
                
                if settingsArray.first!.beznalInDohod {
                    let zakaz = Zakaz()
                    zakaz.dateZakaz = Date()
                    zakaz.clearDateZakaz = Variables.sharedVariables.reomveTimeFrom(date: Date())
                    zakaz.idAccount = Variables.sharedVariables.idAccount
                    zakaz.idSmena = filteredArraySmena.first!.id
                    zakaz.summaZakaz = summa
                    zakaz.typeZakaz = 0
                    
                    StorageManager.saveZakaz(zakaz)
                }
                
                let currentScore = Variables.sharedVariables.scoreAccount
                let settingsScore = settingsArray.first!.summZakaz
                let account = Accounts()
                account.nameAccount = Variables.sharedVariables.currentAccountName
                account.scoreAccount = currentScore + summa - settingsScore
                account.id = Variables.sharedVariables.idAccount
                StorageManager.saveAccount(account)
                Variables.sharedVariables.scoreAccount = currentScore + summa - settingsScore
            }
        }
    }
    
    func alertAddScoreAccount(completion: @escaping () -> ()) -> UIAlertController {
        //Показать алерт добавления новой учетной записи
        let alert = UIAlertController(title: "Пополнение балланса", message: nil, preferredStyle: .alert)
        
        //Настройка строки для ввода наименования учетной записи
        alert.addTextField(configurationHandler: { textField1 in
            textField1.placeholder = "Сумма пополнения"
            textField1.textAlignment = .center
            textField1.keyboardType = .decimalPad
            textField1.clearButtonMode = .whileEditing
            textField1.autocapitalizationType = .sentences
            textField1.font = UIFont.boldSystemFont(ofSize: 17.0)
        })
        
        //Обработчик кнопки добавления записи
        alert.addAction(UIAlertAction(title: "Пополнить", style: .default, handler: { action in
            
            //Если первое поле ввода (Наименование учетной записи) не пустое
            if !(alert.textFields?[0].text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! {
                DispatchQueue.global(qos: .userInteractive).sync {
                    let currentScore = Variables.sharedVariables.scoreAccount
                    let score: Double = Double((alert.textFields![0].text!).replacingOccurrences(of: ",", with: ".")) ?? 0.0
                    let account = Accounts()
                    account.nameAccount = Variables.sharedVariables.currentAccountName
                    account.scoreAccount = currentScore + score
                    account.id = Variables.sharedVariables.idAccount
                    StorageManager.saveAccount(account)
                    Variables.sharedVariables.scoreAccount = currentScore + score
                    
                    let rashod = Rashod()
                    rashod.idAccount = Variables.sharedVariables.idAccount
                    rashod.summRashod = score
                    rashod.nameRashod = "Пополнение счета"
                    StorageManager.saveRashod(rashod)
                    completion()
                }
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .destructive, handler: nil))
        
        return alert
    }
    
    func addInformationAlert(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ок", style: UIAlertAction.Style.cancel, handler: nil))
        
        return alert
    }
    
    func getIdSmena() -> String {
        //Запрос на поиск id открытой смены
        filteredArraySmena = realm.objects(Smena.self).filter("endDateSmena == nil and idAccount == %@",Variables.sharedVariables.idAccount)
        guard let idSmena = filteredArraySmena.first?.id else { return "" }
        return idSmena
        
    }
    
    func getTotalSummCount() -> (summ:Double, count:Int){
        //Запрос на получение общей суммы
        arrayZakaz = realm.objects(Zakaz.self).filter("idSmena == %@",getIdSmena())
        let totalSumm: Double = arrayZakaz.sum(ofProperty: "summaZakaz")
        let totalCount = arrayZakaz.count
        return (totalSumm, totalCount)
    }
    
    func getWheelSummCount() -> (summ:Double, count:Int){
        //Запрос на получение суммы с колёс
        arrayZakaz = realm.objects(Zakaz.self).filter("idSmena == %@ and typeZakaz == %@",getIdSmena(),3)
        let wheelSumm: Double = arrayZakaz.sum(ofProperty: "summaZakaz")
        let wheelCount = arrayZakaz.count
    
        return (wheelSumm, wheelCount)
    }
    
    func getZakazSummCount() -> (summ:Double, count:Int){
        //Запрос на получение суммы с заказов
        arrayZakaz = realm.objects(Zakaz.self).filter("idSmena == %@ and (typeZakaz == %@ or typeZakaz == %@)",getIdSmena(),2,1)
        let zakazSumma: Double = arrayZakaz.sum(ofProperty: "summaZakaz")
        let zakazCount = arrayZakaz.count
        
        return (zakazSumma, zakazCount)
    }
    
    func getBeznalSummCount() -> (summ:Double, count:Int){
        //Запрос на получение суммы с заказа с безнала
        arrayZakaz = realm.objects(Zakaz.self).filter("idSmena == %@ and typeZakaz == %@",getIdSmena(),0)
        let beznalSumm: Double = arrayZakaz.sum(ofProperty: "summaZakaz")
        let beznalCount = arrayZakaz.count
        
        return (beznalSumm, beznalCount)
    }
    
    func getFilteredArraySmena() -> Results<Smena>! {
        return filteredArraySmena
    }
    
    func getSettingsArray() -> Results<Settings>! {
        return settingsArray
    }
    
    
}
