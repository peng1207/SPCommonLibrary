//
//  SPLanguages.swift
//  SPCommonLibrary
//
//  Created by 黄树鹏 on 2019/4/4.
//  Copyright © 2019 Peng. All rights reserved.
//

import Foundation

///  国际化
open class SPLanguageChange {
    
    public static let shareInstance = SPLanguageChange()
    fileprivate var bundle : Bundle?
    fileprivate var libraryBundle : Bundle?
    fileprivate let def = UserDefaults.standard
    fileprivate var isChinese : Bool = false
    /*
     获取国际化对应的文字
     */
    public class func sp_getString(key:String) -> String{
        let bundle = SPLanguageChange.shareInstance.bundle
        if let b = bundle {
            let str =  b.localizedString(forKey: key, value: nil, table: nil)
            return Bundle.main.localizedString(forKey: key, value: str, table: nil)
            
        }else {
            SPLanguageChange.shareInstance.sp_initLanguage()
            let b =  SPLanguageChange.shareInstance.bundle
            let str = b?.localizedString(forKey: key, value: nil, table: nil)
            if let s = str {
                return Bundle.main.localizedString(forKey: key, value: s, table: nil)
            }
        }
        return key
    }
    class func sp_library(key : String) -> String{
        var bundle = SPLanguageChange.shareInstance.libraryBundle
        if let b = bundle {
            let str = b.localizedString(forKey: key, value: nil, table: nil)
            return Bundle.main.localizedString(forKey: key, value: str, table: nil)
        }else{
             SPLanguageChange.shareInstance.sp_initLanguage()
            bundle = SPLanguageChange.shareInstance.libraryBundle
            let str = bundle?.localizedString(forKey: key, value: nil, table: nil)
            if let s = str{
                return Bundle.main.localizedString(forKey: key, value: s, table: nil)
            }
        }
        return key
    }
    
    /*
     初始化语言
     */
    public func sp_initLanguage(){
        var string : String = ""
        if let s = Locale.preferredLanguages.first{
            string = s
        }else{
            string = "en"
        }
 
        string = string.replacingOccurrences(of: "-CN", with: "")
        string = string.replacingOccurrences(of: "-US", with: "")
        var path = Bundle.main.path(forResource:string , ofType: "lproj")
        if path == nil {
            // 没有获取到对应的国际化
            // 判断当前的语言为台湾或相关或繁体字 则更改为中文
            if string.hasPrefix("zh-TW") || string.hasPrefix("zh-HK") || string.hasPrefix("zh-Hant") {
                path = Bundle.main.path(forResource:"zh-Hans" , ofType: "lproj")
                string = "zh-Hans"
                isChinese = true
            }else { // 否则更改为英文显示
                path = Bundle.main.path(forResource:"en" , ofType: "lproj")
                string = "en"
                isChinese = false
            }
        }else{
          
            if string.hasPrefix("en") {
                isChinese = false
            }else{
                isChinese = true
            }
        }
        let library = Bundle.libraryBundle
        self.libraryBundle = Bundle(path: library.path(forResource: string, ofType: "lproj")!)
        bundle = Bundle(path: path!)
    }
    public class func sp_chinese()->Bool {
        let bundle = SPLanguageChange.shareInstance.bundle
        if bundle == nil {
            SPLanguageChange.shareInstance.sp_initLanguage()
        }
        return SPLanguageChange.shareInstance.isChinese
    }
 
}
extension Bundle{
    
    static var libraryBundle : Bundle {
       
        let library = Bundle(path:Bundle(for: SPImagePickerVC.self).path(forResource: "SPCommonLibrary", ofType: "bundle")!)
        return library!
    }
    class func sp_getImg(name : String)->UIImage?{
        
        if  let path = self.libraryBundle.path(forResource: name, ofType: "png") {
            return UIImage(contentsOfFile: path)
        }
        return nil
    }
    
}
