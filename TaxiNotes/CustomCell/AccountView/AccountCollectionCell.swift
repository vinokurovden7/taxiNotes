//
//  AccountCollectionCell.swift
//  TaxiNotes
//
//  Created by Денис Винокуров on 28.10.2019.
//  Copyright © 2019 Денис Винокуров. All rights reserved.
//

import UIKit

class AccountCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var nameAccountLabel: UILabel!
    @IBOutlet weak var scoreAccountLabel: UILabel!
    @IBOutlet weak var startSmenaIndicatior: UIImageView!
    
    weak var viewModel: AccountCollectionViewCellViewModelType? {
        willSet(viewModel) {
            guard let viewModel = viewModel else {return}
            nameAccountLabel.text = viewModel.nameAccountLabel
            scoreAccountLabel.text = "Балланс: \(String(viewModel.scoreAccountLabel)) ₽"
            
            switch traitCollection.userInterfaceStyle {
                case .light, .unspecified:
                    contentView.backgroundColor = .black
                    nameAccountLabel.textColor = yellowColor
                    startSmenaIndicatior.tintColor = yellowColor
                    scoreAccountLabel.textColor = .white
                break
                case .dark:
                    contentView.backgroundColor = yellowColor
                    nameAccountLabel.textColor = .black
                    startSmenaIndicatior.tintColor = .black
                    scoreAccountLabel.textColor = .gray
                    break
            @unknown default:
                fatalError()
            }
        }
    }
}
