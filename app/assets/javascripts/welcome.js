// froogaloop
var Froogaloop=function(){function e(a){return new e.fn.init(a)}function h(a,c,b){if(!b.contentWindow.postMessage)return!1;var f=b.getAttribute("src").split("?")[0],a=JSON.stringify({method:a,value:c});"//"===f.substr(0,2)&&(f=window.location.protocol+f);b.contentWindow.postMessage(a,f)}function j(a){var c,b;try{c=JSON.parse(a.data),b=c.event||c.method}catch(f){}"ready"==b&&!i&&(i=!0);if(a.origin!=k)return!1;var a=c.value,e=c.data,g=""===g?null:c.player_id;c=g?d[g][b]:d[b];b=[];if(!c)return!1;void 0!==a&&b.push(a);e&&b.push(e);g&&b.push(g);return 0<b.length?c.apply(null,b):c.call()}function l(a,c,b){b?(d[b]||(d[b]={}),d[b][a]=c):d[a]=c}var d={},i=!1,k="";e.fn=e.prototype={element:null,init:function(a){"string"===typeof a&&(a=document.getElementById(a));this.element=a;a=this.element.getAttribute("src");"//"===a.substr(0,2)&&(a=window.location.protocol+a);for(var a=a.split("/"),c="",b=0,f=a.length;b<f;b++){if(3>b)c+=a[b];else break;2>b&&(c+="/")}k=c;return this},api:function(a,c){if(!this.element||!a)return!1;var b=this.element,f=""!==b.id?b.id:null,d=!c||!c.constructor||!c.call||!c.apply?c:null,e=c&&c.constructor&&c.call&&c.apply?c:null;e&&l(a,e,f);h(a,d,b);return this},addEvent:function(a,c){if(!this.element)return!1;var b=this.element,d=""!==b.id?b.id:null;l(a,c,d);"ready"!=a?h("addEventListener",a,b):"ready"==a&&i&&c.call(null,d);return this},removeEvent:function(a){if(!this.element)return!1;var c=this.element,b;a:{if((b=""!==c.id?c.id:null)&&d[b]){if(!d[b][a]){b=!1;break a}d[b][a]=null}else{if(!d[a]){b=!1;break a}d[a]=null}b=!0}"ready"!=a&&b&&h("removeEventListener",a,c)}};e.fn.init.prototype=e.fn;window.addEventListener?window.addEventListener("message",j,!1):window.attachEvent("onmessage",j);return window.Froogaloop=window.$f=e}();

