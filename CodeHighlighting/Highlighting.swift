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
//        context = JSContext(virtualMachine: JSVirtualMachine())
        setup()
    }
    
    private func setup() {
        do {
            var contextString = try String(contentsOfFile: NSBundle.mainBundle().pathForResource("highlight.pack", ofType: "js")!)
//            context.evaluateScript("var window = {};")
            context.evaluateScript(contextString)
            contextString = try String(contentsOfFile: NSBundle.mainBundle().pathForResource("traverse", ofType: "js")!)
            context.evaluateScript(contextString)
//            context.evaluateScript("var hljs = window.hljs;")
//            context.evaluateScript(contextString)
        } catch {
            fatalError("Highlighting setup fail: \(error)")
        }
    }
    
//    func highlight(lang: String, code: String) -> String? {
//        context.setObject(code, forKeyedSubscript: "code")
//        context.setObject(lang, forKeyedSubscript: "langForCode")
//        let value = context.evaluateScript("var coding = hljs.highlight(langForCode, code);").valueForProperty("value")
//        context.evaluateScript("var codeNode = document.createElement('code');")
//        context.evaluateScript("codeNode.innerHTML = coding.value;").valueForProperty("value")
//        context.evaluateScript("var nl = codeNode.childNodes;var i = nl.length, arr = new Array(i); for(; i--; arr[i] = nl[i]);")
//        let nodes = context.objectForKeyedSubscript("arr")
//        return value.toString()
//    }

    func highlight(lang: String, code: String) -> String? {
        context.setObject(code, forKeyedSubscript: "code")
        context.setObject(lang, forKeyedSubscript: "langForCode")
        let value = context.evaluateScript("highlightCode(code, langForCode);")
        return value.toString()
    }
    
    func highlightAuto(code: String) -> String? {
        context.setObject(code, forKeyedSubscript: "code")
        let value = context.evaluateScript("hljs.highlightAuto(code)").valueForProperty("value")
        return value.toString()
    }
}

public class Converter {
    let regexString = "<span class=\"([\\w-]+?)\">((?!.*?<span).+?)</span>"
    
    private func setup() {
        
    }
    
    typealias SpanInfo = (totalRange: NSRange, cssClassName: String, content: String)
    public func convert(string: String, theme: String) -> String? {
        let regex: NSRegularExpression
        do {
            regex = try NSRegularExpression(pattern: self.regexString, options: [])
        } catch {
            fatalError("convert error: \(error)")
        }
        var resultString = NSMutableAttributedString()
        string.enumerateLines { (line, stop) -> () in
            var lineAttriString = NSMutableAttributedString(string: line)
            var finished = false
            while (!finished) {
                regex.enumerateMatchesInString(line, options: [], range: NSMakeRange(0, line.utf16.count)) { (match, _, stop) -> Void in
                    stop.memory = true // each time only handle one match
                    guard let match = match where match.range.location != NSNotFound else {
                        finished = true
                        return
                    }
                }
            }
        }
        return nil
    }
}

extension String {
    public func highlight(lang: String?) -> String? {
        if let lang = lang {
            return Highlighting.defaultHighlight.highlight(lang, code: self)
        } else {
            return Highlighting.defaultHighlight.highlightAuto(self)
        }
    }
}
