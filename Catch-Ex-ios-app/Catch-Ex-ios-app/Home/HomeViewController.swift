//
//  HomeViewController.swift
//  Catch-Ex-ios-app
//
//  Created by 김지훈 on 2023/01/08.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
class HomeViewController: UIViewController {
    var disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUI()
        mentLabel.rx.tapGesture()
            .when(.recognized)
            .bind(with: self) { owner, _ in
                let vc = OneButtonAlertViewController(viewModel: .init(content: "매칭을 축하합니다!", buttonText: "확인", textColor: .appColor(.primary)))
                owner.present(vc, animated: true)
                owner.heartArrowImageView.image = UIImage(named: "heartArrow_fill")
                owner.toImageView.image = UIImage(named: "matching")
                if let v = owner.toDateView.subviews.first as? UIImageView {
                    v.image = UIImage(named: "toDate")
                }
                owner.toDateView.backgroundColor = .init(hex: "#F0EEFFFF")
                owner.toDateView.layer.borderColor = UIColor.appColor(.primary).cgColor
                owner.toDateView.layer.borderWidth = 1
            }.disposed(by: disposeBag)
    }
    let dateLabel: UILabel = {
        $0.text = "2023년 1월 28일 오늘,"
        $0.textColor = .appColor(.gray3)
        return $0
    }(UILabel())
    let mentLabel: UILabel = {
        let nickName = UserDefaultManager.user.nickName
        $0.font = .pretendardFont(size: 24, style: .bold)
        $0.text = "\(nickName)님의 그 사람을\n\(nickName)님을 기다린 시간이에요."
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    let fromImageView: UIImageView = {
        $0.image = UIImage(named: "wait")
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    let heartArrowImageView: UIImageView = {
        $0.image = UIImage(named: "heartArrow")
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .red
        return $0
    }(UIImageView())
    let fromDateView: UIView = {
        let label = UILabel()
        label.text = "D+0"
        label.textColor = .appColor(.primary)
        label.font = .pretendardFont(size: 16, style: .bold)
        $0.layer.cornerRadius = 14
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.appColor(.primary).cgColor
        $0.backgroundColor = .init(hex: "#F0EEFFFF")
        $0.addSubview(label)
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        return $0
    }(UIView())
    let toImageView: UIImageView = {
        $0.image = UIImage(named: "person")
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    let toDateView: UIView = {
        let v = UIImageView()
        v.image = UIImage(named: "questionMark")
        $0.layer.cornerRadius = 14
        $0.backgroundColor = .init(hex: "#B5B6BAFF")
        $0.addSubview(v)
        v.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        return $0
    }(UIView())
    
    let mailBoxButton: UIButton = {
        $0.setTitle("쪽지함으로 가기", for: .normal)
        $0.layer.cornerRadius = 8
        $0.titleLabel?.font = .pretendardFont(size: 16, style: .regular)
        $0.backgroundColor = .appColor(.primary)
        return $0
    }(UIButton())
    
    let forYouLabel: UILabel = {
        $0.text = "이별한 당신을 위해"
        $0.font = .pretendardFont(size: 18, style: .bold)
        return $0
    }(UILabel())
    
    let textBox1: UILabel = {
        $0.text = "작별 인사에 낙담하지 말라. 재회에 앞서\n작별은 필요하다. 그리고 인연이라면 \n잠시 혹은 오랜 뒤라도 꼭 재회하게 될 터이니."
        $0.font = .pretendardFont(size: 14, style: .regular)
        $0.textColor = .appColor(.gray3)
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    let textBox2: UILabel = {
        $0.text = "네가 내게 시간을 써준다면 행복이 흔한 일이 되도록\n또 집에 가는 발걸음이 가볍도록\n우리의 시간을 함께해서 너를 따뜻하게 대해줄 텐데"
        $0.font = .pretendardFont(size: 14, style: .regular)
        $0.textColor = .appColor(.gray3)
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    let testButton: UIButton = {
        $0.setTitle("매칭 테스트!", for: .normal)
        $0.titleLabel?.font = .pretendardFont(size: 14, style: .bold)
        $0.backgroundColor = .appColor(.primary)
        $0.layer.cornerRadius = 8
        return $0
    }(UIButton())
    func setUI() {
        [dateLabel, mentLabel].forEach { view.addSubview($0) }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.leading.equalToSuperview().offset(20)
        }
        mentLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(20)
        }
        [fromImageView, heartArrowImageView, toImageView].forEach { view.addSubview($0) }
        
        heartArrowImageView.snp.makeConstraints {
            $0.top.equalTo(mentLabel.snp.bottom).offset(90)
            $0.centerX.equalToSuperview()
        }
        fromImageView.snp.makeConstraints {
            $0.centerY.equalTo(heartArrowImageView)
            $0.trailing.equalTo(heartArrowImageView.snp.leading)
        }
        toImageView.snp.makeConstraints {
            $0.centerY.equalTo(heartArrowImageView)
            $0.leading.equalTo(heartArrowImageView.snp.trailing)
        }
        
        view.addSubview(fromDateView)
        fromDateView.snp.makeConstraints {
            $0.bottom.equalTo(fromImageView).offset(12)
            $0.centerX.equalTo(fromImageView)
            $0.height.equalTo(28)
            $0.width.equalTo(64)
        }
        
        view.addSubview(toDateView)
        toDateView.snp.makeConstraints {
            $0.bottom.equalTo(toImageView).offset(12)
            $0.centerX.equalTo(toImageView)
            $0.height.equalTo(28)
            $0.width.equalTo(64)
        }
        
        [mailBoxButton, forYouLabel, textBox1, textBox2, testButton].forEach { view.addSubview($0) }
        mailBoxButton.snp.makeConstraints {
            $0.top.equalTo(fromImageView.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(121)
            $0.height.equalTo(42)
        }
        
        forYouLabel.snp.makeConstraints {
            $0.top.equalTo(mailBoxButton.snp.bottom).offset(64)
            $0.leading.equalToSuperview().inset(20)
        }
        
        textBox1.snp.makeConstraints {
            $0.top.equalTo(forYouLabel.snp.bottom).offset(36)
            $0.leading.trailing.equalToSuperview().inset(32)
        }
        
        textBox2.snp.makeConstraints {
            $0.top.equalTo(textBox1.snp.bottom).offset(52)
            $0.leading.trailing.equalToSuperview().inset(32)
            
        }
        
//        testButton.snp.makeConstraints {
//            $0.centerY.equalTo(mentLabel)
//            $0.trailing.equalToSuperview().inset(20)
//            $0.width.equalTo(80)
//        }
    }
}
