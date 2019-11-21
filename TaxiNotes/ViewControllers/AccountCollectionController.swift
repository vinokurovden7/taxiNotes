//
//  AccountCollectionController.swift
//  TaxiNotes
//
//  Created by Денис Винокуров on 28.10.2019.
//  Copyright © 2019 Денис Винокуров. All rights reserved.
//

import UIKit
import RealmSwift

let reuseIdentifier = "AccountNameCell"
private var accountArray: Results<Accounts>!
private var filteredArray: Results<Accounts>!
private var arraySmena: Results<Smena>!
private var openArraySmena: Results<Smena>!


class AccountCollectionController: UICollectionViewController{
    @IBOutlet var myCollectionView: UICollectionView!
    @IBOutlet weak var addAccountBtn: UIBarButtonItem!
    @IBOutlet weak var closeAllOpenSmenaBtn: UIBarButtonItem!
    
    private var viewModel: AccountCollectionViewViewModelType?
    
    private var yellowColor = UIColor(displayP3Red: 255/255, green: 250/255, blue: 139/255, alpha: 255/255)
    private var arrayBarButtons: [UIBarButtonItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = AccountViewModel()
        
        arrayBarButtons.append(addAccountBtn)
        arrayBarButtons.append(closeAllOpenSmenaBtn)
        accountArray = realm.objects(Accounts.self).sorted(byKeyPath: "nameAccount")
        Variables.sharedVariables.changeThemeCollectionViewControlle(viewController: self, arrayBarButtons: arrayBarButtons)
        
        openArraySmena = realm.objects(Smena.self).filter("endDateSmena == nil")
        
        if openArraySmena.count <= 0 {
            closeAllOpenSmenaBtn.isEnabled = false
        } else {
            closeAllOpenSmenaBtn.isEnabled = true
        }
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        myCollectionView.reloadData()
        Variables.sharedVariables.changeThemeCollectionViewControlle(viewController: self, arrayBarButtons: arrayBarButtons)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        myCollectionView.reloadData()
        Variables.sharedVariables.changeThemeCollectionViewControlle(viewController: self, arrayBarButtons: arrayBarButtons)
        
        openArraySmena = realm.objects(Smena.self).filter("endDateSmena == nil")
        
        if openArraySmena.count <= 0 {
            closeAllOpenSmenaBtn.isEnabled = false
        } else {
            closeAllOpenSmenaBtn.isEnabled = true
        }
    }
    
    @IBAction func addAccountAction(_ sender: UIBarButtonItem) {
        self.present((viewModel?.addAlertAccount(editMode: false, indexPath: nil, completion: { error in
            self.errorCase(error: error, indexPath: nil)
        }))!, animated: true)
    }
    
    @IBAction func closeAllOpenSmenaBtnAction(_ sender: UIBarButtonItem) {
        
        viewModel?.closeAllOpenSmena()
        myCollectionView.reloadData()
        
        openArraySmena = realm.objects(Smena.self).filter("endDateSmena == nil")
        
        if openArraySmena.count <= 0 {
            closeAllOpenSmenaBtn.isEnabled = false
        } else {
            closeAllOpenSmenaBtn.isEnabled = true
        }
    }
    
    //Нажите на любое пустое место на экране
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func errorCase(error: Int, indexPath: IndexPath?){
        switch error {
        case 0:
            self.present((self.viewModel?.addInformationAlert(title: "Уведомление", message: "Такая учетная запись уже существует", complection: {
                self.present((self.viewModel?.addAlertAccount(editMode: true, indexPath: indexPath, completion: { error in
                    self.errorCase(error: error, indexPath: indexPath)
                }))!, animated: true, completion: nil)
            }))!, animated: true, completion: nil)
        case 1:
            self.myCollectionView.reloadData()
        case 2:
            self.present((self.viewModel?.addInformationAlert(title: "Уведомление", message: "Заполните название учетной записи", complection: {
                self.present((self.viewModel?.addAlertAccount(editMode: true, indexPath: indexPath, completion: { error in
                    self.errorCase(error: error, indexPath: indexPath)
                }))!, animated: true, completion: nil)
            }))!, animated: true, completion: nil)
        case 3:
            self.present((self.viewModel?.addInformationAlert(title: "Уведомление", message: "Заполните название учетной записи", complection: {
                self.present((self.viewModel?.addAlertAccount(editMode: false, indexPath: indexPath, completion: { error in
                    self.errorCase(error: error, indexPath: indexPath)
                }))!, animated: true, completion: nil)
            }))!, animated: true, completion: nil)
        default:
            break
        }
    }
    
}

//Расширение для работы с CollectionView
extension AccountCollectionController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = viewModel else {return 0}
        return viewModel.numberOfRows()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? AccountCollectionCell
        
        guard let tableViewCell = cell, let viewModel = viewModel else { return UICollectionViewCell() }
        
        let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath)
        tableViewCell.viewModel = cellViewModel

        arraySmena = realm.objects(Smena.self).filter("endDateSmena == nil and idAccount == %@",accountArray[indexPath.row].id)
        if arraySmena.count > 0 {
            cell!.startSmenaIndicatior.isHidden = false
        } else {
            cell!.startSmenaIndicatior.isHidden = true
        }
        return cell!
    }
    
    override func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { actions -> UIMenu? in
            
            let deleteAction = UIAction(title: "Удалить", image: UIImage(systemName: "trash"), identifier: nil, attributes: .destructive) { action in
                self.present((self.viewModel?.addDeleteAccountAlert(indexPath: indexPath, completion: {
                    self.myCollectionView.deleteItems(at: [indexPath])
                }))!, animated: true, completion: nil)
            }
            
            let editAction = UIAction(title: "Редактировать", image: UIImage(systemName: "square.and.pencil"), identifier: nil) { action in
                self.present((self.viewModel?.addAlertAccount(editMode: true, indexPath: indexPath, completion: { error in
                    self.errorCase(error: error, indexPath: indexPath)
                }))!, animated: true)
            }
            
            return UIMenu(__title: "", image: nil, identifier: nil, children:[editAction,deleteAction])
        }
        return configuration
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let viewModel = viewModel else {return}
        viewModel.selectRow(atIndexPath: indexPath)
        
        Variables.sharedVariables.currentAccountName = accountArray[indexPath.row].nameAccount
        Variables.sharedVariables.scoreAccount = Double(accountArray[indexPath.row].scoreAccount)
        Variables.sharedVariables.idAccount = accountArray[indexPath.row].id
        
        DispatchQueue.main.async(){
            self.performSegue(withIdentifier: "mainScreen", sender: self)
        }
    }
    
}
