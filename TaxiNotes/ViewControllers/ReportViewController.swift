//
//  ReportViewController.swift
//  TaxiNotes
//
//  Created by Денис Винокуров on 03.11.2019.
//  Copyright © 2019 Денис Винокуров. All rights reserved.
//

import UIKit
import RealmSwift

private var arrayRashod: Results<Rashod>!
private var arrayZakaz: Results<Zakaz>!
private var filteredArrayZakaz: Results<Zakaz>!
private var arraySmena: Results<Smena>!
private var filteredArraySmena: Results<Smena>!

enum typeReport{
    
}

class ReportViewController: UIViewController {
    
    private var beginDateReport: Date?
    private var endDateReport: Date?
    private var globalIdSmena: String = ""
    
    //Labels
    @IBOutlet weak var periodReportLabel: UILabel!
    @IBOutlet weak var timePeriodLabel: UILabel!
    @IBOutlet weak var totalZakazLabel: UILabel!
    @IBOutlet weak var totalZakazSumm: UILabel!
    @IBOutlet weak var wheelZakazLabel: UILabel!
    @IBOutlet weak var wheelZakazSumm: UILabel!
    @IBOutlet weak var zakazLabel: UILabel!
    @IBOutlet weak var zakazSumm: UILabel!
    @IBOutlet weak var beznalZakazLabel: UILabel!
    @IBOutlet weak var beznalZakazSumm: UILabel!

    @IBOutlet weak var zakazTableView: UITableView!
    @IBOutlet weak var rashodTableView: UITableView!
    
    private var arrayBarButtons: [UIBarButtonItem] = []
    @IBOutlet weak var changePeriodBtnItem: UIBarButtonItem!
    @IBOutlet weak var logoutBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        beginDateReport = Date()
        endDateReport = Date()
        
        arrayRashod = realm.objects(Rashod.self).filter("idAccount == %@ and dateRashod between %@ and %@",Variables.sharedVariables.idAccount, beginDateReport!, endDateReport!).sorted(byKeyPath: "dateRashod")
        arrayZakaz = realm.objects(Zakaz.self).filter("idAccount == %@ and dateZakaz between %@ and %@",Variables.sharedVariables.idAccount, beginDateReport!, endDateReport!).sorted(byKeyPath: "dateZakaz")
        arraySmena = realm.objects(Smena.self).filter("idAccount == %@ and startDateSmena between %@ and %@",Variables.sharedVariables.idAccount, beginDateReport!, endDateReport!).sorted(byKeyPath: "startDateSmena")
        filteredArraySmena = arraySmena.filter("idAccount == %@",Variables.sharedVariables.idAccount)
        
        arrayBarButtons.append(changePeriodBtnItem)
        arrayBarButtons.append(logoutBtn)
        Variables.sharedVariables.changeThemeViewController(viewController: self, arrayBarButtons: arrayBarButtons)
        navigationItem.title = Variables.sharedVariables.currentAccountName
        
