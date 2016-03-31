/**
 * Created by yupengyang on 3/30/16.
 */
Array.prototype.extend = function (other_array) {
    /* you should include a test to check whether other_array really is an array */
    other_array.forEach(function(v) {this.push(v)}, this);
}

function highlightToiOS(code, lang) {
    var htmlres = highlightCode(code, lang)
    var codeNode = document.createElement("code");
    codeNode.innerHTML = htmlres;
    document.body.appendChild(codeNode);
    var nl = codeNode.childNodes;
    return convert(nl);
}

function highlightCode(code, lang) {
    var htmlres;
    if(lang) {
        htmlres = hljs.highlight(lang, code).value;
    } else {
        htmlres = hljs.highlightAuto(code).value;
    }
    var codeNode = document.createElement("code");
    codeNode.innerHTML = htmlres;
    document.body.appendChild(codeNode);
    var nl = codeNode.childNodes;
    return convert(nl);
}

function convert(obj, parentClass) {
    if(obj instanceof NodeList) {
        var arr = [];
        for(var i = 0; i < obj.length; i++) {
            var node = obj[i];
            arr.extend(convert(node, parentClass ? parentClass : "hljs"));
        }
        return arr;
    } else if(obj instanceof Node) {
        var arr = [];
        if(obj.hasChildNodes() && !(obj.childNodes.length == 1 && obj.childNodes[0].nodeType == 3)) {
            arr.extend(convert(obj.childNodes, obj.className));
        } else {
            if(obj.nodeType == 3) {
                arr.push([obj.wholeText, parentClass ? parentClass : "hljs"]);
            } else {
                arr.push([obj.innerText, obj.className]);
            }
        }
        return arr;
    }
}