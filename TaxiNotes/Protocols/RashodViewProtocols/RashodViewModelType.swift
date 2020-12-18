//
//  RashodViewModelType.swift
//  TaxiNotes
//
//  Created by Денис Винокуров on 20.11.2019.
//  Copyright © 2019 Денис Винокуров. All rights reserved.
//

import UIKit
import RealmSwift

protocol RashodViewModelType {
    
    func alertAddRashod(editMode: Bool, indexPath: IndexPath?, nameRashod: String?, datePicker: UIDatePicker, pickerView: UIPickerView, complection: @escaping (Int)->()) -> UIAlertController
    func addDeleteRashodAlert(indexPath: IndexPath, complection: @escaping ()->()) -> UIAlertController
    func cloneRashod(indexPath: IndexPath, complection: @escaping ()->())
    func numberOfRows() -> Int
    func cellViewModel(forIndexPath indexPath: IndexPath) -> RashodViewCellViewModelType?
    func selectRow(atIndexPath indexPath: IndexPath)
    func getCountRashod() -> Int
    func getAlert() -> UIAlertController
    func getPickOption(row: Int) -> String
    func getPickOptionCount() -> Int
    func getIndexPathSelectedRow() -> IndexPath
    func addInformationAlert(title: String, message: String, complection: @escaping ()->()) -> UIAlertController
    
}
