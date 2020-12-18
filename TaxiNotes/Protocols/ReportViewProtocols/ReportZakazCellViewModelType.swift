//
//  ReportZakazCellViewModelType.swift
//  TaxiNotes
//
//  Created by Денис Винокуров on 21.11.2019.
//  Copyright © 2019 Денис Винокуров. All rights reserved.
//

import Foundation

protocol ReportZakazCellViewModelType: class {
    
    var dateZakazLabel: String {get}
    var nameZakazLabel: String {get}
    var summaZakazLabel: String {get}
    
}
