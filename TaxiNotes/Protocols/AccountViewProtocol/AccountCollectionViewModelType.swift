//
//  AccountCollectionViewModelType.swift
//  TaxiNotes
//
//  Created by Денис Винокуров on 20.11.2019.
//  Copyright © 2019 Денис Винокуров. All rights reserved.
//

import UIKit

protocol AccountCollectionViewViewModelType {
    
    func numberOfRows() -> Int
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> AccountCollectionViewCellViewModelType?
    
    func selectRow(atIndexPath indexPath: IndexPath)
    
    func getIndexPathSelectedRow() -> IndexPath
    
    func getCountAccount() -> Int
    
    func closeAllOpenSmena()
    
    func addAlertAccount(editMode: Bool, indexPath: IndexPath?, completion: @escaping (Int)->()) -> UIAlertController
    
    func addDeleteAccountAlert(indexPath: IndexPath, completion: @escaping ()->()) -> UIAlertController
}
