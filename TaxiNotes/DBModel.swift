//
//  DBModel.swift
//  TaxiNotes
//
//  Created by Денис Винокуров on 29.10.2019.
//  Copyright © 2019 Денис Винокуров. All rights reserved.
//

import RealmSwift

//Учетки
class Accounts: Object {
    @objc dynamic var id = NSUUID().uuidString
    @objc dynamic var nameAccount = ""
    @objc dynamic var scoreAccount: Double = 0.0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

//Заказы
class Zakaz: Object {
    @objc dynamic var id = NSUUID().uuidString
    @objc dynamic var typeZakaz = 0 //0 - Безнал, 1 - Заказ, 2 - Заказ с процентом, 3 - С колёс
    @objc dynamic var summaZakaz: Double = 0.0
    @objc dynamic var idAccount = ""
    @objc dynamic var dateZakaz = Date()
    @objc dynamic var clearDateZakaz = Variables.sharedVariables.reomveTimeFrom(date: Date())
    @objc dynamic var idSmena = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

//Смены
class Smena: Object {
    @objc dynamic var id = NSUUID().uuidString
    @objc dynamic var startDateSmena = Date()
    @objc dynamic var endDateSmena: Date?
    @objc dynamic var idAccount = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

//Расходы
class Rashod: Object {
    @objc dynamic var id = NSUUID().uuidString
    @objc dynamic var nameRashod = ""
    @objc dynamic var summRashod: Double = 0.0
    @objc dynamic var idAccount = ""
    @objc dynamic var dateRashod = Date()
    @objc dynamic var clearDateRashod = Variables.sharedVariables.reomveTimeFrom(date: Date())
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

//Настройки
class Settings: Object {
    @objc dynamic var id = NSUUID().uuidString
    @objc dynamic var summZakaz = 0.0
    @objc dynamic var percentZakaz = 0
    @objc dynamic var idAccount = ""
    @objc dynamic var enabledButtonBeznal = true
    @objc dynamic var enabledButtonZakaz = true
    @objc dynamic var enabledButtonPercentZakaz = true
    @objc dynamic var enabledButtonWheel = true
    @objc dynamic var themeApplication = 0 //0 - Автоматически 1 - Светлая 2 - Тёмная
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
