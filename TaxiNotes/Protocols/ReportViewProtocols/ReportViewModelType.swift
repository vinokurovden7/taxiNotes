//
//  ReportViewModelType.swift
//  TaxiNotes
//
//  Created by Денис Винокуров on 21.11.2019.
//  Copyright © 2019 Денис Винокуров. All rights reserved.
//

import UIKit
import RealmSwift

protocol ReportViewModelType {
    
    func alertSetPeriod(typeReport: Int, periodPickerView: UIPickerView, smenaPickerView: UIPickerView, completion: @escaping ()->()) -> UIAlertController
    func dateSetter(typeReport: Int)
    func updateStatistic(typeReport: Int, completion: @escaping ()->())
    func selectRow(atIndexPath indexPath: IndexPath)
    func getIndexPathSelectedRow() -> IndexPath
    func getAlert() -> UIAlertController
    func setDatePicker(datePickerView: UIDatePicker)
    func getBeginDate() -> Date
    func getEndDate() -> Date
    func getTypeZakazPickerOption() -> [String]
    func getPickOption() -> [String]
    func getTotalCount() -> Int
    func getTotalSumm() -> Double
    func getWheelCount() -> Int
    func getWheelSumm() -> Double
    func getZakatCount() -> Int
    func getZakazSumm() -> Double
    func getBeznalCount() -> Int
    func getBeznalSumm() -> Double
    func getRashodSumm() -> Double
    func getBallansSumm() -> Double
    func getFilteredZakaz() -> Results<Zakaz>
    func getFilteredRashod() -> Results<Rashod>
    func getFilteredSmena() -> Results<Smena>
    func getArraySmena() -> Results<Smena>
    func cellViewModelZakaz(forIndexPath indexPath: IndexPath) -> ReportZakazCellViewModelType?
    func cellViewModelRashod(forIndexPath indexPath: IndexPath) -> ReportRashodCellViewModelType?
    func addAlertDeleteZakaz(title: String, message: String, indexPath: IndexPath?, completion: @escaping ()->()) -> UIAlertController
    func addInformationAlert(title: String, message: String, completion: @escaping ()->()) -> UIAlertController
    func alertAddZakaz(editMode: Bool, indexPath: IndexPath, datePicker: UIDatePicker, pickerView: UIPickerView, complection: @escaping (Int)->()) -> UIAlertController
}
