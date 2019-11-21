//
//  RashodCellViewModel.swift
//  TaxiNotes
//
//  Created by Денис Винокуров on 20.11.2019.
//  Copyright © 2019 Денис Винокуров. All rights reserved.
//

import Foundation

class RashodCellViewModel: RashodViewCellViewModelType {
    
    private var rashod: Rashod
    var dateRashodLabel: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: rashod.dateRashod)
    }
    var nameRashodLabel: String {
        return rashod.nameRashod
    }
    var summRashodLabel: String {
        return String(rashod.summRashod)
    }
    init(rashod: Rashod) {
        self.rashod = rashod
    }
    
}
