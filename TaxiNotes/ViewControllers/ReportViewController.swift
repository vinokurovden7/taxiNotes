//
//  ReportViewController.swift
//  TaxiNotes
//
//  Created by Денис Винокуров on 03.11.2019.
//  Copyright © 2019 Денис Винокуров. All rights reserved.
//

import UIKit

import SwipeCellKit



class ReportViewController: UIViewController {
    
    
    //MARK: IBOutlets:
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
    @IBOutlet weak var changePeriodBtnItem: UIBarButtonItem!
    @IBOutlet weak var logoutBtn: UIBarButtonItem!
    @IBOutlet weak var dohodLabel: UILabel!
    @IBOutlet weak var rashodLabel: UILabel!
    @IBOutlet weak var ballansLabel: UILabel!
    
    //MARK: Private properties:
    private var arrayBarButtons: [UIBarButtonItem] = []
    private var viewModel: ReportViewModelType?
    private var typeReport: Int = 0 // 0 - день 1 - неделя 2 - месяц 3 - год 4 - период 5 - смена
    private var globalAlert: UIAlertController?
    private var datePicker:UIDatePicker = UIDatePicker()
    private var zakazDatePicker:UIDatePicker = UIDatePicker()
    private var zakazPickerView = UIPickerView()
    private var periodPickerView = UIPickerView()
    private var smenaPickerView = UIPickerView()
    
    //MARK: Init:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = ReportViewModel()
        
        arrayBarButtons.append(changePeriodBtnItem)
        arrayBarButtons.append(logoutBtn)
        Variables.sharedVariables.changeThemeViewController(viewController: self, arrayBarButtons: arrayBarButtons)
        navigationItem.title = Variables.sharedVariables.currentAccountName
        
