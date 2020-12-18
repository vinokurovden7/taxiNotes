//
//  ReportViewModel.swift
//  TaxiNotes
//
//  Created by Денис Винокуров on 21.11.2019.
//  Copyright © 2019 Денис Винокуров. All rights reserved.
//

import UIKit
import RealmSwift

class ReportViewModel: ReportViewModelType {
    
    //MARK: Private properties:
    private var filteredArrayRashod: Results<Rashod>!
    private var filteredArrayZakaz: Results<Zakaz>!
    private var filteredArraySmena: Results<Smena>!
    private var arraySmena: Results<Smena>!
    private var arrayRashod: Results<Rashod>!
    private var arrayZakaz: Results<Zakaz>!
    private var selectedIndexPath: IndexPath?
    private var globalAlert = UIAlertController()
    private var reportVC = ReportViewController()
    private var beginDateReport: Date?
    private var endDateReport: Date?
    private var datePicker:UIDatePicker = UIDatePicker()
    private var smenaPickerView = UIPickerView()
    private var pickOption = ["День", "Неделя", "Месяц", "Год", "Период", "Смена"]
    private var typeZakazPickerOption = ["Безнал","Заказ","Заказ %","С колёс"]
    private var totalSumm: Double = 0.0
    private var totalCount = 0
    private var wheelSumm: Double = 0.0
    private var wheelCount = 0
    private var zakazSumma: Double = 0.0
    private var zakazCount = 0
    private var beznalSumm: Double =  0.0
    private var beznalCount = 0
    private var rashodSumm: Double = 0.0
    
    //MARK: View Controller func:
    func alertSetPeriod(typeReport: Int, periodPickerView: UIPickerView, smenaPickerView: UIPickerView, completion: @escaping ()->()) -> UIAlertController {
        self.smenaPickerView = smenaPickerView
        arraySmena = realm.objects(Smena.self).filter("idAccount == %@",Variables.sharedVariables.idAccount).sorted(byKeyPath: "startDateSmena")
        //Показать алерт добавления новой учетной записи
        let alert = UIAlertController(title: "Период отчета", message: nil, preferredStyle: .alert)
        //Настройка строки для ввода наименования расхода
        
        alert.addTextField(configurationHandler: { textField1 in
            textField1.clearButtonMode = .never
            textField1.textAlignment = .center
            textField1.borderStyle = UITextField.BorderStyle.roundedRect
            textField1.inputView = periodPickerView
            periodPickerView.selectRow(typeReport, inComponent: 0, animated: true)
            textField1.text = self.pickOption[periodPickerView.selectedRow(inComponent: 0)]
            self.globalAlert = alert
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
                textField2.text = dateFormatter.string(from: self.beginDateReport ?? Date() )
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
                textField2.addTarget(self, action: #selector(ReportViewModel.setDateInDatePicker(textField:)), for: .allTouchEvents)
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
                textField3.addTarget(self, action: #selector(ReportViewModel.setDateInDatePicker(textField:)), for: .allTouchEvents)
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
                textField2.inputView = smenaPickerView
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd.MM.yy HH:mm"
                textField2.text = "\(dateFormatter.string(from: self.arraySmena[smenaPickerView.selectedRow(inComponent: 0)].startDateSmena)) - \(dateFormatter.string(from: self.arraySmena[smenaPickerView.selectedRow(inComponent: 0)].endDateSmena ?? Date()))"
            })
        default:
            break
        }
        
        //Обработчик кнопки добавления записи
        alert.addAction(UIAlertAction(title: "Задать период", style: .default, handler: { action in
            self.dateSetter(typeReport: typeReport)
            self.updateStatistic(typeReport: typeReport, completion: {
                completion()
            })
        }))
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .destructive, handler: nil))
        globalAlert = alert
        
