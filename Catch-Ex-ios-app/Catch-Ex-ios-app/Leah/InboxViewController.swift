//
//  inboxViewController.swift
//  Catch-Ex-ios-app
//
//  Created by 김사랑 on 2023/01/08.
//

import UIKit
import SnapKit
import Then

class InboxViewController: UIViewController {
    
    lazy var inboxBtn = UIButton().then {
        $0.setTitle("받은 쪽지함", for: .normal)
        $0.setTitleColor(UIColor(red: 0.188, green: 0.188, blue: 0.188, alpha: 1), for: .normal)
    }
    
    lazy var outboxBtn = UIButton().then {
        $0.setTitle("보낸 쪽지함", for: .normal)
        $0.setTitleColor(UIColor(red: 0.188, green: 0.188, blue: 0.188, alpha: 1), for: .normal)
    }
    
    lazy var inboxBorderView = UIView().then {
        $0.backgroundColor = UIColor(red: 0.502, green: 0.443, blue: 0.988, alpha: 1)
    }
    
    let profileImageBtn = UIButton().then {
        $0.setImage(UIImage(named: "profile_mailbox"), for: .normal)
    }
    
    let nicknameLbl = UILabel().then {
        $0.text = "아크아크"
        $0.textColor = UIColor(red: 0.188, green: 0.188, blue: 0.188, alpha: 1)
        $0.font = UIFont.pretendardFont(size: 14, style: .semiBold)
    }
    
    let dateLbl = UILabel().then {
        $0.text = "2023년 1월 7일"
        $0.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        $0.font = UIFont.pretendardFont(size: 12, style: .regular)
    }
    
    lazy var mailboxView = UIView().then {
        $0.backgroundColor = UIColor(red: 0.961, green: 0.965, blue: 0.98, alpha: 1)
        $0.layer.cornerRadius = 12
    }
    
    let contentLbl = UILabel().then {
        $0.text = "잘 지내? 요즘 어떻게 지내는지 궁금하다...\n이 쪽지를 언젠가 꼭 보길 바래."
        $0.textColor = UIColor(red: 0.188, green: 0.188, blue: 0.188, alpha: 1)
        $0.font = UIFont.pretendardFont(size: 14, style: .regular)
        $0.numberOfLines = 0
    }
    
    
    


    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        title = "쪽지함"
        setupNavigationBackButton()
        
//        let backButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
//        backButton.tintColor = UIColor(red: 0.071, green: 0.071, blue: 0.071, alpha: 1)
//        self.navigationItem.backBarButtonItem = backButton
        
        setUpView()
        setUpConstraints()
        outboxBtn.addTarget(self, action: #selector(goToOutboxBtnDidTap), for: .touchUpInside)
        
        print(outboxBtn.isUserInteractionEnabled)
    }
    
    func setUpView() {
        self.view.addSubview(inboxBtn)
        self.view.addSubview(outboxBtn)
        self.view.addSubview(inboxBorderView)
        self.view.addSubview(profileImageBtn)
        self.view.addSubview(nicknameLbl)
        self.view.addSubview(dateLbl)
        self.view.addSubview(mailboxView)
        self.mailboxView.addSubview(contentLbl)
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
        
        inboxBorderView.snp.makeConstraints { make in
//            make.horizontalEdges.equalTo(inboxBtn)
            make.top.equalTo(inboxBtn.snp.bottom).offset(5)
            make.centerX.equalTo(inboxBtn)
            make.leading.equalToSuperview().offset(20)
//            make.width.equalTo(Constant.width * 162)
            make.height.equalTo(1)
        }
        
        profileImageBtn.snp.makeConstraints { make in
            make.top.equalTo(inboxBorderView.snp.bottom).offset(24)
            make.leading.equalTo(20)
            make.height.width.equalTo(Constant.height * 40)
        }
        
        nicknameLbl.snp.makeConstraints { make in
            make.top.equalTo(profileImageBtn)
            make.leading.equalTo(profileImageBtn.snp.trailing).offset(12)
        }
        
        dateLbl.snp.makeConstraints { make in
            make.leading.equalTo(nicknameLbl)
            make.bottom.equalTo(profileImageBtn)
        }
        
        mailboxView.snp.makeConstraints { make in
            make.top.equalTo(dateLbl.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        contentLbl.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(20)
            make.leading.trailing.equalToSuperview().inset(15)
        }
    }
    
    
    
    @objc func goToOutboxBtnDidTap(_ sender: UIButton) {
        print("asd")
        // outbox 화면으로 이동
        let outboxViewController = OutboxViewController()
        outboxViewController.modalTransitionStyle = .crossDissolve
        outboxViewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(outboxViewController, animated: false)
    }

}