        //Настройка компонента DatePicker
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(ReportViewController.dateChanged(datePicker:)), for: .valueChanged)
        zakazDatePicker.datePickerMode = .dateAndTime
        zakazDatePicker.addTarget(self, action: #selector(ReportViewController.zakazDateChanged(datePicker:)), for: .valueChanged)
        //Настройка компонента Picker
        periodPickerView.delegate = self
        smenaPickerView.delegate = self
        zakazPickerView.delegate = self
        
        viewModel?.updateStatistic(typeReport: 0, completion: {
            self.updateLabel()
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel?.updateStatistic(typeReport: 0, completion: {
            self.updateLabel()
        })
    }
    
    //MARK: View Controller func:
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        Variables.sharedVariables.changeThemeViewController(viewController: self, arrayBarButtons: arrayBarButtons)
    }
    
    @IBAction func changePeriodBtnAction(_ sender: UIBarButtonItem) {
        if self.viewModel!.getArraySmena().count > 0 {
            self.viewModel?.setDatePicker(datePickerView: self.datePicker)
            self.present((self.viewModel?.alertSetPeriod(typeReport: typeReport, periodPickerView: self.periodPickerView, smenaPickerView: self.smenaPickerView, completion: {
                self.updateLabel()
            }))!, animated: true)
        }
    }
    
    //Обработчик события изменения даты в DateTimePicker
    @objc func zakazDateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        //Если в режиме редактирования второе поле (конечная дата)
        if ((self.viewModel?.getAlert().textFields![2].isEditing)!){
            self.viewModel?.getAlert().textFields![2].text = dateFormatter.string(from: datePicker.date)
        }
    }
    
    //Обработчик события изменения даты в DatePicker
    @objc func dateChanged(datePicker: UIDatePicker){
        self.viewModel?.dateSetter(typeReport: typeReport)
    }
    
    //Обновление статистики
    func updateLabel(){
        let dateFormatter = DateFormatter()
        switch typeReport {
        //День
        case 0:
            timePeriodLabel.isHidden = true
            dateFormatter.dateFormat = "dd.MM.yyyy"
            periodReportLabel.text = "Отчет за \(dateFormatter.string(from: self.viewModel?.getBeginDate() ?? Date()))"
            
        //Неделя
        case 1:
            timePeriodLabel.isHidden = true
            dateFormatter.dateFormat = "dd.MM.yyyy"
            periodReportLabel.text = "Отчет c \(dateFormatter.string(from: self.viewModel?.getBeginDate() ?? Date())) по \(dateFormatter.string(from: self.viewModel?.getEndDate() ?? Date())) г."

        //Месяц
        case 2:
            timePeriodLabel.isHidden = true
            dateFormatter.dateFormat = "LLLL yyyy"
            periodReportLabel.text = "Отчет за \(dateFormatter.string(from: self.viewModel?.getBeginDate() ?? Date())) г."
    
        //Год
        case 3:
            timePeriodLabel.isHidden = true
            dateFormatter.dateFormat = "yyyy"
            periodReportLabel.text = "Отчет за \(dateFormatter.string(from: self.viewModel?.getBeginDate() ?? Date())) г."

        //Период
        case 4:
            timePeriodLabel.isHidden = true
            dateFormatter.dateFormat = "dd.MM.yyyy"
            periodReportLabel.text = "Отчет c \(dateFormatter.string(from: self.viewModel?.getBeginDate() ?? Date())) по \(dateFormatter.string(from: self.viewModel?.getEndDate() ?? Date())) г."
            
        //Смена
        case 5:
            timePeriodLabel.isHidden = false
            dateFormatter.dateFormat = "dd.MM.yyyy"
            periodReportLabel.text = "Смена \(dateFormatter.string(from: (self.viewModel?.getFilteredSmena().first!.startDateSmena)!)) - \(dateFormatter.string(from: (self.viewModel?.getFilteredSmena().first!.endDateSmena ?? Date())!))"
            dateFormatter.dateFormat = "HH:mm"
            timePeriodLabel.text = "\(dateFormatter.string(from: (self.viewModel?.getFilteredSmena().first!.startDateSmena)!)) - \(dateFormatter.string(from: (self.viewModel?.getFilteredSmena().first!.endDateSmena ?? Date())!))"
            
        default:
            return
        }
        
        //Заполнение полей
        totalZakazLabel.text = "Итого (\(self.viewModel?.getTotalCount() ?? 0)):"
        totalZakazSumm.text = "\(String(format: "%.2f", self.viewModel?.getTotalSumm() ?? 0.0)) ₽"
        
        dohodLabel.text = "Доход: \(String(format: "%.2f", self.viewModel?.getTotalSumm() ?? 0.0)) ₽"
        rashodLabel.text = "Расход: \(String(format: "%.2f", self.viewModel?.getRashodSumm() ?? 0.0)) ₽"
        ballansLabel.text = "Баланс: \(String(format: "%.2f", self.viewModel?.getBallansSumm() ?? 0.0)) ₽"
    
        wheelZakazLabel.text = "С колёс (\(self.viewModel?.getWheelCount() ?? 0)):"
        wheelZakazSumm.text = "\(String(format: "%.2f", self.viewModel?.getWheelSumm() ?? 0.0)) ₽"
    
        zakazLabel.text = "С заказов (\(self.viewModel?.getZakatCount() ?? 0)):"
        zakazSumm.text = "\(String(format: "%.2f", self.viewModel?.getZakazSumm() ?? 0.0)) ₽"
    
        beznalZakazLabel.text = "С безнала (\(self.viewModel?.getBeznalCount() ?? 0)):"
        beznalZakazSumm.text = "\(String(format: "%.2f", self.viewModel?.getBeznalSumm() ?? 0.0)) ₽"
        
        self.zakazTableView.reloadData()
        self.rashodTableView.reloadData()
        
    }
    
    func errorCase(error: Int, editMode: Bool, indexPath: IndexPath, nameRashod: String?){
        switch error {
        case 0:
            self.viewModel?.updateStatistic(typeReport: self.typeReport, completion: {
                self.updateLabel()
            })
            self.zakazTableView.reloadData()
        case 1:
            self.present((self.viewModel?.addInformationAlert(title: "Уведомление", message: "Заполните название расхода", completion: {
                self.present(((self.viewModel?.alertAddZakaz(editMode: true, indexPath: indexPath, datePicker: self.datePicker, pickerView: self.zakazPickerView, complection: { error in
                    self.errorCase(error: error, editMode: true, indexPath: indexPath, nameRashod: nil)
                }))!), animated: true, completion: nil)
            }))!, animated: true)
        default:
            break
        }
    }

}

