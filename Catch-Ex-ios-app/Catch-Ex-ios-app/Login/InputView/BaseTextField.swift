//
//  BaseTextField.swift
//  Catch-Ex-ios-app
//
//  Created by 김지훈 on 2023/01/07.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
/// no intrinsic size
/// intrinsic size 없습니다
class BaseTextFieldViewModel {
    // MARK: Input
    let inputStringRelay: BehaviorRelay<String> = BehaviorRelay<String>(value: "")
    
    // MARK: Output
    let inputStringDriver: Driver<String>
    let placeholderDriver: Driver<String>

    init(placeholder: String = "내용을 입력해주세요.") {
        placeholderDriver = .just(placeholder)
        inputStringDriver = inputStringRelay
            .asDriver(onErrorJustReturn: "")
    }
}

class BaseTextField: UITextField {
    var disposeBag = DisposeBag()
    var viewModel: BaseTextFieldViewModel
    func bind(to viewModel: BaseTextFieldViewModel) {
        rx.text.orEmpty
            .distinctUntilChanged()
            .bind(to: viewModel.inputStringRelay)
            .disposed(by: disposeBag)
        
        viewModel.placeholderDriver
            .drive(rx.placeholder)
            .disposed(by: disposeBag)
        
        viewModel.inputStringDriver
            .drive(rx.text)
            .disposed(by: disposeBag)
    }
    
    init(viewModel: BaseTextFieldViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        configure()
        bind(to: viewModel)
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPlaceholder(textColor: UIColor = UIColor(hex: "#CCCCCCFF")!, fontSize: CGFloat = 16, font: UIFont.FontType.Pretentdard = .regular) {
        guard let string = placeholder else {
            return
        }
        attributedPlaceholder = NSAttributedString(string: string, attributes: [
            .foregroundColor: textColor,
            .font: UIFont.pretendardFont(size: fontSize, style: font)
        ])
    }
    
    func configure() {
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor(hex: "#CCCCCCFF")?.cgColor
        setLeftPaddingPoints(15)
        font = .pretendardFont(size: 16, style: .regular)
        attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [.foregroundColor: UIColor.gray])
    }
}

extension BaseTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text else { return false }
        return text.count < 25 || range.length == 1
    }
}

