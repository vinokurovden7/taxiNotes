//
//  ContentViewController.swift
//  PageController
//
//  Created by Денис Винокуров on 03/05/2019.
//  Copyright © 2019 Денис Винокуров. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {

    @IBOutlet weak var presentTextLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var closePresent: UIButton!
    @IBOutlet weak var switcherTextLabel: UILabel!
    @IBOutlet weak var switcher: UISwitch!
    
    var presentText = ""
    var emoji = ""
    var currentPage = 0
    var numberOfPage = 0
    var showCloseBtn = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presentTextLabel.text = presentText
        imageView.image = UIImage.init(systemName: emoji) 
        pageControl.numberOfPages = numberOfPage
        pageControl.currentPage = currentPage
        switcher.isHidden = showCloseBtn
        switcherTextLabel.isHidden = showCloseBtn
        closePresent.isHidden = showCloseBtn
        
    }
    
    @IBAction func closePresentBtn(_ sender: UIButton) {
        let page = PageViewController()
        if switcher.isOn {
            page.closeGlobalPresent()
        } else {
            page.closePresent()
        }
        dismiss(animated: true, completion: nil)
    }
    
}
