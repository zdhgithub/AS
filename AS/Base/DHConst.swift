//
//  DHConst.swift
//  mx3app
//
//  Created by dh on 2022/11/10.
//

import Foundation
import UIKit
import MMKV
import HandyJSON



public extension String {
    /** 判断哥伦比亚手机号合法性 57开头共12位*/
    func dh_checkMXPhoneNumber() -> Bool {
        let regex = "^52[0-9]{10}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
}



public let dhScreenWidth:CGFloat = UIScreen.main.bounds.size.width
public let dhScreenHeight:CGFloat = UIScreen.main.bounds.size.height
public let dhNavHeight:CGFloat = 44
public let isIPhoneX:Bool = ((dhScreenHeight/dhScreenWidth)*100 == 216) ? true : false
public let dhTabBarHeight:CGFloat = (isIPhoneX ? (49+34) : 49)
public let dhBottomBarHeight:CGFloat = (isIPhoneX ? 34 : 0)

public func dhStatusBarHeight() -> CGFloat {
    var statusBarH:CGFloat = 20.0
    if #available(iOS 13.0, *) {
        statusBarH = UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.size.height ?? 20
    } else {
        statusBarH = UIApplication.shared.statusBarFrame.size.height
    }
    return statusBarH
}

public let dhNavStatusHeight:CGFloat =  (dhStatusBarHeight() + dhNavHeight)

public let dhSpaceLeft:CGFloat = 16.0
public let dhSpaceRight:CGFloat = dhSpaceLeft


/** 判断主线程block */
public func dhMainQueueAction(_ callback:@escaping ()->Void) {
    if Thread.current.isMainThread {
        callback()
    }else{
        DispatchQueue.main.async {
            callback()
        }
    }
}

public func dhShowErr(_ str:String) {
    ZWTAlertController.showAlert(withTitle: "Errors", message: str, textAlignment: .left, titleArray: ["OK"]) { index in
        
    }
}

public func errStr(_ data:String) -> String {
    let errs = [DHErrorsModel].deserialize(from: data, designatedPath: "errors") as! [DHErrorsModel]
    var errStr = ""
    for err in errs {
        let str = """
\(err.status): \(err.code)

title: \(err.title)

detail: \(err.detail)

pointer: \(err.pointer)

"""
        errStr.append(str)
    }
    return errStr
}

public func delCallback(_ data:String, callback:@escaping ((Bool, String)->Void)){
    if data.count == 0 {
        callback(true, "")
    }else{
        let errStr = errStr(data)
        callback(false, errStr)
    }
}


public extension UILabel {
    class func dhLabel(_ str:String, color:UIColor, font:UIFont, alignment:NSTextAlignment? = NSTextAlignment.left, lines:Int=1) -> UILabel {
        let lb = UILabel()
        lb.text = str
        lb.textColor = color
        lb.font = font
        lb.textAlignment = alignment ?? NSTextAlignment.left
        lb.numberOfLines = lines
        return lb
    }
}

// MARK: - color
private extension Int64 {
    func duplicate4bits() -> Int64 {
        return (self << 4) + self
    }
}
public extension UIColor {
    private convenience init?(hex3: Int64, alpha: Float) {
        self.init(red:   CGFloat( ((hex3 & 0xF00) >> 8).duplicate4bits() ) / 255.0,
                  green: CGFloat( ((hex3 & 0x0F0) >> 4).duplicate4bits() ) / 255.0,
                  blue:  CGFloat( ((hex3 & 0x00F) >> 0).duplicate4bits() ) / 255.0,
                  alpha: CGFloat(alpha))
    }

    private convenience init?(hex4: Int64, alpha: Float?) {
        self.init(red:   CGFloat( ((hex4 & 0xF000) >> 12).duplicate4bits() ) / 255.0,
                  green: CGFloat( ((hex4 & 0x0F00) >> 8).duplicate4bits() ) / 255.0,
                  blue:  CGFloat( ((hex4 & 0x00F0) >> 4).duplicate4bits() ) / 255.0,
                  alpha: alpha.map(CGFloat.init(_:)) ?? CGFloat( ((hex4 & 0x000F) >> 0).duplicate4bits() ) / 255.0)
    }

    private convenience init?(hex6: Int64, alpha: Float) {
        self.init(red:   CGFloat( (hex6 & 0xFF0000) >> 16 ) / 255.0,
                  green: CGFloat( (hex6 & 0x00FF00) >> 8 ) / 255.0,
                  blue:  CGFloat( (hex6 & 0x0000FF) >> 0 ) / 255.0, alpha: CGFloat(alpha))
    }

