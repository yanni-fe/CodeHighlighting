//
//  HighlightWithWebViewController.swift
//  CodeHighlighting
//
//  Created by Yu Pengyang on 3/31/16.
//  Copyright © 2016 Caishuo. All rights reserved.
//

import UIKit

class HighlightWithWebViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = NSBundle.mainBundle().bundlePath
        let url = NSURL(fileURLWithPath: path)
        var htmlString = try! String(contentsOfFile: NSBundle.mainBundle().pathForResource("template", ofType: "html")!)
        let codeString = try! String(contentsOfFile: NSBundle.mainBundle().pathForResource("Test", ofType: "txt")!)
        if let res = Highlighting.defaultHighlight.highlightedHTML(codeString) {
            htmlString.appendContentsOf("\(res)</code></pre></body></html>")
            print(htmlString + "<script></script>")
            webView.loadHTMLString(htmlString, baseURL: url)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
