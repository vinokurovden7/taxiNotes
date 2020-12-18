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
        DispatchQueue.global(qos: .userInteractive).sync {
            try! realm.write {
                realm.add(account, update: .modified)
            }
        }
    }
    
    static func removeAccount(id:String){
        DispatchQueue.global(qos: .userInteractive).sync {
            try! realm.write {
                realm.delete(realm.objects(Accounts.self).filter("id ==[c] %@",id))
                realm.delete(realm.objects(Zakaz.self).filter("idAccount == %@",id))
                realm.delete(realm.objects(Smena.self).filter("idAccount == %@",id))
                realm.delete(realm.objects(Rashod.self).filter("idAccount == %@",id))
                realm.delete(realm.objects(Settings.self).filter("idAccount == %@",id))
                realm.delete(realm.objects(Rashod.self).filter("idAccount == %@",id))
            }
        }
    }
    
    //Работа с заказами
    static func saveZakaz(_ zakaz: Zakaz){
        DispatchQueue.global(qos: .userInteractive).sync {
            try! realm.write {
                realm.add(zakaz, update: .modified)
            }
        }
    }
    
    static func deleteZakaz(id: String){
        DispatchQueue.global(qos: .userInteractive).sync {
            try! realm.write {
                realm.delete(realm.objects(Zakaz.self).filter("id ==[c] %@",id))
            }
        }
    }
    
    //Работа со сменами
    static func saveSmena(_ smena: Smena){
        DispatchQueue.global(qos: .userInteractive).sync {
            try! realm.write {
                realm.add(smena, update: .modified)
            }
        }
    }
    
    static func deleteSmena(id: String){
        DispatchQueue.global(qos: .userInteractive).sync {
            try! realm.write {
                realm.delete(realm.objects(Smena.self).filter("id ==[c] %@",id))
            }
        }
    }
    
    //Работа с настройками
    static func saveSettings(_ settings: Settings){
        DispatchQueue.global(qos: .userInteractive).sync {
            try! realm.write {
                realm.add(settings, update: .modified)
            }
        }
    }
    
    static func deleteSettings(id: String){
        DispatchQueue.global(qos: .userInteractive).sync {
            try! realm.write {
                realm.delete(realm.objects(Settings.self).filter("id ==[c] %@",id))
            }
        }
    }
    
    //Работа с расходами
    static func saveRashod(_ rashod: Rashod){
        DispatchQueue.global(qos: .userInteractive).sync {
            try! realm.write {
                realm.add(rashod, update: .modified)
            }
        }
    }
    
    static func deleteRashod(id: String){
        DispatchQueue.global(qos: .userInteractive).sync {
            try! realm.write {
                realm.delete(realm.objects(Rashod.self).filter("id ==[c] %@",id))
            }
        }
    }
    
}
