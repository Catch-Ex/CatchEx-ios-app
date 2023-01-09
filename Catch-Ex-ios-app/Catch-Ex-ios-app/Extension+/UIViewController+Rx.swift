//
//  UIViewController+Rx.swift
//  Catch-Ex-ios-app
//
//  Created by 김지훈 on 2023/01/07.
//

import UIKit
import RxSwift
import RxCocoa

public extension Reactive where Base: UIViewController {
    
    var viewDidLoad: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
        return ControlEvent(events: source)
    }
    
    var viewWillAppear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewWillAppear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
    
    var viewDidAppear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewDidAppear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
    
    var viewWillDisappear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewWillDisappear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
    
    var viewDidDisappear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewDidDisappear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
    
    var viewWillLayoutSubviews: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewWillLayoutSubviews)).map { _ in }
        return ControlEvent(events: source)
    }
    
    var viewDidLayoutSubviews: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewDidLayoutSubviews)).map { _ in }
        return ControlEvent(events: source)
    }
}

extension UIViewController {

    func setupNavigationBackButton(_ sender: UIImage? = nil) {
       
        
        if sender == nil {
            let backButtonSpacer = UIBarButtonItem()
            backButtonSpacer.width = -28
            let backButton = UIBarButtonItem(image: UIImage(named: "arrow_left")?.withRenderingMode(.alwaysOriginal),
                                             style: .plain,
                                             target: self,
                                             action: #selector(didTapBackButton))
            navigationItem.setLeftBarButtonItems([backButtonSpacer, backButton], animated: false)
        } else {
            let senderImageItem = UIBarButtonItem(image: sender?.resize(newWidth: 73).withTintColor(.appColor(.primary), renderingMode: .alwaysOriginal),
                                             style: .plain,
                                             target: self,
                                             action: #selector(didTapBackButton))
            
            navigationItem.setLeftBarButtonItems([senderImageItem], animated: false)
        }
                
    }
    
    @objc
    func didTapBackButton() {
        if self is InboxViewController || self is OutboxViewController {
            dismiss(animated: false)
            return
        } else {
            navigationController?.popViewController(animated: false)
            tabBarController?.selectedIndex = 0
        }
    }
}
