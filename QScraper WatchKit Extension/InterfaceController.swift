//
//  InterfaceController.swift
//  QScraper WatchKit Extension
//
//  Created by spoonik on 2017/12/03.
//  Copyright © 2017年 spoonikapps. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController, QueryEndDelegate {
    func queryFinish(str: String, row: Int) {
        let table_row = self.contentTable.rowController(at: row) as! ContentTableRow
        table_row.contentLabel.setText(str)
    }
  
    @IBOutlet var contentTable: WKInterfaceTable!
    var search_keyword: String = "default"
  
    let search_list = [
        ["uri": "https://ejje.weblio.jp/content/__word__",
         "regex": "(?<=<meta name=\"twitter:description\" content=\").*?(?=>)",
         //"regex": "<meta name=\"twitter:description\" content=\".*?>"
        ],
        ["uri": "https://www.oxfordlearnersdictionaries.com/definition/english/__word__",
         "regex": "<span class=\"def\" .*?</span>",
         //"regex": "(?<=<span class=\"def\") .*?(?=</span>)"
        ]/*,
        ["uri": "http://www.1101.com/home.html",
         "regex": "<div class=\"darling__txt\">.*<div class=\"darling__txt-more\">"
        ]*/
    ]
  
  
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
    }
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }


    @IBAction func startQuery() {
        if self.isURLRequireWord() {
            presentTextInputController(withSuggestions: [self.search_keyword], allowedInputMode: WKTextInputMode.plain) {
                (arr: [Any]?) in
                print(arr ?? "Not find")
              
                if arr == nil {
                    return
                }
              
                let queries = (arr as! [String])
                if queries.count > 0 {
                    var query_word: String? = queries[0]
                    if query_word == "" {
                        self.search_keyword = ""
                        return
                    }
                    else {
                        //小文字にする
                        query_word = query_word?.lowercased()
                        self.search_keyword = query_word!

                        self.getAllQueries(query_word: (query_word as! String))
                    }
                }
                else {
                    let table_row = self.contentTable.rowController(at: 0) as! ContentTableRow
                    table_row.contentLabel.setText("Please Retry")
                    self.search_keyword = ""
                }
            }
        }
        else {
            self.getAllQueries(query_word: "")
        }
    }
  
    func getAllQueries(query_word: String) {
        var i = 0
      
        self.contentTable.setNumberOfRows(search_list.count, withRowType: "ContentTableRow")

        for search_item in search_list {
            let uri = search_item["uri"] as! String
            let query_uri = uri.replacingOccurrences(of:"__word__", with:query_word)
            let q = Query(query_address: query_uri,
                          scrape_regex: search_item["regex"] as! String,
                          controller: self, row: i)
            q.query_and_scrape()
            i = i+1
        }

    }
  
    func isURLRequireWord() -> Bool {
        for search_item in search_list {
            if (search_item["uri"] as! String).contains("__word__") {
                return true
            }
        }
        return false
    }
}