//MARK: Extension:
extension ReportViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    //Изменение значения picker
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case periodPickerView:
            if ((self.viewModel?.getAlert().textFields![0].isEditing)!){
                self.viewModel?.getAlert().textFields![0].text = self.viewModel!.getPickOption()[row]
                typeReport = row
                self.viewModel?.getAlert().dismiss(animated: true, completion: nil)
                
                self.viewModel?.setDatePicker(datePickerView: self.datePicker)
                self.present((self.viewModel?.alertSetPeriod(typeReport: typeReport, periodPickerView: self.periodPickerView, smenaPickerView: self.smenaPickerView, completion: {
                    self.updateLabel()
                }))!, animated: true)
                
            }
        case smenaPickerView:
            if ((self.viewModel?.getAlert().textFields![1].isEditing)!){
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd.MM.yy HH:mm"
                self.viewModel?.getAlert().textFields![1].text = "\(dateFormatter.string(from: self.viewModel!.getArraySmena()[self.smenaPickerView.selectedRow(inComponent: 0)].startDateSmena)) - \(dateFormatter.string(from: self.viewModel!.getArraySmena()[self.smenaPickerView.selectedRow(inComponent: 0)].endDateSmena ?? Date()))"
            }
        case zakazPickerView:
            self.viewModel?.getAlert().textFields![0].text = self.viewModel?.getTypeZakazPickerOption()[pickerView.selectedRow(inComponent: 0)]
        default:
            return
        }
    }
    
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
                dateFormatter.dateFormat = "(EE) dd.MM.yy HH:mm"
            } else {
                dateFormatter.dateFormat = "(EEEE) dd.MM.yy HH:mm"
            }
            pickerLabel?.text = "\(dateFormatter.string(from: self.viewModel!.getArraySmena()[row].startDateSmena)) - \(dateFormatter.string(from: self.viewModel!.getArraySmena()[row].endDateSmena ?? Date()))"
        case zakazPickerView:
            if pickerLabel == nil {
                pickerLabel = UILabel()
                pickerLabel?.font = UIFont(name: "Arial Rounded MT Bold", size: 25.0)
                pickerLabel?.textAlignment = .center
            }
            pickerLabel?.text = self.viewModel!.getTypeZakazPickerOption()[row]
        default:
            if pickerLabel == nil {
                pickerLabel = UILabel()
                pickerLabel?.font = UIFont(name: "Arial Rounded MT Bold", size: 25.0)
                pickerLabel?.textAlignment = .center
            }
            pickerLabel?.text = self.viewModel!.getPickOption()[row]
        }

        return pickerLabel!
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case smenaPickerView:
            return self.viewModel!.getArraySmena().count
        case zakazPickerView:
            return self.viewModel!.getTypeZakazPickerOption().count
        default:
            return self.viewModel!.getPickOption().count
        }
    }
}

