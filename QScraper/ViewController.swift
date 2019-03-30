//
//  ViewController.swift
//  QScraper
//
//  Created by spoonik on 2017/12/03.
//  Copyright © 2017年 spoonikapps. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  var qName1: String = ""
  var url1: String = ""
  var regEx1: String = ""
  var qName2: String = ""
  var url2: String = ""
  var regEx2: String = ""

  @IBAction func inputQName1(_ sender: UITextField) {
    qName1 = sender.text!
  }
  @IBAction func inputQName2(_ sender: UITextField) {
    url1 = sender.text!
  }
  @IBAction func inputURL1(_ sender: UITextField) {
    regEx1 = sender.text!
  }
  @IBAction func inputURL2(_ sender: UITextField) {
    qName2 = sender.text!
  }
  @IBAction func inputRegEx1(_ sender: UITextField) {
    url2 = sender.text!
  }
  @IBAction func inputRegEx2(_ sender: UITextField) {
    regEx2 = sender.text!
  }
  
  @IBAction func SaveSettings(_ sender: Any) {
    let userDefaults = UserDefaults.standard
    // Keyを指定して保存
    userDefaults.set(qName1, forKey: "QueryName1")
    userDefaults.set(url1, forKey: "URL1")
    userDefaults.set(regEx1, forKey: "RegEx1")
    userDefaults.set(qName2, forKey: "QueryName2")
    userDefaults.set(url2, forKey: "URL2")
    userDefaults.set(regEx2, forKey: "RegEx2")
    userDefaults.synchronize()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