// jQuery easing
jQuery.easing.jswing=jQuery.easing.swing;
jQuery.extend(jQuery.easing,{def:"easeOutQuad",swing:function(e,a,c,b,d){return jQuery.easing[jQuery.easing.def](e,a,c,b,d)},easeInQuad:function(e,a,c,b,d){return b*(a/=d)*a+c},easeOutQuad:function(e,a,c,b,d){return-b*(a/=d)*(a-2)+c},easeInOutQuad:function(e,a,c,b,d){if((a/=d/2)<1)return b/2*a*a+c;return-b/2*(--a*(a-2)-1)+c},easeInCubic:function(e,a,c,b,d){return b*(a/=d)*a*a+c},easeOutCubic:function(e,a,c,b,d){return b*((a=a/d-1)*a*a+1)+c},easeInOutCubic:function(e,a,c,b,d){if((a/=d/2)<1)return b/
2*a*a*a+c;return b/2*((a-=2)*a*a+2)+c},easeInQuart:function(e,a,c,b,d){return b*(a/=d)*a*a*a+c},easeOutQuart:function(e,a,c,b,d){return-b*((a=a/d-1)*a*a*a-1)+c},easeInOutQuart:function(e,a,c,b,d){if((a/=d/2)<1)return b/2*a*a*a*a+c;return-b/2*((a-=2)*a*a*a-2)+c},easeInQuint:function(e,a,c,b,d){return b*(a/=d)*a*a*a*a+c},easeOutQuint:function(e,a,c,b,d){return b*((a=a/d-1)*a*a*a*a+1)+c},easeInOutQuint:function(e,a,c,b,d){if((a/=d/2)<1)return b/2*a*a*a*a*a+c;return b/2*((a-=2)*a*a*a*a+2)+c},easeInSine:function(e,
a,c,b,d){return-b*Math.cos(a/d*(Math.PI/2))+b+c},easeOutSine:function(e,a,c,b,d){return b*Math.sin(a/d*(Math.PI/2))+c},easeInOutSine:function(e,a,c,b,d){return-b/2*(Math.cos(Math.PI*a/d)-1)+c},easeInExpo:function(e,a,c,b,d){return a==0?c:b*Math.pow(2,10*(a/d-1))+c},easeOutExpo:function(e,a,c,b,d){return a==d?c+b:b*(-Math.pow(2,-10*a/d)+1)+c},easeInOutExpo:function(e,a,c,b,d){if(a==0)return c;if(a==d)return c+b;if((a/=d/2)<1)return b/2*Math.pow(2,10*(a-1))+c;return b/2*(-Math.pow(2,-10*--a)+2)+c},
easeInCirc:function(e,a,c,b,d){return-b*(Math.sqrt(1-(a/=d)*a)-1)+c},easeOutCirc:function(e,a,c,b,d){return b*Math.sqrt(1-(a=a/d-1)*a)+c},easeInOutCirc:function(e,a,c,b,d){if((a/=d/2)<1)return-b/2*(Math.sqrt(1-a*a)-1)+c;return b/2*(Math.sqrt(1-(a-=2)*a)+1)+c},easeInElastic:function(e,a,c,b,d){e=1.70158;var f=0,g=b;if(a==0)return c;if((a/=d)==1)return c+b;f||(f=d*0.3);if(g<Math.abs(b)){g=b;e=f/4}else e=f/(2*Math.PI)*Math.asin(b/g);return-(g*Math.pow(2,10*(a-=1))*Math.sin((a*d-e)*2*Math.PI/f))+c},easeOutElastic:function(e,
a,c,b,d){e=1.70158;var f=0,g=b;if(a==0)return c;if((a/=d)==1)return c+b;f||(f=d*0.3);if(g<Math.abs(b)){g=b;e=f/4}else e=f/(2*Math.PI)*Math.asin(b/g);return g*Math.pow(2,-10*a)*Math.sin((a*d-e)*2*Math.PI/f)+b+c},easeInOutElastic:function(e,a,c,b,d){e=1.70158;var f=0,g=b;if(a==0)return c;if((a/=d/2)==2)return c+b;f||(f=d*0.3*1.5);if(g<Math.abs(b)){g=b;e=f/4}else e=f/(2*Math.PI)*Math.asin(b/g);if(a<1)return-0.5*g*Math.pow(2,10*(a-=1))*Math.sin((a*d-e)*2*Math.PI/f)+c;return g*Math.pow(2,-10*(a-=1))*Math.sin((a*
d-e)*2*Math.PI/f)*0.5+b+c},easeInBack:function(e,a,c,b,d,f){if(f==undefined)f=1.70158;return b*(a/=d)*a*((f+1)*a-f)+c},easeOutBack:function(e,a,c,b,d,f){if(f==undefined)f=1.70158;return b*((a=a/d-1)*a*((f+1)*a+f)+1)+c},easeInOutBack:function(e,a,c,b,d,f){if(f==undefined)f=1.70158;if((a/=d/2)<1)return b/2*a*a*(((f*=1.525)+1)*a-f)+c;return b/2*((a-=2)*a*(((f*=1.525)+1)*a+f)+2)+c},easeInBounce:function(e,a,c,b,d){return b-jQuery.easing.easeOutBounce(e,d-a,0,b,d)+c},easeOutBounce:function(e,a,c,b,d){return(a/=
d)<1/2.75?b*7.5625*a*a+c:a<2/2.75?b*(7.5625*(a-=1.5/2.75)*a+0.75)+c:a<2.5/2.75?b*(7.5625*(a-=2.25/2.75)*a+0.9375)+c:b*(7.5625*(a-=2.625/2.75)*a+0.984375)+c},easeInOutBounce:function(e,a,c,b,d){if(a<d/2)return jQuery.easing.easeInBounce(e,a*2,0,b,d)*0.5+c;return jQuery.easing.easeOutBounce(e,a*2-d,0,b,d)*0.5+b*0.5+c}});

