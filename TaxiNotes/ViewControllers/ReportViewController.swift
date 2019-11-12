//
//  ReportViewController.swift
//  TaxiNotes
//
//  Created by Денис Винокуров on 03.11.2019.
//  Copyright © 2019 Денис Винокуров. All rights reserved.
//

import UIKit
import RealmSwift

private var arrayRashod: Results<Rashod>!
private var filteredArrayRashod: Results<Rashod>!
private var arrayZakaz: Results<Zakaz>!
private var filteredArrayZakaz: Results<Zakaz>!
private var arraySmena: Results<Smena>!
private var filteredArraySmena: Results<Smena>!
private var globalAlert: UIAlertController?

class ReportViewController: UIViewController {
    
    private var beginDateReport: Date?
    private var endDateReport: Date?
    private var globalIdSmena: String = ""
    private var typeReport: Int = 0 // 0 - день 1 - неделя 2 - месяц 3 - год 4 - период 5 - смена
    
    private var totalSumm: Double = 0.0
    private var totalCount = 0
    
    private var wheelSumm: Double = 0.0
    private var wheelCount = 0
    
    private var zakazSumma: Double = 0.0
    private var zakazCount = 0
    
    private var beznalSumm: Double =  0.0
    private var beznalCount = 0
    
    var datePicker:UIDatePicker = UIDatePicker()
    var periodPickerView = UIPickerView()
    var smenaPickerView = UIPickerView()
    
    //Labels
    @IBOutlet weak var periodReportLabel: UILabel!
    @IBOutlet weak var timePeriodLabel: UILabel!
    @IBOutlet weak var totalZakazLabel: UILabel!
    @IBOutlet weak var totalZakazSumm: UILabel!
    @IBOutlet weak var wheelZakazLabel: UILabel!
    @IBOutlet weak var wheelZakazSumm: UILabel!
    @IBOutlet weak var zakazLabel: UILabel!
    @IBOutlet weak var zakazSumm: UILabel!
    @IBOutlet weak var beznalZakazLabel: UILabel!
    @IBOutlet weak var beznalZakazSumm: UILabel!

    @IBOutlet weak var zakazTableView: UITableView!
    @IBOutlet weak var rashodTableView: UITableView!
    
    private var arrayBarButtons: [UIBarButtonItem] = []
    @IBOutlet weak var changePeriodBtnItem: UIBarButtonItem!
    @IBOutlet weak var logoutBtn: UIBarButtonItem!
    
    var pickOption = ["День", "Неделя", "Месяц", "Год", "Период", "Смена"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        beginDateReport = Date()
        endDateReport = Date()
        
        arrayRashod = realm.objects(Rashod.self).filter("idAccount == %@",Variables.sharedVariables.idAccount).sorted(byKeyPath: "dateRashod")
        
        arrayZakaz = realm.objects(Zakaz.self).filter("idAccount == %@",Variables.sharedVariables.idAccount).sorted(byKeyPath: "dateZakaz")
        
        arraySmena = realm.objects(Smena.self).filter("idAccount == %@",Variables.sharedVariables.idAccount).sorted(byKeyPath: "startDateSmena")
        
        filteredArraySmena = arraySmena.filter("idAccount == %@",Variables.sharedVariables.idAccount)
        
        arrayBarButtons.append(changePeriodBtnItem)
        arrayBarButtons.append(logoutBtn)
        Variables.sharedVariables.changeThemeViewController(viewController: self, arrayBarButtons: arrayBarButtons)
        navigationItem.title = Variables.sharedVariables.currentAccountName
        
        //Настройка компонента DatePicker
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(ReportViewController.dateChanged(datePicker:)), for: .valueChanged)
        //Настройка компонента Picker
        periodPickerView.delegate = self
        smenaPickerView.delegate = self
        
