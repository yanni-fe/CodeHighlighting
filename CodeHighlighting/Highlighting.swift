//
//  Highlighting.swift
//  CodeHighlighting
//
//  Created by Yu Pengyang on 3/29/16.
//  Copyright © 2016 Caishuo. All rights reserved.
//

import UIKit
import JavaScriptCore

class Highlighting {
    static let defaultHighlight = Highlighting()
    
    let context: JSContext
    private init () {
        let webview = UIWebView()
        context = webview.valueForKeyPath("documentView.webView.mainFrame.javaScriptContext") as! JSContext
        setup()
    }
    
    private func setup() {
        do {
            let contextString = try String(contentsOfFile: NSBundle.mainBundle().pathForResource("highlight.pack", ofType: "js")!)
            context.evaluateScript(contextString)
            let contextString1 = try String(contentsOfFile: NSBundle.mainBundle().pathForResource("traverse", ofType: "js")!)
            context.evaluateScript(contextString1)
        } catch {
            fatalError("Highlighting setup fail: \(error)")
        }
    }

    func highlightedHTML(code: String, lang: String? = nil) -> String? {
        context.setObject(code, forKeyedSubscript: "code")
        var value: JSValue;
        if let lang = lang {
            context.setObject(lang, forKeyedSubscript: "langForCode")
            value = context.evaluateScript("hljs.highlight(langForCode, code).value;")
        } else {
            value = context.evaluateScript("hljs.highlightAuto(code).value;")
        }
        let res = value.toString().stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        print(res)
        return res
    }
    
    func highlight(lang: String? = nil, code: String) -> [[String]]? {
        context.setObject(code, forKeyedSubscript: "code")
        var value: JSValue
        if let lang = lang {
            context.setObject(lang, forKeyedSubscript: "langForCode")
            value = context.evaluateScript("highlightCode(code, langForCode);")
        } else {
            value = context.evaluateScript("highlightCode(code)")
        }
        let valueArray = value.toArray() as? [[String]]
        return valueArray
    }
}

extension String {
    public func highlight(lang: String? = nil) -> NSAttributedString? {
        return Highlighting.defaultHighlight.highlight(lang, code: self).flatMap { array in
            let res = NSMutableAttributedString()
            array.forEach {
                res.appendAttributedString(NSAttributedString(string: $0[0], attributes: [NSForegroundColorAttributeName: UIColor(rgb: zenburn[$0[1]] ?? zenburn["hljs"]!)]))
            }
            res.addAttribute(NSFontAttributeName, value: UIFont(name: "menlo", size: 14)!, range: NSMakeRange(0, res.length))
            return res
        }
    }
}