        return alert
    }
    
    @objc func setDateInDatePicker(textField: UITextField){
        
        DispatchQueue.main.async {
            if (self.getAlert().textFields![1].isEditing) {
                self.datePicker.setDate(self.beginDateReport ?? Date(), animated: true)
            } else {
                self.datePicker.setDate(self.endDateReport ?? Date(), animated: true)
            }
        }
    }
    
    func dateSetter(typeReport: Int) {
        DispatchQueue.global(qos: .userInteractive).sync {
            switch typeReport {
            case 0:
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd.MM.yyyy"
                //Если в режиме редактирования второе поле (конечная дата)
                getAlert().textFields![1].text = dateFormatter.string(from: datePicker.date)
                beginDateReport = self.datePicker.date
                endDateReport = self.datePicker.date
            case 1:
                let week = NSCalendar.current.component(.weekOfYear, from: datePicker.date)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd.MM.yyyy"
                //Если в режиме редактирования второе поле (конечная дата)
                getAlert().textFields![1].text = dateFormatter.string(from: datePicker.date)
                beginDateReport = self.datePicker.date.startOfWeek(weekday: week)
                endDateReport = self.datePicker.date.endOfWeek(weekday: week)
            case 2:
                let dateFormatter = DateFormatter()
                //Если в режиме редактирования второе поле (конечная дата)
                dateFormatter.dateFormat = "MM.yyyy"
                getAlert().textFields![1].text = dateFormatter.string(from: self.datePicker.date)
                let dateString = "01.\(dateFormatter.string(from: self.datePicker.date))"
                dateFormatter.dateFormat = "dd.MM.yyyy"
                beginDateReport = dateFormatter.date(from: dateString)!.startOfMonth()
                endDateReport = dateFormatter.date(from: dateString)!.endOfMonth()
            case 3:
            let dateFormatter = DateFormatter()
            //Если в режиме редактирования второе поле (конечная дата)
                dateFormatter.dateFormat = "yyyy"
                getAlert().textFields![1].text = dateFormatter.string(from: self.datePicker.date)
                let begDateString = "01.01.\(dateFormatter.string(from: self.datePicker.date))"
                let endDateString = "31.12.\(dateFormatter.string(from: self.datePicker.date))"
                dateFormatter.dateFormat = "dd.MM.yyyy"
                beginDateReport = dateFormatter.date(from: begDateString)!
                endDateReport = dateFormatter.date(from: endDateString)!
            case 4:
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd.MM.yyyy"
                //Если в режиме редактирования второе поле (конечная дата)
                if ((globalAlert.textFields![1].isEditing)){
                    globalAlert.textFields![1].text = dateFormatter.string(from: self.datePicker.date)
                    beginDateReport = self.datePicker.date
                }
                if ((globalAlert.textFields![2].isEditing)){
                    globalAlert.textFields![2].text = dateFormatter.string(from: self.datePicker.date)
                    endDateReport = self.datePicker.date
                }
            case 5:
                beginDateReport = arraySmena[smenaPickerView.selectedRow(inComponent: 0)].startDateSmena
                endDateReport = arraySmena[smenaPickerView.selectedRow(inComponent: 0)].endDateSmena
            default:
                return
            }
        }
    }
    
    func updateStatistic(typeReport: Int , completion: @escaping ()->()) {
        DispatchQueue.global(qos: .userInteractive).sync {
            arrayRashod = realm.objects(Rashod.self).filter("idAccount == %@",Variables.sharedVariables.idAccount).sorted(byKeyPath: "dateRashod")
            arrayZakaz = realm.objects(Zakaz.self).filter("idAccount == %@",Variables.sharedVariables.idAccount).sorted(byKeyPath: "dateZakaz")
            let dateFormatter = DateFormatter()
            switch typeReport {
            //День
            case 0:
                
                dateFormatter.dateFormat = "dd.MM.yyyy"
                
                //Запрос на получение общей суммы
                filteredArrayZakaz = arrayZakaz.filter("clearDateZakaz == %@",Variables.sharedVariables.reomveTimeFrom(date: beginDateReport ?? Date()))
                totalSumm = filteredArrayZakaz?.sum(ofProperty: "summaZakaz") ?? 0.0
                totalCount = filteredArrayZakaz?.count ?? 0
                
                //Запрос на получение суммы с колёс
                filteredArrayZakaz = arrayZakaz.filter("clearDateZakaz == %@ and typeZakaz == %@",Variables.sharedVariables.reomveTimeFrom(date: beginDateReport ?? Date()),3)
                wheelSumm = filteredArrayZakaz?.sum(ofProperty: "summaZakaz") ?? 0.0
                wheelCount = filteredArrayZakaz?.count ?? 0
                
                //Запрос на получение суммы с заказов
                filteredArrayZakaz = arrayZakaz.filter("clearDateZakaz == %@ and (typeZakaz == %@ or typeZakaz == %@)",Variables.sharedVariables.reomveTimeFrom(date: beginDateReport ?? Date()),2,1)
                zakazSumma = filteredArrayZakaz?.sum(ofProperty: "summaZakaz") ?? 0.0
                zakazCount = filteredArrayZakaz?.count ?? 0
                
                //Запрос на получение суммы с заказа с безнала
                filteredArrayZakaz = arrayZakaz.filter("clearDateZakaz == %@ and typeZakaz == %@",Variables.sharedVariables.reomveTimeFrom(date: beginDateReport ?? Date()),0)
                beznalSumm = filteredArrayZakaz?.sum(ofProperty: "summaZakaz") ?? 0.0
                beznalCount = filteredArrayZakaz?.count ?? 0
                
                //Запрос на получение расходов
                filteredArrayRashod = arrayRashod.filter("clearDateRashod == %@",Variables.sharedVariables.reomveTimeFrom(date: beginDateReport ?? Date()))
                rashodSumm = filteredArrayRashod?.sum(ofProperty: "summRashod") ?? 0.0
                filteredArrayZakaz = self.arrayZakaz.filter("clearDateZakaz == %@",Variables.sharedVariables.reomveTimeFrom(date: self.beginDateReport ?? Date()))
                
            //Неделя
            case 1:
                //Запрос на получение общей суммы
                filteredArrayZakaz = arrayZakaz.filter("(clearDateZakaz > %@ and clearDateZakaz < %@) or (clearDateZakaz = %@ or clearDateZakaz = %@)",
                                                       Variables.sharedVariables.reomveTimeFrom(date: beginDateReport ?? Date()),
                                                       Variables.sharedVariables.reomveTimeFrom(date: endDateReport ?? Date()),
                                                       Variables.sharedVariables.reomveTimeFrom(date: beginDateReport ?? Date()),
                                                       Variables.sharedVariables.reomveTimeFrom(date: endDateReport ?? Date()))
                totalSumm = filteredArrayZakaz?.sum(ofProperty: "summaZakaz") ?? 0.0
                totalCount = filteredArrayZakaz?.count ?? 0
                
                //Запрос на получение суммы с колёс
                filteredArrayZakaz = arrayZakaz.filter("((clearDateZakaz > %@ and clearDateZakaz < %@) or (clearDateZakaz = %@ or clearDateZakaz = %@)) and typeZakaz == %@",
                                                       Variables.sharedVariables.reomveTimeFrom(date: beginDateReport ?? Date()),
                                                       Variables.sharedVariables.reomveTimeFrom(date: endDateReport ?? Date()),
                                                       Variables.sharedVariables.reomveTimeFrom(date: beginDateReport ?? Date()),
                                                       Variables.sharedVariables.reomveTimeFrom(date: endDateReport ?? Date()),
                                                       3)
                wheelSumm = filteredArrayZakaz?.sum(ofProperty: "summaZakaz") ?? 0.0
                wheelCount = filteredArrayZakaz?.count ?? 0
                
                //Запрос на получение суммы с заказов
                filteredArrayZakaz = arrayZakaz.filter("((clearDateZakaz > %@ and clearDateZakaz < %@) or (clearDateZakaz = %@ or clearDateZakaz = %@)) and (typeZakaz == %@ or typeZakaz == %@)",
                                                       Variables.sharedVariables.reomveTimeFrom(date: beginDateReport ?? Date()),
                                                       Variables.sharedVariables.reomveTimeFrom(date: endDateReport ?? Date()),
                                                       Variables.sharedVariables.reomveTimeFrom(date: beginDateReport ?? Date()),
                                                       Variables.sharedVariables.reomveTimeFrom(date: endDateReport ?? Date()),
                                                       2,
                                                       1)
                zakazSumma = filteredArrayZakaz?.sum(ofProperty: "summaZakaz") ?? 0.0
                zakazCount = filteredArrayZakaz?.count ?? 0
                
                //Запрос на получение суммы с заказа с безнала
                filteredArrayZakaz = arrayZakaz.filter("((clearDateZakaz > %@ and clearDateZakaz < %@) or (clearDateZakaz = %@ or clearDateZakaz = %@)) and typeZakaz == %@",
                                                       Variables.sharedVariables.reomveTimeFrom(date: beginDateReport ?? Date()),
                                                       Variables.sharedVariables.reomveTimeFrom(date: endDateReport ?? Date()),
                                                       Variables.sharedVariables.reomveTimeFrom(date: beginDateReport ?? Date()),
                                                       Variables.sharedVariables.reomveTimeFrom(date: endDateReport ?? Date()),
                                                       0)
                beznalSumm = filteredArrayZakaz?.sum(ofProperty: "summaZakaz") ?? 0.0
                beznalCount = filteredArrayZakaz?.count ?? 0
                
                //Запрос на получение расходов
                filteredArrayRashod = arrayRashod.filter("(clearDateRashod > %@ and clearDateRashod < %@) or (clearDateRashod = %@ or clearDateRashod = %@)",
                                                         Variables.sharedVariables.reomveTimeFrom(date: beginDateReport ?? Date()),
                                                         Variables.sharedVariables.reomveTimeFrom(date: endDateReport ?? Date()),
                                                         Variables.sharedVariables.reomveTimeFrom(date: beginDateReport ?? Date()),
                                                         Variables.sharedVariables.reomveTimeFrom(date: endDateReport ?? Date()))
                rashodSumm = filteredArrayRashod?.sum(ofProperty: "summRashod") ?? 0.0
                
                filteredArrayZakaz = self.arrayZakaz.filter("(clearDateZakaz > %@ and clearDateZakaz < %@) or (clearDateZakaz = %@ or clearDateZakaz = %@)",
                                                         Variables.sharedVariables.reomveTimeFrom(date: self.beginDateReport ?? Date()),
                                                         Variables.sharedVariables.reomveTimeFrom(date: self.endDateReport ?? Date()),
                                                         Variables.sharedVariables.reomveTimeFrom(date: self.beginDateReport ?? Date()),
                                                         Variables.sharedVariables.reomveTimeFrom(date: self.endDateReport ?? Date()))
                
            //Месяц
            case 2:
                //Запрос на получение общей суммы
                filteredArrayZakaz = arrayZakaz.filter("(clearDateZakaz > %@ and clearDateZakaz < %@) or (clearDateZakaz = %@ or clearDateZakaz = %@)",
                                                       Variables.sharedVariables.reomveTimeFrom(date: beginDateReport ?? Date()),
                                                       Variables.sharedVariables.reomveTimeFrom(date: endDateReport ?? Date()),
                                                       Variables.sharedVariables.reomveTimeFrom(date: beginDateReport ?? Date()),
                                                       Variables.sharedVariables.reomveTimeFrom(date: endDateReport ?? Date()))
                totalSumm = filteredArrayZakaz?.sum(ofProperty: "summaZakaz") ?? 0.0
                totalCount = filteredArrayZakaz?.count ?? 0
                
                //Запрос на получение суммы с колёс
                filteredArrayZakaz = arrayZakaz.filter("((clearDateZakaz > %@ and clearDateZakaz < %@) or (clearDateZakaz = %@ or clearDateZakaz = %@)) and typeZakaz == %@",
                                                       Variables.sharedVariables.reomveTimeFrom(date: beginDateReport ?? Date()),
                                                       Variables.sharedVariables.reomveTimeFrom(date: endDateReport ?? Date()),
                                                       Variables.sharedVariables.reomveTimeFrom(date: beginDateReport ?? Date()),
                                                       Variables.sharedVariables.reomveTimeFrom(date: endDateReport ?? Date()),
                                                       3)
                wheelSumm = filteredArrayZakaz?.sum(ofProperty: "summaZakaz") ?? 0.0
                wheelCount = filteredArrayZakaz?.count ?? 0
                
                //Запрос на получение суммы с заказов
                filteredArrayZakaz = arrayZakaz.filter("((clearDateZakaz > %@ and clearDateZakaz < %@) or (clearDateZakaz = %@ or clearDateZakaz = %@)) and (typeZakaz == %@ or typeZakaz == %@)",
                                                       Variables.sharedVariables.reomveTimeFrom(date: beginDateReport ?? Date()),
                                                       Variables.sharedVariables.reomveTimeFrom(date: endDateReport ?? Date()),
                                                       Variables.sharedVariables.reomveTimeFrom(date: beginDateReport ?? Date()),
                                                       Variables.sharedVariables.reomveTimeFrom(date: endDateReport ?? Date()),
                                                       2,
                                                       1)
                zakazSumma = filteredArrayZakaz?.sum(ofProperty: "summaZakaz") ?? 0.0
                zakazCount = filteredArrayZakaz?.count ?? 0
                
                //Запрос на получение суммы с заказа с безнала
                filteredArrayZakaz = arrayZakaz.filter("((clearDateZakaz > %@ and clearDateZakaz < %@) or (clearDateZakaz = %@ or clearDateZakaz = %@)) and typeZakaz == %@",
                                                       Variables.sharedVariables.reomveTimeFrom(date: beginDateReport ?? Date()),
                                                       Variables.sharedVariables.reomveTimeFrom(date: endDateReport ?? Date()),
                                                       Variables.sharedVariables.reomveTimeFrom(date: beginDateReport ?? Date()),
                                                       Variables.sharedVariables.reomveTimeFrom(date: endDateReport ?? Date()),
                                                       0)
                beznalSumm = filteredArrayZakaz?.sum(ofProperty: "summaZakaz") ?? 0.0
                beznalCount = filteredArrayZakaz?.count ?? 0
                
                //Запрос на получение расходов
                filteredArrayRashod = arrayRashod.filter("(clearDateRashod > %@ and clearDateRashod < %@) or (clearDateRashod = %@ or clearDateRashod = %@)",
                                                         Variables.sharedVariables.reomveTimeFrom(date: beginDateReport ?? Date()),
                                                         Variables.sharedVariables.reomveTimeFrom(date: endDateReport ?? Date()),
                                                         Variables.sharedVariables.reomveTimeFrom(date: beginDateReport ?? Date()),
                                                         Variables.sharedVariables.reomveTimeFrom(date: endDateReport ?? Date()))
                rashodSumm = filteredArrayRashod?.sum(ofProperty: "summRashod") ?? 0.0
                
                filteredArrayZakaz = self.arrayZakaz.filter("(clearDateZakaz > %@ and clearDateZakaz < %@) or (clearDateZakaz = %@ or clearDateZakaz = %@)",
                                                        Variables.sharedVariables.reomveTimeFrom(date: self.beginDateReport ?? Date()),
                                                        Variables.sharedVariables.reomveTimeFrom(date: self.endDateReport ?? Date()),
                                                        Variables.sharedVariables.reomveTimeFrom(date: self.beginDateReport ?? Date()),
                                                        Variables.sharedVariables.reomveTimeFrom(date: self.endDateReport ?? Date()))
            //Год
            case 3:
                
                //Запрос на получение общей суммы
                filteredArrayZakaz = arrayZakaz.filter("(clearDateZakaz > %@ and clearDateZakaz < %@) or (clearDateZakaz = %@ or clearDateZakaz = %@)",
                                                       Variables.sharedVariables.reomveTimeFrom(date: beginDateReport ?? Date()),
                                                       Variables.sharedVariables.reomveTimeFrom(date: endDateReport ?? Date()),
                                                       Variables.sharedVariables.reomveTimeFrom(date: beginDateReport ?? Date()),
                                                       Variables.sharedVariables.reomveTimeFrom(date: endDateReport ?? Date()))
                totalSumm = filteredArrayZakaz?.sum(ofProperty: "summaZakaz") ?? 0.0
                totalCount = filteredArrayZakaz?.count ?? 0
                
                //Запрос на получение суммы с колёс
                filteredArrayZakaz = arrayZakaz.filter("((clearDateZakaz > %@ and clearDateZakaz < %@) or (clearDateZakaz = %@ or clearDateZakaz = %@)) and typeZakaz == %@",
                                                       Variables.sharedVariables.reomveTimeFrom(date: beginDateReport ?? Date()),
                                                       Variables.sharedVariables.reomveTimeFrom(date: endDateReport ?? Date()),
                                                       Variables.sharedVariables.reomveTimeFrom(date: beginDateReport ?? Date()),
                                                       Variables.sharedVariables.reomveTimeFrom(date: endDateReport ?? Date()),
                                                       3)
                wheelSumm = filteredArrayZakaz?.sum(ofProperty: "summaZakaz") ?? 0.0
                wheelCount = filteredArrayZakaz?.count ?? 0
                
                //Запрос на получение суммы с заказов
                filteredArrayZakaz = arrayZakaz.filter("((clearDateZakaz > %@ and clearDateZakaz < %@) or (clearDateZakaz = %@ or clearDateZakaz = %@)) and (typeZakaz == %@ or typeZakaz == %@)",
                                                       Variables.sharedVariables.reomveTimeFrom(date: beginDateReport ?? Date()),
                                                       Variables.sharedVariables.reomveTimeFrom(date: endDateReport ?? Date()),
                                                       Variables.sharedVariables.reomveTimeFrom(date: beginDateReport ?? Date()),
                                                       Variables.sharedVariables.reomveTimeFrom(date: endDateReport ?? Date()),
                                                       2,
                                                       1)
                zakazSumma = filteredArrayZakaz?.sum(ofProperty: "summaZakaz") ?? 0.0
                zakazCount = filteredArrayZakaz?.count ?? 0
                
                //Запрос на получение суммы с заказа с безнала
                filteredArrayZakaz = arrayZakaz.filter("((clearDateZakaz > %@ and clearDateZakaz < %@) or (clearDateZakaz = %@ or clearDateZakaz = %@)) and typeZakaz == %@",
                                                       Variables.sharedVariables.reomveTimeFrom(date: beginDateReport ?? Date()),
                                                       Variables.sharedVariables.reomveTimeFrom(date: endDateReport ?? Date()),
                                                       Variables.sharedVariables.reomveTimeFrom(date: beginDateReport ?? Date()),
                                                       Variables.sharedVariables.reomveTimeFrom(date: endDateReport ?? Date()),
                                                       0)
                beznalSumm = filteredArrayZakaz?.sum(ofProperty: "summaZakaz") ?? 0.0
                beznalCount = filteredArrayZakaz?.count ?? 0
                
                //Запрос на получение расходов
                filteredArrayRashod = arrayRashod.filter("(clearDateRashod > %@ and clearDateRashod < %@) or (clearDateRashod = %@ or clearDateRashod = %@)",
                                                         Variables.sharedVariables.reomveTimeFrom(date: beginDateReport ?? Date()),
                                                         Variables.sharedVariables.reomveTimeFrom(date: endDateReport ?? Date()),
                                                         Variables.sharedVariables.reomveTimeFrom(date: beginDateReport ?? Date()),
                                                         Variables.sharedVariables.reomveTimeFrom(date: endDateReport ?? Date()))
                rashodSumm = filteredArrayRashod?.sum(ofProperty: "summRashod") ?? 0.0
                
                filteredArrayZakaz = self.arrayZakaz.filter("(clearDateZakaz > %@ and clearDateZakaz < %@) or (clearDateZakaz = %@ or clearDateZakaz = %@)",
                                                         Variables.sharedVariables.reomveTimeFrom(date: self.beginDateReport ?? Date()),
                                                         Variables.sharedVariables.reomveTimeFrom(date: self.endDateReport ?? Date()),
                                                         Variables.sharedVariables.reomveTimeFrom(date: self.beginDateReport ?? Date()),
                                                         Variables.sharedVariables.reomveTimeFrom(date: self.endDateReport ?? Date()))
            //Период
            case 4:
                
                //Запрос на получение общей суммы
                filteredArrayZakaz = arrayZakaz.filter("(clearDateZakaz > %@ and clearDateZakaz < %@) or (clearDateZakaz = %@ or clearDateZakaz = %@)",
                                                       Variables.sharedVariables.reomveTimeFrom(date: beginDateReport ?? Date()),
                                                       Variables.sharedVariables.reomveTimeFrom(date: endDateReport ?? Date()),
                                                       Variables.sharedVariables.reomveTimeFrom(date: beginDateReport ?? Date()),
                                                       Variables.sharedVariables.reomveTimeFrom(date: endDateReport ?? Date()))
                totalSumm = filteredArrayZakaz?.sum(ofProperty: "summaZakaz") ?? 0.0
                totalCount = filteredArrayZakaz?.count ?? 0
                
                //Запрос на получение суммы с колёс
                filteredArrayZakaz = arrayZakaz.filter("((clearDateZakaz > %@ and clearDateZakaz < %@) or (clearDateZakaz = %@ or clearDateZakaz = %@)) and typeZakaz == %@",
                                                       Variables.sharedVariables.reomveTimeFrom(date: beginDateReport ?? Date()),
                                                       Variables.sharedVariables.reomveTimeFrom(date: endDateReport ?? Date()),
                                                       Variables.sharedVariables.reomveTimeFrom(date: beginDateReport ?? Date()),
                                                       Variables.sharedVariables.reomveTimeFrom(date: endDateReport ?? Date()),
                                                       3)
                wheelSumm = filteredArrayZakaz?.sum(ofProperty: "summaZakaz") ?? 0.0
                wheelCount = filteredArrayZakaz?.count ?? 0
                
                //Запрос на получение суммы с заказов
                filteredArrayZakaz = arrayZakaz.filter("((clearDateZakaz > %@ and clearDateZakaz < %@) or (clearDateZakaz = %@ or clearDateZakaz = %@)) and (typeZakaz == %@ or typeZakaz == %@)",
                                                       Variables.sharedVariables.reomveTimeFrom(date: beginDateReport ?? Date()),
                                                       Variables.sharedVariables.reomveTimeFrom(date: endDateReport ?? Date()),
                                                       Variables.sharedVariables.reomveTimeFrom(date: beginDateReport ?? Date()),
                                                       Variables.sharedVariables.reomveTimeFrom(date: endDateReport ?? Date()),
                                                       2,
                                                       1)
                zakazSumma = filteredArrayZakaz?.sum(ofProperty: "summaZakaz") ?? 0.0
                zakazCount = filteredArrayZakaz?.count ?? 0
                
                //Запрос на получение суммы с заказа с безнала
                filteredArrayZakaz = arrayZakaz.filter("((clearDateZakaz > %@ and clearDateZakaz < %@) or (clearDateZakaz = %@ or clearDateZakaz = %@)) and typeZakaz == %@",
                                                       Variables.sharedVariables.reomveTimeFrom(date: beginDateReport ?? Date()),
                                                       Variables.sharedVariables.reomveTimeFrom(date: endDateReport ?? Date()),
                                                       Variables.sharedVariables.reomveTimeFrom(date: beginDateReport ?? Date()),
                                                       Variables.sharedVariables.reomveTimeFrom(date: endDateReport ?? Date()),
                                                       0)
                beznalSumm = filteredArrayZakaz?.sum(ofProperty: "summaZakaz") ?? 0.0
                beznalCount = filteredArrayZakaz?.count ?? 0
                
                //Запрос на получение расходов
                filteredArrayRashod = arrayRashod.filter("(clearDateRashod > %@ and clearDateRashod < %@) or (clearDateRashod = %@ or clearDateRashod = %@)",
                                                         Variables.sharedVariables.reomveTimeFrom(date: beginDateReport ?? Date()),
                                                         Variables.sharedVariables.reomveTimeFrom(date: endDateReport ?? Date()),
                                                         Variables.sharedVariables.reomveTimeFrom(date: beginDateReport ?? Date()),
                                                         Variables.sharedVariables.reomveTimeFrom(date: endDateReport ?? Date()))
                rashodSumm = filteredArrayRashod?.sum(ofProperty: "summRashod") ?? 0.0
                
                filteredArrayZakaz = self.arrayZakaz.filter("(clearDateZakaz > %@ and clearDateZakaz < %@) or (clearDateZakaz = %@ or clearDateZakaz = %@)",
                                                         Variables.sharedVariables.reomveTimeFrom(date: self.beginDateReport ?? Date()),
                                                         Variables.sharedVariables.reomveTimeFrom(date: self.endDateReport ?? Date()),
                                                         Variables.sharedVariables.reomveTimeFrom(date: self.beginDateReport ?? Date()),
                                                         Variables.sharedVariables.reomveTimeFrom(date: self.endDateReport ?? Date()))
            //Смена
            case 5:
                
                filteredArraySmena = arraySmena.filter("id = %@",arraySmena[smenaPickerView.selectedRow(inComponent: 0)].id)
                let idSmena: String = arraySmena[smenaPickerView.selectedRow(inComponent: 0)].id
                
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
                
                //Запрос на получение суммы с заказа с безнала
                filteredArrayZakaz = arrayZakaz.filter("idSmena == %@ and typeZakaz == %@",idSmena,0)
                beznalSumm = filteredArrayZakaz?.sum(ofProperty: "summaZakaz") ?? 0.0
                beznalCount = filteredArrayZakaz?.count ?? 0
                
                //Запрос на получение расходов
                filteredArrayRashod = arrayRashod.filter("(dateRashod > %@ and dateRashod < %@) or (dateRashod = %@ or dateRashod = %@)",
                                                         filteredArraySmena.first!.startDateSmena, filteredArraySmena.first!.endDateSmena ?? Date(),
                                                         filteredArraySmena.first!.startDateSmena,filteredArraySmena.first!.endDateSmena ?? Date())
                rashodSumm = filteredArrayRashod?.sum(ofProperty: "summRashod") ?? 0.0
                
                //Запрос на получение заказов
                filteredArrayZakaz = self.arrayZakaz.filter("idSmena == %@",idSmena)
                
            default:
                return
            }
            
            completion()
        }
    }
    
    func selectRow(atIndexPath indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
    }
    
    func getIndexPathSelectedRow() -> IndexPath {
        self.selectedIndexPath!
    }
    
    func getAlert() -> UIAlertController {
        return globalAlert
    }
    
    func setDatePicker(datePickerView: UIDatePicker) {
        self.datePicker = datePickerView
    }
    
    func getBeginDate() -> Date {
        return beginDateReport ?? Date()
    }
    
    func getEndDate() -> Date {
        return endDateReport ?? Date()
    }
    
    func getTotalCount() -> Int {
        return totalCount
    }
    
    func getTotalSumm() -> Double {
        return totalSumm
    }
    
    func getWheelCount() -> Int {
        return wheelCount
    }
    
    func getWheelSumm() -> Double {
        return wheelSumm
    }
    
    func getZakatCount() -> Int {
        return zakazCount
    }
    
    func getZakazSumm() -> Double {
        return zakazSumma
    }
    
    func getBeznalCount() -> Int {
        return beznalCount
    }
    
    func getBeznalSumm() -> Double {
        return beznalSumm
    }
    
    func getFilteredZakaz() -> Results<Zakaz> {
        return filteredArrayZakaz
    }
    
    func getFilteredRashod() -> Results<Rashod> {
        return filteredArrayRashod
    }
    
    func getRashodSumm() -> Double {
        return rashodSumm
    }
    
    func getBallansSumm() -> Double {
        return totalSumm - rashodSumm
    }
    
    //Функция получения ячейки
    func cellViewModelZakaz(forIndexPath indexPath: IndexPath) -> ReportZakazCellViewModelType? {
        var zakaz = Zakaz()
        zakaz = filteredArrayZakaz![indexPath.row]
        return ReportZakazCellViewModel(zakaz: zakaz)
    }
    
    //Функция получения ячейки
    func cellViewModelRashod(forIndexPath indexPath: IndexPath) -> ReportRashodCellViewModelType? {
        var rashod = Rashod()
        rashod = filteredArrayRashod![indexPath.row]
        return ReportRashodCellViewModel(rashod: rashod)
    }
    
    func addAlertDeleteZakaz(title: String, message: String, indexPath: IndexPath?, completion: @escaping ()->()) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))
            
        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: {action in
            guard let indexPath = indexPath else {return}
            self.returnScoreAccount(indexPath: indexPath, editMode: false)
            StorageManager.deleteZakaz(id: self.filteredArrayZakaz[indexPath.row].id)
            completion()
        }))
        
        return alert
    }
    
    func addInformationAlert(title: String, message: String, completion: @escaping ()->()) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ок", style: UIAlertAction.Style.cancel, handler: {action in
            completion()
        }))
        
        return alert
    }
    
    func alertAddZakaz(editMode: Bool, indexPath: IndexPath, datePicker: UIDatePicker, pickerView: UIPickerView, complection: @escaping (Int) -> ()) -> UIAlertController {
        
        let settingsArray = realm.objects(Settings.self).filter("idAccount == %@",Variables.sharedVariables.idAccount)
        
        //Показать алерт добавления новой учетной записи
        let alert = UIAlertController(title: "Редактирование записи", message: nil, preferredStyle: .alert)
        //Настройка строки для ввода наименования расхода
        alert.addTextField(configurationHandler: { textField1 in
            textField1.clearButtonMode = .whileEditing
            textField1.autocapitalizationType = .sentences
            textField1.keyboardType = .default
            textField1.clearButtonMode = .never
            textField1.placeholder = "Тип заказа"
            textField1.textAlignment = .center
            textField1.borderStyle = UITextField.BorderStyle.roundedRect
            textField1.inputView = pickerView
            pickerView.selectRow(self.filteredArrayZakaz[indexPath.row].typeZakaz , inComponent: 0, animated: true)
            textField1.text = self.typeZakazPickerOption[pickerView.selectedRow(inComponent: 0)]
            textField1.font = UIFont.boldSystemFont(ofSize: 17.0)
        })
        
        //Настройка строки для ввода суммы расхода
        alert.addTextField(configurationHandler: { textField2 in
            textField2.placeholder = "Сумма"
            textField2.textAlignment = .center
            textField2.borderStyle = UITextField.BorderStyle.roundedRect
            textField2.keyboardType = .decimalPad
            textField2.clearButtonMode = .whileEditing
            textField2.text = String(self.filteredArrayZakaz[indexPath.row].summaZakaz)
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
                textField3.clearButtonMode = .never
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
                textField3.text = dateFormatter.string(from: self.filteredArrayZakaz[indexPath.row].dateZakaz)
                datePicker.setDate(self.filteredArrayZakaz[indexPath.row].dateZakaz, animated: true)
            })
        }
        
        //Обработчик кнопки добавления записи
        alert.addAction(UIAlertAction(title: "Сохранить изменения", style: .default, handler: { action in
            
            //Если первое поле ввода (Наименование учетной записи) не пустое
            let score: String = ((alert.textFields?[1].text!)?.replacingOccurrences(of: ",", with: "."))!
                if !(alert.textFields?[0].text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! {
                    
                    let idSmena = self.arrayZakaz[indexPath.row].idSmena
                    
                    self.returnScoreAccount(indexPath: indexPath, editMode: editMode)
                    
                    //0 - Безнал, 1 - Заказ, 2 - Заказ с процентом, 3 - С колёс
                    switch pickerView.selectedRow(inComponent: 0) {
                    case 0:
                        
                        let doubleScore = Double(score)
                        let currentScore = Variables.sharedVariables.scoreAccount
                        let settingsScore = settingsArray.first!.summZakaz
                        let account = Accounts()
                        account.nameAccount = Variables.sharedVariables.currentAccountName
                        account.scoreAccount = currentScore + doubleScore! - settingsScore
                        account.id = Variables.sharedVariables.idAccount
                        StorageManager.saveAccount(account)
                        Variables.sharedVariables.scoreAccount = currentScore + doubleScore! - settingsScore
                        
                    case 1:
                        let currentScore = Variables.sharedVariables.scoreAccount
                        let settingsScore = settingsArray.first!.summZakaz
                        Variables.sharedVariables.scoreAccount = currentScore - settingsScore
                        
                        let account = Accounts()
                        account.nameAccount = Variables.sharedVariables.currentAccountName
                        account.scoreAccount = currentScore - settingsScore
                        account.id = Variables.sharedVariables.idAccount
                        StorageManager.saveAccount(account)
                        
                    case 2:
                        let doubleScore = Double(score)
                        let currentScore = Variables.sharedVariables.scoreAccount
                        let settingsScore = settingsArray.first!.percentZakaz
                        let itog = String(format: "%.2f", currentScore - (doubleScore!/100 * Double(settingsScore)))
                        Variables.sharedVariables.scoreAccount = Double(itog)!
                        
                        let account = Accounts()
                        account.nameAccount = Variables.sharedVariables.currentAccountName
                        account.scoreAccount = Double(itog)!
                        account.id = Variables.sharedVariables.idAccount
                        StorageManager.saveAccount(account)

                    default:
                        break
                    }

                    let zakaz = Zakaz()
                    zakaz.typeZakaz = pickerView.selectedRow(inComponent: 0)
                    zakaz.summaZakaz = Double(score) ?? 0.0
                    zakaz.idAccount = Variables.sharedVariables.idAccount
                    zakaz.idSmena = idSmena
                    if editMode {
                        if !(alert.textFields?[2].text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! {
                            zakaz.dateZakaz = datePicker.date
                            zakaz.clearDateZakaz = Variables.sharedVariables.reomveTimeFrom(date: datePicker.date)
                        } else {
                            zakaz.dateZakaz = self.arrayRashod[(indexPath.row)].dateRashod
                            zakaz.clearDateZakaz = Variables.sharedVariables.reomveTimeFrom(date: self.filteredArrayZakaz[(indexPath.row)].dateZakaz)
                        }
                    }
                    StorageManager.saveZakaz(zakaz)
                    complection(0)
                } else {
                    complection(1)
                }
            
            
        }))
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .destructive, handler: nil))
        self.globalAlert = alert
        
        return alert
    }
    
    func getFilteredSmena() -> Results<Smena> {
        return filteredArraySmena
    }
    
    func getArraySmena() -> Results<Smena> {
        return realm.objects(Smena.self).filter("idAccount == %@",Variables.sharedVariables.idAccount).sorted(byKeyPath: "startDateSmena")
    }
    
    func getTypeZakazPickerOption() -> [String] {
        return typeZakazPickerOption
    }
    
    func getPickOption() -> [String] {
        return pickOption
    }
    
    func returnScoreAccount(indexPath: IndexPath, editMode: Bool) {
        let settingsArray = realm.objects(Settings.self).filter("idAccount == %@",Variables.sharedVariables.idAccount)
        
        switch self.arrayZakaz[indexPath.row].typeZakaz {
        case 0:
            self.arrayZakaz = realm.objects(Zakaz.self).filter("idAccount == %@",Variables.sharedVariables.idAccount).sorted(byKeyPath: "dateZakaz")
            let currentScore = Variables.sharedVariables.scoreAccount
            let settingsScore = settingsArray.first!.summZakaz
            let account = Accounts()
            account.nameAccount = Variables.sharedVariables.currentAccountName
            let doubleScore = self.arrayZakaz[indexPath.row].summaZakaz
            account.scoreAccount = currentScore - doubleScore + settingsScore
            account.id = Variables.sharedVariables.idAccount
            StorageManager.saveAccount(account)
            Variables.sharedVariables.scoreAccount = currentScore - doubleScore + settingsScore
            
        case 1:
            let currentScore = Variables.sharedVariables.scoreAccount
            let settingsScore = settingsArray.first!.summZakaz
            Variables.sharedVariables.scoreAccount = currentScore + settingsScore
            
            let account = Accounts()
            account.nameAccount = Variables.sharedVariables.currentAccountName
            account.scoreAccount = currentScore + settingsScore
            account.id = Variables.sharedVariables.idAccount
            StorageManager.saveAccount(account)
            Variables.sharedVariables.scoreAccount = currentScore + settingsScore
            
            
        case 2:
            let doubleScore = self.arrayZakaz[indexPath.row].summaZakaz
            let currentScore = Variables.sharedVariables.scoreAccount
            let settingsScore = settingsArray.first!.percentZakaz
            let itog = String(format: "%.2f", currentScore + (doubleScore/100 * Double(settingsScore)))
            Variables.sharedVariables.scoreAccount = Double(itog)!
            
            let account = Accounts()
            account.nameAccount = Variables.sharedVariables.currentAccountName
            account.scoreAccount = Double(itog)!
            account.id = Variables.sharedVariables.idAccount
            StorageManager.saveAccount(account)
            Variables.sharedVariables.scoreAccount = Double(itog)!
        default:
            break
        }
        
        if editMode {
            StorageManager.deleteZakaz(id: self.filteredArrayZakaz[(indexPath.row)].id)
        }
    }

}
