//
//  DetailPostViewController.swift
//  CatchEx_Practice
//
//  Created by 김사랑 on 2023/01/07.
//

import UIKit
import SnapKit
import Then

class DetailPostViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    // Tabbar 가리기
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @IBOutlet weak var sendViewBottomMargin: NSLayoutConstraint!
    
    let mainView = CommentView()
    
    let contentView = CommunityDetailView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var commentProfileImageArr: [String] = ["profile", "profile"]
    var commentNicknameArr: [String] = ["피터피터", "샤인샤인"]
    var commentDateArr: [String] = ["2023년 1월 7일", "2023년 1월 7일"]

    var commentContentArr: [String] = ["ㄴㄴ 그냥 설정했을 듯.", "조만간 매칭 된다에 내 머리카락 걸겠음"]
    
    let cellReuseIdentifier = "cell"
    let cellSpacingHeight: CGFloat = 0
    
    lazy var backBtn = UIButton().then {
        $0.backgroundColor = .black
        $0.setImage(UIImage(systemName: "arrowshape.turn.up.left.fill"), for: .normal)
        $0.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .medium), forImageIn: .normal)
        $0.setTitle("뒤로가기", for: .normal)
        $0.tintColor = .white
        $0.setTitleColor(.white, for: .normal)
        $0.layer.shadowRadius = 10
        $0.layer.shadowOpacity = 0.3
        $0.layer.cornerRadius = 20
        $0.addTarget(self, action: #selector(backBtnDidTap), for: .touchUpInside)
    }
    
    let commentTextField = UITextField().then {
        $0.font = UIFont.notosans(size: 16, family: .regular)
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .white
        $0.textColor = .black
        $0.tintColor = .black
    }
    
    let commentImageView = UIImageView().then {
        $0.image = UIImage(named: "comment_button")
//        $0.contentMode = .scaleAspectFill
    }
    
    lazy var commentBtn = UIButton().then {
        $0.backgroundColor = .clear
        $0.addTarget(self, action: #selector(commentBtnDidTap), for: .touchUpInside)
    }
    
    var nickname = ""
    var date = ""
    var titleName = ""
    var content = ""
    var countHeart = ""
    var countComment = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        contentView.nicknameLbl.text = nickname
        contentView.dateLbl.text = date
        contentView.titleLbl.text = titleName
        contentView.contentLbl.text = content
        contentView.countHeartLbl.text = countHeart
        contentView.countCommentLbl.text = countComment
        
        setUpView()
        setUpConstraints()
        
        initNotification()
        setupNavigationBackButton()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 화면을 누르면 키보드 내려가게 하는 것
        if self.view.endEditing(true) {
            self.commentTextField.snp.updateConstraints{
                $0.bottom.equalTo(self.view.snp.bottom).inset(50)
            }
        }
    }
    
    func initNotification() {
        // 키보드 올라올 때
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(noti:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        // 키보드 내려갈 때
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(noti:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // 키보드 올라오기
    @objc func keyboardWillShow(noti: Notification) {
        let notiInfo = noti.userInfo!
        // 키보드 높이를 가져옴
        print("키보드위로")
        let keyboardFrame = notiInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        let height = keyboardFrame.size.height
        
        DispatchQueue.main.async {
            
        }
        
//        sendViewBottomMargin.constant = height

        // 애니메이션 효과를 키보드 애니메이션 시간과 동일하게
        let animationDuration = notiInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        UIView.animate(withDuration: animationDuration, delay: 0.5) {
//            self.view.layoutIfNeeded()
            self.commentTextField.snp.updateConstraints{
                $0.bottom.equalTo(self.view.snp.bottom).offset(-height-12)
            }
        }
    }

    // 키보드 내려가기
    @objc func keyboardWillHide(noti: Notification) {
        let notiInfo = noti.userInfo!
//        let animationDuration = notiInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        self.sendViewBottomMargin?.constant = 0
        
        // 키보드 높이를 뺌
        print("키보드아래로")
        let keyboardFrame = notiInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        let height = keyboardFrame.size.height
        
        DispatchQueue.main.async {
            
        }
            
        
        // 애니메이션 효과를 키보드 애니메이션 시간과 동일하게
        let animationDuration = notiInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        UIView.animate(withDuration: animationDuration, delay: 0.5) {
//            self.view.layoutIfNeeded()
            self.sendViewBottomMargin?.constant = 0
            self.commentTextField.snp.updateConstraints{
                $0.bottom.equalTo(self.view.snp.bottom).offset(-height)
            }
        }

//        // 애니메이션 효과를 키보드 애니메이션 시간과 동일하게
//        UIView.animate(withDuration: animationDuration) {
//            self.view.layoutIfNeeded()
//        }
    }
    
    
    
    func setUpView() {
        
        self.view.addSubview(contentView)
        self.view.addSubview(commentTextField)
        self.commentTextField.addSubview(commentImageView)
        self.commentImageView.addSubview(commentBtn)
        
        commentTextField.addLeftPadding()
        
        textFieldDidBeginEditing(commentTextField)
        textFieldDidEndEditing(commentTextField)
        
        // tableView
        self.view.addSubview(mainView)
        
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.separatorInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        }
    
    func setUpConstraints() {
        contentView.snp.makeConstraints{ make in
            make.top.equalTo(92)
            make.leading.trailing.equalToSuperview()
        }
        
        mainView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.bottom)
            $0.bottom.equalTo(commentTextField.snp.top)
            $0.leading.trailing.equalToSuperview()
        }
        
        commentTextField.snp.makeConstraints{ (make) in
            make.bottom.equalTo(-50)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(Constant.height * 40)
        }
        
        commentImageView.snp.makeConstraints{ make in
            make.top.bottom.equalToSuperview().inset(Constant.height*4)
            make.trailing.equalToSuperview().inset(Constant.width*4)
            make.width.equalTo(Constant.width * 42)
            
        }
        
        commentBtn.snp.makeConstraints{ make in
            make.top.bottom.equalToSuperview().inset(Constant.height*4)
            make.trailing.equalToSuperview().inset(Constant.width*4)
            make.width.equalTo(Constant.width * 42)
        }
    }
    
    @objc private func backBtnDidTap() {
        
        // 이전 화면으로 이동
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func commentBtnDidTap() {
    }
    
    // MARK: 텍스트필드 커스텀
    @objc func textFieldDidBeginEditing(_ textField: UITextField) {
        
        // 텍스트필드 입력 시 테두리 생기게 하기
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(red: 0.188, green: 0.188, blue: 0.188, alpha: 1).cgColor
        
        // 초기 탭 시, 텍스트필드 비우기 (1)
        textField.placeholder = nil
    }
    
    @objc func textFieldDidEndEditing(_ textField: UITextField) {
        
        // 초기 탭 시, 텍스트필드 비우기 (2)
        textField.placeholder = "댓글을 입력해주세요"
        textField.attributedPlaceholder = NSAttributedString(
            string: "댓글을 입력해주세요",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.754, green: 0.754, blue: 0.754, alpha: 1)]
        )
    }
}

// tableView
extension DetailPostViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return commentNicknameArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as! CommentTableViewCell
        cell.commentNicknameLbl.text = commentNicknameArr[indexPath.row]
        cell.commentDateLbl.text = commentDateArr[indexPath.row]
        cell.commentContentLbl.text = commentContentArr[indexPath.row]
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
        
    }
}

// MARK: 텍스트필드 왼쪽 간격 주기 -> 패딩에서 텍스트 입력 시작
extension UITextField {
  func addPadding() {
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: self.frame.height))
    self.leftView = paddingView
    self.leftViewMode = ViewMode.always
  }
}
