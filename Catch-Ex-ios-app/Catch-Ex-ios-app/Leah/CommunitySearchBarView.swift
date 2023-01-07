//
//  CommunitySearchBarView.swift
//  CatchEx_Practice
//
//  Created by 김사랑 on 2023/01/07.
//

import UIKit
import SnapKit
import Then

class CommunitySearchBarView: UIView, UITextFieldDelegate, UITextViewDelegate {
    
    let searchTextField = UITextField().then {
        $0.font = UIFont.notosans(size: 16, family: .regular)
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .white
        $0.textColor = .black
        $0.tintColor = .black
    }
    
    lazy var searchBtn = UIButton().then {
        $0.setImage(UIImage(named: "search"), for: .normal)
        $0.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 15, weight: .regular), forImageIn: .normal)
        $0.tintColor = .black
    }
    
    lazy var firstViewBtn = UIButton().then {
        $0.setTitle("인기", for: .normal)
        $0.setTitleColor(UIColor(red: 0.502, green: 0.443, blue: 0.988, alpha: 1), for: .normal)
        $0.titleLabel?.font = UIFont.notosans(size: 16, family: .regular)
        $0.backgroundColor = UIColor(red: 0.941, green: 0.933, blue: 1, alpha: 1)
        $0.layer.borderColor = UIColor(red: 0.502, green: 0.443, blue: 0.988, alpha: 1).cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 12
    }
    
    lazy var secondViewBtn = UIButton().then {
        $0.setTitle("이별", for: .normal)
        $0.setTitleColor(UIColor(red: 0.773, green: 0.776, blue: 0.792, alpha: 1), for: .normal)
        $0.titleLabel?.font = UIFont.notosans(size: 16, family: .regular)
        $0.backgroundColor = .white
        $0.layer.borderColor = UIColor(red: 0.773, green: 0.776, blue: 0.792, alpha: 1).cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 12
    }
    
    lazy var thirdViewBtn = UIButton().then {
        $0.setTitle("19금", for: .normal)
        $0.setTitleColor(UIColor(red: 0.773, green: 0.776, blue: 0.792, alpha: 1), for: .normal)
        $0.titleLabel?.font = UIFont.notosans(size: 16, family: .regular)
        $0.backgroundColor = .white
        $0.layer.borderColor = UIColor(red: 0.773, green: 0.776, blue: 0.792, alpha: 1).cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 12
    }
    
    lazy var fourthViewBtn = UIButton().then {
        $0.setTitle("꿀팁", for: .normal)
        $0.setTitleColor(UIColor(red: 0.773, green: 0.776, blue: 0.792, alpha: 1), for: .normal)
        $0.titleLabel?.font = UIFont.notosans(size: 16, family: .regular)
        $0.backgroundColor = .white
        $0.layer.borderColor = UIColor(red: 0.773, green: 0.776, blue: 0.792, alpha: 1).cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 12
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 화면을 누르면 키보드 내려가게 하는 것
        self.endEditing(true)
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
        addSubview(searchTextField)
        searchTextField.addSubview(searchBtn)
        addSubview(firstViewBtn)
        addSubview(secondViewBtn)
        addSubview(thirdViewBtn)
        addSubview(fourthViewBtn)
        
        
        searchTextField.addLeftPadding()
        
        textFieldDidBeginEditing(searchTextField)
        textFieldDidEndEditing(searchTextField)
    }
    
    func setUpConstraints() {
        searchTextField.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(40)
        }
        
        searchBtn.snp.makeConstraints { make in
            make.top.equalTo(9.8)
            make.bottom.equalTo(-9.8)
            make.trailing.equalTo(-13.8)
        }
        
        firstViewBtn.snp.makeConstraints { make in
            make.left.equalTo(searchTextField.snp.left)
            make.top.equalTo(searchTextField.snp.bottom).offset(16)
            make.height.equalTo(26)
            make.width.equalTo(60)
            make.bottom.equalTo(-16)
        }
        
        secondViewBtn.snp.makeConstraints{ make in
            make.leading.equalTo(firstViewBtn.snp.trailing).offset(8)
            make.centerY.equalTo(firstViewBtn)
            make.width.height.equalTo(firstViewBtn)
        }
        
        thirdViewBtn.snp.makeConstraints{ make in
            make.leading.equalTo(secondViewBtn.snp.trailing).offset(8)
            make.centerY.equalTo(secondViewBtn)
            make.width.height.equalTo(firstViewBtn)
        }
        
        fourthViewBtn.snp.makeConstraints{ make in
            make.leading.equalTo(thirdViewBtn.snp.trailing).offset(8)
            make.centerY.equalTo(thirdViewBtn)
            make.width.height.equalTo(firstViewBtn)
        }
    }
    
    // MARK: 텍스트필드 커스텀
    @objc func textFieldDidBeginEditing(_ textField: UITextField) {
        
        // 텍스트필드 입력 시 테두리 생기게 하기
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(red: 0.188, green: 0.188, blue: 0.188, alpha: 1).cgColor
        
        // 초기 탭 시, 텍스트필드 비우기 (1)
        textField.placeholder = nil
    }
    
    @objc func textFieldDidEndEditing(_ textField: UITextField) {
        
        // 초기 탭 시, 텍스트필드 비우기 (2)
        textField.placeholder = "검색어를 입력해주세요"
        textField.attributedPlaceholder = NSAttributedString(
            string: "검색어를 입력해주세요",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.754, green: 0.754, blue: 0.754, alpha: 1)]
        )
    }
}


// MARK: 텍스트필드 왼쪽 간격 주기 -> 패딩에서 텍스트 입력 시작
extension UITextField {
  func add() {
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: self.frame.height))
    self.leftView = paddingView
    self.leftViewMode = ViewMode.always
  }
}
