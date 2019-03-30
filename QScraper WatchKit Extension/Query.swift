//
//  Query.swift
//  QScraper WatchKit Extension
//
//  Created by spoonik on 2017/12/03.
//  Copyright © 2017年 spoonikapps. All rights reserved.
//

import Foundation

protocol QueryEndDelegate {
    func queryFinish(str:String, row:Int)
}

class Query: NSObject {

    let query_address: String
    let scrape_regex: String
    var scraped: String = ""
    var remove_html_tag: Bool = true
    var delegate:InterfaceController! = nil
    var table_row:Int = 0

    init(query_address: String, scrape_regex: String, controller: InterfaceController, row: Int) {
        self.query_address = query_address //"https://www.oxfordlearnersdictionaries.com/definition/english/word"
        self.scrape_regex = scrape_regex //"<span class=\"def\" .*?</span>"
        self.remove_html_tag = true
        self.table_row = row
        delegate = controller
    }

    func query_and_scrape() {
        var query_str: String = ""
        query_str = self.query_address
        var str: String? = ""
      
        guard let url = URL(string: query_str) else {
            self.scraped = self.generateDisplayString(content: "No Such File")
            return
        }
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: {(data, response, error) in
            str = String(data: data!, encoding: String.Encoding.utf8)
            print(str!)
            self.scraped = self.generateDisplayString(content: self.scrape(str: str, remove_html_tag: self.remove_html_tag))
            self.delegate.queryFinish(str: self.scraped, row: self.table_row)
        })
        task.resume()

        return
    }
  
    func generateDomainString() -> String {
        let url = URL(string: self.query_address)
        return (url?.host)!
    }
  
    func generateDisplayString(content: String) -> String {
        var res = generateDomainString()
        res = res + "\n\n"
        return (res + content)
    }
  
    func scrape(str: String?, remove_html_tag: Bool) -> String {
        var formatted_result: String = ""
      
        if str != nil {
            let res = get_regex_matches(pattern:self.scrape_regex, str:str!)
          
            var i = 1
            var define_str = ""
            for define in res {
                if remove_html_tag {
                    //HTMLタグを削除する
                    define_str = define.replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil)
                }
                else {
                    define_str = define
                }

                if res.count > 1 {
                    // タグが複数なければインデックスは振らない
                    formatted_result += String(i)
                }
                formatted_result += "\n"
                formatted_result += define_str
                formatted_result += "\n\n"

                i += 1
            }

            if res.count == 0 {
                // タグが見つからない
                formatted_result += "Tags Not Found"
            }
        }
        else {
            // そもそもURLがみつからない
            formatted_result += "Page Not Found"
        }

        return formatted_result
    }
  
    func get_regex_matches(pattern: String, str: String) -> [String] {
        let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
      
        let matches = regex.matches(in: str, options: [], range: NSMakeRange(0, str.count))
        let res = matches.map { String(str[Range($0.range, in: str)!]) }

        print(res)
        return res
    }

}
