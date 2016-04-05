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
    var codeString: String? {
        didSet {
            if let codeString = codeString {
                context.setObject(codeString, forKeyedSubscript: "codeString")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        webView.scrollView.bounces = false
        webView.delegate = self
        let htmlString = try! String(contentsOfFile: NSBundle.mainBundle().pathForResource("template1", ofType: "html")!)
        context = webView.valueForKeyPath("documentView.webView.mainFrame.javaScriptContext") as! JSContext
        codeString = try? String(contentsOfFile: NSBundle.mainBundle().pathForResource("Test", ofType: "txt")!)
        webView.loadHTMLString(htmlString, baseURL: NSBundle.mainBundle().bundleURL)
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
