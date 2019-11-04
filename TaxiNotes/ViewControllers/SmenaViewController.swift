//
//  SmenaViewController.swift
//  TaxiNotes
//
//  Created by Денис Винокуров on 02.11.2019.
//  Copyright © 2019 Денис Винокуров. All rights reserved.
//

import UIKit
import RealmSwift

private var arraySmena: Results<Smena>!
private var filteredArraySmena: Results<Smena>!
private var arrayZakaz: Results<Zakaz>!
private var filteredArrayZakaz: Results<Zakaz>!
private var settingsArray: Results<Settings>!

class SmenaViewController: UIViewController {

    private var arrayBarButtons: [UIBarButtonItem] = []
    
    //Buttons
    @IBOutlet weak var startStopSmenaBtn: UIBarButtonItem!
    @IBOutlet weak var logountBtn: UIBarButtonItem!
    @IBOutlet weak var beznalBtn: UIButton!
    @IBOutlet weak var zakazBtn: UIButton!
    @IBOutlet weak var percentBtn: UIButton!
    @IBOutlet weak var wheelBtn: UIButton!
    
    //TextFields
    @IBOutlet weak var summaTextField: UITextField!
    
    //Labels
    @IBOutlet weak var totalZakazLabel: UILabel!
    @IBOutlet weak var totalZakazSumm: UILabel!
    @IBOutlet weak var wheelZakazLabel: UILabel!
    @IBOutlet weak var wheelZakazSumm: UILabel!
    @IBOutlet weak var zakazLabel: UILabel!
    @IBOutlet weak var zakazSumm: UILabel!
    @IBOutlet weak var beznalZakazLabel: UILabel!
    @IBOutlet weak var beznalZakazSumm: UILabel!
    @IBOutlet weak var scoreAccountLabel: UILabel!
    @IBOutlet weak var smenaPeriodLabel: UILabel!
    @IBOutlet weak var beznalLabel: UILabel!
    @IBOutlet weak var captionBtnZakaz: UILabel!
    @IBOutlet weak var percentZakazLabel: UILabel!
    @IBOutlet weak var wheelLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrayBarButtons.append(startStopSmenaBtn)
        arrayBarButtons.append(logountBtn)
        Variables.sharedVariables.changeThemeViewController(viewController: self, arrayBarButtons: arrayBarButtons)
        arraySmena = realm.objects(Smena.self)
        arrayZakaz = realm.objects(Zakaz.self)
        scoreAccountLabel.text = "На счету: \(Variables.sharedVariables.scoreAccount) ₽"
        
        navigationItem.title = Variables.sharedVariables.currentAccountName
        
        filteredArraySmena = arraySmena.filter("endDateSmena == nil and idAccount == %@",Variables.sharedVariables.idAccount)
        settingsArray = realm.objects(Settings.self).filter("idAccount == %@",Variables.sharedVariables.idAccount)
        
        showHideButtons()
        
