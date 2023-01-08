//
//  CommunityView.swift
//  CatchEx_Practice
//
//  Created by 김사랑 on 2023/01/07.
//

import UIKit
import SnapKit
import Then

class CommunityView: UIView {

    let tableView = UITableView().then{
        
        $0.showsVerticalScrollIndicator = false
//        $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
//        $0.backgroundColor = .blue
        
        $0.register(CommunityTableViewCell.self, forCellReuseIdentifier: CommunityTableViewCell.cellIdentifier)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(tableView)
        
        tableView.snp.makeConstraints{
            $0.bottom.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview()
        }
        
        // MARK: 테이블뷰 헤더 간격 없앰
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
