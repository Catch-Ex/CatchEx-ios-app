//
//  CommunityViewController.swift
//  CatchEx_Practice
//
//  Created by 김사랑 on 2023/01/07.
//

import UIKit
import SnapKit
import Then

class CommunityViewController: UIViewController {
    
    let mainView = CommunityView()
    
    let contentView = CommunitySearchBarView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var profileImageArr: [String] = ["profile", "profile", "profile", "profile", "profile"]
    var nicknameArr: [String] = ["아라아라", "아라아라", "아라아라", "아라아라", "아라아라"]
    var dateArr: [String] = ["2023년 1월 7일", "2023년 1월 7일", "2023년 1월 7일", "2023년 1월 7일", "2023년 1월 7일"]
    var titleArr: [String] = ["나한테도 가능성이 있을까?", "나 매칭 성공했다 애들아!!", "제목3", "제목4", "제목5"]
    
    var contentArr: [String] = ["내가 잘못해서 헤어졌어. 근데... 걔 카톡 프로필 음악이 ‘나의 x에게’ 인데 자바 매칭 기대해봐도 될까?", "1년 반 동안 사귄 전여친이랑 드디어...!!!", "내용3", "내용4", "내용5"]
    
    var countHeartArr: [String] = ["2", "2", "3", "4", "5"]
    
    var countCommentArr: [String] = ["52", "52", "3", "4", "5"]
    
    let cellReuseIdentifier = "cell"
    let cellSpacingHeight: CGFloat = 0
    
    lazy var goToWritePostBtn = UIButton().then {
        $0.backgroundColor = UIColor(red: 0.502, green: 0.443, blue: 0.988, alpha: 1)
        $0.setImage(UIImage(named: "cross_white"), for: .normal)
        $0.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 18.8, weight: .medium), forImageIn: .normal)
        $0.layer.cornerRadius = 56/2
        $0.addTarget(self, action: #selector(goToWritePostBtnDidTap), for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        setUpView()
        setUpConstraints()
    }
    
    func setUpView() {
        self.view.addSubview(contentView)
        
        // tableView
        self.view.addSubview(mainView)
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        
        mainView.tableView.separatorInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        
        self.view.addSubview(goToWritePostBtn)
    }
    
    func setUpConstraints() {
        
        contentView.snp.makeConstraints{ make in
            make.top.equalTo(92)
            make.leading.trailing.equalToSuperview()
        }
        
        mainView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.bottom).offset(0)
            $0.bottom.leading.trailing.equalToSuperview()
        }
        
        goToWritePostBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-110)
            make.width.equalTo(Constant.width * 56)
            make.height.equalTo(Constant.width * 56)
        }
    }
    
    
    @objc private func goToWritePostBtnDidTap() {
        
        // WritePost 화면으로 이동
        let WritePostViewController = WritePostViewController()
        WritePostViewController.modalTransitionStyle = .crossDissolve
        WritePostViewController.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(WritePostViewController, animated: true)
    }
}

// tableView
extension CommunityViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return titleArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommunityTableViewCell", for: indexPath) as! CommunityTableViewCell
        cell.nicknameLbl.text = nicknameArr[indexPath.row]
        cell.dateLbl.text = dateArr[indexPath.row]
        cell.titleLbl.text = titleArr[indexPath.row]
        cell.contentLbl.text = contentArr[indexPath.row]
        cell.countHeartLbl.text = countHeartArr[indexPath.row]
        cell.countCommentLbl.text = countCommentArr[indexPath.row]
        cell.backgroundColor = UIColor.clear
        cell.clipsToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return cellSpacingHeight
    }

    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
        
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("You tapped cell number \(indexPath.section).")
        
        let DetailPostViewController = DetailPostViewController() // MARK: 이슈 - if를 붙이면 오류가 난다
        DetailPostViewController.nickname = nicknameArr[indexPath.row]
        DetailPostViewController.date = dateArr[indexPath.row]
        DetailPostViewController.titleName = titleArr[indexPath.row]
        DetailPostViewController.content = contentArr[indexPath.row]
        DetailPostViewController.countHeart = countHeartArr[indexPath.row]
        DetailPostViewController.countComment = countCommentArr[indexPath.row]
        DetailPostViewController.modalPresentationStyle = .fullScreen
        contentView.searchTextField.endEditing(true)
        navigationController?.pushViewController(DetailPostViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {

        
        let emoji = UIAction(title: "공감하기") { _ in
        }

        return UIContextMenuConfiguration(identifier: nil, previewProvider: { return nil}) { _ in UIMenu(title: "", children: [emoji])
        }
    }
}
