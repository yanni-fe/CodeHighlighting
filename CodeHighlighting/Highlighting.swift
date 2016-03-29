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
        context = JSContext(virtualMachine: JSVirtualMachine())
        setup()
    }
    
    private func setup() {
        do {
            let contextString = try String(contentsOfFile: NSBundle.mainBundle().pathForResource("highlight.pack", ofType: "js")!)
            context.evaluateScript("var window = {};")
            context.evaluateScript(contextString)
            context.evaluateScript("var hljs = window.hljs;")
            context.evaluateScript(contextString)
        } catch {
            fatalError("error: \(error)")
        }
    }
    
    func highlight(lang: String, code: String) -> String? {
        context.setObject(code, forKeyedSubscript: "code")
        context.setObject(lang, forKeyedSubscript: "langForCode")
        let value = context.evaluateScript("hljs.highlight(langForCode, code)").valueForProperty("value")
        return value.toString()
    }
    
    func highlightAuto(code: String) -> String? {
        context.setObject(code, forKeyedSubscript: "code")
        let value = context.evaluateScript("hljs.highlightAuto(code)").valueForProperty("value")
        return value.toString()
    }
}

class Converter {
    let regexString = "<span class=\"([\\w-]+?)\">((?!.*?<span).+?)</span>"
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
