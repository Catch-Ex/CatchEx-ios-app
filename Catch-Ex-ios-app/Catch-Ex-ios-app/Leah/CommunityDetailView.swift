//
//  CommunityDetailView.swift
//  CatchEx_Practice
//
//  Created by 김사랑 on 2023/01/08.
//

import UIKit
import SnapKit
import Then

class CommunityDetailView: UIView {

    let profileImageBtn = UIButton().then {
        $0.setImage(UIImage(named: "profile_small"), for: .normal)
    }
    
    let nicknameLbl = UILabel().then {
        $0.text = "닉네임"
        $0.textColor = UIColor(red: 0.188, green: 0.188, blue: 0.188, alpha: 1)
        $0.font = UIFont.pretendardFont(size: 14, style: .bold)
    }
    
    let dateLbl = UILabel().then {
        $0.text = "0000년 0월 0일"
        $0.textColor = UIColor(red: 0.376, green: 0.376, blue: 0.376, alpha: 1)
        $0.font = UIFont.pretendardFont(size: 14, style: .regular)
    }
    
    let titleLbl = UILabel().then {
        $0.text = "제목"
        $0.textColor = UIColor(red: 0.188, green: 0.188, blue: 0.188, alpha: 1)
        $0.font = UIFont.pretendardFont(size: 14, style: .bold)
    }
    
    let contentLbl = UILabel().then {
        $0.text = "내용"
        $0.textColor = UIColor(red: 0.376, green: 0.376, blue: 0.376, alpha: 1)
        $0.font = UIFont.pretendardFont(size: 14, style: .regular)
        $0.numberOfLines = 3
    }
    
    lazy var heartBtn = UIButton().then {
        $0.setImage(UIImage(named: "heart_empty"), for: .normal)
    }
    
    @objc func toggleHeart(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected{
            sender.setImage(UIImage(named: "heart_fill"), for: .selected)
        }else{
            sender.setImage(UIImage(named: "heart_empty"), for: .normal)
        }
//        print("좋아요")
//        DispatchQueue.main.async {
//            sender.setImage(sender.image(for: .normal) ==
//                        ? UIImage(systemName: "heart_fill") :  UIImage(systemName: "heart_empty"), for: .normal)
//        }
    }
    
    let countHeartLbl = UILabel().then {
        $0.text = "00"
        $0.textColor = UIColor(red: 0.376, green: 0.376, blue: 0.376, alpha: 1)
        $0.font = UIFont.pretendardFont(size: 12, style: .regular)
    }
    
    let commentImageView = UIImageView().then {
        $0.image = UIImage(named: "comment")
        
    }
    
    let countCommentLbl = UILabel().then {
        $0.text = "00"
        $0.textColor = UIColor(red: 0.376, green: 0.376, blue: 0.376, alpha: 1)
        $0.font = UIFont.pretendardFont(size: 12, style: .regular)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpView()
        setUpConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setUpView()
        setUpConstraints()
    }
    
    func setUpView() {
        
        addSubview(profileImageBtn)
        addSubview(nicknameLbl)
        addSubview(dateLbl)
        addSubview(titleLbl)
        addSubview(contentLbl)
        addSubview(heartBtn)
        addSubview(countHeartLbl)
        addSubview(commentImageView)
        addSubview(countCommentLbl)
        
        heartBtn.addTarget(self, action: #selector(toggleHeart), for: .touchUpInside)
    }
    
    func setUpConstraints() {
        
        profileImageBtn.snp.makeConstraints { make in
            make.top.equalTo(28)
            make.leading.equalTo(20)
            make.height.width.equalTo(40)
        }
        
        nicknameLbl.snp.makeConstraints { make in
            make.top.equalTo(28)
            make.leading.equalTo(profileImageBtn.snp.trailing).offset(12)
        }
        
        dateLbl.snp.makeConstraints { make in
            make.left.equalTo(nicknameLbl.snp.left)
            make.bottom.equalTo(profileImageBtn.snp.bottom)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.top.equalTo(profileImageBtn.snp.bottom).offset(20)
            make.left.equalTo(profileImageBtn.snp.left)
            make.trailing.equalToSuperview().offset(-100)
        }
        
        contentLbl.snp.makeConstraints { make in
            make.top.equalTo(titleLbl.snp.bottom).offset(16)
            make.left.equalTo(titleLbl.snp.left)
            make.trailing.equalToSuperview().offset(-100)
        }
        
        heartBtn.snp.makeConstraints { make in
            make.top.equalTo(contentLbl.snp.bottom).offset(22)
            make.bottom.equalTo(-30)
            make.left.equalTo(contentLbl.snp.left)
        }
        
        countHeartLbl.snp.makeConstraints { make in
            make.centerY.equalTo(heartBtn)
            make.leading.equalTo(heartBtn.snp.trailing).offset(5)
        }
        
        commentImageView.snp.makeConstraints { make in
            make.centerY.equalTo(countHeartLbl)
            make.leading.equalTo(countHeartLbl.snp.trailing).offset(19)
        }
        
        countCommentLbl.snp.makeConstraints { make in
            make.centerY.equalTo(commentImageView)
            make.leading.equalTo(commentImageView.snp.trailing).offset(5)
        }
    }
}