    private convenience init?(hex8: Int64, alpha: Float?) {
        self.init(red:   CGFloat( (hex8 & 0xFF000000) >> 24 ) / 255.0,
                  green: CGFloat( (hex8 & 0x00FF0000) >> 16 ) / 255.0,
                  blue:  CGFloat( (hex8 & 0x0000FF00) >> 8 ) / 255.0,
                  alpha: alpha.map(CGFloat.init(_:)) ?? CGFloat( (hex8 & 0x000000FF) >> 0 ) / 255.0)
    }

    /**
     Create non-autoreleased color with in the given hex string and alpha.

     - parameter hexString: The hex string, with or without the hash character.
     - parameter alpha: The alpha value, a floating value between 0 and 1.
     - returns: A color with the given hex string and alpha.
     */
    convenience init?(_ hexString: String, alpha: Float? = nil) {
        var hex = hexString

        // Check for hash and remove the hash
        if hex.hasPrefix("#") {
            hex = String(hex[hex.index(after: hex.startIndex)...])
        }

        guard let hexVal = Int64(hex, radix: 16) else {
            self.init()
            return nil
        }

        switch hex.count {
        case 3:
            self.init(hex3: hexVal, alpha: alpha ?? 1.0)
        case 4:
            self.init(hex4: hexVal, alpha: alpha)
        case 6:
            self.init(hex6: hexVal, alpha: alpha ?? 1.0)
        case 8:
            self.init(hex8: hexVal, alpha: alpha)
        default:
            // Note:
            // The swift 1.1 compiler is currently unable to destroy partially initialized classes in all cases,
            // so it disallows formation of a situation where it would have to.  We consider this a bug to be fixed
            // in future releases, not a feature. -- Apple Forum
            self.init()
            return nil
        }
    }

    /**
     Create non-autoreleased color with in the given hex value and alpha

     - parameter hex: The hex value. For example: 0xff8942 (no quotation).
     - parameter alpha: The alpha value, a floating value between 0 and 1.
     - returns: color with the given hex value and alpha
     */
    convenience init?(hex: Int, alpha: Float = 1.0) {
        if (0x000000 ... 0xFFFFFF) ~= hex {
            self.init(hex6: Int64(hex), alpha: alpha)
        } else {
            self.init()
            return nil
        }
    }

    convenience init?(argbHex: Int) {
        if (0x00000000 ... 0xFFFFFFFF) ~= argbHex {
            let hex = Int64(argbHex)
            self.init(red: CGFloat( (hex & 0x00FF0000) >> 16 ) / 255.0,
                      green: CGFloat( (hex & 0x0000FF00) >> 8 ) / 255.0,
                      blue:  CGFloat( (hex & 0x000000FF) >> 0 ) / 255.0,
                      alpha: CGFloat( (hex & 0xFF000000) >> 24 ) / 255.0)
        } else {
            self.init()
            return nil
        }
    }

    convenience init?(argbHexString: String) {
        var hex = argbHexString

        // Check for hash and remove the hash
        if hex.hasPrefix("#") {
            hex = String(hex[hex.index(after: hex.startIndex)...])
        }

        guard hex.count == 8, let hexVal = Int64(hex, radix: 16) else {
            self.init()
            return nil
        }
        self.init(red: CGFloat( (hexVal & 0x00FF0000) >> 16 ) / 255.0,
                  green: CGFloat( (hexVal & 0x0000FF00) >> 8 ) / 255.0,
                  blue:  CGFloat( (hexVal & 0x000000FF) >> 0 ) / 255.0,
                  alpha: CGFloat( (hexVal & 0xFF000000) >> 24 ) / 255.0)
    }

}
//public extension UIColor {
//    static func hexColor(_ hexValue: Int, alphaValue: Float) -> UIColor {
//        return UIColor(red: CGFloat((hexValue & 0xFF0000) >> 16) / 255.0,
//                       green: CGFloat((hexValue & 0x00FF00) >> 8) / 255.0,
//                       blue: CGFloat(hexValue & 0x0000FF) / 255.0,
//                       alpha: CGFloat(alphaValue))
//    }
//
//    static func hexColor(_ hexValue: Int) -> UIColor {
//        return hexColor(hexValue, alphaValue: 1)
//    }
//
//    convenience init(_ hexValue: Int, alphaValue: Float) {
//        self.init(red: CGFloat( (hexValue & 0xFF0000) >> 16) / 255.0,
//                  green: CGFloat( (hexValue & 0x00FF00) >> 8) / 255.0,
//                  blue: CGFloat( hexValue & 0x0000FF) / 255.0,
//                  alpha: CGFloat(alphaValue))
//    }
//
//    convenience init(_ hexValue: Int) {
//        self.init(hexValue, alphaValue: 1)
//    }
//
//    func toImage() -> UIImage {
//        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
//        UIGraphicsBeginImageContext(rect.size)
//        let context = UIGraphicsGetCurrentContext()
//        context?.setFillColor(self.cgColor)
//        context?.fill(rect)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return image!
//    }
//}

