//
//  LoginViewController.swift
//  Catch-Ex-ios-app
//
//  Created by 김지훈 on 2023/01/07.
//

import UIKit
import RxSwift
import RxGesture
import RxKeyboard
class LoginViewModel {
    
}
class LoginViewController: UIViewController {
    // MARK: - Properties
    var disposeBag = DisposeBag()
    // MARK: - Binding
    func bind(to viewModel: LoginViewModel) {
        signupLabel.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .bind { owner, _ in
                owner.navigationController?.pushViewController(SignUpViewController(), animated: true)
            }.disposed(by: disposeBag)
        RxKeyboard.instance.visibleHeight
            .skip(1)    // 초기 값 버리기
            .drive(with: self) { owner, keyboardVisibleHeight in
                owner.updateView(with: keyboardVisibleHeight)
            }.disposed(by: disposeBag)

    }
    
    func updateView(with keyboardHeight: CGFloat) {
        scrollView.snp.updateConstraints {
            $0.bottom.equalToSuperview().inset(keyboardHeight)
        }
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Initializer
    init(viewModel: LoginViewModel) {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .systemBackground
        setUI()
        bind(to: viewModel)
        warningView.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layoutIfNeeded()
        passwordInputView.textField.isSecureTextEntry = true
    }
    
    // MARK: - UIComponents
    let scrollView = UIScrollView()
    let contentView = UIView()
    let appNameLabel: UILabel = {
        $0.text = "Ja-ba"
        $0.font = .pretendardFont(size: 40, style: .bold)
        $0.textColor = .appColor(.primary)
        return $0
    }(UILabel())
    
    let descriptionLabel: UILabel = {
        $0.text = "자꾸만 생각나는 그 사람,\n혹시 그 사람도 날?"
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.font = .pretendardFont(size: 16, style: .regular)
        $0.textColor = .appColor(.gray3)
        return $0
    }(UILabel())
    
    let emailInputView = SimpleInputView(viewModel: .init(textFieldViewModel: .init(placeholder: "아이디")))
    let passwordInputView = SimpleInputView(viewModel: .init(textFieldViewModel: .init(placeholder: "비밀번호")))
    let completeButton: UIButton = {
        $0.setTitle("로그인", for: .normal)
        $0.backgroundColor = .appColor(.primary)
        $0.layer.cornerRadius = 8
        return $0
    }(UIButton())
    let warningView = WarningView(image: UIImage(named: "warning_stroke"), text: "이메일, 비밀번호를 확인해주세요.", color: .init(hex: "#F54336FF"))
    let findIdLabel: UILabel = {
        $0.text = "아이디 찾기"
        $0.textColor = .gray
        $0.font = .systemFont(ofSize: 14)
        return $0
    }(UILabel())
    let findPasswordLabel: UILabel = {
        $0.text = "비밀번호 찾기"
        $0.textColor = .gray
        $0.font = .systemFont(ofSize: 14)
        $0.textAlignment = .center
        
        return $0
    }(UILabel())
    let signupLabel: UILabel = {
        $0.text = "회원가입"
        $0.textColor = .gray
        $0.font = .systemFont(ofSize: 14)
        return $0
    }(UILabel())
    let optionView = UIView()
    
    let VLine1: UIView = {
        $0.backgroundColor = .gray
        return $0
    }(UIView())
    let VLine2: UIView = {
        $0.backgroundColor = .gray
        return $0
    }(UIView())
}

extension LoginViewController {
    func setUI() {
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        [appNameLabel, descriptionLabel, emailInputView, passwordInputView, warningView, completeButton, optionView].forEach { contentView.addSubview($0) }
        
        appNameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(120 / view.frame.height * 812)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(appNameLabel.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        
        emailInputView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(48)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        passwordInputView.snp.makeConstraints {
            $0.top.equalTo(emailInputView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        warningView.snp.makeConstraints {
            $0.top.equalTo(passwordInputView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20.75)
        }
        
        completeButton.snp.makeConstraints {
            $0.top.equalTo(warningView.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(52)
        }
        
        optionView.snp.makeConstraints {
            $0.top.equalTo(completeButton.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(30)
        }
        
        [findIdLabel, findPasswordLabel, signupLabel, VLine1, VLine2].forEach { optionView.addSubview($0) }

        findIdLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(36)
            $0.bottom.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        findPasswordLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(141)
            $0.centerY.equalToSuperview()
        }
        
        VLine1.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalTo(findPasswordLabel.snp.leading)
            $0.width.equalTo(1)
        }
        VLine2.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(findPasswordLabel.snp.trailing)
            $0.width.equalTo(1)
        }
        signupLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(36)
            $0.centerY.equalToSuperview()
        }
    }
}
