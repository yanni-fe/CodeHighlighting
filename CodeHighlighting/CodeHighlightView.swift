//
//  CodeHighlightView.swift
//  CodeHighlighting
//
//  Created by Yu Pengyang on 4/5/16.
//  Copyright © 2016 Caishuo. All rights reserved.
//

import UIKit
import JavaScriptCore

private let template = "<!DOCTYPE html><html lang='en'><head><meta charset='UTF-8'><link href='zenburn.css' rel='stylesheet' type='text/css'><script src='highlight.pack.js'></script><script>function highlightCode(code, lang){var htmlres;if(lang){htmlres=hljs.highlight(lang, code).value;}else{htmlres=hljs.highlightAuto(code).value;}document.getElementById('id_code').innerHTML=htmlres;}</script></head><body><pre><code id='id_code' class='hljs'></code></pre></body></html>"

@IBDesignable
class CodeHighlightView: UIView {

    private let webView = UIWebView()
    var context: JSContext!
    var codeString: String? {
        didSet {
            addCodeString()
        }
    }
    
    var height: CGFloat = 200 {
        didSet {
            self.invalidateIntrinsicContentSize()
            self.layoutIfNeeded()
        }
    }
    
    init(code: String) {
        super.init(frame: CGRectZero)
        codeString = code
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func intrinsicContentSize() -> CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: height)
    }
    
    private func setup() {
        addSubview(webView)
        webView.delegate = self
        webView.scrollView.bounces = false
        webView.scrollView.contentInset = UIEdgeInsetsZero
        webView.frame = bounds
        webView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        context = webView.valueForKeyPath("documentView.webView.mainFrame.javaScriptContext") as! JSContext
        addCodeString()
    }
    
    private func addCodeString() {
        if let codeString = codeString {
            webView.loadHTMLString(template, baseURL: NSBundle.mainBundle().bundleURL)
            context.setObject(codeString, forKeyedSubscript: "codeString")
        }
    }

}

extension CodeHighlightView: UIWebViewDelegate {
    func webViewDidFinishLoad(webView: UIWebView) {
        context.evaluateScript("highlightCode(codeString)")
        dispatch_async(dispatch_get_main_queue()) { 
            if let h = webView.stringByEvaluatingJavaScriptFromString("document.body.offsetHeight") {
                print(h)
                self.height = CGFloat((h as NSString).floatValue)
            }
        }
    }
}
