//
//  ViewController.swift
//  Catch-Ex-ios-app
//
//  Created by 김지훈 on 2023/01/07.
//

import UIKit
import Then
import SnapKit
import Moya
import CatchEx_ios_key
import CryptoKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        testAligoApi(code: "123456")
    }
    struct TestRequest: Codable {
        
        let type: String
        let from: String
        let content: String
        let messages:[Message]
        
        struct Message: Codable {
            let to: String
        }
        
        init(type: String = "SMS",
             from: String = "01076536434",
             phoneNumber: String,
             code: String) {
            
            self.type = type
            self.from = from
            self.content = "인증\(code)"
            self.messages = [Message(to: phoneNumber)]
        }
    }
    
    struct TestResponse: Codable {
        let requestId: String?
        let requestTime: Date?
        let statusCode: String?
        let statusName: String?
        let message: String?
    }
    public func makeSignature(_ msg: String, _ time: String) -> String {
        let method = "POST"
        let uri = "/sms/v2/services/\(CatchExKey.Sens.serviceId)/messages"
        let accessKey = CatchExKey.Sens.apiKey
        let secretKey = CatchExKey.Sens.apiSecret
        let t = "1673090366323"
        let message = method + " " + uri + "\n" + t + "\n" + accessKey
        // TODO: - 서버 통신
        print(message, secretKey)
        return ""
    }
    func testAligoApi(code: String) {
        
        let time = Date().millisecondsSince1970.description
        let a = TestRequest(phoneNumber: "01076536434", code: code)
        print(Date().description)
        SensAPI<TestResponse>(path: "\(CatchExKey.Sens.serviceId)/messages",
                              method: .post,
                              parameters: [:],
                              task: .requestJSONEncodable(a),
                              headers: [
                                "Content-Type": "application/json",
                                "x-ncp-apigw-timestamp": "1673090366323",
                                "x-ncp-iam-access-key": CatchExKey.Sens.apiKey,
                                "x-ncp-apigw-signature-v2": "PW0uHrYb93SzDk3lHPm0ciIvbMTmwRMyY0UAJYhfnJs="
                              ]
        ).request { result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print("💡", error)
            }
        }
    }
}

extension Date {
    var millisecondsSince1970: Int64 {
        Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}
