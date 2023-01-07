//
//  WarningView.swift
//  Catch-Ex-ios-app
//
//  Created by 김지훈 on 2023/01/07.
//

import UIKit

class WarningView: UIView {
    init(image: UIImage?, text: String, color: UIColor!) {
        super.init(frame: .zero)
        label.textColor = color
        label.text = text
        imageView.image = image
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let imageView = UIImageView()
    let label: UILabel = {
        $0.font = .systemFont(ofSize: 14)
        return $0
    }(UILabel())
    
    func setUI() {
        [imageView, label].forEach { addSubview($0) }
        
        imageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.width.height.equalTo(16.5)
            $0.bottom.equalToSuperview()
        }
        
        label.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.trailing).offset(4.75)
            $0.centerY.equalToSuperview()
        }
    }
}
