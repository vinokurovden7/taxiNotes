//
//  GlobalVariables.swift
//  TaxiNotes
//
//  Created by Денис Винокуров on 28.10.2019.
//  Copyright © 2019 Денис Винокуров. All rights reserved.
//

import UIKit
import RealmSwift

var yellowColor = UIColor(displayP3Red: 255/255, green: 250/255, blue: 139/255, alpha: 255/255)

class Variables {

    static let sharedVariables = Variables()
    
    var currentAccountName = ""
    var scoreAccount: Double = 0.0
    var idAccount = ""
    var startedSmena = false
    
    func changeThemeViewController(viewController: UIViewController, arrayBarButtons: [UIBarButtonItem]){
          switch viewController.traitCollection.userInterfaceStyle {
                    case .light, .unspecified:
                     DispatchQueue.main.async {
                        for item in arrayBarButtons {
                            item.tintColor = .black
                        }
                        viewController.tabBarController?.tabBar.barTintColor = yellowColor
                        viewController.tabBarController?.tabBar.tintColor = .black
                        viewController.navigationController?.navigationBar.barTintColor = yellowColor
                        viewController.navigationController?.navigationBar.backgroundColor = yellowColor
                        viewController.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
                        viewController.navigationController?.navigationBar.barStyle = .default
                     }
                    break
                    case .dark:
                     DispatchQueue.main.async {
                        for item in arrayBarButtons {
                         item.tintColor = yellowColor
                        }
                        viewController.tabBarController?.tabBar.barTintColor = .black
                        viewController.tabBarController?.tabBar.tintColor = yellowColor
                        viewController.navigationController?.navigationBar.barTintColor = .black
                        viewController.navigationController?.navigationBar.backgroundColor = .black
                        viewController.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : yellowColor]
                        viewController.navigationController?.navigationBar.barStyle = .black
                     }
                    break
                @unknown default:
                    fatalError()
          }
    }
    
    func changeThemeCollectionViewControlle(viewController: UICollectionViewController, arrayBarButtons: [UIBarButtonItem]){
        switch viewController.traitCollection.userInterfaceStyle {
            case .light, .unspecified:
                DispatchQueue.main.async {
                    for item in arrayBarButtons {
                        item.tintColor = .black
                    }
                    viewController.navigationController?.navigationBar.barTintColor = yellowColor
                    viewController.navigationController?.navigationBar.backgroundColor = yellowColor
                    viewController.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
                    viewController.navigationController?.navigationBar.barStyle = .default
                }
            break
            case .dark:
                DispatchQueue.main.async {
                    for item in arrayBarButtons {
                        item.tintColor = yellowColor
                    }
                    viewController.navigationController?.navigationBar.barTintColor = .black
                    viewController.navigationController?.navigationBar.backgroundColor = .black
                    viewController.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : yellowColor]
                    viewController.navigationController?.navigationBar.barStyle = .black
                }
                break
        @unknown default:
            fatalError()
        }
    }
    
    func reomveTimeFrom(date: Date) -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        let date = Calendar.current.date(from: components)
        return date!
    }
    
}
