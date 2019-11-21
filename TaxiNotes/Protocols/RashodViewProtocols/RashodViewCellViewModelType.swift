//
//  RashodViewCellViewModelType.swift
//  TaxiNotes
//
//  Created by Денис Винокуров on 20.11.2019.
//  Copyright © 2019 Денис Винокуров. All rights reserved.
//

import Foundation

protocol RashodViewCellViewModelType: class {
    var dateRashodLabel: String {get}
    var nameRashodLabel: String {get}
    var summRashodLabel: String {get}
}