        updateStatistic()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        arrayRashod = realm.objects(Rashod.self).filter("idAccount == %@",Variables.sharedVariables.idAccount).sorted(byKeyPath: "dateRashod")
        arrayZakaz = realm.objects(Zakaz.self).filter("idAccount == %@",Variables.sharedVariables.idAccount).sorted(byKeyPath: "dateZakaz")
        zakazTableView.reloadData()
        rashodTableView.reloadData()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        Variables.sharedVariables.changeThemeViewController(viewController: self, arrayBarButtons: arrayBarButtons)
    }
    
    @IBAction func changePeriodBtnAction(_ sender: UIBarButtonItem) {
        if arraySmena.count > 0 {
            alertSetPeriod(typeReport: typeReport)
        }
    }
    
    //Диалогове окно добавления расхода
    func alertSetPeriod(typeReport: Int){
        //Показать алерт добавления новой учетной записи
        let alert = UIAlertController(title: "Период отчета", message: nil, preferredStyle: .alert)
        //Настройка строки для ввода наименования расхода
        
        alert.addTextField(configurationHandler: { textField1 in
            textField1.clearButtonMode = .never
            textField1.textAlignment = .center
            textField1.borderStyle = UITextField.BorderStyle.roundedRect
            textField1.inputView = self.periodPickerView
            self.periodPickerView.selectRow(typeReport, inComponent: 0, animated: true)
            textField1.text = self.pickOption[self.periodPickerView.selectedRow(inComponent: 0)]
            globalAlert = alert
            textField1.font = UIFont.boldSystemFont(ofSize: 17.0)
        })
        
        switch typeReport {
        case 0:
            //Настройка строки для редактирования даты записи расхода
            alert.addTextField(configurationHandler: { textField2 in
                textField2.placeholder = "Дата"
                textField2.clearButtonMode = .never
                textField2.textAlignment = .center
                textField2.borderStyle = UITextField.BorderStyle.roundedRect
                textField2.font = UIFont.boldSystemFont(ofSize: 17.0)
                textField2.inputView = self.datePicker
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd.MM.yyyy"
                textField2.text = dateFormatter.string(from: self.beginDateReport ?? Date())
                self.datePicker.setDate(self.beginDateReport ?? Date(), animated: true)
            })
        case 1:
            //Настройка строки для редактирования даты записи расхода
            alert.addTextField(configurationHandler: { textField2 in
                textField2.placeholder = "Дата"
                textField2.clearButtonMode = .never
                textField2.textAlignment = .center
                textField2.borderStyle = UITextField.BorderStyle.roundedRect
                textField2.font = UIFont.boldSystemFont(ofSize: 17.0)
                textField2.inputView = self.datePicker
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd.MM.yyyy"
                textField2.text = dateFormatter.string(from: self.beginDateReport ?? Date())
                self.datePicker.setDate(self.beginDateReport ?? Date(), animated: true)
            })
        case 2:
            //Настройка строки для редактирования даты записи расхода
            alert.addTextField(configurationHandler: { textField2 in
                textField2.placeholder = "Дата"
                textField2.clearButtonMode = .never
                textField2.textAlignment = .center
                textField2.borderStyle = UITextField.BorderStyle.roundedRect
                textField2.font = UIFont.boldSystemFont(ofSize: 17.0)
                textField2.inputView = self.datePicker
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM.yyyy"
                textField2.text = dateFormatter.string(from: self.beginDateReport ?? Date())
                self.datePicker.setDate(self.beginDateReport ?? Date(), animated: true)
            })
        case 3:
            //Настройка строки для редактирования даты записи расхода
            alert.addTextField(configurationHandler: { textField2 in
                textField2.placeholder = "Дата"
                textField2.clearButtonMode = .never
                textField2.textAlignment = .center
                textField2.borderStyle = UITextField.BorderStyle.roundedRect
                textField2.font = UIFont.boldSystemFont(ofSize: 17.0)
                textField2.inputView = self.datePicker
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy"
                textField2.text = dateFormatter.string(from: self.beginDateReport ?? Date())
                self.datePicker.setDate(self.beginDateReport ?? Date(), animated: true)
            })
        case 4:
            //Настройка строки для редактирования даты записи расхода
            alert.addTextField(configurationHandler: { textField2 in
                textField2.placeholder = "Дата"
                textField2.clearButtonMode = .never
                textField2.textAlignment = .center
                textField2.borderStyle = UITextField.BorderStyle.roundedRect
                textField2.font = UIFont.boldSystemFont(ofSize: 17.0)
                textField2.inputView = self.datePicker
                textField2.addTarget(self, action: #selector(ReportViewController.setDateInDatePicker(textField:)), for: .allTouchEvents)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd.MM.yyyy"
                textField2.text = dateFormatter.string(from: self.beginDateReport ?? Date())
                self.datePicker.setDate(self.beginDateReport ?? Date(), animated: true)
            })
            
            //Настройка строки для редактирования даты записи расхода
            alert.addTextField(configurationHandler: { textField3 in
                textField3.placeholder = "Дата"
                textField3.clearButtonMode = .never
                textField3.textAlignment = .center
                textField3.borderStyle = UITextField.BorderStyle.roundedRect
                textField3.font = UIFont.boldSystemFont(ofSize: 17.0)
                textField3.inputView = self.datePicker
                textField3.addTarget(self, action: #selector(ReportViewController.setDateInDatePicker(textField:)), for: .allTouchEvents)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd.MM.yyyy"
                textField3.text = dateFormatter.string(from: self.endDateReport ?? Date())
                self.datePicker.setDate(self.endDateReport ?? Date(), animated: true)
            })
        case 5:
            //Настройка строки для редактирования даты записи расхода
            alert.addTextField(configurationHandler: { textField2 in
                textField2.placeholder = "Смена"
                textField2.clearButtonMode = .never
                textField2.textAlignment = .center
                textField2.borderStyle = UITextField.BorderStyle.roundedRect
                textField2.font = UIFont.boldSystemFont(ofSize: 13.0)
                textField2.inputView = self.smenaPickerView
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd.MM.yy hh:mm"
                textField2.text = "\(dateFormatter.string(from: arraySmena[self.smenaPickerView.selectedRow(inComponent: 0)].startDateSmena)) - \(dateFormatter.string(from: arraySmena[self.smenaPickerView.selectedRow(inComponent: 0)].endDateSmena ?? Date()))"
            })
        default:
            return
        }
        
        //Обработчик кнопки добавления записи
        alert.addAction(UIAlertAction(title: "Задать период", style: .default, handler: { action in
            self.updateStatistic()
        }))
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .destructive, handler: nil))
        globalAlert = alert
        self.present(alert, animated: true)
    }
    
    //Обработчик события изменения даты в DatePicker
    @objc func dateChanged(datePicker: UIDatePicker){
        
        switch typeReport {
        case 0:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            //Если в режиме редактирования второе поле (конечная дата)
            if ((globalAlert?.textFields![1].isEditing)!){
                globalAlert?.textFields![1].text = dateFormatter.string(from: datePicker.date)
                beginDateReport = datePicker.date
            }
        case 1:
            let week = NSCalendar.current.component(.weekOfYear, from: datePicker.date)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            //Если в режиме редактирования второе поле (конечная дата)
            if ((globalAlert?.textFields![1].isEditing)!){
                globalAlert?.textFields![1].text = dateFormatter.string(from: datePicker.date)
                beginDateReport = datePicker.date.startOfWeek(weekday: week)
                endDateReport = datePicker.date.endOfWeek(weekday: week)
            }
        case 2:
            let dateFormatter = DateFormatter()
            //Если в режиме редактирования второе поле (конечная дата)
            if ((globalAlert?.textFields![1].isEditing)!){
                dateFormatter.dateFormat = "MM.yyyy"
                globalAlert?.textFields![1].text = dateFormatter.string(from: datePicker.date)
                let dateString = "01.\(dateFormatter.string(from: datePicker.date))"
                dateFormatter.dateFormat = "dd.MM.yyyy"
                beginDateReport = dateFormatter.date(from: dateString)!.startOfMonth()
                endDateReport = dateFormatter.date(from: dateString)!.endOfMonth()
            }
        case 3:
        let dateFormatter = DateFormatter()
        //Если в режиме редактирования второе поле (конечная дата)
        if ((globalAlert?.textFields![1].isEditing)!){
            dateFormatter.dateFormat = "yyyy"
            globalAlert?.textFields![1].text = dateFormatter.string(from: datePicker.date)
            let begDateString = "01.01.\(dateFormatter.string(from: datePicker.date))"
            let endDateString = "31.12.\(dateFormatter.string(from: datePicker.date))"
            dateFormatter.dateFormat = "dd.MM.yyyy"
            beginDateReport = dateFormatter.date(from: begDateString)!
            endDateReport = dateFormatter.date(from: endDateString)!
        }
        case 4:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            //Если в режиме редактирования второе поле (конечная дата)
            if ((globalAlert?.textFields![1].isEditing)!){
                globalAlert?.textFields![1].text = dateFormatter.string(from: datePicker.date)
                beginDateReport = datePicker.date
            }
            if ((globalAlert?.textFields![2].isEditing)!){
                globalAlert?.textFields![2].text = dateFormatter.string(from: datePicker.date)
                endDateReport = datePicker.date
            }
        default:
            return
        }
    }
    
    //Изменение значения picker
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case periodPickerView:
            if ((globalAlert?.textFields![0].isEditing)!){
                globalAlert?.textFields![0].text = pickOption[row]
                typeReport = row
                globalAlert?.dismiss(animated: true, completion: nil)
                alertSetPeriod(typeReport: typeReport)
            }
        case smenaPickerView:
            if ((globalAlert?.textFields![1].isEditing)!){
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd.MM.yy hh:mm"
                globalAlert?.textFields![1].text = "\(dateFormatter.string(from: arraySmena[self.smenaPickerView.selectedRow(inComponent: 0)].startDateSmena)) - \(dateFormatter.string(from: arraySmena[self.smenaPickerView.selectedRow(inComponent: 0)].endDateSmena ?? Date()))"
                filteredArraySmena = arraySmena.filter("id = %@",arraySmena[self.smenaPickerView.selectedRow(inComponent: 0)].id)
            }
        default:
            return
        }
    }
    
    @objc func setDateInDatePicker(textField: UITextField){
        
        DispatchQueue.main.async {
            if (globalAlert?.textFields![1].isEditing)! {
                self.datePicker.setDate(self.beginDateReport ?? Date(), animated: true)
            } else {
                self.datePicker.setDate(self.endDateReport ?? Date(), animated: true)
            }
        }
    }
    
    //Обновление статистики
    func updateStatistic(){
        
        let dateFormatter = DateFormatter()
        switch typeReport {
            //День
        case 0:
            
            timePeriodLabel.isHidden = true
            
            dateFormatter.dateFormat = "dd.MM.yyyy"
            periodReportLabel.text = "Отчет за \(dateFormatter.string(from: beginDateReport ?? Date()))"
            
            //Запрос на получение общей суммы
            filteredArrayZakaz = arrayZakaz.filter("clearDateZakaz == %@",Variables.sharedVariables.reomveTimeFrom(date: beginDateReport!))
            totalSumm = filteredArrayZakaz?.sum(ofProperty: "summaZakaz") ?? 0.0
            totalCount = filteredArrayZakaz?.count ?? 0
            
            //Запрос на получение суммы с колёс
            filteredArrayZakaz = arrayZakaz.filter("clearDateZakaz == %@ and typeZakaz == %@",Variables.sharedVariables.reomveTimeFrom(date: beginDateReport!),3)
            wheelSumm = filteredArrayZakaz?.sum(ofProperty: "summaZakaz") ?? 0.0
            wheelCount = filteredArrayZakaz?.count ?? 0
            
            //Запрос на получение суммы с заказов
            filteredArrayZakaz = arrayZakaz.filter("clearDateZakaz == %@ and (typeZakaz == %@ or typeZakaz == %@)",Variables.sharedVariables.reomveTimeFrom(date: beginDateReport!),2,1)
            zakazSumma = filteredArrayZakaz?.sum(ofProperty: "summaZakaz") ?? 0.0
            zakazCount = filteredArrayZakaz?.count ?? 0
            
            //Запрос на получение суммы с заказа с безнала
            filteredArrayZakaz = arrayZakaz.filter("clearDateZakaz == %@ and typeZakaz == %@",Variables.sharedVariables.reomveTimeFrom(date: beginDateReport!),0)
            beznalSumm = filteredArrayZakaz?.sum(ofProperty: "summaZakaz") ?? 0.0
            beznalCount = filteredArrayZakaz?.count ?? 0
            
            //Запрос на получение расходов
            filteredArrayRashod = arrayRashod.filter("clearDateRashod == %@",Variables.sharedVariables.reomveTimeFrom(date: beginDateReport!))
            
            DispatchQueue.main.async {
                filteredArrayZakaz = arrayZakaz.filter("clearDateZakaz == %@",Variables.sharedVariables.reomveTimeFrom(date: self.beginDateReport!))
                self.zakazTableView.reloadData()
                self.rashodTableView.reloadData()
            }
            
            //Неделя
        case 1:
            timePeriodLabel.isHidden = true
            
            dateFormatter.dateFormat = "dd.MM.yyyy"
            
            periodReportLabel.text = "Отчет c \(dateFormatter.string(from: beginDateReport ?? Date())) по \(dateFormatter.string(from: endDateReport ?? Date())) г."
            
            //Запрос на получение общей суммы
            filteredArrayZakaz = arrayZakaz.filter("(clearDateZakaz > %@ and clearDateZakaz < %@) or (clearDateZakaz = %@ or clearDateZakaz = %@)",
                                                   Variables.sharedVariables.reomveTimeFrom(date: beginDateReport!),
                                                   Variables.sharedVariables.reomveTimeFrom(date: endDateReport!),
                                                   Variables.sharedVariables.reomveTimeFrom(date: beginDateReport!),
                                                   Variables.sharedVariables.reomveTimeFrom(date: endDateReport!))
            totalSumm = filteredArrayZakaz?.sum(ofProperty: "summaZakaz") ?? 0.0
            totalCount = filteredArrayZakaz?.count ?? 0
            
            //Запрос на получение суммы с колёс
            filteredArrayZakaz = arrayZakaz.filter("((clearDateZakaz > %@ and clearDateZakaz < %@) or (clearDateZakaz = %@ or clearDateZakaz = %@)) and typeZakaz == %@",
                                                   Variables.sharedVariables.reomveTimeFrom(date: beginDateReport!),
                                                   Variables.sharedVariables.reomveTimeFrom(date: endDateReport!),
                                                   Variables.sharedVariables.reomveTimeFrom(date: beginDateReport!),
                                                   Variables.sharedVariables.reomveTimeFrom(date: endDateReport!),
                                                   3)
            wheelSumm = filteredArrayZakaz?.sum(ofProperty: "summaZakaz") ?? 0.0
            wheelCount = filteredArrayZakaz?.count ?? 0
            
            //Запрос на получение суммы с заказов
            filteredArrayZakaz = arrayZakaz.filter("((clearDateZakaz > %@ and clearDateZakaz < %@) or (clearDateZakaz = %@ or clearDateZakaz = %@)) and (typeZakaz == %@ or typeZakaz == %@)",
                                                   Variables.sharedVariables.reomveTimeFrom(date: beginDateReport!),
                                                   Variables.sharedVariables.reomveTimeFrom(date: endDateReport!),
                                                   Variables.sharedVariables.reomveTimeFrom(date: beginDateReport!),
                                                   Variables.sharedVariables.reomveTimeFrom(date: endDateReport!),
                                                   2,
                                                   1)
            zakazSumma = filteredArrayZakaz?.sum(ofProperty: "summaZakaz") ?? 0.0
            zakazCount = filteredArrayZakaz?.count ?? 0
            
            //Запрос на получение суммы с заказа с безнала
            filteredArrayZakaz = arrayZakaz.filter("((clearDateZakaz > %@ and clearDateZakaz < %@) or (clearDateZakaz = %@ or clearDateZakaz = %@)) and typeZakaz == %@",
                                                   Variables.sharedVariables.reomveTimeFrom(date: beginDateReport!),
                                                   Variables.sharedVariables.reomveTimeFrom(date: endDateReport!),
                                                   Variables.sharedVariables.reomveTimeFrom(date: beginDateReport!),
                                                   Variables.sharedVariables.reomveTimeFrom(date: endDateReport!),
                                                   0)
            beznalSumm = filteredArrayZakaz?.sum(ofProperty: "summaZakaz") ?? 0.0
            beznalCount = filteredArrayZakaz?.count ?? 0
            
            //Запрос на получение расходов
            filteredArrayRashod = arrayRashod.filter("(clearDateRashod > %@ and clearDateRashod < %@) or (clearDateRashod = %@ or clearDateRashod = %@)",
                                                     Variables.sharedVariables.reomveTimeFrom(date: beginDateReport!),
                                                     Variables.sharedVariables.reomveTimeFrom(date: endDateReport!),
                                                     Variables.sharedVariables.reomveTimeFrom(date: beginDateReport!),
                                                     Variables.sharedVariables.reomveTimeFrom(date: endDateReport!))
            
            DispatchQueue.main.async {
                filteredArrayZakaz = arrayZakaz.filter("(clearDateZakaz > %@ and clearDateZakaz < %@) or (clearDateZakaz = %@ or clearDateZakaz = %@)",
                                                       Variables.sharedVariables.reomveTimeFrom(date: self.beginDateReport!),
                                                       Variables.sharedVariables.reomveTimeFrom(date: self.endDateReport!),
                                                       Variables.sharedVariables.reomveTimeFrom(date: self.beginDateReport!),
                                                       Variables.sharedVariables.reomveTimeFrom(date: self.endDateReport!))
                self.zakazTableView.reloadData()
                self.rashodTableView.reloadData()
            }
            //Месяц
        case 2:
            timePeriodLabel.isHidden = true
            
            dateFormatter.dateFormat = "LLLL yyyy"
            
            periodReportLabel.text = "Отчет за \(dateFormatter.string(from: beginDateReport ?? Date())) г."
            
            //Запрос на получение общей суммы
            filteredArrayZakaz = arrayZakaz.filter("(clearDateZakaz > %@ and clearDateZakaz < %@) or (clearDateZakaz = %@ or clearDateZakaz = %@)",
                                                   Variables.sharedVariables.reomveTimeFrom(date: beginDateReport!),
                                                   Variables.sharedVariables.reomveTimeFrom(date: endDateReport!),
                                                   Variables.sharedVariables.reomveTimeFrom(date: beginDateReport!),
                                                   Variables.sharedVariables.reomveTimeFrom(date: endDateReport!))
            totalSumm = filteredArrayZakaz?.sum(ofProperty: "summaZakaz") ?? 0.0
            totalCount = filteredArrayZakaz?.count ?? 0
            
            //Запрос на получение суммы с колёс
            filteredArrayZakaz = arrayZakaz.filter("((clearDateZakaz > %@ and clearDateZakaz < %@) or (clearDateZakaz = %@ or clearDateZakaz = %@)) and typeZakaz == %@",
                                                   Variables.sharedVariables.reomveTimeFrom(date: beginDateReport!),
                                                   Variables.sharedVariables.reomveTimeFrom(date: endDateReport!),
                                                   Variables.sharedVariables.reomveTimeFrom(date: beginDateReport!),
                                                   Variables.sharedVariables.reomveTimeFrom(date: endDateReport!),
                                                   3)
            wheelSumm = filteredArrayZakaz?.sum(ofProperty: "summaZakaz") ?? 0.0
            wheelCount = filteredArrayZakaz?.count ?? 0
            
            //Запрос на получение суммы с заказов
            filteredArrayZakaz = arrayZakaz.filter("((clearDateZakaz > %@ and clearDateZakaz < %@) or (clearDateZakaz = %@ or clearDateZakaz = %@)) and (typeZakaz == %@ or typeZakaz == %@)",
                                                   Variables.sharedVariables.reomveTimeFrom(date: beginDateReport!),
                                                   Variables.sharedVariables.reomveTimeFrom(date: endDateReport!),
                                                   Variables.sharedVariables.reomveTimeFrom(date: beginDateReport!),
                                                   Variables.sharedVariables.reomveTimeFrom(date: endDateReport!),
                                                   2,
                                                   1)
            zakazSumma = filteredArrayZakaz?.sum(ofProperty: "summaZakaz") ?? 0.0
            zakazCount = filteredArrayZakaz?.count ?? 0
            
            //Запрос на получение суммы с заказа с безнала
            filteredArrayZakaz = arrayZakaz.filter("((clearDateZakaz > %@ and clearDateZakaz < %@) or (clearDateZakaz = %@ or clearDateZakaz = %@)) and typeZakaz == %@",
                                                   Variables.sharedVariables.reomveTimeFrom(date: beginDateReport!),
                                                   Variables.sharedVariables.reomveTimeFrom(date: endDateReport!),
                                                   Variables.sharedVariables.reomveTimeFrom(date: beginDateReport!),
                                                   Variables.sharedVariables.reomveTimeFrom(date: endDateReport!),
                                                   0)
            beznalSumm = filteredArrayZakaz?.sum(ofProperty: "summaZakaz") ?? 0.0
            beznalCount = filteredArrayZakaz?.count ?? 0
            
            //Запрос на получение расходов
            filteredArrayRashod = arrayRashod.filter("(clearDateRashod > %@ and clearDateRashod < %@) or (clearDateRashod = %@ or clearDateRashod = %@)",
                                                     Variables.sharedVariables.reomveTimeFrom(date: beginDateReport!),
                                                     Variables.sharedVariables.reomveTimeFrom(date: endDateReport!),
                                                     Variables.sharedVariables.reomveTimeFrom(date: beginDateReport!),
                                                     Variables.sharedVariables.reomveTimeFrom(date: endDateReport!))
            
            DispatchQueue.main.async {
                filteredArrayZakaz = arrayZakaz.filter("(clearDateZakaz > %@ and clearDateZakaz < %@) or (clearDateZakaz = %@ or clearDateZakaz = %@)",
                                                       Variables.sharedVariables.reomveTimeFrom(date: self.beginDateReport!),
                                                       Variables.sharedVariables.reomveTimeFrom(date: self.endDateReport!),
                                                       Variables.sharedVariables.reomveTimeFrom(date: self.beginDateReport!),
                                                       Variables.sharedVariables.reomveTimeFrom(date: self.endDateReport!))
                self.zakazTableView.reloadData()
                self.rashodTableView.reloadData()
            }
            //Год
        case 3:
            timePeriodLabel.isHidden = true
            
            dateFormatter.dateFormat = "yyyy"
            
            periodReportLabel.text = "Отчет за \(dateFormatter.string(from: beginDateReport ?? Date())) г."
            
            //Запрос на получение общей суммы
            filteredArrayZakaz = arrayZakaz.filter("(clearDateZakaz > %@ and clearDateZakaz < %@) or (clearDateZakaz = %@ or clearDateZakaz = %@)",
                                                   Variables.sharedVariables.reomveTimeFrom(date: beginDateReport!),
                                                   Variables.sharedVariables.reomveTimeFrom(date: endDateReport!),
                                                   Variables.sharedVariables.reomveTimeFrom(date: beginDateReport!),
                                                   Variables.sharedVariables.reomveTimeFrom(date: endDateReport!))
            totalSumm = filteredArrayZakaz?.sum(ofProperty: "summaZakaz") ?? 0.0
            totalCount = filteredArrayZakaz?.count ?? 0
            
            //Запрос на получение суммы с колёс
            filteredArrayZakaz = arrayZakaz.filter("((clearDateZakaz > %@ and clearDateZakaz < %@) or (clearDateZakaz = %@ or clearDateZakaz = %@)) and typeZakaz == %@",
                                                   Variables.sharedVariables.reomveTimeFrom(date: beginDateReport!),
                                                   Variables.sharedVariables.reomveTimeFrom(date: endDateReport!),
                                                   Variables.sharedVariables.reomveTimeFrom(date: beginDateReport!),
                                                   Variables.sharedVariables.reomveTimeFrom(date: endDateReport!),
                                                   3)
            wheelSumm = filteredArrayZakaz?.sum(ofProperty: "summaZakaz") ?? 0.0
            wheelCount = filteredArrayZakaz?.count ?? 0
            
            //Запрос на получение суммы с заказов
            filteredArrayZakaz = arrayZakaz.filter("((clearDateZakaz > %@ and clearDateZakaz < %@) or (clearDateZakaz = %@ or clearDateZakaz = %@)) and (typeZakaz == %@ or typeZakaz == %@)",
                                                   Variables.sharedVariables.reomveTimeFrom(date: beginDateReport!),
                                                   Variables.sharedVariables.reomveTimeFrom(date: endDateReport!),
                                                   Variables.sharedVariables.reomveTimeFrom(date: beginDateReport!),
                                                   Variables.sharedVariables.reomveTimeFrom(date: endDateReport!),
                                                   2,
                                                   1)
            zakazSumma = filteredArrayZakaz?.sum(ofProperty: "summaZakaz") ?? 0.0
            zakazCount = filteredArrayZakaz?.count ?? 0
            
            //Запрос на получение суммы с заказа с безнала
            filteredArrayZakaz = arrayZakaz.filter("((clearDateZakaz > %@ and clearDateZakaz < %@) or (clearDateZakaz = %@ or clearDateZakaz = %@)) and typeZakaz == %@",
                                                   Variables.sharedVariables.reomveTimeFrom(date: beginDateReport!),
                                                   Variables.sharedVariables.reomveTimeFrom(date: endDateReport!),
                                                   Variables.sharedVariables.reomveTimeFrom(date: beginDateReport!),
                                                   Variables.sharedVariables.reomveTimeFrom(date: endDateReport!),
                                                   0)
            beznalSumm = filteredArrayZakaz?.sum(ofProperty: "summaZakaz") ?? 0.0
            beznalCount = filteredArrayZakaz?.count ?? 0
            
            //Запрос на получение расходов
            filteredArrayRashod = arrayRashod.filter("(clearDateRashod > %@ and clearDateRashod < %@) or (clearDateRashod = %@ or clearDateRashod = %@)",
                                                     Variables.sharedVariables.reomveTimeFrom(date: beginDateReport!),
                                                     Variables.sharedVariables.reomveTimeFrom(date: endDateReport!),
                                                     Variables.sharedVariables.reomveTimeFrom(date: beginDateReport!),
                                                     Variables.sharedVariables.reomveTimeFrom(date: endDateReport!))
            
            DispatchQueue.main.async {
                filteredArrayZakaz = arrayZakaz.filter("(clearDateZakaz > %@ and clearDateZakaz < %@) or (clearDateZakaz = %@ or clearDateZakaz = %@)",
                                                       Variables.sharedVariables.reomveTimeFrom(date: self.beginDateReport!),
                                                       Variables.sharedVariables.reomveTimeFrom(date: self.endDateReport!),
                                                       Variables.sharedVariables.reomveTimeFrom(date: self.beginDateReport!),
                                                       Variables.sharedVariables.reomveTimeFrom(date: self.endDateReport!))
                self.zakazTableView.reloadData()
                self.rashodTableView.reloadData()
            }
            //Период
        case 4:
            timePeriodLabel.isHidden = true
            
            dateFormatter.dateFormat = "dd.MM.yyyy"
            
            periodReportLabel.text = "Отчет c \(dateFormatter.string(from: beginDateReport ?? Date())) по \(dateFormatter.string(from: endDateReport ?? Date())) г."
            
            //Запрос на получение общей суммы
            filteredArrayZakaz = arrayZakaz.filter("(clearDateZakaz > %@ and clearDateZakaz < %@) or (clearDateZakaz = %@ or clearDateZakaz = %@)",
                                                   Variables.sharedVariables.reomveTimeFrom(date: beginDateReport!),
                                                   Variables.sharedVariables.reomveTimeFrom(date: endDateReport!),
                                                   Variables.sharedVariables.reomveTimeFrom(date: beginDateReport!),
                                                   Variables.sharedVariables.reomveTimeFrom(date: endDateReport!))
            totalSumm = filteredArrayZakaz?.sum(ofProperty: "summaZakaz") ?? 0.0
            totalCount = filteredArrayZakaz?.count ?? 0
            
            //Запрос на получение суммы с колёс
            filteredArrayZakaz = arrayZakaz.filter("((clearDateZakaz > %@ and clearDateZakaz < %@) or (clearDateZakaz = %@ or clearDateZakaz = %@)) and typeZakaz == %@",
                                                   Variables.sharedVariables.reomveTimeFrom(date: beginDateReport!),
                                                   Variables.sharedVariables.reomveTimeFrom(date: endDateReport!),
                                                   Variables.sharedVariables.reomveTimeFrom(date: beginDateReport!),
                                                   Variables.sharedVariables.reomveTimeFrom(date: endDateReport!),
                                                   3)
            wheelSumm = filteredArrayZakaz?.sum(ofProperty: "summaZakaz") ?? 0.0
            wheelCount = filteredArrayZakaz?.count ?? 0
            
            //Запрос на получение суммы с заказов
            filteredArrayZakaz = arrayZakaz.filter("((clearDateZakaz > %@ and clearDateZakaz < %@) or (clearDateZakaz = %@ or clearDateZakaz = %@)) and (typeZakaz == %@ or typeZakaz == %@)",
                                                   Variables.sharedVariables.reomveTimeFrom(date: beginDateReport!),
                                                   Variables.sharedVariables.reomveTimeFrom(date: endDateReport!),
                                                   Variables.sharedVariables.reomveTimeFrom(date: beginDateReport!),
                                                   Variables.sharedVariables.reomveTimeFrom(date: endDateReport!),
                                                   2,
                                                   1)
            zakazSumma = filteredArrayZakaz?.sum(ofProperty: "summaZakaz") ?? 0.0
            zakazCount = filteredArrayZakaz?.count ?? 0
            
            //Запрос на получение суммы с заказа с безнала
            filteredArrayZakaz = arrayZakaz.filter("((clearDateZakaz > %@ and clearDateZakaz < %@) or (clearDateZakaz = %@ or clearDateZakaz = %@)) and typeZakaz == %@",
                                                   Variables.sharedVariables.reomveTimeFrom(date: beginDateReport!),
                                                   Variables.sharedVariables.reomveTimeFrom(date: endDateReport!),
                                                   Variables.sharedVariables.reomveTimeFrom(date: beginDateReport!),
                                                   Variables.sharedVariables.reomveTimeFrom(date: endDateReport!),
                                                   0)
            beznalSumm = filteredArrayZakaz?.sum(ofProperty: "summaZakaz") ?? 0.0
            beznalCount = filteredArrayZakaz?.count ?? 0
            
            //Запрос на получение расходов
            filteredArrayRashod = arrayRashod.filter("(clearDateRashod > %@ and clearDateRashod < %@) or (clearDateRashod = %@ or clearDateRashod = %@)",
                                                     Variables.sharedVariables.reomveTimeFrom(date: beginDateReport!),
                                                     Variables.sharedVariables.reomveTimeFrom(date: endDateReport!),
                                                     Variables.sharedVariables.reomveTimeFrom(date: beginDateReport!),
                                                     Variables.sharedVariables.reomveTimeFrom(date: endDateReport!))
            
            DispatchQueue.main.async {
                filteredArrayZakaz = arrayZakaz.filter("(clearDateZakaz > %@ and clearDateZakaz < %@) or (clearDateZakaz = %@ or clearDateZakaz = %@)",
                                                       Variables.sharedVariables.reomveTimeFrom(date: self.beginDateReport!),
                                                       Variables.sharedVariables.reomveTimeFrom(date: self.endDateReport!),
                                                       Variables.sharedVariables.reomveTimeFrom(date: self.beginDateReport!),
                                                       Variables.sharedVariables.reomveTimeFrom(date: self.endDateReport!))
                self.zakazTableView.reloadData()
                self.rashodTableView.reloadData()
            }
            //Смена
        case 5:
            
            timePeriodLabel.isHidden = false
            //Запрос на поиск id открытой смены
            guard let idSmena = filteredArraySmena.first?.id else {return}
            dateFormatter.dateFormat = "dd.MM.yyyy"
            periodReportLabel.text = "Смена \(dateFormatter.string(from: filteredArraySmena.first!.startDateSmena)) - \(dateFormatter.string(from: filteredArraySmena.first!.endDateSmena!))"
            dateFormatter.dateFormat = "hh:mm"
            timePeriodLabel.text = "\(dateFormatter.string(from: filteredArraySmena.first!.startDateSmena)) - \(dateFormatter.string(from: filteredArraySmena.first!.endDateSmena!))"
            
            //Запрос на получение общей суммы
            filteredArrayZakaz = arrayZakaz.filter("idSmena == %@",idSmena)
            totalSumm = filteredArrayZakaz?.sum(ofProperty: "summaZakaz") ?? 0.0
            totalCount = filteredArrayZakaz?.count ?? 0
            
            //Запрос на получение суммы с колёс
            filteredArrayZakaz = arrayZakaz.filter("idSmena == %@ and typeZakaz == %@",idSmena,3)
            wheelSumm = filteredArrayZakaz?.sum(ofProperty: "summaZakaz") ?? 0.0
            wheelCount = filteredArrayZakaz?.count ?? 0
            
            //Запрос на получение суммы с заказов
            filteredArrayZakaz = arrayZakaz.filter("idSmena == %@ and (typeZakaz == %@ or typeZakaz == %@)",idSmena,2,1)
            zakazSumma = filteredArrayZakaz?.sum(ofProperty: "summaZakaz") ?? 0.0
            zakazCount = filteredArrayZakaz?.count ?? 0
            
            //Запрос на получение расходов
            filteredArrayRashod = arrayRashod.filter("(dateRashod > %@ and dateRashod < %@) or (dateRashod = %@ or dateRashod = %@)",
                                                     filteredArraySmena.first!.startDateSmena, filteredArraySmena.first!.endDateSmena!,
                                                     filteredArraySmena.first!.startDateSmena,filteredArraySmena.first!.endDateSmena!)
            
            //Запрос на получение суммы с заказа с безнала
            filteredArrayZakaz = arrayZakaz.filter("idSmena == %@ and typeZakaz == %@",idSmena,0)
            beznalSumm = filteredArrayZakaz?.sum(ofProperty: "summaZakaz") ?? 0.0
            beznalCount = filteredArrayZakaz?.count ?? 0
            
            DispatchQueue.main.async {
                filteredArrayZakaz = arrayZakaz.filter("idSmena == %@",idSmena)
                self.zakazTableView.reloadData()
                self.rashodTableView.reloadData()
            }
            
            
        default:
            return
        }
        
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

}

