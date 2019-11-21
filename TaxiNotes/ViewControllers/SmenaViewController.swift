//
//  SmenaViewController.swift
//  TaxiNotes
//
//  Created by Денис Винокуров on 02.11.2019.
//  Copyright © 2019 Денис Винокуров. All rights reserved.
//

import UIKit
import RealmSwift

private var filteredArraySmena: Results<Smena>!
private var arrayZakaz: Results<Zakaz>!
private var filteredArrayZakaz: Results<Zakaz>!
private var settingsArray: Results<Settings>!

class SmenaViewController: UIViewController {

    private var viewModel: SmenaViewModeType?
    
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
        
        viewModel = SmenaViewModel()
        
        arrayBarButtons.append(startStopSmenaBtn)
        arrayBarButtons.append(logountBtn)
        
        Variables.sharedVariables.changeThemeViewController(viewController: self, arrayBarButtons: arrayBarButtons)
        
        scoreAccountLabel.text = "На счету: \(Variables.sharedVariables.scoreAccount) ₽"
        
        navigationItem.title = Variables.sharedVariables.currentAccountName
        
        arrayZakaz = realm.objects(Zakaz.self)
        filteredArraySmena = realm.objects(Smena.self).filter("endDateSmena == nil and idAccount == %@",Variables.sharedVariables.idAccount)
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
            viewModel!.wheel(summa: Double(summaTextField.text ?? "0") ?? 0.0)
            summaTextField.text = ""
            self.view.endEditing(true)
            updateStatistic()
        }
    }
    //Кнопка поездки по-заказу с процентом
    @IBAction func percentBtnAction(_ sender: UIButton) {
        if (summaTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count)! > 0 {
            viewModel!.percentZakaz(summa: Double(summaTextField.text ?? "0") ?? 0.0)
            scoreAccountLabel.text = "На счету: \(Variables.sharedVariables.scoreAccount) ₽"
            summaTextField.text = ""
            self.view.endEditing(true)
            updateStatistic()
        }
    }
    //Кнопка поездки по-заказу без процента
    @IBAction func zakazBtnAction(_ sender: UIButton) {
        if (summaTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count)! > 0 {
            viewModel!.zakaz(summa: Double(summaTextField.text ?? "0") ?? 0.0)
            scoreAccountLabel.text = "На счету: \(Variables.sharedVariables.scoreAccount) ₽"
            summaTextField.text = ""
            self.view.endEditing(true)
            updateStatistic()
        }
    }
    //Кнопка поездки по-безналу
    @IBAction func beznalBtnAction(_ sender: UIButton) {
        if (summaTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count)! > 0 {
            viewModel!.beznal(summa: Double(summaTextField.text ?? "0") ?? 0.0)
            summaTextField.text = ""
            self.view.endEditing(true)
            updateStatistic()
        }
    }
    //Кнопка пополнения счета
    @IBAction func addMoneyScoreBtnAction(_ sender: UIButton) {
        self.present((viewModel?.alertAddScoreAccount(completion: {
                self.scoreAccountLabel.text = "На счету: \(Variables.sharedVariables.scoreAccount) ₽"
        }))!, animated: true)
    }
    //Кнопка начала и окончания смены
    @IBAction func startStopSmenaBtnAction(_ sender: UIBarButtonItem) {
        
        if !Variables.sharedVariables.startedSmena {
            startStopSmenaBtn.image = UIImage(systemName: "stop.fill")
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
            viewModel?.startStopSmena()
            
        } else {
            filteredArraySmena = realm.objects(Smena.self).filter("endDateSmena == nil and idAccount == %@",Variables.sharedVariables.idAccount)
            if filteredArraySmena.count > 0 {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd.MM.yyyy"
                let todaysDate = dateFormatter.string(from: Date())
                smenaPeriodLabel.text = "Смена \(dateFormatter.string(from:filteredArraySmena.first!.startDateSmena)) - \(todaysDate)"
                viewModel?.startStopSmena()
                startStopSmenaBtn.image = UIImage(systemName: "play.fill")
            }
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
    
    //Создание уведомления
    func addInformationAlert(title: String, message: String){
        self.present((viewModel?.addInformationAlert(title: title, message: message))!, animated: true, completion: nil)
    }
    
    //Обновление статистики
    func updateStatistic(){
        //Заполнение полей
        totalZakazLabel.text = "Итого (\(viewModel?.getTotalSummCount().count ?? 0)):"
        totalZakazSumm.text = "\(viewModel?.getTotalSummCount().summ ?? 0.0) ₽"
        
        wheelZakazLabel.text = "С колёс (\(viewModel?.getWheelSummCount().count ?? 0)):"
        wheelZakazSumm.text = "\(viewModel?.getWheelSummCount().summ ?? 0.0) ₽"
        
        zakazLabel.text = "С заказов (\(viewModel?.getZakazSummCount().count ?? 0)):"
        zakazSumm.text = "\(viewModel?.getZakazSummCount().summ ?? 0.0) ₽"
        
        beznalZakazLabel.text = "С безнала (\(viewModel?.getBeznalSummCount().count ?? 0)):"
        beznalZakazSumm.text = "\(viewModel?.getBeznalSummCount().summ ?? 0.0) ₽"
    }
    
    //Нажите на любое пустое место на экране
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
