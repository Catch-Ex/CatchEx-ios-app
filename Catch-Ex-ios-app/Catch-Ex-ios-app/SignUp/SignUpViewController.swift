//
//  SignUpViewController.swift
//  Catch-Ex-ios-app
//
//  Created by 김지훈 on 2023/01/07.
//

import UIKit
import RxKeyboard
import RxSwift

class IDInputView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let titleLabel: UILabel = {
        $0.text = "아이디"
        $0.font = .pretendardFont(size: 14, style: .semiBold)
        return $0
    }(UILabel())
    let textfield = SimpleInputView(viewModel: .init(textFieldViewModel: .init(placeholder: "아이디를 입력해주세요.")))
    func setUI() {
        [titleLabel, textfield].forEach { addSubview($0) }
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        textfield.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
class PasswordInputView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let titleLabel: UILabel = {
        $0.text = "비밀번호"
        $0.font = .pretendardFont(size: 14, style: .semiBold)
        return $0
    }(UILabel())
    let passwordTextfield = SimpleInputView(viewModel: .init(textFieldViewModel: .init(placeholder: "영문, 숫자, 특수문자 조합 8자리 이상")))
    let passwordConfirmTextField = SimpleInputView(viewModel: .init(textFieldViewModel: .init(placeholder: "비밀번호 확인")))
    func setUI() {
        [titleLabel, passwordTextfield, passwordConfirmTextField].forEach { addSubview($0) }
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        passwordTextfield.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
        }
        passwordConfirmTextField.snp.makeConstraints {
            $0.top.equalTo(passwordTextfield.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
class SignUpViewController: UIViewController {
    var disposeBag = DisposeBag()
    let contentView = UIView()
    let VStackView: UIStackView = {
        $0.axis = .vertical
        $0.distribution = .fillProportionally
        $0.spacing = 24
        return $0
    }(UIStackView())
    func bind() {
        RxKeyboard.instance.visibleHeight
            .skip(1)    // 초기 값 버리기
            .drive(with: self) { owner, keyboardVisibleHeight in
                owner.updateView(with: keyboardVisibleHeight)
            }.disposed(by: disposeBag)
        let idInput = idInputView.textfield.textField.viewModel.inputStringRelay
        let passwordInput = passwordInputView.passwordTextfield.textField.viewModel.inputStringRelay
        let confirmInput = passwordInputView.passwordConfirmTextField.textField.viewModel.inputStringRelay
        let combinedData = Observable.combineLatest(idInput, passwordInput, confirmInput).share()
        
        combinedData.filter { !$0.0.isEmpty && !$0.1.isEmpty && !$0.2.isEmpty}
            .bind(with: self) { owner, _ in
                owner.completeButton.backgroundColor = .appColor(.primary)
                owner.completeButton.isUserInteractionEnabled = true
            }.disposed(by: disposeBag)
        combinedData.filter { !(!$0.0.isEmpty && !$0.1.isEmpty && !$0.2.isEmpty && $0.1 == $0.2) }
            .bind(with: self) { owner, _ in
                owner.completeButton.backgroundColor = .appColor(.빈인풋)
                owner.completeButton.isUserInteractionEnabled = false
            }.disposed(by: disposeBag)
        combinedData
            .bind { [weak self] in
                self?.waringView2.isHidden = $0.1 == $0.2
            }.disposed(by: disposeBag)
        
        // TODO: 서버통신
        completeButton.rx.tap
            .withLatestFrom(combinedData)
            .bind(with: self) { owner, data in
                UserDefaultManager.user.id = data.0
                UserDefaultManager.user.password = data.1
                let vc = SignUpViewController2()
                
                owner.navigationController?.pushViewController(vc, animated: true)
            }.disposed(by: disposeBag)
    }
    
    func updateView(with keyboardHeight: CGFloat) {
        scrollView.snp.updateConstraints {
            $0.bottom.equalToSuperview().inset(keyboardHeight + 100)
        }
        completeButton.snp.updateConstraints {
            $0.bottom.equalToSuperview().inset(
                keyboardHeight == 0
                ? 34
                :keyboardHeight + 26
            )
        }
        UIView.animate(withDuration: 0.4) {
//            self.view.layoutIfNeeded()
        }
    }
    let scrollView = UIScrollView()
    let idInputView = IDInputView()
    let waringView = WarningView(image: UIImage(named: "warning_stroke"), text: "이미 가입된 아이디입니다.", color: .init(hex: "#F54336FF"))
    let waringView2 = WarningView(image: UIImage(named: "warning_stroke"), text: "비밀번호가 일치하지 않아요.", color: .init(hex: "#F54336FF"))
    let passwordInputView = PasswordInputView()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "회원가입"
        view.backgroundColor = .white
        setUI()
        waringView.isHidden = true
        waringView2.isHidden = true
        bind()
        passwordInputView.passwordConfirmTextField.textField.isSecureTextEntry = true
        passwordInputView.passwordTextfield.textField.isSecureTextEntry = true
        setupNavigationBackButton()
    }
    let completeButton: UIButton = {
        $0.setTitle("다음", for: .normal)
        $0.backgroundColor = .appColor(.gray1)
        $0.layer.cornerRadius = 8
        return $0
    }(UIButton())
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
        
        contentView.addSubview(VStackView)
        
        [idInputView, waringView, passwordInputView, waringView2].forEach { VStackView.addArrangedSubview($0) }
        
        VStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(50)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(50)
        }
        
        view.addSubview(completeButton)
        
        completeButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(56)
            $0.bottom.equalToSuperview().inset(34)
        }
    }
}
class 인증View: UIView {
    var disposeBag = DisposeBag()
    init(title: String, placeholder: String, completeButtonText: String) {
        titleLabel.text = title
        textfield = SimpleInputView(viewModel: .init(textFieldViewModel: .init(placeholder: placeholder)))
        super.init(frame: .zero)
        confirmButton.setTitle(completeButtonText, for: .normal)
        bind()
        setUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let titleLabel: UILabel = {
        $0.font = .pretendardFont(size: 14, style: .semiBold)
        $0.textColor = .init(hex: "#303030FF")
        return $0
    }(UILabel())
    
    let textfield: SimpleInputView
    let confirmButton: UIButton = {
        $0.backgroundColor = .appColor(.빈인풋)
        $0.layer.cornerRadius = 8
        $0.titleLabel?.font = .pretendardFont(size: 16, style: .regular)
        return $0
    }(UIButton())
    
    func setUI() {
        [titleLabel, textfield, confirmButton].forEach { addSubview($0) }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        
        textfield.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(20)
            $0.width.equalTo(215 * UIScreen.main.bounds.width / 375)
            $0.bottom.equalToSuperview()
        }
        confirmButton.snp.makeConstraints {
            $0.leading.equalTo(textfield.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(textfield)
            $0.centerY.equalTo(textfield)
        }
    }
    
    func bind() {
        textfield.textField.viewModel.inputStringRelay
            .bind(with: self) { owner, string in
                let valid = !string.isEmpty
                owner.confirmButton.isUserInteractionEnabled = valid
                owner.confirmButton.backgroundColor = valid ? .appColor(.primary) : .appColor(.빈인풋)
            }.disposed(by: disposeBag)
    }
}
class SignUpViewController2: UIViewController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        setUI()
        
