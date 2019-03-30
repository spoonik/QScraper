//
//  SettingsUtility.swift
//  txt.rdr
//
//  Created by spoonik on 2016/06/07.
//  Copyright © 2016年 spoonikapps. All rights reserved.
//

import WatchKit

struct SettingsUtility {

    // DBスキーマ：キーワード群
    static let keySETTINGS = "Settings"   // plistのエントリー名
    static let keyQUERYLIST = "QueryList"
    static let keyQUERYNAME = "QueryName"
    static let keyQUERYADDRESS = "QueryAddress"
    static let keySCRAPERSTART = "ScraperStart"
    static let keySCRAPEREND = "ScraperEnd"

    // 大きいフォント設定：plistには実フォントサイズを書き込むようにしている
    static func getAllSetting() -> [NSDictionary]? {
        let userDefaults = UserDefaults.standard
        let settingsDict: NSDictionary? = userDefaults.object(forKey: keyQUERYLIST) as? NSDictionary
        if settingsDict != nil {
          return settingsDict![keyQUERYLIST] as? [NSDictionary]
        }
        return nil
    }
  
    static func setOneSetting(index: Int, name: String, address: String, start: String, end: String) {
        let newDict: NSDictionary = [keyQUERYNAME: name, keyQUERYADDRESS: address, keySCRAPERSTART: start, keySCRAPEREND: end]
        let userDefaults = UserDefaults.standard
        var settingsDict: NSDictionary? = userDefaults.object(forKey: keyQUERYLIST) as? NSDictionary
        if settingsDict != nil {
            var qList = settingsDict![keyQUERYLIST] as? [NSDictionary]
            if index >= (qList?.count)! {
                qList?.append(newDict)
            }
            else {
                qList?[index] = newDict
            }
        }
        else {
            settingsDict = [keyQUERYLIST: [newDict]]
        }
      
        userDefaults.set(settingsDict, forKey: keyQUERYLIST)
    }
}
