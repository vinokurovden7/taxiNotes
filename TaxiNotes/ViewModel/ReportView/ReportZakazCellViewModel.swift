//
//  ReportZakazCellViewModel.swift
//  TaxiNotes
//
//  Created by Денис Винокуров on 21.11.2019.
//  Copyright © 2019 Денис Винокуров. All rights reserved.
//

import UIKit

class ReportZakazCellViewModel: ReportZakazCellViewModelType {
    
    private var zakaz: Zakaz
    var dateZakazLabel: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        return dateFormatter.string(from: zakaz.dateZakaz)
    }
    
    var nameZakazLabel: String {
        switch zakaz.typeZakaz {
        case 0:
            return "Безнал"
        case 1:
            return "Заказ"
        case 2:
            return "Заказ %"
        case 3:
            return "С колёс"
        default:
            return "Заказ"
        }
    }
    
    var summaZakazLabel: String {
        return String(format: "%.2f", zakaz.summaZakaz)
    }
    
    init(zakaz: Zakaz) {
        self.zakaz = zakaz
    }
}
