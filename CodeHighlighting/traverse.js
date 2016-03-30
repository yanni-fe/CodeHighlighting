/**
 * Created by yupengyang on 3/30/16.
 */
Array.prototype.extend = function (other_array) {
    /* you should include a test to check whether other_array really is an array */
    other_array.forEach(function(v) {this.push(v)}, this);
}
function highlightCode(code, lang) {
    var htmlres;
    if(lang) {
        htmlres = hljs.highlight(lang, code).value;
    } else {
        htmlres = hljs.highlightAuto(code).value;
    }
    return htmlres;
    var codeNode = document.createElement("code");
    codeNode.innerHTML = htmlres;
    var nl = codeNode.childNodes;
    return convert(nl);
}

function convert(obj) {
    if(obj instanceof NodeList) {
        var arr = [];
        for(var i = 0; i < obj.length; i++) {
            var node = obj.item(i);
            arr.extend(convert(node));
        }
        return arr;
    } else if(obj instanceof Node) {
        var arr = [];
        if(obj.hasChildNodes()) {
            arr.extend(convert(obj.childNodes));
        } else {
            if(!obj.className) {
                arr.push([obj.wholeText, ""]);
            } else {
                arr.push([obj.innerText, obj.className]);
            }
        }
        return arr;
    }
}