// layerSlider
eval(function(p,a,c,k,e,d){e=function(c){return(c<a?'':e(parseInt(c/a)))+((c=c%a)>35?String.fromCharCode(c+29):c.toString(36))};if(!''.replace(/^/,String)){while(c--){d[e(c)]=k[c]||e(c)}k=[function(e){return d[e]}];e=function(){return'\\w+'};c=1};while(c--){if(k[c]){p=p.replace(new RegExp('\\b'+e(c)+'\\b','g'),k[c])}}return p}('(5(a){a.3O.Y=5(c){3((34 c).21("3P|3Q")){V 9.12(5(a){3R b(9,c)})}w{3(c=="7"){6 d=a(9).7("26");3(d){V d}}w{V 9.12(5(b){6 d=a(9).7("26");3(d){3(!d.g.1u){3(34 c=="3N"){3(c>0&&c<d.g.10+1&&c!=d.g.R){d.1U(c)}}w{1o(c){u"K":d.o.1T();d.K();t;u"J":d.o.1Z();d.J();t;u"11":3(!d.g.W){d.o.2K();d.11()}t}}}3(d.g.W&&c=="X"){d.o.2J();d.X()}}})}}};6 b=5(c,d){6 e=9;e.$3c=a(c).14("4-2a");e.$3c.7("26",e);e.36=5(){e.o=a.3e({},b.3g,d);e.g=a.3e({},b.3k);3(a(c).p(".4-S").T==1){a(c).p(".4-S:16(0)").3M().Q(a(c))}e.g.20=a(c)[0].1g.P;a(c).p(\'.4-S, *[I^="4-s"]\').12(5(){3(a(9).L("1z")||a(9).L("1g")){3(a(9).L("1z")){6 b=a(9).L("1z").1n().19(";")}w{6 b=a(9).L("1g").1n().19(";")}1M(x=0;x<b.T;x++){1e=b[x].19(":");3(1e[0].1p("3I")!=-1){1e[1]=e.3i(1e[1])}a(9).7(a.1D(1e[0]),a.1D(1e[1]))}}a(9).7("2U",a(9)[0].1g.F);a(9).7("2V",a(9)[0].1g.H)});e.g.10=a(c).p(".4-S").T;e.o.M=e.o.M<e.g.10+1?e.o.M:1;e.o.M=e.o.M<1?1:e.o.M;3(e.o.2n==A){e.o.M=e.o.M-1==0?e.g.10:e.o.M-1}e.g.R=e.o.M;e.g.v=a(c).p(".4-S:16("+(e.g.R-1)+")");e.g.D=5(){V a(c).P()};e.g.E=5(){V a(c).13()};3(e.o.2m){6 f=a("<23>").Q(a(c)).L("29",e.o.2m).L("1g",e.o.2B);3(e.o.2p!=O){a("<a>").Q(a(c)).L("17",e.o.2p).L("3H",e.o.2Y).q({3J:"1a",3K:"1a"}).3L(f)}}a(c).p(".4-S").3S(\'<27 I="4-1w"></27>\');3(a(c).q("2v")=="3T"){a(c).q("2v","41")}a(c).p(".4-1w").q({42:e.o.2E});3(e.o.2t){a(c).p(".4-1w").q({43:"1v("+e.o.2t+")"})}a(c).p(".4-31").q({18:-(e.g.D()/2)+"1H",1b:-(e.g.E()/2)+"1H"});3(e.o.3s){a(\'<a I="4-y-K" 17="#" />\').1s(5(b){b.1j();a(c).Y("K")}).Q(a(c));a(\'<a I="4-y-J" 17="#" />\').1s(5(b){b.1j();a(c).Y("J")}).Q(a(c))}3(e.o.2q||e.o.2o){a(\'<27 I="4-r-y-1l" />\').Q(a(c));3(e.o.2o){a(\'<28 I="4-r-1m" />\').Q(a(c).p(".4-r-y-1l"));1M(x=1;x<e.g.10+1;x++){a(\'<a 17="#"></a>\').Q(a(c).p(".4-r-1m")).1s(5(b){b.1j();a(c).Y(a(9).2W()+1)})}a(c).p(".4-r-1m a:16("+(e.o.M-1)+")").14("4-y-Z")}3(e.o.2q){a(\'<a I="4-y-11" 17="#" />\').1s(5(b){b.1j();a(c).Y("11")}).3m(a(c).p(".4-r-y-1l"));a(\'<a I="4-y-X" 17="#" />\').1s(5(b){b.1j();a(c).Y("X")}).Q(a(c).p(".4-r-y-1l"))}w{a(\'<28 I="4-y-32 4-y-40" />\').3m(a(c).p(".4-r-y-1l"));a(\'<28 I="4-y-32 4-y-3Z" />\').Q(a(c).p(".4-r-y-1l"))}}3(e.o.3r){a("2C").1E("3G",5(a){3(!e.g.1u){3(a.2A==37){e.o.1T();e.K()}w 3(a.2A==39){e.o.1Z();e.J()}}})}3("3U"3W 1t){a(c).1E("3X",5(a){6 b=a.1i?a.1i:a.2X.1i;3(b.T==1){e.g.1C=e.g.1q=b[0].2R}});a(c).1E("3Y",5(a){6 b=a.1i?a.1i:a.2X.1i;3(b.T==1){e.g.1q=b[0].2R}3(3u.2O(e.g.1C-e.g.1q)>45){a.1j()}});a(c).1E("46",5(b){3(3u.2O(e.g.1C-e.g.1q)>45){3(e.g.1C-e.g.1q>0){e.o.1Z();a(c).Y("J")}w{e.o.1T();a(c).Y("K")}}})}3(e.o.2D==A){a(c).p(".4-1w").3B(5(){e.o.2M();3(e.g.W){e.X();e.g.25=A}},5(){3(e.g.25){e.11();e.g.25=O}})}a(c).14("4-"+e.o.1P);6 g=e.o.3j+e.o.1P+"/1P.q";3(2F.3l){2F.3l(g)}w{a(\'<3z 1z="3y" 17="\'+g+\'" 3x="3A/q" />\').Q(a("3E"))}3(e.o.2n==A){3(e.o.2y){e.g.W=A}e.J()}w{e.1r(e.g.v,5(){e.g.v.3a(3w).14("4-Z");3(e.o.2y){e.11()}})}a(1t).3D(5(){e.1d(e.g.v,5(){V})});a(c).15(3C).3F(5(){e.1d(e.g.v,5(){V})});e.o.2L(a(c))};e.11=5(){3(e.g.W){3(e.g.U=="K"&&e.o.3q){e.K()}w{e.J()}}w{e.g.W=A;e.2j()}};e.2j=5(){6 b=a(c).p(".4-Z").7("3f")?B(a(c).p(".4-Z").7("3f")):e.o.3t;24(e.g.1x);e.g.1x=1t.3v(5(){e.11()},b)};e.X=5(){24(e.g.1x);e.g.W=O};e.3i=5(b){3(a.1D(b.1n())=="3V"||a.1D(b.1n())=="4x"){V b.1n()}w{V b.G("4D","4C").G("4z","4H").G("4M","4F").G("4Q","4E").G("4B","4w").G("4y","4G").G("4N","4O").G("4P","47").G("4L","4I").G("4J","4K").G("4A","4u").G("4e","4f").G("4g","4v")}};e.K=5(){6 a=e.g.R<2?e.g.10:e.g.R-1;e.g.U="K";e.1U(a,e.g.U)};e.J=5(){6 a=e.g.R<e.g.10?e.g.R+1:1;e.g.U="J";e.1U(a,e.g.U)};e.1U=5(b,d){24(e.g.1x);e.g.1S=b;e.g.C=a(c).p(".4-S:16("+(e.g.1S-1)+")");3(!d){3(e.g.R<e.g.1S){e.g.U="J"}w{e.g.U="K"}}e.1r(e.g.C,5(){e.1c()})};e.1r=5(b,c){3(e.o.1r){6 d=[];6 f=0;3(b.q("1k-1f")!="1a"&&b.q("1k-1f").1p("1v")!=-1){6 g=b.q("1k-1f");g=g.21(/1v\\((.*)\\)/)[1].G(/"/2S,"");d.22(g)}b.p("23").12(5(){d.22(a(9).L("29"))});b.p("*").12(5(){3(a(9).q("1k-1f")!="1a"&&a(9).q("1k-1f").1p("1v")!=-1){6 b=a(9).q("1k-1f");b=b.21(/1v\\((.*)\\)/)[1].G(/"/2S,"");d.22(b)}});3(d.T==0){e.1d(b,c)}w{1M(x=0;x<d.T;x++){a("<23>").4d(5(){3(++f==d.T){e.1d(b,c)}}).L("29",d[x])}}}w{e.1d(b,c)}};e.1d=5(b,c){b.q({1F:"3b",2H:"49"});e.2z();1M(6 d=0;d<b.2I().T;d++){6 f=b.2I(":16("+d+")");6 g=f.7("2U");6 h=f.7("2V");3(g&&g.1p("%")!=-1){f.q({F:e.g.D()/2h*B(g)-f.2T()/2})}3(h&&h.1p("%")!=-1){f.q({H:e.g.E()/2h*B(g)-f.2g()/2})}}b.q({1F:"1a",2H:"4b"});c();a(9).4i()};e.2z=5(){3(a(c).1N(".4-1O-1L-2a").T){a(c).1N(".4-1O-1L-2G").q({13:a(c).2g(A)});a(c).1N(".4-1O-1L-2a").q({13:a(c).2g(A)});a(c).1N(".4-1O-1L-2G").q({P:a(1t).P(),F:-a(1t).P()/2});3(e.g.20.19("%")!=-1){6 b=B(e.g.20);6 d=a("2C").P()/2h*b-(a(c).2T()-a(c).P());a(c).P(d)}}a(c).p(".4-1w, .4-S").q({P:e.g.D(),13:e.g.E()});a(c).p(".4-31").q({18:-(e.g.D()/2)+"1H",1b:-(e.g.E()/2)+"1H"})};e.1c=5(){e.o.2N();e.g.1u=A;e.g.C.14("4-33");6 b=2i=1W=2f=1V=2b=1R=2c=1I=4t=1J=4p="4o";6 d=2e=e.g.D();6 f=2k=e.g.E();6 g=e.g.U=="K"?e.g.v:e.g.C;6 h=g.7("1h")?g.7("1h"):e.o.3p;6 i=e.g.3d[e.g.U][h];3(i=="F"||i=="N"){d=1W=2e=1R=0;1J=0}3(i=="H"||i=="r"){f=b=2k=1V=0;1I=0}1o(i){u"F":2i=1V=0;1I=-e.g.D();t;u"N":b=2b=0;1I=e.g.D();t;u"H":2f=1R=0;1J=-e.g.E();t;u"r":1W=2c=0;1J=e.g.4l;t}e.g.v.q({F:b,N:2i,H:1W,r:2f});e.g.C.q({P:2e,13:2k,F:1V,N:2b,H:1R,r:2c});6 j=e.g.v.7("1A")?B(e.g.v.7("1A")):e.o.2r;6 k=e.g.v.7("1X")?B(e.g.v.7("1X")):e.o.2w;6 l=e.g.v.7("1Q")?e.g.v.7("1Q"):e.o.2l;e.g.v.15(j+k/4n).1c({P:d,13:f},k,l,5(){e.g.v=e.g.C;e.g.R=e.g.1S;a(c).p(".4-S").2d("4-Z");a(c).p(".4-S:16("+(e.g.R-1)+")").14("4-Z").2d("4-33");a(c).p(".4-r-1m a").2d("4-y-Z");a(c).p(".4-r-1m a:16("+(e.g.R-1)+")").14("4-y-Z");e.g.1u=O;e.o.2Q();3(e.g.W){e.2j()}});e.g.v.p(\' > *[I^="4-s"]\').12(5(){6 b=a(9).7("1h")?a(9).7("1h"):i;6 c,d;1o(b){u"F":c=-e.g.D();d=0;t;u"N":c=e.g.D();d=0;t;u"H":d=-e.g.E();c=0;t;u"r":d=e.g.E();c=0;t}6 f=a(9).7("3o")?a(9).7("3o"):O;1o(f){u"F":c=e.g.D();d=0;t;u"N":c=-e.g.D();d=0;t;u"H":d=e.g.E();c=0;t;u"r":d=-e.g.E();c=0;t}6 g=e.g.v.7("38")?B(e.g.v.7("38")):e.o.35;6 h=B(a(9).L("I").19("4-s")[1])*g;6 j=a(9).7("1A")?B(a(9).7("1A")):e.o.2r;6 k=a(9).7("1X")?B(a(9).7("1X")):e.o.2w;6 l=a(9).7("1Q")?a(9).7("1Q"):e.o.2l;3(f=="1B"||!f&&b=="1B"){a(9).15(j).4c(k,l)}w{a(9).X().15(j).1c({18:-c*h,1b:-d*h},k,l)}});6 m=e.g.C.7("1Y")?B(e.g.C.7("1Y")):e.o.2u;6 n=e.g.C.7("1G")?B(e.g.C.7("1G")):e.o.2s;6 o=e.g.C.7("1K")?e.g.C.7("1K"):e.o.2x;e.g.C.15(j+m).1c({P:e.g.D(),13:e.g.E()},n,o);e.g.C.p(\' > *[I^="4-s"]\').12(5(){6 b=a(9).7("1h")?a(9).7("1h"):i;6 c,d;1o(b){u"F":c=-e.g.D();d=0;t;u"N":c=e.g.D();d=0;t;u"H":d=-e.g.E();c=0;t;u"r":d=e.g.E();c=0;t;u"1B":d=0;c=0;t}6 f=e.g.C.7("3n")?B(e.g.C.7("3n")):e.o.3h;6 g=B(a(9).L("I").19("4-s")[1])*f;6 h=a(9).7("1Y")?B(a(9).7("1Y")):e.o.2u;6 k=a(9).7("1G")?B(a(9).7("1G")):e.o.2s;6 l=a(9).7("1K")?a(9).7("1K"):e.o.2x;3(b=="1B"){a(9).q({1F:"1a",18:0,1b:0}).15(j+h).3a(k,l)}w{a(9).q({1F:"3b",18:c*g,1b:d*g}).X().15(j+h).1c({18:0,1b:0},k,l)}})};e.36()};b.3g={2y:A,M:1,3q:O,3r:A,1r:A,3s:A,2q:A,2o:A,1P:"4k",3j:"/4s/4r/",2D:A,2E:"4q",2t:O,2n:O,2m:O,2B:"2v: 4j; z-2W: 48; F: 2Z; H: 2Z;",2p:O,2Y:"4h",2L:5(){},2K:5(){},2J:5(){},2M:5(){},2N:5(){},2Q:5(){},1T:5(){},1Z:5(){},3p:"N",3t:4a,3h:.45,35:.45,2s:30,2w:30,2x:"2P",2l:"2P",2u:0,2r:0};b.3k={44:"1.8",W:O,1u:O,10:1y,U:"J",1x:1y,D:1y,E:1y,3d:{K:{F:"N",N:"F",H:"r",r:"H"},J:{F:"F",N:"N",H:"H",r:"r"}}}})(4m)',62,301,'|||if|ls|function|var|data||this||||||||||||||||find|css|bottom||break|case|curLayer|else||nav||true|parseInt|nextLayer|sliderWidth|sliderHeight|left|replace|top|class|next|prev|attr|firstLayer|right|false|width|appendTo|curLayerIndex|layer|length|prevNext|return|autoSlideshow|stop|layerSlider|active|layersNum|start|each|height|addClass|delay|eq|href|marginLeft|split|none|marginTop|animate|makeResponsive|param|image|style|slidedirection|touches|preventDefault|background|wrapper|slidebuttons|toLowerCase|switch|indexOf|touchEndX|imgPreload|click|window|isAnimating|url|inner|slideTimer|null|rel|delayout|fade|touchStartX|trim|bind|display|durationin|px|layerMarginLeft|layerMarginTop|easingin|forceresponsive|for|closest|wp|skin|easingout|nextLayerTop|nextLayerIndex|cbPrev|change|nextLayerLeft|curLayerTop|durationout|delayin|cbNext|sliderOriginalWidth|match|push|img|clearTimeout|paused|LayerSlider|div|span|src|container|nextLayerRight|nextLayerBottom|removeClass|nextLayerWidth|curLayerBottom|outerHeight|100|curLayerRight|timer|nextLayerHeight|easingOut|yourLogo|animateFirstLayer|navButtons|yourLogoLink|navStartStop|delayOut|durationIn|globalBGImage|delayIn|position|durationOut|easingIn|autoStart|resizeSlider|which|yourLogoStyle|body|pauseOnHover|globalBGColor|document|helper|visibility|children|cbStop|cbStart|cbInit|cbPause|cbAnimStart|abs|easeInOutQuint|cbAnimStop|clientX|gi|outerWidth|originalLeft|originalTop|index|originalEvent|yourLogoTarget|10px|1500|bg|sides|animating|typeof|parallaxOut|init||parallaxout||fadeIn|block|el|slideDirections|extend|slidedelay|options|parallaxIn|ieEasing|skinsPath|global|createStyleSheet|prependTo|parallaxin|slideoutdirection|slideDirection|twoWaySlideshow|keybNav|navPrevNext|slideDelay|Math|setTimeout|1e3|type|stylesheet|link|text|hover|150|resize|head|queue|keydown|target|easing|textDecoration|outline|append|clone|number|fn|object|undefined|new|wrapAll|static|ontouchstart|swing|in|touchstart|touchmove|sideright|sideleft|relative|backgroundColor|backgroundImage|version||touchend|Sine|1001|hidden|4e3|visible|fadeOut|load|back|Back|bounce|_blank|dequeue|absolute|lightskin|sliderHeight89|jQuery|80|auto|layerMarginBottom|transparent|skins|layerslider|layerMarginRight|Elastic|Bounce|Quart|linear|cubic|easein|elastic|quart|easeInOut|easeinout|Quad|easeOut|Cubic|easeIn|Expo|circ|Circ|expo|easeout|quint|Quint|sine|quad'.split('|'),0,{}))

