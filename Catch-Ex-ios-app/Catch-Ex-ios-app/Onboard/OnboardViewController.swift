//
//  OnboardViewController.swift
//  Catch-Ex-ios-app
//
//  Created by 김지훈 on 2023/01/07.
//

import UIKit
import RxSwift
import RxKeyboard
class BaseStepViewController: UIViewController {
    var disposeBag = DisposeBag()
    init() {
        super.init(nibName: nil, bundle: nil)
        disposeBag = DisposeBag()
        setBaseUI()
        baseBind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func baseBind() {
        RxKeyboard.instance.visibleHeight
            .skip(1)    // 초기 값 버리기
            .drive(with: self) { owner, keyboardVisibleHeight in
                owner.updateView(with: keyboardVisibleHeight)
            }.disposed(by: disposeBag)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        firstStepView.backgroundColor = .appColor(.primary)
    }
    let completeButton: UIButton = {
        $0.setTitle("다음", for: .normal)
        $0.backgroundColor = .appColor(.gray1)
        $0.layer.cornerRadius = 8
        return $0
    }(UIButton())

    func updateView(with keyboardHeight: CGFloat) {
        scrollView.snp.updateConstraints {
            $0.bottom.equalToSuperview().inset(keyboardHeight + 50)
        }
        completeButton.snp.updateConstraints {
            $0.bottom.equalToSuperview().inset(
                keyboardHeight == 0
                ? 34
                : keyboardHeight + 20
            )
        }
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
    }
    let stepView = UIView()
    lazy var firstStepView = makeStepView(step: 1)
    lazy var secondStepView = makeStepView(step: 2)
    lazy var thirdStepView = makeStepView(step: 3)
    let stepfirstLineView: UIView = {
        $0.backgroundColor = .appColor(.primary)
        return $0
    }(UIView())
    let stepsecondLineView: UIView = {
        $0.backgroundColor = .appColor(.disable)
        return $0
    }(UIView())
    let scrollView = UIScrollView()
    
    func makeStepView(step: Int) -> UIView {
        let v = UIView()
        v.backgroundColor = .init(hex: "#D5D6DAFF")
        v.layer.cornerRadius = 10
        let l = UILabel()
        l.text = "\(step)"
        l.textColor = .white
        v.addSubview(l)
        l.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        return v
    }
    
    func setBaseUI() {
        [firstStepView, stepfirstLineView, secondStepView, stepsecondLineView, thirdStepView].forEach { stepView.addSubview($0) }
        
        firstStepView.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
            $0.width.height.equalTo(20)
            $0.bottom.equalToSuperview()
        }
        stepfirstLineView.snp.makeConstraints {
            $0.leading.equalTo(firstStepView.snp.trailing)
            $0.width.equalTo(12)
            $0.height.equalTo(1)
            $0.centerY.equalToSuperview()
        }
        secondStepView.snp.makeConstraints {
            $0.leading.equalTo(stepfirstLineView.snp.trailing)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(20)
        }
        stepsecondLineView.snp.makeConstraints {
            $0.leading.equalTo(secondStepView.snp.trailing)
            $0.width.equalTo(12)
            $0.height.equalTo(1)
            $0.centerY.equalToSuperview()
        }
        thirdStepView.snp.makeConstraints {
            $0.leading.equalTo(stepsecondLineView.snp.trailing)
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(20)
        }

        [stepView, scrollView].forEach { view.addSubview($0) }
        stepView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(35)
            $0.height.equalTo(20)
            $0.centerX.equalToSuperview()
        }
        scrollView.snp.makeConstraints {
            $0.top.equalTo(stepView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        view.addSubview(completeButton)
        
        completeButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(56)
            $0.bottom.equalToSuperview().inset(34)
        }
    }
}
class FirstStepViewController: BaseStepViewController {
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind() {
        completeButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(SecondStepViewController(), animated: false)
            }.disposed(by: disposeBag)
        let nicknameInput = nickNameInputView.textField.viewModel.inputStringRelay
        nicknameInput
            .bind(with: self) { owner, string in
                let isEmpty = string.isEmpty
                owner.updateCheckButton(owner.checkButton, state: !isEmpty)
            }.disposed(by: disposeBag)
        
        checkButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.validNickNameView.isHidden = false
                owner.updateCheckButton(owner.completeButton, state: true)
            }.disposed(by: disposeBag)
    }
    func updateCheckButton(_ sender: UIButton, state: Bool) {
        sender.isUserInteractionEnabled = state
        sender.backgroundColor = state ? .appColor(.primary) : .appColor(.빈인풋)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bind()
        validNickNameView.isHidden = true
    }
    
    let contentView = UIView()
    let celebrationLabel: UILabel = {
        $0.text = "가입을 축하드립니다.\n닉네임을 설정해주세요."
        $0.font = .pretendardFont(size: 24, style: .bold)
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    let nickNameLabel: UILabel = {
        $0.text = "닉네임"
        $0.font = .pretendardFont(size: 14, style: .bold)
        return $0
    }(UILabel())
    let nickNameInputView = SimpleInputView(viewModel: .init(textFieldViewModel: .init(placeholder: "8자 이내 한글 혹은 영문")))
    let checkButton: UIButton = {
        $0.setTitle("중복 확인", for: .normal)
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .appColor(.disable)
        $0.titleLabel?.font = .pretendardFont(size: 16, style: .regular)
        return $0
    }(UIButton())
    let validNickNameView = WarningView(image: UIImage(systemName: "trash"), text: "사용 가능한 닉네임입니다.", color: .appColor(.primary))
    let invalidNickNameView = WarningView(image: UIImage(named: "warning_stroke"), text: "사용할 수 없는 닉네임입니다.", color: .red)
    
    func setUI() {
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        [celebrationLabel, nickNameLabel, nickNameInputView, checkButton, validNickNameView].forEach { contentView.addSubview($0) }
        
        celebrationLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(43)
            $0.leading.equalToSuperview().inset(20)
        }
        
        nickNameLabel.snp.makeConstraints {
            $0.top.equalTo(celebrationLabel.snp.bottom).offset(40)
            $0.leading.equalToSuperview().inset(20)
        }
        
        nickNameInputView.snp.makeConstraints {
            $0.top.equalTo(nickNameLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(20)
            $0.width.equalTo(215 * UIScreen.main.bounds.width / 375)
        }
        
        checkButton.snp.makeConstraints {
            $0.leading.equalTo(nickNameInputView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(48)
            $0.top.equalTo(nickNameLabel.snp.bottom).offset(12)
        }
        
        validNickNameView.snp.makeConstraints {
            $0.top.equalTo(checkButton.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(20.75)
            $0.bottom.equalToSuperview()
        }
    }
}
enum GenderSelection: Int {
    case man, woman
    
    func asString() -> String {
        switch self {
        case .man:
            return "남자"
        case .woman:
            return "여자"
        }
    }
}
class SecondStepViewController: BaseStepViewController {
    func bind() {
        completeButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(ThirdStepViewController(), animated: false)
            }.disposed(by: disposeBag)
        manView.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .bind { owner, _ in
                print("asd")
                owner.selectedButton(type: .man)
            }.disposed(by: disposeBag)
        womanView.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .bind { owner, _ in
                owner.selectedButton(type: .woman)
            }.disposed(by: disposeBag)
    }
    func selectedButton(type: GenderSelection) {
        switch type {
        case .man:
            manView.layer.borderColor = UIColor.appColor(.primary).cgColor
            manImageView.tintColor = .appColor(.primary)
            manLabel.textColor = .appColor(.primary)
            manView.backgroundColor = .init(hex: "#F0EEFFFF")
            
            womanView.layer.borderColor = UIColor(hex: "#EDEDEDFF")?.cgColor
            womanImageView.tintColor = UIColor(hex: "#C5C6CAFF")
            womanLabel.textColor = UIColor(hex: "#C5C6CAFF")
            womanView.backgroundColor = .white
        case .woman:
            womanView.layer.borderColor = UIColor.appColor(.primary).cgColor
            womanImageView.tintColor = .appColor(.primary)
            womanLabel.textColor = .appColor(.primary)
            womanView.backgroundColor = .init(hex: "#F0EEFFFF")
            
            manView.layer.borderColor = UIColor(hex: "#EDEDEDFF")?.cgColor
            manImageView.tintColor = UIColor(hex: "#C5C6CAFF")
            manLabel.textColor = UIColor(hex: "#C5C6CAFF")
            manView.backgroundColor = .white
        }
        
        completeButton.backgroundColor = .appColor(.primary)
        completeButton.isUserInteractionEnabled = true
    }
    override init() {
        super.init()
        
        secondStepView.backgroundColor = .appColor(.primary)
        stepfirstLineView.backgroundColor = .appColor(.primary)
        setUI()
        bind()
        completeButton.isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    let contentView = UIView()
    
    let manView: UIView = {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(hex: "#EDEDEDFF")?.cgColor
        $0.layer.cornerRadius = 12
        return $0
    }(UIView())
    let manImageView: UIImageView = {
        $0.image = UIImage(systemName: "trash")
        return $0
    }(UIImageView())
    let manLabel: UILabel = {
        $0.text = GenderSelection.man.asString()
        return $0
    }(UILabel())
    
    let womanView: UIView = {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(hex: "#EDEDEDFF")?.cgColor
        $0.layer.cornerRadius = 12
        return $0
    }(UIView())
    let womanImageView: UIImageView = {
        $0.image = UIImage(systemName: "trash")
        return $0
    }(UIImageView())
    let womanLabel: UILabel = {
        $0.text = GenderSelection.woman.asString()
        return $0
    }(UILabel())
    
    
    let titleLabel: UILabel = {
        $0.text = "성별은\n어떻게 되시나요?"
        $0.numberOfLines = 0
        $0.font = .pretendardFont(size: 24, style: .bold)
        return $0
    }(UILabel())
    let HStackView: UIStackView = {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 11
       return $0
    }(UIStackView())
    func setUI() {
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        [manImageView, manLabel].forEach { manView.addSubview($0) }
        [womanImageView, womanLabel].forEach { womanView.addSubview($0) }
        
        manImageView.snp.makeConstraints {
            $0.width.height.equalTo(85)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(30)
        }
        manLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
        }
        womanImageView.snp.makeConstraints {
            $0.width.height.equalTo(85)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(30)
        }
        womanLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
        }
        [titleLabel, HStackView].forEach { contentView.addSubview($0) }
        [manView, womanView].forEach { HStackView.addArrangedSubview($0) }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.leading.equalToSuperview().inset(20)
        }
        HStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(80)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(180 * view.frame.width / 375)
            $0.bottom.equalToSuperview()
        }
    }
}

