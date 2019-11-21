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


class RashodViewController: UIViewController {
    
    private var viewModel: RashodViewModelType?

    @IBOutlet weak var addRashodBtnItem: UIBarButtonItem!
    @IBOutlet weak var logoutBtn: UIBarButtonItem!
    @IBOutlet weak var addFuelRashodBtnItem: UIBarButtonItem!
    @IBOutlet weak var myTableViewRashod: UITableView!
    
    var datePicker:UIDatePicker = UIDatePicker()
    var pickerView = UIPickerView()
    private var arrayBarButtons: [UIBarButtonItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = RashodViewModel()
        
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
        //alertAddRashod(editMode: false, indexPath: nil, nameRashod: nil)
        self.present((viewModel?.alertAddRashod(editMode: false, indexPath: nil, nameRashod: nil, datePicker: datePicker, pickerView: pickerView, complection: { error in
            self.errorCase(error: error, editMode: false, indexPath: nil, nameRashod: nil)
        }))!, animated: true)
    }
    
    //Обработчик события изменения даты в DatePicker
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        //Если в режиме редактирования второе поле (конечная дата)
        if ((viewModel?.getAlert().textFields![2].isEditing)!){
            viewModel?.getAlert().textFields![2].text = dateFormatter.string(from: datePicker.date)
        }
    }
    
    //Обработчик кнопки добавления расхода
    @IBAction func fuelAddRashod(_ sender: UIBarButtonItem) {
        self.present((viewModel?.alertAddRashod(editMode: false, indexPath: nil, nameRashod: "Топливо", datePicker: self.datePicker, pickerView: self.pickerView, complection: { error in
            self.errorCase(error: error, editMode: false, indexPath: nil, nameRashod: "Топливо")
        }))!, animated: true)
    }
    
    //Изменение значения picker
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if ((viewModel?.getAlert().textFields![0].isEditing)!){
            viewModel?.getAlert().textFields![0].text = viewModel?.getPickOption(row: row)
        }
    }
    
    func errorCase(error: Int, editMode: Bool, indexPath: IndexPath?, nameRashod: String?){
        switch error {
        case 0:
            self.myTableViewRashod.reloadData()
        case 1:
            self.present((self.viewModel?.addInformationAlert(title: "Уведомление", message: "Заполните название расхода", complection: {
                self.present((self.viewModel?.alertAddRashod(editMode: editMode, indexPath: indexPath, nameRashod: nameRashod, datePicker: self.datePicker, pickerView: self.pickerView, complection: { error in
                    self.errorCase(error: error, editMode: editMode, indexPath: indexPath, nameRashod: nameRashod)
                }))!, animated: true)
            }))!, animated: true)            
        default:
            break
        }
    }
    
}

extension RashodViewController: UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate {

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

            let editRashod = SwipeAction(style: .destructive, title: "Редактировать", handler: {(action, indexPath) -> Void in
                self.present((self.viewModel?.alertAddRashod(editMode: true, indexPath: indexPath, nameRashod: nil, datePicker: self.datePicker, pickerView: self.pickerView, complection: { error in
                    self.errorCase(error: error, editMode: true, indexPath: indexPath, nameRashod: nil)
                }))!, animated: true, completion: nil)
            })
            editRashod.hidesWhenSelected = true
            editRashod.backgroundColor = UIColor.init(red: 10/255, green: 91/255, blue: 255/255, alpha: 255/255)
            editRashod.image = UIImage(systemName: "square.and.pencil")
            editRashod.textColor = UIColor.white
            editRashod.font = UIFont.boldSystemFont(ofSize: 10.0)

            let deleteRashod = SwipeAction(style: .destructive, title: "Удалить", handler: {(action, indexPath) -> Void in

                self.present((self.viewModel?.addDeleteRashodAlert(indexPath: indexPath, complection: {
                    self.myTableViewRashod.deleteRows(at: [indexPath], with: .middle)
                }))!, animated: true, completion: nil)

            })
            deleteRashod.hidesWhenSelected = true
            deleteRashod.backgroundColor = UIColor.init(red: 252/255, green: 30/255, blue: 28/255, alpha: 255/255)
            deleteRashod.textColor = UIColor.white
            deleteRashod.font = UIFont.boldSystemFont(ofSize: 10.0)
            deleteRashod.image = UIImage(systemName: "trash")

            return [deleteRashod, editRashod]
        } else {
            let cloneRashod = SwipeAction(style: .destructive, title: "Создать копию", handler: {(action, indexPath) -> Void in
                self.viewModel?.cloneRashod(indexPath: indexPath, complection: {
                    self.myTableViewRashod.reloadData()
                })
            })
            cloneRashod.hidesWhenSelected = true
            cloneRashod.backgroundColor = UIColor.init(red: 71/255, green: 186/255, blue: 251/255, alpha: 255/255)
            cloneRashod.image = UIImage(systemName: "doc.on.doc")
            cloneRashod.textColor = UIColor.white
            cloneRashod.font = UIFont.boldSystemFont(ofSize: 10.0)

            return [cloneRashod]
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayRashod.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rashodCell") as! RashodViewCell

        cell.delegate = self

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"

        cell.dateRashodLabel.text = dateFormatter.string(from: arrayRashod[indexPath.row].dateRashod)
        cell.nameRashodLabel.text = arrayRashod[indexPath.row].nameRashod
        cell.summRashodLabel.text = "\(arrayRashod[indexPath.row].summRashod) ₽"

        return cell
    }

    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
       let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { actions -> UIMenu? in

            let deleteAction = UIAction(title: "Удалить", image: UIImage(systemName: "trash"), identifier: nil, attributes: .destructive) { action in
                self.present((self.viewModel?.addDeleteRashodAlert(indexPath: indexPath, complection: {
                    self.myTableViewRashod.deleteRows(at: [indexPath], with: .middle)
                }))!, animated: true, completion: nil)
            }

            let editAction = UIAction(title: "Редактировать", image: UIImage(systemName: "square.and.pencil"), identifier: nil) { action in
                self.present((self.viewModel?.alertAddRashod(editMode: true, indexPath: indexPath, nameRashod: nil, datePicker: self.datePicker, pickerView: self.pickerView, complection: { error in
                    self.errorCase(error: error, editMode: true, indexPath: indexPath, nameRashod: nil)
                }))!, animated: true, completion: nil)
            }

            let cloneRashod = UIAction(title: "Создать копию", image: UIImage(systemName: "doc.on.doc"), identifier: nil) { action in
                self.viewModel?.cloneRashod(indexPath: indexPath, complection: {
                    self.myTableViewRashod.reloadData()
                })
            }

            let moreActions = UIMenu(__title: "Еще...", image: UIImage(systemName: "ellipsis"), identifier: nil, children:[cloneRashod])
            return UIMenu(__title: "", image: nil, identifier: nil, children:[editAction,deleteAction, moreActions])
        }
        return configuration
    }

}

extension RashodViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel?.getPickOptionCount() ?? 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel?.getPickOption(row: row)
    }
}