extension ReportViewController: UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        switch pickerView {
        case smenaPickerView:
            if pickerLabel == nil {
                pickerLabel = UILabel()
                pickerLabel?.font = UIFont(name: "Arial Rounded MT Bold", size: 15.0)
                pickerLabel?.textAlignment = .center
            }
            let dateFormatter = DateFormatter()
            if UIDevice.modelName == "iPhone SE" || UIDevice.modelName == "iPhone 6" || UIDevice.modelName == "iPhone 6S" || UIDevice.modelName == "iPhone 7" || UIDevice.modelName == "iPhone 8" || UIDevice.modelName == "iPhone X" || UIDevice.modelName == "iPhone 11" {
                dateFormatter.dateFormat = "(EE) dd.MM.yy hh:mm"
            } else {
                dateFormatter.dateFormat = "(EEEE) dd.MM.yy hh:mm"
            }
            pickerLabel?.text = "\(dateFormatter.string(from: arraySmena[row].startDateSmena)) - \(dateFormatter.string(from: arraySmena[row].endDateSmena ?? Date()))"
        default:
            if pickerLabel == nil {
                pickerLabel = UILabel()
                pickerLabel?.font = UIFont(name: "Arial Rounded MT Bold", size: 25.0)
                pickerLabel?.textAlignment = .center
            }
            pickerLabel?.text = pickOption[row]
        }

        return pickerLabel!
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case smenaPickerView:
            return arraySmena.count
        default:
            return pickOption.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case zakazTableView:
            return filteredArrayZakaz.count
        case rashodTableView:
            return filteredArrayRashod.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy hh:mm"
        
        switch tableView {
        case zakazTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "zakazTableCell") as! zakazReportCell
            cell.dateZakazLabel.text = dateFormatter.string(from: filteredArrayZakaz[indexPath.row].dateZakaz)
            switch filteredArrayZakaz[indexPath.row].typeZakaz {
            case 0:
                cell.nameZakazLabel.text = "Безнал"
            case 1:
                cell.nameZakazLabel.text = "Заказ"
            case 2:
                cell.nameZakazLabel.text = "Заказ %"
            case 3:
                cell.nameZakazLabel.text = "С колёс"
            default:
                cell.nameZakazLabel.text = "Заказ"
            }
            cell.summaZakazLabel.text = "\(filteredArrayZakaz[indexPath.row].summaZakaz)₽"
            return cell
        case rashodTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "rashodTableCell") as! rashodReportCell
            cell.dateRashodLabel.text = dateFormatter.string(from: filteredArrayRashod[indexPath.row].dateRashod)
            cell.nameRashodLabel.text = filteredArrayRashod[indexPath.row].nameRashod
            cell.summaRashodLabel.text = "\(filteredArrayRashod[indexPath.row].summRashod)₽"
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "zakazTableCell") as! zakazReportCell
            return cell
        }
        
    }
    
    
}

extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.day, .month, .year], from: Calendar.current.startOfDay(for: self)))!
    }

    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    func startOfWeek(weekday: Int?) -> Date {
        var cal = Calendar.current
        var component = cal.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        component.to12am()
        cal.firstWeekday = weekday ?? 1
        return cal.date(from: component)!
    }

    func endOfWeek(weekday: Int) -> Date {
        let cal = Calendar.current
        var component = DateComponents()
        component.weekOfYear = 1
        component.day = -1
        component.to12pm()
        return cal.date(byAdding: component, to: startOfWeek(weekday: weekday))!
     }
}

internal extension DateComponents {
    mutating func to12am() {
      self.hour = 0
      self.minute = 0
      self.second = 0
  }

  mutating func to12pm(){
      self.hour = 23
      self.minute = 59
      self.second = 59
  }
}

extension UIDevice {

    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod touch (5th generation)"
            case "iPod7,1":                                 return "iPod touch (6th generation)"
            case "iPod9,1":                                 return "iPod touch (7th generation)"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPhone12,1":                              return "iPhone 11"
            case "iPhone12,3":                              return "iPhone 11 Pro"
            case "iPhone12,5":                              return "iPhone 11 Pro Max"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad (3rd generation)"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad (4th generation)"
            case "iPad6,11", "iPad6,12":                    return "iPad (5th generation)"
            case "iPad7,5", "iPad7,6":                      return "iPad (6th generation)"
            case "iPad7,11", "iPad7,12":                    return "iPad (7th generation)"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad11,4", "iPad11,5":                    return "iPad Air (3rd generation)"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad mini 4"
            case "iPad11,1", "iPad11,2":                    return "iPad mini (5th generation)"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch)"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }

        return mapToDevice(identifier: identifier)
    }()

}
