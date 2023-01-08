//
//  TabBarViewController.swift
//  BlackCat
//
//  Created by Hamlit Jason on 2022/10/08.
//

import UIKit

final class TabBarViewController: UITabBarController {
    
    // MARK: - Properties
    let homeVC = TabBarFactory.create(viewController: HomeViewController(),
                                      title: "홈",
                                      image: .home)
    let temp = TabBarFactory.create(viewController: ViewController(),
                                         title: "내정보",
                                         image: .my)
    let leahVC = TabBarFactory.create(viewController: CommunityViewController(),
                                     title: "커뮤니티",
                                     image: .community)
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        tabBar.backgroundColor = .white
        viewControllers = [homeVC, leahVC, temp]
        delegate = self
        tabBar.tintColor = .appColor(.primary)
    }
    
}

struct TabBarFactory {
    static func create(viewController: UIViewController,
                       title: String,
                       image: Asset,
                       selectedImage: Asset? = nil) -> UINavigationController {
        
        viewController.tabBarItem = UITabBarItem(title: title,
                                                 image: UIImage(image) ?? UIImage(systemName: "trash"),
                                                 tag: 1)
        
        return UINavigationController(rootViewController: viewController)
    }
}

extension TabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let vc = viewController as? UINavigationController, let _ = vc.viewControllers[0] as? ViewController {
            present(OneButtonAlertViewController(viewModel: .init(content: "준비중입니다!", buttonText: "확인", textColor: .appColor(.primary))), animated: true)
            return false
        }
        return true
    }
}