        view.backgroundColor = .white
        bind()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var disposeBag = DisposeBag()
    func bind() {
        RxKeyboard.instance.visibleHeight
            .skip(2)    // 초기 값 버리기
            .drive(with: self) { owner, keyboardVisibleHeight in
                print("Asd")
                owner.updateView(with: keyboardVisibleHeight)
            }.disposed(by: disposeBag)
        
        phoneInput.confirmButton.rx.tap
            .bind(with: self) { owner, _ in
                let vc = OneButtonAlertViewController(viewModel: .init(content: "임시 인증번호!\n 0000", buttonText: "확인", textColor: .appColor(.primary)))
                owner.present(vc, animated: false)
            }.disposed(by: disposeBag)
        codeInput.confirmButton.rx.tap
            .bind(with: self) { owner, _ in
                let vc = OneButtonAlertViewController(viewModel: .init(content: "인증 완료!", buttonText: "확인", textColor: .appColor(.primary)))
                owner.present(vc, animated: false)
                owner.completeButton.isUserInteractionEnabled = true
                owner.completeButton.backgroundColor = .appColor(.primary)
            }.disposed(by: disposeBag)
        completeButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(FirstStepViewController(), animated: true)
            }.disposed(by: disposeBag)
    }
    
    func updateView(with keyboardHeight: CGFloat) {
        completeButton.snp.updateConstraints {
            $0.bottom.equalToSuperview().inset(
                keyboardHeight == 0
                ? 34
                :keyboardHeight + 26
            )
        }
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "회원가입"
        setupNavigationBackButton()

    }
    let phoneInput = 인증View(title: "휴대폰 번호", placeholder: "휴대폰 번호 입력", completeButtonText: "인증요청")
    let codeInput = 인증View(title: "인증번호", placeholder: "인증번호 입력", completeButtonText: "확인")
    let completeButton: UIButton = {
        $0.setTitle("다음", for: .normal)
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .appColor(.빈인풋)
        return $0
    }(UIButton())
    func setUI() {
        [phoneInput, codeInput, completeButton].forEach { view.addSubview($0) }
        phoneInput.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(50)
            $0.leading.trailing.equalToSuperview()
        }
        codeInput.snp.makeConstraints {
            $0.top.equalTo(phoneInput.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
        }
        completeButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }
    }
}


