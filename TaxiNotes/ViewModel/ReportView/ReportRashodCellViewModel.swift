//
//  ReportRashodCellViewModel.swift
//  TaxiNotes
//
//  Created by Денис Винокуров on 21.11.2019.
//  Copyright © 2019 Денис Винокуров. All rights reserved.
//

import UIKit

class ReportRashodCellViewModel: ReportRashodCellViewModelType {
      
    private var rashod: Rashod
    var dateRashodLabel: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        return dateFormatter.string(from: rashod.dateRashod)
    }
    
    var nameRashodLabel: String {
        return rashod.nameRashod
    }
    
    var summaRashodLabel: String {
        return String(format: "%.2f", rashod.summRashod)
    }
    
    init(rashod: Rashod) {
        self.rashod = rashod
    }
}
