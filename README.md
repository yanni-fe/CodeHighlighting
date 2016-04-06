## 语法高亮的view

自己不会写parser, 上网找到了[highlightjs](https://highlightjs.org).

一开始的思路是用把highlightjs解析出来的html转成`NSAttributedString`放到`UITextView`里面. 但是`UITextView`有个问题是行宽度, 如果我们限制了行宽度, 那么不好实现, 所以就没有用`UITextView`而改用了`UIWebView`.

原理是用`JavaScriptCore`拿到`UIWebView`的`JSContext`, 然后让webView去load一个包含highlightjs的html模板, 在通过`JSContext`把要高亮的代码传进去解析. 就完成了....

