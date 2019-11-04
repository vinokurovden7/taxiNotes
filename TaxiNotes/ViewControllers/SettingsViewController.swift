//
//  SettingsViewController.swift
//  TaxiNotes
//
//  Created by Денис Винокуров on 03.11.2019.
//  Copyright © 2019 Денис Винокуров. All rights reserved.
//

import UIKit
import RealmSwift

class SettingsViewController: UIViewController {
    
    private var settingsArray: Results<Settings>!
    
    //BarItem
    @IBOutlet weak var logoutBtn: UIBarButtonItem!
    
    //TextView
    @IBOutlet weak var summSpisan: UITextField!
    @IBOutlet weak var percentSpisan: UITextField!
    
    //Swiches
    @IBOutlet weak var beznalSwitch: UISwitch!
    @IBOutlet weak var zakazSwitch: UISwitch!
    @IBOutlet weak var zakazPercentSwitch: UISwitch!
    @IBOutlet weak var wheelSwitch: UISwitch!
    
    //Segmented
    @IBOutlet weak var themeSwitch: UISegmentedControl!
    
    private var arrayBarButtons: [UIBarButtonItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsArray = realm.objects(Settings.self).filter("idAccount == %@",Variables.sharedVariables.idAccount)
        
        summSpisan.addTarget(self, action: #selector(saveSetting(_:)), for: .editingDidEnd)
        summSpisan.addTarget(self, action: #selector(replaseChar(_:)), for: .editingChanged)
        percentSpisan.addTarget(self, action: #selector(saveSetting(_:)), for: .editingDidEnd)
        
        let summZakaz = settingsArray.first!.summZakaz
        let percentZakaz = settingsArray.first!.percentZakaz
        
        summSpisan.text = "\(summZakaz)"
        percentSpisan.text = "\(percentZakaz)"
        
        beznalSwitch.setOn(settingsArray.first!.enabledButtonBeznal, animated: true)
        zakazSwitch.setOn(settingsArray.first!.enabledButtonZakaz, animated: true)
        zakazPercentSwitch.setOn(settingsArray.first!.enabledButtonPercentZakaz, animated: true)
        wheelSwitch.setOn(settingsArray.first!.enabledButtonWheel, animated: true)
        
        arrayBarButtons.append(logoutBtn)
        Variables.sharedVariables.changeThemeViewController(viewController: self, arrayBarButtons: arrayBarButtons)
        navigationItem.title = Variables.sharedVariables.currentAccountName

    }
    
    @objc func saveSetting(_ textField: UITextField) {
        if textField.text?.count == 0 {
            textField.text = "0"
        }
        self.saveSettings()
    }
    
    @objc func replaseChar(_ textField: UITextField) {
        let val = textField.text!.replacingOccurrences(of: ",", with: ".")
        textField.text = val
    }
    
    @IBAction func beznalSwitchAction(_ sender: UISwitch) {
        saveSettings()
    }
    @IBAction func zakazSwitchAction(_ sender: UISwitch) {
        saveSettings()
    }
    @IBAction func zakazPercentSwitchAction(_ sender: UISwitch) {
        saveSettings()
    }
    @IBAction func wheelSwitchAction(_ sender: UISwitch) {
        saveSettings()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        saveSettings()
    }
    
    @IBAction func themeChangeAction(_ sender: UISegmentedControl) {
        saveSettings()
        Variables.sharedVariables.changeThemeViewController(viewController: self, arrayBarButtons: arrayBarButtons)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        Variables.sharedVariables.changeThemeViewController(viewController: self, arrayBarButtons: arrayBarButtons)
    }
    
    func saveSettings(){
        let localSetting = Settings()
        localSetting.enabledButtonBeznal = beznalSwitch.isOn
        localSetting.enabledButtonWheel = wheelSwitch.isOn
        localSetting.enabledButtonZakaz = zakazSwitch.isOn
        localSetting.enabledButtonPercentZakaz = zakazPercentSwitch.isOn
        localSetting.id = settingsArray.first!.id
        localSetting.idAccount = Variables.sharedVariables.idAccount
        localSetting.percentZakaz = Int(percentSpisan.text ?? "0")!
        localSetting.summZakaz = Double(summSpisan.text ?? "0.0")!
        StorageManager.saveSettings(localSetting)
    }
    
    //Нажите на любое пустое место на экране
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
