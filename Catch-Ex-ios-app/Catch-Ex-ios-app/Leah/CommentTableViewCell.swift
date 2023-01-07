//
//  CommunityCommentTableViewCell.swift
//  CatchEx_Practice
//
//  Created by 김사랑 on 2023/01/08.
//

import UIKit
import SnapKit
import Then

class CommentTableViewCell: UITableViewCell {

    static let cellIdentifier = "CommentTableViewCell"
            
    let baseView = UIView()
    
    let commentProfileImageBtn = UIButton().then {
        $0.setImage(UIImage(named: "profile_small"), for: .normal)
    }
    
    let commentNicknameLbl = UILabel().then {
        $0.text = "닉네임"
        $0.textColor = UIColor(red: 0.188, green: 0.188, blue: 0.188, alpha: 1)
        $0.font = UIFont.notosans(size: 14, family: .bold)
    }
    
    let commentDateLbl = UILabel().then {
        $0.text = "0000년 0월 0일"
        $0.textColor = UIColor(red: 0.376, green: 0.376, blue: 0.376, alpha: 1)
        $0.font = UIFont.notosans(size: 14, family: .regular)
    }
    
    let commentContentLbl = UILabel().then {
        $0.text = "내용"
        $0.textColor = UIColor(red: 0.376, green: 0.376, blue: 0.376, alpha: 1)
        $0.font = UIFont.notosans(size: 14, family: .regular)
        $0.numberOfLines = 3
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectedBackgroundView = UIView()
        
        setUpView()
        setUpConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView() {
        self.contentView.addSubview(baseView)
        baseView.addSubview(commentProfileImageBtn)
        baseView.addSubview(commentNicknameLbl)
        baseView.addSubview(commentDateLbl)
        baseView.addSubview(commentContentLbl)
    }
    
    func setUpConstraint() {
        
        baseView.snp.makeConstraints{ make in
//            make.top.bottomMargin.equalToSuperview()
            
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.trailing.equalToSuperview().inset(12)
        }
        
        commentProfileImageBtn.snp.makeConstraints { make in
            make.top.equalTo(28)
            make.leading.equalTo(20)
            make.height.width.equalTo(40)
        }
        
        commentNicknameLbl.snp.makeConstraints { make in
            make.top.equalTo(28)
            make.leading.equalTo(commentProfileImageBtn.snp.trailing).offset(12)
        }
        
        commentDateLbl.snp.makeConstraints { make in
            make.leading.equalTo(commentNicknameLbl)
            make.bottom.equalTo(commentProfileImageBtn)
        }
        
        commentContentLbl.snp.makeConstraints { make in
            make.top.equalTo(commentProfileImageBtn.snp.bottom).offset(16)
            make.leading.equalTo(commentProfileImageBtn)
            make.trailing.equalToSuperview().inset(100)
            make.bottom.equalToSuperview()
        }
    }
}
