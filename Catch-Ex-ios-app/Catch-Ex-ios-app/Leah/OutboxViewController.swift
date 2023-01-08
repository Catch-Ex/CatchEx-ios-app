//
//  noteboxViewController.swift
//  Catch-Ex-ios-app
//
//  Created by 김사랑 on 2023/01/08.
//

import UIKit
import SnapKit
import Then

class OutboxViewController: UIViewController {

    lazy var inboxBtn = UIButton().then {
        $0.setTitle("받은 쪽지함", for: .normal)
        $0.setTitleColor(UIColor(red: 0.188, green: 0.188, blue: 0.188, alpha: 1), for: .normal)
    }
    
    lazy var outboxBtn = UIButton().then {
        $0.setTitle("보낸 쪽지함", for: .normal)
        $0.setTitleColor(UIColor(red: 0.188, green: 0.188, blue: 0.188, alpha: 1), for: .normal)
    }
    
    lazy var outboxBorderView = UIView().then {
        $0.backgroundColor = UIColor(red: 0.502, green: 0.443, blue: 0.988, alpha: 1)
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        title = "쪽지함"
        
        let navBackImage = UIImage(named: "arrow_left")
        self.navigationController?.navigationBar.backIndicatorImage = navBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = navBackImage
        
        /*** If needed Assign Title Here ***/
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        
//        let backButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
//        backButton.tintColor = UIColor(red: 0.071, green: 0.071, blue: 0.071, alpha: 1)
//        self.navigationItem.backBarButtonItem = backButton
        
        setUpView()
        setUpConstraints()
        inboxBtn.addTarget(self, action: #selector(goToInboxBtnDidTap), for: .touchUpInside)
        
        print(outboxBtn.isUserInteractionEnabled)
    }
    
    func setUpView() {
        self.view.addSubview(inboxBtn)
        self.view.addSubview(outboxBtn)
        self.view.addSubview(outboxBorderView)
    }
    
    func setUpConstraints() {
    
        inboxBtn.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.leading.equalToSuperview().offset(50)
        }
            
        outboxBtn.snp.makeConstraints { make in
            make.centerY.equalTo(inboxBtn)
            make.leading.lessThanOrEqualTo(inboxBtn.snp.trailing).offset(200)
            make.trailing.equalToSuperview().inset(50)
        }
        
        outboxBorderView.snp.makeConstraints { make in
//            make.horizontalEdges.equalTo(inboxBtn)
            make.top.equalTo(outboxBtn.snp.bottom).offset(5)
            make.centerX.equalTo(outboxBtn)
            make.trailing.equalToSuperview().inset(20)
//            make.width.equalTo(Constant.width * 162)
            make.height.equalTo(1)
        }
    }
    
    
    
    @objc func goToInboxBtnDidTap(_ sender: UIButton) {
        print("asd")
        // outbox 화면으로 이동
        let inboxViewController = InboxViewController()
        inboxViewController.modalTransitionStyle = .crossDissolve
        inboxViewController.modalPresentationStyle = .fullScreen
        self.present(inboxViewController, animated: true, completion: nil)
    }

    

   

}