// eventTrack
function eventTrack(key,data,note){var _page_key='welcome',_page_url=parseUrl(document.URL);if(document.createEvent&&document.dispatchEvent){var evt=document.createEvent('Event');evt.initEvent(key,true,true);document.dispatchEvent(evt)}if(window.optimizely=window.optimizely||[]){window.optimizely.push(['trackEvent',key])}if(mixpanel&&typeof mixpanel.track==='function'){var properties=data||{};if(!properties.mp_note){if(note){properties.mp_note=note}else{properties.mp_note=_page_key}}properties.pagekey=_page_key;properties.pageurl=_page_url;if(_page_key&&!properties.page){properties.page=_page_key}mixpanel.track(key,properties)}if(typeof(_gaq)==='object'){_gaq.push(['_trackEvent',key,note])}}

// Mixpanel
(function(d,c){var a,b,g,e;a=d.createElement("script");a.type="text/javascript";
a.async=!0;a.src=("https:"===d.location.protocol?"https:":"http:")+
'//api.mixpanel.com/site_media/js/api/mixpanel.2.js';b=d.getElementsByTagName("script")[0];
b.parentNode.insertBefore(a,b);c._i=[];c.init=function(a,d,f){var b=c;
"undefined"!==typeof f?b=c[f]=[]:f="mixpanel";g=['disable','track','track_pageview',
'track_links','track_forms','register','register_once','unregister','identify',
'name_tag','set_config'];
for(e=0;e<g.length;e++)(function(a){b[a]=function(){b.push([a].concat(
Array.prototype.slice.call(arguments,0)))}})(g[e]);c._i.push([a,d,f])};window.mixpanel=c}
)(document,[]);
mixpanel.init((isProduction) ? 'e9b7f4ffd0fe916a8ea8c4f051116be0' : '4ca3d9ff8594851be052ab913aca627f');

