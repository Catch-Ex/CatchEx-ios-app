//
//  UIFont+.swift
//  Catch-Ex-ios-app
//
//  Created by 김지훈 on 2023/01/07.
//

import UIKit

extension UIFont {
    enum FontType {
        enum Pretentdard: String {
            case bold = "Pretendard-Bold"
            case extraBold = "Pretendard-ExtraBold"
            case extraLight = "Pretendard-ExtraLight"
            case light = "Pretendard-Light"
            case medium = "Pretendard-Medium"
            case regular = "Pretendard-Regular"
            case semiBold = "Pretendard-SemiBold"
            case thin = "Pretendard-Thin"
        }
        
    }
    
    static func pretendardFont(size: CGFloat = 15, style: FontType.Pretentdard = .regular) -> UIFont {
        if let font = UIFont(name: style.rawValue, size: size) {
            return font
        } else {
            print("pretendard 폰트 유실 에러", style)
            return systemFont(ofSize: size)
        }
    }
}

