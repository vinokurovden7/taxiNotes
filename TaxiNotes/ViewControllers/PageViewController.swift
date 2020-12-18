//
//  PageViewController.swift
//  PageController
//
//  Created by Денис Винокуров on 03/05/2019.
//  Copyright © 2019 Денис Винокуров. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {
    
    let presentScreenContent = [
        """
        Краткое руководство пользователя.
        Смахните, чтобы продолжить.
        """,
        "Эта программа предназначена для учета Ваших личных доходов и расходов при работе в такси.",
        "Для начала работы, необходимо создать учетную запись, нажав на кнопку в правой верхней части экрана:",
        "Для того, чтобы записывать поездки, необходимо начать смену, нажав на кнопку в правой верхней части экрана:",
        "Для добавления расхода, нужно нажать на кнопку в правой верхней части экрана:",
        "Для быстрого добавления расходов на топливо, нужно нажать на кнопку, рядом с кнопкой добавления расхода.",
        "Для выбора периода отчета, нужно нажать на кнопку в правой верхней части экрана:",
        """
        В разделе настроек нужно настроить тарифы.
        У каждой учетной записи задаются свои настройки.
        Все изменения сохраняются автоматически.
        """,
        "Для выхода из учетной записи нужно нажать на кнопку 'Выйти', в верхней левой части экрана, при этом открытая смена не закрывается.",
        "Если смена в учетной записи не закрыта, на кнопке учетной записи отображается индикатор: ",
        "Для одновременного закрытия смен во всех учетных записях, нужно нажать на кнопку в левой верхней части экрана:",
        "Работать можно сразу в нескольких учетных записях одновременно !"
    ]
    
    let amojiArray = ["","square.and.pencil","person.crop.circle.fill.badge.plus","play.fill","cart.fill.badge.plus", "speedometer", "calendar", "gear", "arrowshape.turn.up.left.fill", "play.fill", "xmark.circle.fill", "person.3.fill"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self

        if let contentViewController = showViewControllerAtIndex(0) {
            setViewControllers([contentViewController], direction: .forward, animated: true, completion: nil)
        }
        
    }
    
    func showViewControllerAtIndex(_ index: Int) -> ContentViewController? {
        guard index >= 0 else {return nil}
        guard index < presentScreenContent.count else {return nil}
        guard let contentViewController = storyboard?.instantiateViewController(withIdentifier: "ContentViewController") as? ContentViewController else {return nil}
        
        contentViewController.presentText = presentScreenContent[index]
        contentViewController.emoji = amojiArray[index]
        contentViewController.currentPage = index
        contentViewController.numberOfPage = presentScreenContent.count
        if index == presentScreenContent.count - 1 {
            contentViewController.showCloseBtn = false
        }
        
        return contentViewController
    }
    
    func closeGlobalPresent(){
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: "presentationWasViewed")
        dismiss(animated: true, completion: nil)
    }
    
    func closePresent(){
        dismiss(animated: true, completion: nil)
    }
    
}

extension PageViewController: UIPageViewControllerDataSource{
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var pageNumber = (viewController as! ContentViewController).currentPage
        pageNumber -= 1
        
        return showViewControllerAtIndex(pageNumber)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var pageNumber = (viewController as! ContentViewController).currentPage
        pageNumber += 1
        
        return showViewControllerAtIndex(pageNumber)
    }
    
    
}
