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
    let loginVC = TabBarFactory.create(viewController: LoginViewController(viewModel: .init()),
                                       title: "로그인",
                                       image: .ic_board,
                                       selectedImage: .ic_board_fill)
    let firstVC = TabBarFactory.create(viewController: FirstStepViewController(),
                                         title: "온보드1",
                                         image: .ic_board,
                                         selectedImage: .ic_board_fill)
    let secondVC = TabBarFactory.create(viewController: SecondStepViewController(),
                                         title: "온보드2",
                                         image: .ic_board,
                                         selectedImage: .ic_board_fill)
    let thirdVC = TabBarFactory.create(viewController: ThirdStepViewController(),
                                         title: "온보드",
                                         image: .ic_board,
                                         selectedImage: .ic_board_fill)
    let leahVC = TabBarFactory.create(viewController: CommunityViewController(),
                                     title: "리아",
                                     image: .ic_board,
                                     selectedImage: .ic_board_fill)
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        tabBar.backgroundColor = .white
        viewControllers = [leahVC]
        
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
