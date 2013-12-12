
$.fn.dataTableExt.afnFiltering.push(
    function( oSettings, aData, iDataIndex ) {
        if(oSettings.sTableId=="liudong"){
            var num1=0,num2=1,num3=0,num4=0;
            var obj = document.getElementsByName("checkbox1"); // 获取多选框数组
            var objLen = obj.length;
            var objYN = false; // 是否有选择
            for (var i = 0; i < objLen; i++) {
                if (obj [i].checked == true) {
                    objYN = true;
                    break;
                }
            }
            if(!objYN){
                $("#amounts0").addClass('currbg');
                $("#s-amount").addClass('hide');
                $("[class*='color1']").removeClass('currbg');
                num1=1;
            }
            else{
                $("#amounts0").removeClass('currbg');
                $("#s-amount").removeClass('hide');
                var text='';
                if(obj[0].checked == true){
                    $(".color11").addClass('currbg');
                    text='1元-1000元';
                    if(aData[3]>=1 && aData[3]<=1000){
                        num1=1;
                    }
                }
                else{
                    $(".color11").removeClass('currbg');
                }
                if(obj[1].checked == true){
                    $(".color12").addClass('currbg');
                    if(text!=""){text=text+",1000元以上"}else{text="1000元以上"}
                    if(aData[3]>=1001){
                        num1=1;
                    }
                }
                else{
                    $(".color12").removeClass('currbg');
                }
                $("#st-amount").html('起购金额:'+text);
            }

            var obj = document.getElementsByName("checkbox2"); // 获取多选框数组
            var objLen = obj.length;
            var objYN = false; // 是否有选择
            for (var i = 0; i < objLen; i++) {
                if (obj [i].checked == true) {
                    objYN = true;
                    break;
                }
            }
            if(!objYN){
                $("#expectYIDs0").addClass('currbg');
                $("#s-expectYID").addClass('hide');
                $("[class*='color2']").removeClass('currbg');
            }
            else{
                $("#expectYIDs0").removeClass('currbg');
                $("#s-expectYID").removeClass('hide');
                var text='';
                if(obj[0].checked == true){text='一';}
                if(obj[1].checked == true){if(text!=""){text=text+",三"}else{text="三"}}
                $("#st-expectYID").html('同类排名:近'+text+'年前20名');
                if(obj[0].checked == true){
                    $(".color21").addClass('currbg');
                    if(!(aData[9]>=1 && aData[9]<=20)){
                        num2=0;
                    }
                }
                else{
                    $(".color21").removeClass('currbg');
                }
                if(obj[1].checked == true){
                    $(".color22").addClass('currbg');
                    if(!(aData[12]>=1 && aData[12]<=20)){
                        num2=0;
                    }
                }
                else{
                    $(".color22").removeClass('currbg');
                }
            }

            var obj = document.getElementsByName("checkbox3"); // 获取多选框数组
            var objLen = obj.length;
            var objYN = false; // 是否有选择
            for (var i = 0; i < objLen; i++) {
                if (obj [i].checked == true) {
                    objYN = true;
                    break;
                }
            }
            if(!objYN){
                $("#durations0").addClass('currbg');
                $("#s-duration").addClass('hide');
                $("[class*='color3']").removeClass('currbg');
                num3=1;
            }
            else{
                $("#durations0").removeClass('currbg');
                $("#s-duration").removeClass('hide');
                var text='';
                if(obj[0].checked == true){
                    $(".color31").addClass('currbg');
                    text='0-100亿';
                    if(aData[4]>=0 && aData[4]<=100){
                        num3=1;
                    }
                }
                else{
                    $(".color31").removeClass('currbg');
                }
                if(obj[1].checked == true){
                    $(".color32").addClass('currbg');
                    if(text!=""){text=text+",100亿以上"}else{text="100亿以上"}
                    if(aData[4]>100){
                        num3=1;
                    }
                }
                else{
                    $(".color32").removeClass('currbg');
                }
                $("#st-duration").html('资金规模:'+text);
            }

            var obj = document.getElementsByName("checkbox4"); // 获取多选框数组
            var objLen = obj.length;
            var objYN = false; // 是否有选择
            for (var i = 0; i < objLen; i++) {
                if (obj [i].checked == true) {
                    objYN = true;
                    break;
                }
            }
            if(!objYN){
                $("#scates0").addClass('currbg');
                $("#s-scate").addClass('hide');
                $("[class*='color4']").removeClass('currbg');
                num4=1;
            }
            else{
                $("#scates0").removeClass('currbg');
                $("#s-scate").removeClass('hide');
                var text='';
                if(obj[0].checked == true){
                    $(".color41").addClass('currbg');
                    text='0-10年';
                    if(aData[6]>=0 && aData[6]<3650){
                        num4=1;
                    }
                }
                else{
                    $(".color41").removeClass('currbg');
                }
                if(obj[1].checked == true){
                    $(".color42").addClass('currbg');
                    if(text!=""){text=text+",10年以上"}else{text="10年以上"}
                    if(aData[6]>=3650){
                        num4=1;
                    }
                }
                else{
                    $(".color42").removeClass('currbg');
                }
                $("#st-scate").html('成立时间:'+text);
            }

            if(num1==1 && num2==1 && num3==1 && num4==1){
                return true;
            }
            else{
                return false;
            }
        }
        else if(oSettings.sTableId=="select"){
            var num1=0,num2=0,num3=1,num4=0,num5=0,num6=0;
            if(typeid!="" && typeid==aData[0]){
                num1=1;
            }

            var obj = document.getElementsByName("checkbox6"); // 获取多选框数组
            var objLen = obj.length;
            var objYN = false; // 是否有选择
            for (var i = 0; i < objLen; i++) {
                if (obj [i].checked == true) {
                    objYN = true;
                    break;
                }
            }
            if(!objYN){
                $("#categorys0").addClass('currbg');
                $("#s-category").addClass('hide');
                $("[class*='colors1']").removeClass('currbg');
                num2=1;
            }
            else{
                $("#categorys0").removeClass('currbg');
                $("#s-category").removeClass('hide');
                var text='';
                if(obj[0].checked == true){
                    $(".colors11").addClass('currbg');
                    text='0-1000元';
                    if(aData[1]>=0 && aData[1]<=1000){
                        num2=1;
                    }
                }
                else{
                    $(".colors11").removeClass('currbg');
                }
                if(obj[1].checked == true){
                    $(".colors12").addClass('currbg');
                    if(text!=""){text=text+",1000元以上"}else{text="1000元以上"}
                    if(aData[1]>1000){
                        num2=1;
                    }
                }
                else{
                    $(".colors12").removeClass('currbg');
                }
                $("#st-category").html('起购金额:'+text);
            }
            var obj = document.getElementsByName("checkbox7"); // 获取多选框数组
            var objLen = obj.length;
            var objYN = false; // 是否有选择
            for (var i = 0; i < objLen; i++) {
                if (obj [i].checked == true) {
                    objYN = true;
                    break;
                }
            }
            if(!objYN){
                $("#ranks0").addClass('currbg');
                $("#s-rank").addClass('hide');
                $("[class*='colors2']").removeClass('currbg');
            }
            else{
                $("#ranks0").removeClass('currbg');
                $("#s-rank").removeClass('hide');
                var text='';
                if(obj[0].checked == true){text='一';}
                if(obj[1].checked == true){if(text!=""){text=text+",三"}else{text="三"}}
                $("#st-rank").html('同类排名:近'+text+'年前20名');
                if(obj[0].checked == true){
                    $(".colors21").addClass('currbg');
                    if(!(aData[11]>=1 && aData[11]<=20)){
                        num3=0;
                    }
                }
                else{
                    $(".colors21").removeClass('currbg');
                }
                if(obj[1].checked == true){
                    $(".colors23").addClass('currbg');
                    if(!(aData[14]>=1 && aData[14]<=20)){
                        num3=0;
                    }
                }
                else{
                    $(".colors23").removeClass('currbg');
                }
            }
            var obj = document.getElementsByName("checkbox8"); // 获取多选框数组
            var objLen = obj.length;
            var objYN = false; // 是否有选择
            for (var i = 0; i < objLen; i++) {
                if (obj [i].checked == true) {
                    objYN = true;
                    break;
                }
            }
            if(!objYN){
                $("#terms0").addClass('currbg');
                $("#s-term").addClass('hide');
                $("[class*='colors3']").removeClass('currbg');
                num4=1;
            }
            else{
                $("#terms0").removeClass('currbg');
                $("#s-term").removeClass('hide');
                var text='';
                if(obj[0].checked == true){
                    $(".colors31").addClass('currbg');
                    text='0-10年';
                    if(aData[2]>=0 && aData[2]<3650){
                        num4=1;
                    }
                }
                else{
                    $(".colors31").removeClass('currbg');
                }
                if(obj[1].checked == true){
                    $(".colors32").addClass('currbg');
                    if(text!=""){text=text+",10年以上"}else{text="10年以上"}
                    if(aData[2]>=3650){
                        num4=1;
                    }
                }
                else{
                    $(".colors32").removeClass('currbg');
                }
                $("#st-term").html('成立时间:'+text);
            }
            num5=1;
            var obj = document.getElementsByName("checkbox10"); // 获取多选框数组
            var objLen = obj.length;
            var objYN = false; // 是否有选择
            for (var i = 0; i < objLen; i++) {
                if (obj [i].checked == true) {
                    objYN = true;
                    break;
                }
            }
            if(!objYN){
                $("#levels0").addClass('currbg');
                $("#s-level").addClass('hide');
                $("[class*='colors5']").removeClass('currbg');
                num6=1;
            }
            else{
                $("#levels0").removeClass('currbg');
                $("#s-level").removeClass('hide');
                var text='';
                if(obj[0].checked == true){
                    $(".colors51").addClass('currbg');
                    text='三星';
                    if(aData[15]=='★★★'){
                        num6=1;
                    }
                }
                else{
                    $(".colors51").removeClass('currbg');
                }
                if(obj[1].checked == true){
                    $(".colors52").addClass('currbg');
                    if(text!=""){text=text+",四星"}else{text="四星"}
                    if(aData[15]=='★★★★'){
                        num6=1;
                    }
                }
                else{
                    $(".colors52").removeClass('currbg');
                }
                if(obj[2].checked == true){
                    $(".colors53").addClass('currbg');
                    if(text!=""){text=text+",五星"}else{text="五星"}
                    if(aData[15]=='★★★★★'){
                        num6=1;
                    }
                }
                else{
                    $(".colors53").removeClass('currbg');
                }
                $("#st-level").html('晨星评级:'+text);
            }

            if(num1==1 && num2==1 && num3==1&& num4==1 && num5==1 && num6==1){
                return true;
            }
            else{
                return false;
            }
        }
        else{
            return true;
        }
    }
);