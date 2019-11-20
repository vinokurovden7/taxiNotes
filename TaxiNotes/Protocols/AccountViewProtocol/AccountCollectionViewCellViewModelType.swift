//
//  AccountCollectionViewCellViewModelType.swift
//  TaxiNotes
//
//  Created by Денис Винокуров on 20.11.2019.
//  Copyright © 2019 Денис Винокуров. All rights reserved.
//

import UIKit

protocol AccountCollectionViewCellViewModelType: class {
    var nameAccountLabel: String {get}
    var scoreAccountLabel: Double {get}
}
