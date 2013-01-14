/**
 * Created with JetBrains RubyMine.
 * User: Administrator
 * Date: 13-1-14
 * Time: 上午11:40
 * To change this template use File | Settings | File Templates.
 */
//placeholder IE8
var _placeholderSupport = function() {
    var t = document.createElement("input");
    t.type = "text";
    return (typeof t.placeholder !== "undefined");
}();

window.onload = function() {
    var arrInputs = document.getElementsByTagName("input");
    for (var i = 0; i < arrInputs.length; i++) {
        var curInput = arrInputs[i];
        if (!curInput.type || curInput.type == "" || curInput.type == "text")
            HandlePlaceholder(curInput);
    }
};

function HandlePlaceholder(oTextbox) {
    if (!_placeholderSupport) {
        var curPlaceholder = oTextbox.getAttribute("placeholder");
        if (curPlaceholder && curPlaceholder.length > 0) {
            oTextbox.value = curPlaceholder;
            oTextbox.setAttribute("old_color", oTextbox.style.color);
            oTextbox.style.color = "#c0c0c0";
            oTextbox.onfocus = function() {
                this.style.color = this.getAttribute("old_color");
                if (this.value === curPlaceholder)
                    this.value = "";
            };
            oTextbox.onblur = function() {
                if (this.value === "") {
                    this.style.color = "#c0c0c0";
                    this.value = curPlaceholder;
                }
            }
        }
    }
}
