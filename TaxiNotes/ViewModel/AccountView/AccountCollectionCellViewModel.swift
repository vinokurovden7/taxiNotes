//
//  AccountCollectionCellViewModel.swift
//  TaxiNotes
//
//  Created by Денис Винокуров on 20.11.2019.
//  Copyright © 2019 Денис Винокуров. All rights reserved.
//

import UIKit

class AccountCollectionViewCellViewModel: AccountCollectionViewCellViewModelType {    
    
    private var account: Accounts
    var nameAccountLabel: String {
        return account.nameAccount
    }
    var scoreAccountLabel: Double {
        return account.scoreAccount
    }
    
    init(account: Accounts) {
        self.account = account
    }
    
}
