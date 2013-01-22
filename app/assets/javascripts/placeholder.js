/**
 * Created with JetBrains RubyMine.
 * User: Administrator
 * Date: 13-1-14
 * Time: 上午11:40
 * To change this template use File | Settings | File Templates.
 */
$.fn.extend({
    /**
     * 该方法为了解决不支持placeholder属性的浏览器下达到相似效果作用
     * @param _color 文本框输入字体颜色,默认黑色
     * @param _plaColor 文本框placeholder字体颜色，默认灰色#a3a3a3
     */
    inputTip:function(_color, _plaColor) {
        _color = _color || "#000000";
        _plaColor = _plaColor || "#a3a3a3";
        function supportsInputPlaceholder() { // 判断浏览器是否支持html5的placeholder属性
            var input = document.createElement('input');
            return "placeholder" in input;
        }

        function showPassword(_bool, _passEle, _textEle) { // 密码框和文本框的转换
            if (_bool) {
                _passEle.show();
                _textEle.hide();
            } else {
                _passEle.hide();
                _textEle.show();
    }
        }

        if (!supportsInputPlaceholder()) {
            this.each(function() {
                var thisEle = $(this);
                var inputType = thisEle.attr("type")
                var isPasswordInput = inputType == "password";
                var isInputBox = inputType == "password" || inputType == "text";
                if (isInputBox) { //如果是密码或文本输入框
                    var isUserEnter = false; // 是否为用户输入内容,允许用户的输入和默认内容一样
                    var placeholder = thisEle.attr("placeholder");

                    if (isPasswordInput) { // 如果是密码输入框
//原理：由于input标签的type属性不可以动态更改，所以要构造一个文本input替换整个密码input
                        var textStr = "<input type='text' class='" + thisEle.attr("class") + "' style='" + (thisEle.attr("style") || "") + "' />";
                        var textEle = $(textStr);
                        textEle.css("color", _plaColor).val(placeholder).focus(
                            function() {
                                thisEle.focus();
                            }).insertAfter(this);
                        thisEle.hide();
                }
                    thisEle.css("color", _plaColor).val("");//解决ie下刷新无法清空已输入input数据问题
                    if (thisEle.val() == "") {
                        thisEle.val(placeholder);
            }
                    thisEle.focus(function() {
                        if (thisEle.val() == placeholder && !isUserEnter) {
                            thisEle.css("color", _color).val("");
                            if (isPasswordInput) {
                                showPassword(true, thisEle, textEle);
        }
    }
                    });
                    thisEle.blur(function() {
                        if (thisEle.val() == "") {
                            thisEle.css("color", _plaColor).val(placeholder);
                            isUserEnter = false;
                            if (isPasswordInput) {
                                showPassword(false, thisEle, textEle);
                            }
                        }
                    });
                    thisEle.keyup(function() {
                        if (thisEle.val() != placeholder) {
                            isUserEnter = true;
                        }
                    });
}
            });
        }
    }
});


$(function() {
    $("input").inputTip();  // 调用inputTip方法
    $("input[type='button']").focus();  // 页面打开后焦点置于button上，也可置于别处。否则IE上刷新页面后焦点在第一个输入框内造成placeholder文字后紧跟光标现象
});
