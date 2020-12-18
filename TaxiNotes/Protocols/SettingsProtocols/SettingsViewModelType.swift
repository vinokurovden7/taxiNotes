//
//  SettingsViewModelType.swift
//  TaxiNotes
//
//  Created by Денис Винокуров on 22.11.2019.
//  Copyright © 2019 Денис Винокуров. All rights reserved.
//

import Foundation
import RealmSwift

protocol SettingsViewModelType {
    func getSettingsArray() -> Results<Settings>!
    func saveSettings(beznalSwitch: Bool, wheelSwitch:Bool, zakazSwitch:Bool, zakazPercentSwitch:Bool, percentSpisan: Int, summSpisan:Double, beznalInDohod: Bool)
}
