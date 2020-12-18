//
//  SettingsViewModel.swift
//  TaxiNotes
//
//  Created by Денис Винокуров on 22.11.2019.
//  Copyright © 2019 Денис Винокуров. All rights reserved.
//

import UIKit
import RealmSwift

class SettingsViewModel: SettingsViewModelType {
    
    //MARK: Private properties:
    private var viewModel: HelpScreenViewController?
    private var settingsArray = realm.objects(Settings.self).filter("idAccount == %@",Variables.sharedVariables.idAccount)
    
    //MARK: View Controller func
    func getSettingsArray() -> Results<Settings>! {
        return settingsArray
    }
    
    func saveSettings(beznalSwitch: Bool, wheelSwitch:Bool, zakazSwitch:Bool, zakazPercentSwitch:Bool, percentSpisan: Int, summSpisan:Double, beznalInDohod: Bool) {
        DispatchQueue.global(qos: .userInteractive).sync {
            let localSetting = Settings()
            localSetting.enabledButtonBeznal = beznalSwitch
            localSetting.enabledButtonWheel = wheelSwitch
            localSetting.enabledButtonZakaz = zakazSwitch
            localSetting.enabledButtonPercentZakaz = zakazPercentSwitch
            localSetting.id = self.settingsArray.first!.id
            localSetting.idAccount = Variables.sharedVariables.idAccount
            localSetting.percentZakaz = percentSpisan
            localSetting.summZakaz = summSpisan
            localSetting.beznalInDohod = beznalInDohod
            StorageManager.saveSettings(localSetting)
        }
    }
    
}
