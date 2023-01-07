//
//  BaseTextView.swift
//  Catch-Ex-ios-app
//
//  Created by 김지훈 on 2023/01/08.
//


import UIKit

import RxSwift
import RxCocoa
import RxRelay
class BaseTextViewModel {
    // MARK: Input
    let inputStringRelay: BehaviorRelay<String>
    let inputStringShare: Observable<String>
    
    // MARK: Output
    let inputStringDriver: Driver<String>
    let placeholderDriver: Driver<String>
    let hiddenPlaceholderLabelDriver: Driver<Bool>
    
    init(placeholder: String = "내용을 입력해주세요.", inputStringRelay: BehaviorRelay<String> = BehaviorRelay<String>(value: "")) {
        self.inputStringRelay = inputStringRelay
        
        placeholderDriver = .just(placeholder)
        inputStringShare = inputStringRelay.share()
        
        hiddenPlaceholderLabelDriver = inputStringShare
            .map { $0 != "" }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: true)
        
        inputStringDriver = inputStringShare
            .asDriver(onErrorJustReturn: "")
    }
}
class BaseTextView: UITextView {
    var disposeBag = DisposeBag()
    var viewModel: BaseTextViewModel
    
    // MARK: Initializer
    init(viewModel: BaseTextViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero, textContainer: nil)
        setUI()
        bind(to: viewModel)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Binding
    func bind(to viewModel: BaseTextViewModel) {
        rx.text.orEmpty
            .distinctUntilChanged()

            .bind(to: viewModel.inputStringRelay)
            .disposed(by: disposeBag)

        viewModel.placeholderDriver
            .drive(placeholerLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.hiddenPlaceholderLabelDriver
            .drive(placeholerLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.inputStringDriver
            .drive(rx.text)
            .disposed(by: disposeBag)
    }
    
    // MARK: UIComponents
    let placeholerLabel: UILabel = {
        let l = UILabel()
        l.font = .pretendardFont(size: 12, style: .regular)
        l.textColor = .appColor(.gray1)
        return l
    }()
    
    func configure() {
        sizeToFit()
        isScrollEnabled = false
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.appColor(.gray1).cgColor
        font = .pretendardFont(size: 13, style: .regular)
        contentInset = .init(top: 10, left: 10, bottom: -10, right: 10)
        textContainerInset = .init(top: 8, left: 0, bottom: 10, right: 10)
        
        placeholerLabel.numberOfLines = 0
    }
    
    func setUI() {
        addSubview(placeholerLabel)
        
        placeholerLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.leading.equalToSuperview().inset(5)
        }
    }
}

