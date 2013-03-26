(function($){
    $.fn.sFilter = function(options) {
        var opts = $.extend({}, $.fn.sFilter.defaults, options);
        return this.each(function() {
            var $this = $(this);
            new $.SFilter($this, opts);
        })
    };

    $.fn.sFilter.defaults = {
        targetDom : "s",//显示目标节点
        targetText: "st",//显示文字节点
        category: "category",//分类属性前缀
        isCategory: true,//是否显示分类名
        traversal: ".current",//通过traversal来识别被选择项
        condition: 'condition',//传输的条件
        showClass: 'visible',
        hideClass: 'hide',
        noConditionNoShow: '',//传输的condition为这个值，则不显示该项
        targetPond: "#selected",//目标池
        url: '',
        isJump: true,//是否跳转
        paramInput: '',
        param: ''//传入的其他参数
    };

    $.SFilter = function($elem, options) {
        if (!$elem) {
            throw new Error("Invalid parameter for jquery.sFilter");
        }
        var self = this;
        this.options = options;

        $elem.bind('click', function(e) {
            var condition = !!$elem.attr(self.options.condition) ? $elem.attr(self.options.condition) : "";
            var targetId = "#" + self.options.targetDom + "-" + $elem.attr("cid");
            var targetTextId = "#" + self.options.targetText + "-" + $elem.attr("cid");
            var category = "#" + self.options.category + "-" + $elem.attr("cid");
            var text;

            if (options.isCategory) {
                text = $(category).text() + $elem.text();
            } else {
                text = $elem.text();
            }

            //显示
            $(targetId).removeClass(self.options.hideClass);
            $(targetTextId).text(text).attr(self.options.condition, condition);
            //是否加上类名

            var a = $elem.attr("cid");
            if (Request(a)=='0') {
                $(targetId).addClass(self.options.hideClass);
            }
            //是否跳转
            if (self.options.isJump) {
                window.location.href = self.getUrl();
            }
            return false;
        });
        //传导的条件拼装字符串
        this.ConditionToStr = function() {
            var pond = self.options.targetPond;
            var condition = self.options.condition;
            var $doms = $(pond + " [" + condition + "]");
            var str = "";
            $.each($doms, function(i, n) {
                if (!!$(n).attr(condition)) {
                    str += "&" + $(n).attr(condition);
                }
            });
            //去掉首尾多余的&符号
            return str.replace(/(^[&])|([&]$)/g, "");
        };
        //字符串与url拼装出最后的链接地址
        this.getUrl = function() {
            var url = self.options.url;
            var conditionStr = !!self.ConditionToStr() ? self.ConditionToStr() : "";
            if(conditionStr!=''){
                if(url.indexOf("?") < 0){
                    url = url+"?" + conditionStr;
                }
                else if(url.indexOf($elem.attr("cid")) < 0){
                    url = url+"&" + conditionStr;
                }
                else{
                    var a = $elem.attr("cid");
                    url = url.replace(a+"="+Request(a),conditionStr);
                }
            }
            else{
                if(url.indexOf($elem.attr("cid")) >= 0){
                    var a = $elem.attr("cid");
                    if (url.indexOf("&") >= 0){
                        url = url.replace("?"+a+"="+Request(a)+"&","?");
                    }
                    else{
                        url = url.replace("?"+a+"="+Request(a),"");
                    }
                    url = url.replace("&"+a+"="+Request(a),"");
                }
            }

            return url
            /*
            var url = self.options.url;
            var conditionStr = !!self.ConditionToStr() ? self.ConditionToStr() : "";
            var param;
            if (self.options.paramInput != "") {
                param = $(self.options.paramInput).attr('value');
            } else {
                param = self.options.param;
            }
            var strParam = "";
            if (typeof param == "object") {
                $.each(param, function(i, n){
                    strParam = strParam + "&" + i + "=" + n;
                });
                strParam = strParam.replace(/(^[&])|([&]$)/g, "");
            } else {
                strParam = !!param ? param : "";
            }
            var strings = "";
            if (!!conditionStr && !!strParam) {
                strings = conditionStr + "&" + strParam;
            } else if (!!conditionStr || !!strParam) {
                strings = conditionStr + strParam;
            }
            if (strings != "") {
                strings = "?" + strings;
            }

            return url + strings;
            */
        };
    }
})(jQuery);


function Request(sName)
{
    var sURL = new String(window.location);
    var sURL = document.location.href;
    sURL=decodeURI(sURL);
    var iQMark= sURL.lastIndexOf('?');
    var iLensName=sName.length;
    //retrieve loc. of sName
    var iStart = sURL.indexOf('?' + sName +'=') //limitation 1
    if (iStart==-1)
    {//not found at start
        iStart = sURL.indexOf('&' + sName +'=')//limitation 1
        if (iStart==-1)
        {//not found at end
            return 0; //not found
        }
    }

    iStart = iStart + + iLensName + 2;
    var iTemp= sURL.indexOf('&',iStart); //next pair start
    if (iTemp ==-1)
    {//EOF
        iTemp=sURL.length;
    }
    return sURL.slice(iStart,iTemp ) ;
    sURL=null;//destroy String
}

