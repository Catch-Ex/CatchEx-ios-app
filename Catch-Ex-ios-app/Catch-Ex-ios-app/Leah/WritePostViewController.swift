//
//  WritePostViewController.swift
//  CatchEx_Practice
//
//  Created by 김사랑 on 2023/01/07.
//

import UIKit
import SnapKit
import Then

class WritePostViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    let placeholderContent = "내용 입력"
    
//    lazy var offBtn = UIButton().then {
//        $0.setImage(UIImage(systemName: "multiply"), for: .normal)
//        $0.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 23, weight: .medium), forImageIn: .normal)
//        $0.tintColor = .black
//        $0.addTarget(self, action: #selector(offBtnDidTap), for: .touchUpInside)
//    }
    
//    lazy var postBtn = UIButton().then {
//        $0.setTitle("완료", for: .normal)
//        $0.setTitleColor(.black, for: .normal)
//        $0.titleLabel?.font = UIFont.notosans(size: 20, family: .regular)
//        $0.addTarget(self, action: #selector(postBtnDidTap), for: .touchUpInside)
//        $0.setTitleColor(.systemGray, for: .highlighted)
//    }
    
    let titleTextField = UITextField().then {
        $0.font = UIFont.notosans(size: 20, family: .regular)
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .white
        $0.textColor = .black
        $0.tintColor = .black
    }
    
    let contentTextView = UITextView().then {
        $0.font = UIFont.notosans(size: 18, family: .regular)
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .white
        $0.tintColor = .black
        $0.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1).cgColor
    }
    
    lazy var titleBorderView = UIView().then {
        $0.backgroundColor = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
                
        titleTextField.delegate = self
        contentTextView.delegate = self
                
        titleTextField.addLeftPadding()
        
        textFieldDidBeginEditing(titleTextField)
        textFieldDidEndEditing(titleTextField)
        
        textViewDidBeginEditing(contentTextView)
        textViewDidChange(contentTextView)
        textViewDidEndEditing(contentTextView)
        
        setupTextView()
        
        setUpView()
        setUpConstraints()
    }

    func setupTextView() {
        contentTextView.text = placeholderContent /// 초반 placeholder 생성
        contentTextView.textColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1) /// 초반 placeholder 색상 설정
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 화면을 누르면 키보드 내려가게 하는 것
        self.view.endEditing(true)
    }
    
    func setUpView() {
        self.view.addSubview(titleTextField)
        self.view.addSubview(contentTextView)
        self.view.addSubview(titleBorderView)
    }
    
    func setUpConstraints() {
        
        titleTextField.snp.makeConstraints{ (make) in
            make.top.equalTo(134)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(Constant.height * 48)
        }
        
        contentTextView.snp.makeConstraints{ (make) in
            make.top.equalTo(titleTextField.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(Constant.height * 281)
        }

        titleBorderView.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(3)
            make.centerX.equalToSuperview()
            make.height.equalTo(1)
            make.left.right.equalTo(titleTextField)
        }

    }
    
    func isEmptyOrNot() -> Bool {
//        let text = titleTextField.text
        
        if (contentTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) {
            return true
        }
        else {
            return false
        }
    }
    
    // MARK: 텍스트필드 커스텀
    @objc func textFieldDidBeginEditing(_ textField: UITextField) {
        
        // 초기 탭 시, 텍스트필드 비우기 (1)
        textField.placeholder = nil
    }
    
    @objc func textFieldDidEndEditing(_ textField: UITextField) {
        
        // 초기 탭 시, 텍스트필드 비우기 (2)
        textField.placeholder = "제목"
        textField.attributedPlaceholder = NSAttributedString(
            string: "제목",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)]
        )
    }

    // MARK: 텍스트뷰 커스텀
    @objc func textViewDidBeginEditing(_ textView: UITextView) {
        
        // 텍스트뷰 입력 시 테두리 생기게 하기
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1).cgColor
        
        // 플레이스홀더
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.textColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
            textView.text = placeholderContent
        } else if textView.text == placeholderContent {
            textView.textColor = .black // text 색상
            textView.text = nil // 텍스트뷰 초기 터치 시 플레이스홀더 사라짐
        }
    }
    
    @objc func textViewDidChange(_ textView: UITextView) {
        
        // contentTextView 높이 동적 조정
        var frame = textView.frame
        frame.size.height = textView.contentSize.height
        textView.frame = frame
    
    }
    
    @objc func textViewDidEndEditing(_ textView: UITextView) {
        
        // 텍스트뷰 입력 시 테두리 생기게 하기
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1).cgColor
    }
}

// MARK: 텍스트필드 왼쪽 간격 주기 -> 패딩에서 텍스트 입력 시작
extension UITextField {
  func addLeftPadding() {
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: self.frame.height))
    self.leftView = paddingView
    self.leftViewMode = ViewMode.always
  }
}
