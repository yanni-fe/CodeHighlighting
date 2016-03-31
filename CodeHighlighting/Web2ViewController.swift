//
//  Web2ViewController.swift
//  CodeHighlighting
//
//  Created by Yu Pengyang on 3/31/16.
//  Copyright © 2016 Caishuo. All rights reserved.
//

import UIKit
import JavaScriptCore

class Web2ViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    var context: JSContext!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        webView.delegate = self
        let path = NSBundle.mainBundle().bundlePath
        let url = NSURL(fileURLWithPath: path)
        let htmlString = try! String(contentsOfFile: NSBundle.mainBundle().pathForResource("template1", ofType: "html")!)
        let codeString = try! String(contentsOfFile: NSBundle.mainBundle().pathForResource("Test", ofType: "txt")!)
        context = webView.valueForKeyPath("documentView.webView.mainFrame.javaScriptContext") as! JSContext
        context.setObject(codeString, forKeyedSubscript: "codeString")
        webView.loadHTMLString(htmlString, baseURL: url)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension Web2ViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(webView: UIWebView) {
        context.evaluateScript("highlightCode(codeString)")
    }
}