class ThirdStepViewController: BaseStepViewController {
    override init() {
        super.init()
        thirdStepView.backgroundColor = .appColor(.primary)
        secondStepView.backgroundColor = .appColor(.primary)
        stepsecondLineView.backgroundColor = .appColor(.primary)
        stepfirstLineView.backgroundColor = .appColor(.primary)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    let contentView = UIView()
    let skipButton: UILabel = {
        $0.text = "Skip"
        return $0
    }(UILabel())
    let titleLabel: UILabel = {
        $0.text = "자꾸만 생각나는\n그 사람의 전화번호는요?"
        $0.numberOfLines = 0
        $0.font = .pretendardFont(size: 24, style: .bold)
        return $0
    }(UILabel())
    let numberLabel: UILabel = {
        $0.font = .pretendardFont(size: 14, style: .bold)
        $0.text = "휴대폰 번호"
        return $0
    }(UILabel())
    let numberInputView = SimpleInputView(viewModel: .init(textFieldViewModel: .init(placeholder: "휴대폰 번호")))
    let textView: BaseTextView = {
        return $0
    }(BaseTextView(viewModel: .init(placeholder: "그사람에게 보낼 메시지를 적어주세요.")))
    func setUI() {
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        [titleLabel, numberLabel, numberInputView, textView, skipButton].forEach { contentView.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.leading.equalToSuperview().inset(20)
        }
        
        numberLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        numberInputView.snp.makeConstraints {
            $0.top.equalTo(numberLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        textView.snp.makeConstraints {
            $0.top.equalTo(numberInputView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(180)
        }
        skipButton.snp.makeConstraints {
            $0.top.equalTo(textView.snp.bottom).offset(150)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(50)
        }
        numberInputView.textField.keyboardType = .numberPad
    }
}
