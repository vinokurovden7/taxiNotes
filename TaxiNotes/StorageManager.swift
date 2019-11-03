//
//  StorageManager.swift
//  TaxiNotes
//
//  Created by Денис Винокуров on 29.10.2019.
//  Copyright © 2019 Денис Винокуров. All rights reserved.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    //Работа с учетными записями
    static func saveAccount(_ account: Accounts){
        try! realm.write {
            realm.add(account, update: true)
        }
    }
    
    static func removeAccount(id:String){
        try! realm.write {
            realm.delete(realm.objects(Accounts.self).filter("id ==[c] %@",id))
            realm.delete(realm.objects(Zakaz.self).filter("idAccount == %@",id))
            realm.delete(realm.objects(Smena.self).filter("idAccount == %@",id))
            realm.delete(realm.objects(Rashod.self).filter("idAccount == %@",id))
            realm.delete(realm.objects(Settings.self).filter("idAccount == %@",id))
        }
    }
    
    //Работа с заказами
    static func saveZakaz(_ zakaz: Zakaz){
        try! realm.write {
            realm.add(zakaz)
        }
    }
    
    static func deleteZakaz(id: String){
        try! realm.write {
            realm.delete(realm.objects(Zakaz.self).filter("id ==[c] %@",id))
        }
    }
    
    //Работа со сменами
    static func saveSmena(_ smena: Smena){
        try! realm.write {
            realm.add(smena, update: true)
        }
    }
    
    static func deleteSmena(id: String){
        try! realm.write {
            realm.delete(realm.objects(Smena.self).filter("id ==[c] %@",id))
        }
    }
    
    //Работа с настройками
    static func saveSettings(_ settings: Settings){
        try! realm.write {
            realm.add(settings, update: true)
        }
    }
    
    static func deleteSettings(id: String){
        try! realm.write {
            realm.delete(realm.objects(Settings.self).filter("id ==[c] %@",id))
        }
    }
    
}
