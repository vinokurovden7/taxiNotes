//
//  SettingsViewController.swift
//  TaxiNotes
//
//  Created by Денис Винокуров on 03.11.2019.
//  Copyright © 2019 Денис Винокуров. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
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
    @IBOutlet weak var beznalInDohod: UISwitch!
    //Segmented
    @IBOutlet weak var themeSwitch: UISegmentedControl!
    
    private var arrayBarButtons: [UIBarButtonItem] = []
    private var viewModel: SettingsViewModelType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = SettingsViewModel()
        
        summSpisan.addTarget(self, action: #selector(saveSetting(_:)), for: .editingDidEnd)
        summSpisan.addTarget(self, action: #selector(replaseChar(_:)), for: .editingChanged)
        percentSpisan.addTarget(self, action: #selector(saveSetting(_:)), for: .editingDidEnd)
        
        let summZakaz = self.viewModel!.getSettingsArray().first!.summZakaz
        let percentZakaz = self.viewModel!.getSettingsArray().first!.percentZakaz
        
        summSpisan.text = "\(summZakaz)"
        percentSpisan.text = "\(percentZakaz)"
        
        DispatchQueue.main.async {
            self.beznalSwitch.setOn(self.viewModel!.getSettingsArray().first!.enabledButtonBeznal, animated: true)
            self.zakazSwitch.setOn(self.viewModel!.getSettingsArray().first!.enabledButtonZakaz, animated: true)
            self.zakazPercentSwitch.setOn(self.viewModel!.getSettingsArray().first!.enabledButtonPercentZakaz, animated: true)
            self.wheelSwitch.setOn(self.viewModel!.getSettingsArray().first!.enabledButtonWheel, animated: true)
            self.beznalInDohod.setOn(self.viewModel!.getSettingsArray().first!.beznalInDohod, animated: true)
        }
        
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
        self.viewModel?.saveSettings(beznalSwitch: beznalSwitch.isOn, wheelSwitch: wheelSwitch.isOn, zakazSwitch: zakazSwitch.isOn, zakazPercentSwitch: zakazPercentSwitch.isOn, percentSpisan: Int(percentSpisan.text ?? "0") ?? 0, summSpisan: Double(summSpisan.text ?? "0.0") ?? 0.0, beznalInDohod: beznalInDohod.isOn)
    }
    
    //Нажите на любое пустое место на экране
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    @IBAction func helpStoimZakaz(_ sender: UIButton) {
        Variables.sharedVariables.typeBtn = 0
    }
    @IBAction func helpPercentZakaz(_ sender: UIButton) {
        Variables.sharedVariables.typeBtn = 1
    }
}
