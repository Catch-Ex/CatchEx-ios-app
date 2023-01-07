//
//  TabBarViewController.swift
//  BlackCat
//
//  Created by Hamlit Jason on 2022/10/08.
//

import UIKit

final class TabBarViewController: UITabBarController {
    
    // MARK: - Properties
    let homeVC = TabBarFactory.create(viewController: ViewController(),
                                                title: "홈",
                                                image: .ic_board,
                                                selectedImage: .ic_board_fill)

    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        
        viewControllers = [homeVC, homeVC, homeVC, homeVC, homeVC, homeVC, homeVC, homeVC, homeVC]
        
    }
    
}

struct TabBarFactory {
    static func create(viewController: UIViewController,
                       title: String,
                       image: Asset,
                       selectedImage: Asset) -> UINavigationController {
        
        viewController.tabBarItem = UITabBarItem(title: title,
                                                 image: UIImage(image) ?? UIImage(systemName: "trash"),
                                                 selectedImage: UIImage(selectedImage) ?? UIImage(systemName: "trash"))
        
        return UINavigationController(rootViewController: viewController)
    }
}