extension ReportViewController: UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
        
        if orientation == .right && tableView == zakazTableView {
        
            let editRashod = SwipeAction(style: .destructive, title: "Редактировать", handler: {(action, indexPath) -> Void in
                self.present(((self.viewModel?.alertAddZakaz(editMode: true, indexPath: indexPath, datePicker: self.zakazDatePicker, pickerView: self.zakazPickerView, complection: { error in
                    self.errorCase(error: error, editMode: true, indexPath: indexPath, nameRashod: nil)
                }))!), animated: true, completion: nil)
            })
            editRashod.hidesWhenSelected = true
            editRashod.backgroundColor = UIColor.init(red: 10/255, green: 91/255, blue: 255/255, alpha: 255/255)
            editRashod.image = UIImage(systemName: "square.and.pencil")
            editRashod.textColor = UIColor.white
            editRashod.font = UIFont.boldSystemFont(ofSize: 10.0)

            let deleteRashod = SwipeAction(style: .destructive, title: "Удалить", handler: {(action, indexPath) -> Void in
                
                self.present((self.viewModel?.addAlertDeleteZakaz(title: "Подтверждение удаления", message: "Вы действительно хотите удалить запись '\(self.viewModel!.getTypeZakazPickerOption()[ (self.viewModel?.getFilteredZakaz()[indexPath.row].typeZakaz)!])'?", indexPath: indexPath, completion: {
                    self.zakazTableView.deleteRows(at: [indexPath], with: .middle)
                    self.viewModel?.updateStatistic(typeReport: self.typeReport, completion: {
                        self.updateLabel()
                    })
                }))!, animated: true, completion: nil)
                
            })
            deleteRashod.hidesWhenSelected = true
            deleteRashod.backgroundColor = UIColor.init(red: 252/255, green: 30/255, blue: 28/255, alpha: 255/255)
            deleteRashod.textColor = UIColor.white
            deleteRashod.font = UIFont.boldSystemFont(ofSize: 10.0)
            deleteRashod.image = UIImage(systemName: "trash")
            
            return [deleteRashod, editRashod]
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch tableView {
        case zakazTableView:
            return self.viewModel?.getFilteredZakaz().count ?? 0
        case rashodTableView:
            return self.viewModel?.getFilteredRashod().count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        switch tableView {
        case zakazTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "zakazTableCell") as? zakazReportCell
            guard let tableViewCell = cell, let viewModel = viewModel else { return UITableViewCell() }

            let cellViewModel = viewModel.cellViewModelZakaz(forIndexPath: indexPath)
            tableViewCell.viewModel = cellViewModel

            tableViewCell.dateZakazLabel.text = dateFormatter.string(from: self.viewModel?.getFilteredZakaz()[indexPath.row].dateZakaz ?? Date())
            tableViewCell.delegate = self
            return tableViewCell
        case rashodTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "rashodTableCell") as? rashodReportCell
            guard let tableViewCell = cell, let viewModel = viewModel else { return UITableViewCell() }
            let cellViewModel = viewModel.cellViewModelRashod(forIndexPath: indexPath)
            tableViewCell.viewModel = cellViewModel
            return tableViewCell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "zakazTableCell") as? zakazReportCell
            guard let tableViewCell = cell, let viewModel = viewModel else { return UITableViewCell() }

            let cellViewModel = viewModel.cellViewModelZakaz(forIndexPath: indexPath)
            tableViewCell.viewModel = cellViewModel

            tableViewCell.dateZakazLabel.text = dateFormatter.string(from: self.viewModel?.getFilteredZakaz()[indexPath.row].dateZakaz ?? Date())
            tableViewCell.delegate = self
            return tableViewCell
        }

    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        if tableView == self.zakazTableView {
           let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { actions -> UIMenu? in
                
                    let deleteAction = UIAction(title: "Удалить", image: UIImage(systemName: "trash"), identifier: nil, attributes: .destructive) { action in
                        //self.viewModel?.returnScoreAccount(indexPath: indexPath)
                        self.present((self.viewModel?.addAlertDeleteZakaz(title: "Подтверждение удаления", message: "Вы действительно хотите удалить запись '\(self.viewModel!.getTypeZakazPickerOption()[ self.viewModel?.getFilteredZakaz()[indexPath.row].typeZakaz ?? 0])'?", indexPath: indexPath, completion: {
                            self.zakazTableView.deleteRows(at: [indexPath], with: .middle)
                            self.viewModel?.updateStatistic(typeReport: self.typeReport, completion: {
                                self.updateLabel()
                            })
                        }))!, animated: true, completion: nil)
                        
                    }
                    
                    let editAction = UIAction(title: "Редактировать", image: UIImage(systemName: "square.and.pencil"), identifier: nil) { action in
                        self.present(((self.viewModel?.alertAddZakaz(editMode: true, indexPath: indexPath, datePicker: self.zakazDatePicker, pickerView: self.zakazPickerView, complection: { error in
                            self.errorCase(error: error, editMode: true, indexPath: indexPath, nameRashod: nil)
                        }))!), animated: true, completion: nil)
                        
                    }
                
                    return UIMenu(__title: "", image: nil, identifier: nil, children:[editAction,deleteAction])
            }
            return configuration
        } else {
            return nil
        }
        
    }
    
    
}