public func colorRandom() -> UIColor {
       return UIColor.init(red: CGFloat(arc4random()%256)/255.0, green: CGFloat(arc4random()%256)/255.0, blue: CGFloat(arc4random()%256)/255.0, alpha: 1)

   }

extension UIColor {
    static var random: UIColor {
        return .init(hue: .random(in: 0...1), saturation: 1, brightness: 1, alpha: 1)
    }
}


//MARK: RGBA
public func RGB(_ r:CGFloat, g:CGFloat, b:CGFloat) -> UIColor {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
}

public func dhImg(_ str:String) -> UIImage {
    return UIImage(named: str) ?? UIImage()
}

public let dhColor3 = UIColor("#333333")!
public let dhColor6 = UIColor("#666666")!
public let dhColor9 = UIColor("#999999")!

public let dhColorLine = UIColor("#EBEBEB")!
public let dhColorDis = UIColor("#778699")!
public let dhColorBg = UIColor("#F7F8F9")!
public let dhColorYellow = UIColor("#FFE7C1")!



public let dhColorMain = UIColor("#24a0e8")! //UIColor("#7876E5")! //
public let dhColorMainDis = UIColor("#9391EF")!


// MARK: - font
public let dhFont10 = UIFont.systemFont(ofSize: 10)
public let dhFont12 = UIFont.systemFont(ofSize: 12)
public let dhFont13 = UIFont.systemFont(ofSize: 13)
public let dhFont14 = UIFont.systemFont(ofSize: 14)
public let dhFont15 = UIFont.systemFont(ofSize: 15)
public let dhFont16 = UIFont.systemFont(ofSize: 16)
public let dhFont17 = UIFont.systemFont(ofSize: 17)
public let dhFont18 = UIFont.systemFont(ofSize: 18)
public let dhFont19 = UIFont.systemFont(ofSize: 19)
public let dhFont20 = UIFont.systemFont(ofSize: 20)
public let dhFont21 = UIFont.systemFont(ofSize: 21)
public let dhFont22 = UIFont.systemFont(ofSize: 22)
public let dhFont24 = UIFont.systemFont(ofSize: 24)

public let dhBoldFont10 = UIFont.boldSystemFont(ofSize: 10)
public let dhBoldFont12 = UIFont.boldSystemFont(ofSize: 12)
public let dhBoldFont13 = UIFont.boldSystemFont(ofSize: 13)
public let dhBoldFont14 = UIFont.boldSystemFont(ofSize: 14)
public let dhBoldFont15 = UIFont.boldSystemFont(ofSize: 15)
public let dhBoldFont16 = UIFont.boldSystemFont(ofSize: 16)
public let dhBoldFont17 = UIFont.boldSystemFont(ofSize: 17)
public let dhBoldFont18 = UIFont.boldSystemFont(ofSize: 18)
public let dhBoldFont19 = UIFont.boldSystemFont(ofSize: 19)
public let dhBoldFont20 = UIFont.boldSystemFont(ofSize: 20)
public let dhBoldFont21 = UIFont.boldSystemFont(ofSize: 21)
public let dhBoldFont22 = UIFont.boldSystemFont(ofSize: 22)
public let dhBoldFont24 = UIFont.boldSystemFont(ofSize: 24)
public let dhBoldFont27 = UIFont.boldSystemFont(ofSize: 27)
public let dhBoldFont32 = UIFont.boldSystemFont(ofSize: 32)

public let dhHeaveyFont18 = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.heavy)
public let dhHeaveyFont19 = UIFont.systemFont(ofSize: 19, weight: UIFont.Weight.heavy)
public let dhHeaveyFont20 = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.heavy)
public let dhHeaveyFont21 = UIFont.systemFont(ofSize: 21, weight: UIFont.Weight.heavy)
public let dhHeaveyFont22 = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.heavy)
public let dhHeaveyFont24 = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.heavy)
public let dhHeaveyFont27 = UIFont.systemFont(ofSize: 27, weight: UIFont.Weight.heavy)
public let dhHeaveyFont32 = UIFont.systemFont(ofSize: 32, weight: UIFont.Weight.heavy)



extension Data {
    func write(withName name: String) -> URL {
        let url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(name)
        try! write(to: url, options: .atomicWrite)
        return url
    }
}