        updateStatistic()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        arrayRashod = realm.objects(Rashod.self).filter("idAccount == %@",Variables.sharedVariables.idAccount).sorted(byKeyPath: "dateRashod")
        arrayZakaz = realm.objects(Zakaz.self).filter("idAccount == %@",Variables.sharedVariables.idAccount).sorted(byKeyPath: "dateZakaz")
        zakazTableView.reloadData()
        rashodTableView.reloadData()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        Variables.sharedVariables.changeThemeViewController(viewController: self, arrayBarButtons: arrayBarButtons)
    }
    
    //Обновление статистики
    func updateStatistic(){
        
        let dateFormatter = DateFormatter()
        
        //Запрос на поиск id открытой смены
        filteredArraySmena = arraySmena.filter("idAccount == %@",Variables.sharedVariables.idAccount)
        guard let idSmena = filteredArraySmena.first?.id else {return}
        dateFormatter.dateFormat = "dd.MM.yyyy"
        periodReportLabel.text = "Смена \(dateFormatter.string(from: filteredArraySmena.first!.startDateSmena)) - \(dateFormatter.string(from: filteredArraySmena.first!.endDateSmena!))"
        dateFormatter.dateFormat = "hh:mm"
        timePeriodLabel.text = "\(dateFormatter.string(from: filteredArraySmena.first!.startDateSmena)) - \(dateFormatter.string(from: filteredArraySmena.first!.endDateSmena!))"
        
        //Запрос на получение общей суммы
        filteredArrayZakaz = arrayZakaz.filter("idSmena == %@",idSmena)
        guard let totalSumm: Double = filteredArrayZakaz?.sum(ofProperty: "summaZakaz") else {return}
        guard let totalCount = filteredArrayZakaz?.count else {return}
        
        //Запрос на получение суммы с колёс
        filteredArrayZakaz = arrayZakaz.filter("idSmena == %@ and typeZakaz == %@",idSmena,3)
        guard let wheelSumm: Double = filteredArrayZakaz?.sum(ofProperty: "summaZakaz") else {return}
        guard let wheelCount = filteredArrayZakaz?.count else {return}
        
        //Запрос на получение суммы с заказов
        filteredArrayZakaz = arrayZakaz.filter("idSmena == %@ and (typeZakaz == %@ or typeZakaz == %@)",idSmena,2,1)
        guard let zakazSumma: Double = filteredArrayZakaz?.sum(ofProperty: "summaZakaz") else {return}
        guard let zakazCount = filteredArrayZakaz?.count else {return}
        
        //Запрос на получение суммы с заказа с безнала
        filteredArrayZakaz = arrayZakaz.filter("idSmena == %@ and typeZakaz == %@",idSmena,0)
        guard let beznalSumm: Double = filteredArrayZakaz?.sum(ofProperty: "summaZakaz") else {return}
        guard let beznalCount = filteredArrayZakaz?.count else {return}
        
        //Заполнение полей
        totalZakazLabel.text = "Итого (\(totalCount)):"
        totalZakazSumm.text = "\(totalSumm) ₽"
        
        wheelZakazLabel.text = "С колёс (\(wheelCount)):"
        wheelZakazSumm.text = "\(wheelSumm) ₽"
        
        zakazLabel.text = "С заказов (\(zakazCount)):"
        zakazSumm.text = "\(zakazSumma) ₽"
        
        beznalZakazLabel.text = "С безнала (\(beznalCount)):"
        beznalZakazSumm.text = "\(beznalSumm) ₽"
    }

}

extension ReportViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case zakazTableView:
            return arrayZakaz.count
        case rashodTableView:
            return arrayRashod.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy hh:mm"
        
        switch tableView {
        case zakazTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "zakazTableCell") as! zakazReportCell
            cell.dateZakazLabel.text = dateFormatter.string(from: arrayZakaz[indexPath.row].dateZakaz)
            switch arrayZakaz[indexPath.row].typeZakaz {
            case 0:
                cell.nameZakazLabel.text = "Безнал"
            case 1:
                cell.nameZakazLabel.text = "Заказ"
            case 2:
                cell.nameZakazLabel.text = "Заказ %"
            case 3:
                cell.nameZakazLabel.text = "С колёс"
            default:
                cell.nameZakazLabel.text = "Заказ"
            }
            cell.summaZakazLabel.text = "\(arrayZakaz[indexPath.row].summaZakaz)₽"
            return cell
        case rashodTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "rashodTableCell") as! rashodReportCell
            cell.dateRashodLabel.text = dateFormatter.string(from: arrayRashod[indexPath.row].dateRashod)
            cell.nameRashodLabel.text = arrayRashod[indexPath.row].nameRashod
            cell.summaRashodLabel.text = "\(arrayRashod[indexPath.row].summRashod)₽"
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "zakazTableCell") as! zakazReportCell
            return cell
        }
        
    }
    
    
}