// Google Analytics
var _gaq = _gaq || [];
_gaq.push(['_setAccount', (isProduction) ? 'UA-24847606-3' : 'UA-24847606-4']);
_gaq.push(['_setDomainName', 'smartasset.com']);
_gaq.push(['_trackPageview']);
(function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
})();

// mouseflow
if (isProduction) {
    (function() {
        var mf = document.createElement("script"); mf.type = "text/javascript"; mf.async = true;
        mf.src = "//cdn.mouseflow.com/projects/9acede93-86ba-4abf-bd77-d13ab55f7c93.js";
        document.getElementsByTagName("head")[0].appendChild(mf);
    })();
}

// prefect audience
if (isProduction) {
    (function() {
        window._pa = window._pa || {};
        // _pa.orderId = "myCustomer@email.com"; // OPTIONAL: attach user email or order ID to conversions
        // _pa.revenue = "19.99"; // OPTIONAL: attach dynamic purchase values to conversions
        var pa = document.createElement('script'); pa.type = 'text/javascript'; pa.async = true;
        pa.src = ('https:' == document.location.protocol ? 'https:' : 'http:') + "//tag.perfectaudience.com/serve/51781c09a601920002000415.js";
        var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(pa, s);
    })();
}

// setup the video and slider widgets on page load
$(document).ready(function(){
    $('#slider').layerSlider({
        skin : 'skinsa',
        skinsPath : pageOther + '/slider/layerslider/skins/',
        navStartStop: false,
        navPrevNext: false,
        cbAnimStart: function() {
            $("#slider .thanks").slideUp(function() {
                $("#slider .thanks").css("display", "none");
            });
        }
    });

    // get the iframe for the video
    var iframe = $('iframe.xv')[0],
    player = $f(iframe);

    // When the player is ready, add listeners for pause, finish, and playProgress
    player.addEvent('ready', function() {

        // when the video was finished
        player.addEvent('finish', function(id) {
            isCompleted = true;
            eventTrack("SmartAsset Intro Video", { status:"completed" }, "Intro Video Completed");
        });

        // video was played event
        player.addEvent('playProgress', function(data, id) {
            if(!isPlayed)
            {
                isPlayed = true;
                //console.log("Video has been played!");
                eventTrack("SmartAsset Intro Video", { status:"played" }, "Intro Video Played");
            }
        })
    });
})