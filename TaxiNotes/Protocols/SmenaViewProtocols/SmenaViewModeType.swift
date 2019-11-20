//
//  SmenaViewModeType.swift
//  TaxiNotes
//
//  Created by Денис Винокуров on 20.11.2019.
//  Copyright © 2019 Денис Винокуров. All rights reserved.
//

import UIKit

protocol SmenaViewModeType {
    
    func startStopSmena()
    func wheel(summa: Double)
    func percentZakaz(summa: Double)
    func zakaz(summa: Double)
    func beznal(summa: Double)
    func alertAddScoreAccount() -> UIAlertController
    func addInformationAlert(title: String, message: String) -> UIAlertController
    func getIdSmena() -> String
    func getTotalSummCount() -> (summ:Double, count:Int)
    func getWheelSummCount() -> (summ:Double, count:Int)
    func getZakazSummCount() -> (summ:Double, count:Int)
    func getBeznalSummCount() -> (summ:Double, count:Int)
    
}