        //Проверка на наличие незаконченной смены
        if filteredArraySmena.count > 0 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            smenaPeriodLabel.text = "Смена \(dateFormatter.string(from:filteredArraySmena.first!.startDateSmena)) -"
            startStopSmenaBtn.image = UIImage(systemName: "stop.fill")
            Variables.sharedVariables.startedSmena = true
            updateStatistic()
        } else {
           Variables.sharedVariables.startedSmena = false
           startStopSmenaBtn.image = UIImage(systemName: "play.fill")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showHideButtons()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        Variables.sharedVariables.changeThemeViewController(viewController: self, arrayBarButtons: arrayBarButtons)
    }

    //Кнопка поездки с колес
    @IBAction func wheelBtnAction(_ sender: UIButton) {
        if (summaTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count)! > 0 {
            wheel(summa: Double(summaTextField.text ?? "0")!)
        }
    }
    //Кнопка поездки по-заказу с процентом
    @IBAction func percentBtnAction(_ sender: UIButton) {
        if (summaTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count)! > 0 {
            percentZakaz(summa: Double(summaTextField.text ?? "0")!)
        }
    }
    //Кнопка поездки по-заказу без процента
    @IBAction func zakazBtnAction(_ sender: UIButton) {
        if (summaTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count)! > 0 {
            zakaz(summa: Double(summaTextField.text ?? "0")!)
        }
    }
    //Кнопка поездки по-безналу
    @IBAction func beznalBtnAction(_ sender: UIButton) {
        if (summaTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count)! > 0 {
            beznal(summa: Double(summaTextField.text ?? "0")!)
        }
    }
    //Кнопка пополнения счета
    @IBAction func addMoneyScoreBtnAction(_ sender: UIButton) {
        alertAddScoreAccount()
    }
    //Кнопка начала и окончания смены
    @IBAction func startStopSmenaBtnAction(_ sender: UIBarButtonItem) {
        if !Variables.sharedVariables.startedSmena {
            startStopSmenaBtn.image = UIImage(systemName: "stop.fill")
            let smena = Smena()
            smena.idAccount = Variables.sharedVariables.idAccount
            smena.endDateSmena = nil
            StorageManager.saveSmena(smena)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            let todaysDate = dateFormatter.string(from: Date())
            smenaPeriodLabel.text = "Смена \(todaysDate) - "
            
            //Заполнение полей
            totalZakazLabel.text = "Итого (0):"
            totalZakazSumm.text = "0.0 ₽"
            
            wheelZakazLabel.text = "С колёс (0):"
            wheelZakazSumm.text = "0.0 ₽"
            
            zakazLabel.text = "С заказов (0):"
            zakazSumm.text = "0.0 ₽"
            
            beznalZakazLabel.text = "С безнала (0):"
            beznalZakazSumm.text = "0.0 ₽"
            
        } else {
            filteredArraySmena = arraySmena.filter("endDateSmena == nil and idAccount == %@",Variables.sharedVariables.idAccount)
            
            if filteredArraySmena.count > 0 {
                let smena = Smena()
                smena.idAccount = Variables.sharedVariables.idAccount
                smena.startDateSmena = filteredArraySmena.first!.startDateSmena
                smena.endDateSmena = Date()
                smena.id = filteredArraySmena.first!.id
                let idSmena = filteredArraySmena.first!.id
                StorageManager.saveSmena(smena)
                
                filteredArraySmena = arraySmena.filter("id == %@",idSmena)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd.MM.yyyy"
                smenaPeriodLabel.text = "Смена \(dateFormatter.string(from:filteredArraySmena.first!.startDateSmena)) - \(dateFormatter.string(from: filteredArraySmena.first!.endDateSmena!))"
            }
            startStopSmenaBtn.image = UIImage(systemName: "play.fill")
        }
        Variables.sharedVariables.startedSmena = !Variables.sharedVariables.startedSmena
    }
    
    func showHideButtons(){
        if settingsArray.first!.enabledButtonBeznal {
            beznalBtn.isHidden = false
            beznalLabel.isHidden = false
        } else {
            beznalBtn.isHidden = true
            beznalLabel.isHidden = true
        }
        
        if settingsArray.first!.enabledButtonWheel {
            wheelBtn.isHidden = false
            wheelLabel.isHidden = false
        } else {
            wheelBtn.isHidden = true
            wheelLabel.isHidden = true
        }
        
        if settingsArray.first!.enabledButtonZakaz {
            captionBtnZakaz.isHidden = false
            zakazBtn.isHidden = false
        } else {
            captionBtnZakaz.isHidden = true
            zakazBtn.isHidden = true
        }
        
        if settingsArray.first!.enabledButtonPercentZakaz {
            percentBtn.isHidden = false
            percentZakazLabel.isHidden = false
        } else {
            percentBtn.isHidden = true
            percentZakazLabel.isHidden = true
        }
    }
    
    //Функция поездки с колес
    private func wheel(summa: Double){
        summaTextField.text = ""
        self.view.endEditing(true)
        
        filteredArraySmena = arraySmena.filter("endDateSmena == nil and idAccount == %@",Variables.sharedVariables.idAccount)
        if filteredArraySmena.count > 0 {
            let zakaz = Zakaz()
            zakaz.dateZakaz = Date()
            zakaz.idAccount = Variables.sharedVariables.idAccount
            zakaz.idSmena = filteredArraySmena.first!.id
            zakaz.summaZakaz = summa
            zakaz.typeZakaz = 3
            
            StorageManager.saveZakaz(zakaz)
            updateStatistic()
        }
        
    }
    
    //Функция поездки по-заказу с процентом
    private func percentZakaz(summa: Double){
        summaTextField.text = ""
        self.view.endEditing(true)
        
        filteredArraySmena = arraySmena.filter("endDateSmena == nil and idAccount == %@",Variables.sharedVariables.idAccount)
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
            
            scoreAccountLabel.text = "На счету: \(Variables.sharedVariables.scoreAccount) ₽"
            
            let zakaz = Zakaz()
            zakaz.dateZakaz = Date()
            zakaz.idAccount = Variables.sharedVariables.idAccount
            zakaz.idSmena = filteredArraySmena.first!.id
            zakaz.summaZakaz = summa
            zakaz.typeZakaz = 2
            
            StorageManager.saveZakaz(zakaz)
            updateStatistic()
        }
        
    }
    //Функция поездки по-заказу без процента
    private func zakaz(summa: Double){
        summaTextField.text = ""
        self.view.endEditing(true)
        
        filteredArraySmena = arraySmena.filter("endDateSmena == nil and idAccount == %@",Variables.sharedVariables.idAccount)
        if filteredArraySmena.count > 0 {
            
            let currentScore = Variables.sharedVariables.scoreAccount
            let settingsScore = settingsArray.first!.summZakaz
            Variables.sharedVariables.scoreAccount = currentScore - settingsScore
            
            let account = Accounts()
            account.nameAccount = Variables.sharedVariables.currentAccountName
            account.scoreAccount = currentScore - settingsScore
            account.id = Variables.sharedVariables.idAccount
            StorageManager.saveAccount(account)
            
            scoreAccountLabel.text = "На счету: \(Variables.sharedVariables.scoreAccount) ₽"
            
            let zakaz = Zakaz()
            zakaz.dateZakaz = Date()
            zakaz.idAccount = Variables.sharedVariables.idAccount
            zakaz.idSmena = filteredArraySmena.first!.id
            zakaz.summaZakaz = summa
            zakaz.typeZakaz = 1
            
            StorageManager.saveZakaz(zakaz)
            
            updateStatistic()
        }
        
    }
    //Функция поездки по-безналу
    private func beznal(summa: Double){
        summaTextField.text = ""
        self.view.endEditing(true)
        
        filteredArraySmena = arraySmena.filter("endDateSmena == nil and idAccount == %@",Variables.sharedVariables.idAccount)
        if filteredArraySmena.count > 0 {
            let zakaz = Zakaz()
            zakaz.dateZakaz = Date()
            zakaz.idAccount = Variables.sharedVariables.idAccount
            zakaz.idSmena = filteredArraySmena.first!.id
            zakaz.summaZakaz = summa
            zakaz.typeZakaz = 0
            
            StorageManager.saveZakaz(zakaz)
            updateStatistic()
        }
    }
    
    //Функция пополнения счета
    func alertAddScoreAccount(){
        //Показать алерт добавления новой учетной записи
        let alert = UIAlertController(title: "Пополнение балланса", message: nil, preferredStyle: .alert)
        
        //Настройка строки для ввода наименования учетной записи
        alert.addTextField(configurationHandler: { textField1 in
            textField1.placeholder = "Сумма пополнения"
            textField1.textAlignment = .center
            textField1.keyboardType = .numberPad
            textField1.clearButtonMode = .whileEditing
            textField1.autocapitalizationType = .sentences
            textField1.font = UIFont.boldSystemFont(ofSize: 17.0)
        })
        
        //Обработчик кнопки добавления записи
        alert.addAction(UIAlertAction(title: "Пополнить", style: .default, handler: { action in
            
            //Если первое поле ввода (Наименование учетной записи) не пустое
            if !(alert.textFields?[0].text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! {
                let currentScore = Variables.sharedVariables.scoreAccount
                let score: Double = Double((alert.textFields![0].text!))!
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
                self.scoreAccountLabel.text = "На счету: \(Variables.sharedVariables.scoreAccount) ₽"
            } else {
              self.addInformationAlert(title: "Уведомление", message: "Укажите сумму пополнения")
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .destructive, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    //Создание уведомления
    func addInformationAlert(title: String, message: String){
        let editRadiusAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        editRadiusAlert.addAction(UIAlertAction(title: "Ок", style: UIAlertAction.Style.cancel, handler: {action in
            self.alertAddScoreAccount()
        }))
        self.present(editRadiusAlert, animated: true, completion: nil)
    }
    
    //Обновление статистики
    func updateStatistic(){
        //Запрос на поиск id открытой смены
        filteredArraySmena = arraySmena.filter("endDateSmena == nil and idAccount == %@",Variables.sharedVariables.idAccount)
        guard let idSmena = filteredArraySmena.first?.id else {return}
        
        //Запрос на получение общей суммы
        filteredArrayZakaz = arrayZakaz.filter("idSmena == %@",idSmena)
        guard let totalSumm: Double = filteredArrayZakaz?.sum(ofProperty: "summaZakaz") else {return}
        guard let totalCount = filteredArrayZakaz?.count else {return}
        
        //Запрос на получение суммы с колёс
        filteredArrayZakaz = arrayZakaz.filter("idSmena == %@ and typeZakaz == %@",idSmena,3)
        guard let wheelSumm: Double = filteredArrayZakaz?.sum(ofProperty: "summaZakaz") else {return}
        guard let wheelCount = filteredArrayZakaz?.count else {return}
        
        //Запрос на получение суммы с заказов
        filteredArrayZakaz = arrayZakaz.filter("idSmena == %@ and (typeZakaz == %@ or typeZakaz == %@)",idSmena,2,1)
        guard let zakazSumma: Double = filteredArrayZakaz?.sum(ofProperty: "summaZakaz") else {return}
        guard let zakazCount = filteredArrayZakaz?.count else {return}
        
        //Запрос на получение суммы с заказа с безнала
        filteredArrayZakaz = arrayZakaz.filter("idSmena == %@ and typeZakaz == %@",idSmena,0)
        guard let beznalSumm: Double = filteredArrayZakaz?.sum(ofProperty: "summaZakaz") else {return}
        guard let beznalCount = filteredArrayZakaz?.count else {return}
        
        //Заполнение полей
        totalZakazLabel.text = "Итого (\(totalCount)):"
        totalZakazSumm.text = "\(totalSumm) ₽"
        
        wheelZakazLabel.text = "С колёс (\(wheelCount)):"
        wheelZakazSumm.text = "\(wheelSumm) ₽"
        
        zakazLabel.text = "С заказов (\(zakazCount)):"
        zakazSumm.text = "\(zakazSumma) ₽"
        
        beznalZakazLabel.text = "С безнала (\(beznalCount)):"
        beznalZakazSumm.text = "\(beznalSumm) ₽"
    }
    
    //Нажите на любое пустое место на экране
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
