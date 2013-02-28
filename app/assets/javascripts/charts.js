(function(){function d(b,a){a=a||{};b=$(b)[0];this.sort=!!a.sort;this.data=$R.value();this.width=$R.value(a.width||$(b).width());this.height=$R.value(a.height||$(b).height());var i=$R.value(a.margin||0),e=$R(function(a,b,c){return Math.min(a-c,b-c)/2}),f=$R.value(a.innerRadius||0),c=$R(d.arc,this),g=$R(d.layout,this),j=$R(d.paths,this),l=d3.select(b).append("g").attr("transform","translate("+this.width()/2+","+this.height()/2+")");e.bindTo(this.width,this.height,i);c.bindTo(e,f,i);j.bindTo(l,g,c,
this.data)}function k(b,a){b=$(b)[0];this.canvasX=$R.value(0);this.canvasY=$R.value(0);this.canvasWidth=$R.value($(b).width());this.canvasHeight=$R.value($(b).height());this.top=$R.value(a.top||0);this.right=$R.value(a.right||this.svgWidth());this.bottom=$R.value(a.bottom||this.svgHeight());this.left=$R.value(a.left||0);this.width=$R(function(a,b){return b-a}).bindTo(this.left,this.right);this.height=$R(function(a,b){return b-a}).bindTo(this.top,this.bottom);this.viz=d3.select(b);this.appendGroup=
function(){return this.viz.append("g")};this.prependGroup=function(){return this.viz.insert("g",":first-child")}}function h(b,a){return b?$R.value(b):$R(function(a){return a}).bindTo(a)}w=w||{};w.charts={};w.charts.mixins={};d.keyFnc=function(b){return b&&b.data.id||$(this).data("pie-slice-id")};d.sortFnc=function(b,a){return d3.ascending(b.orderIndex,a.orderIndex)};d._difference=function(b,a){var i=_.difference(_.pluck(a,"id"),_.pluck(b,"id"));return _.filter(a,function(a){return _.contains(i,a.id)})};
d._zeroedDifference=function(b,a){var i=d._difference(b,a).map(function(a){return _.chain(a).clone().tap(function(a){a.value=0}).value()});return b.concat(i)};d._nonZeroedDifference=function(b,a){return b.concat(d._difference(b,a))};d.arc=function(b,a,i){return d3.svg.arc().outerRadius(b-i).innerRadius(a)};d.layout=function(){return d3.layout.pie().value(function(b){return b.value}).sort(this.sort?d.sortFnc:null)};d.paths=_.throttle(function(b,a,i,e){function f(a){var b=d3.interpolate(this._current,
a);this._current=b(0);return function(a){return i(b(a))}}var c=this._oldData||e,g=d._zeroedDifference(c,e),j=d._nonZeroedDifference(c,e),c=d._zeroedDifference(e,c);b.selectAll(".segment").data(a(g),d.keyFnc).enter().append("path").attr("data-pie-slice-id",function(a){return a.data.id}).attr("class",function(a){return["segment",a.data.id].join(" ")}).attr("d",i).each(function(a){this._current=a});b.selectAll(".segment").data(a(j),d.keyFnc).transition().duration(500).attrTween("d",f);b.selectAll(".segment").data(a(c),
d.keyFnc).transition().duration(500).attrTween("d",f).each("end",function(a){0===a.value&&d3.select(this).remove()});b.selectAll(".segment").data(a(e),d.keyFnc).transition().duration(500).attrTween("d",f);this._oldData=e},500);w.charts.Pie=d;w.charts.Stack=function(b,a){a=a||{};b=$(b)[0];this.data=$R.value();var i=$R.value(a.width||$(b).width()),e=$R.value(a.height||$(b).height()),f=$R.value(a.margin||{top:0,right:0,bottom:0,left:0}),c=$R.value(d3.layout.stack().offset("expand")),g=d3.select(b),j=
g.append("g"),d=g.append("g"),c=$R(function(a,b){return b(_.map(a,function(a){var b=_.map(a.values,function(a,b){return{x:b,y:a}});b.id=a.id;b.html_class=a.html_class;return b}))},this).bindTo(this.data,c),g=$R(function(a,b,c){a=_.chain(a).pluck("length").max().value();return d3.scale.linear().nice().domain([0,a-1]).range([c.left,b-c.right])}).bindTo(c,i,f),h=$R(function(a,b,c){return d3.scale.linear().nice().domain([0,d3.max(a,function(a){return d3.max(a,function(a){return a.y0+a.y})})]).range([b-
c.bottom,c.top])}).bindTo(c,e,f),k=$R(function(a,b){return d3.svg.area().x(function(b){return a(b.x)}).y0(function(a){return b(a.y0)}).y1(function(a){return b(a.y0+a.y)})}).bindTo(g,h);$R(function(a,b){var c=j.selectAll("path").data(a);c.enter().append("path");c.attr("d",b).attr("class",function(a){return a.html_class||a.id})}).bindTo(c,k);$R(function(a,b){var c=b.range();d.selectAll(".xrule").data(a.ticks(20)).enter().append("line").attr("class","xrule").attr("x1",a).attr("x2",a).attr("y1",c[0]).attr("y2",
c[1])}).bindTo(g,h);$R(function(a,b){var c=b.range()[0];d.selectAll(".xlabel").data(a.ticks(10)).enter().append("text").attr("class","xlabel").attr("x",_.compose(a,function(a){return a+1})).attr("y",c).attr("dy",15).text(function(a){return""+(a/2+1)})}).bindTo(g,h);$R(function(a,b,c,f,g){a=f-g.bottom+0.9*g.bottom;c=0.5*(c-g.left-g.right)+g.left;d.selectAll(".xtitle").data([1]).enter().append("text").attr("class","xtitle").attr("transform","translate("+c+","+a+")").text("RISK")}).bindTo(g,h,i,e,f)};
w.charts.Line=function(b,a){a=a||{};k.apply(this,[b,a]);this.data=$R.value();var d=this.appendGroup(),e=$R(function(a){return _.map(a,function(a){var b=_.map(a.values,function(a){return{x:a.x,y:a.y}});b.id=a.id;b.html_class=a.html_class;return b})},this).bindTo(this.data);this.yDomainFunction=$R.value(function(a){return d3.extent(_.flatten(_.map(a,function(a){return _.pluck(a,"y")})))});this.xDomainFunction=$R.value(function(a){return d3.extent(_.flatten(_.map(a,function(a){return _.pluck(a,"x")})))});
this.x=$R(function(a,b,f,e){return d3.scale.linear().nice().domain(f(a)).range([e,e+b])}).bindTo(e,this.width,this.xDomainFunction,this.left);this.y=$R(function(a,b,f,e){return d3.scale.linear().nice().domain(f(a)).range([b+e,e])}).bindTo(e,this.height,this.yDomainFunction,this.top);var f=$R(function(a,b){return d3.svg.line().x(function(b){return a(b.x)}).y(function(a){return b(a.y)})}).bindTo(this.x,this.y);$R(function(a,b){var f=d.selectAll("path").data(a);f.enter().append("path");f.attr("d",function(a){return b(a)}).attr("class",
function(a){return a.html_class||a.id});f.exit().remove()}).bindTo(e,f);this.mixin=_.reduce(w.charts.mixins,function(a,b,f){a[f]=_.bind(b,this);return a},{},this)};w.charts.mixins.YAxis=function(b){var b=b||{},a=this.yAxis={};a.top=h(b.y||b.top,this.top);a.bottom=h(b.y||b.bottom,this.bottom);a.left=h(b.x||b.left,this.left);a.right=h(b.x||b.right,this.right);a.yTicksFunction=$R.value(function(a){return a.ticks(4)});a.yTicks=$R(function(a,b){return b(a)}).bindTo(this.y,a.yTicksFunction);a.yTicksFormat=
$R.value(String);var d=this.appendGroup(),e=this.appendGroup();$R(function(a,b,g,d){a=d3.svg.axis().scale(a).tickValues(b).orient("left").tickFormat(d);e.attr("class","y axis ylabel").attr("transform","translate("+g+",0)").call(a)}).bindTo(this.y,a.yTicks,a.left,a.yTicksFormat);$R(function(a,b,e,h){e=d.selectAll(".xrule").data(e);e.enter().append("line");e.attr("class","xrule").attr("x1",h).attr("x2",b).attr("y1",a).attr("y2",a);e.exit().remove()}).bindTo(this.y,a.right,a.yTicks,a.left);return a};
w.charts.mixins.XAxis=function(b){var b=b||{},a=this.xAxis={};a.top=h(b.y||b.top,this.top);a.bottom=h(b.y||b.bottom,this.bottom);a.left=h(b.x||b.left,this.left);a.right=h(b.x||b.right,this.right);a.xTicksFunction=$R.value(function(a){return a.ticks(4)});a.xTicks=$R(function(a,b){return b(a)}).bindTo(this.x,a.xTicksFunction);a.xTicksFormat=$R.value(String);var d=this.appendGroup(),e=this.appendGroup();$R(function(a,b,d,i,h){a=d3.svg.axis().scale(a).tickValues(b).orient("bottom").tickFormat(h);e.attr("class",
"x axis xlabel").attr("transform","translate(0,"+i+")").call(a)}).bindTo(this.x,a.xTicks,a.top,a.bottom,a.xTicksFormat);$R(function(a,b,e,h){b=d.selectAll(".yrule").data(b);b.enter().append("line");b.attr("class","yrule").attr("x1",a).attr("x2",a).attr("y1",e).attr("y2",h);b.exit().remove()}).bindTo(this.x,a.xTicks,a.top,a.bottom);return a};w.charts.mixins.XTitle=function(b){var b=b||{},a=this.xTitle={};a.titleText=$R.value();a.top=$R(_.identity).bindTo(b.y||b.top||this.bottom);a.bottom=$R(_.identity).bindTo(b.y||
b.bottom||this.canvasHeight);a.left=$R(_.identity).bindTo(b.x||b.left||this.left);a.right=$R(_.identity).bindTo(b.x||b.right||this.right);a.x=$R(function(a,b){return(b-a)/2+a}).bindTo(a.left,a.right);a.y=$R(function(a,b){return(b-a)/2+a}).bindTo(a.top,a.bottom);var d=this.appendGroup();$R(function(a,b,c){c=d.selectAll(".xtitle").data(_.flatten([c]));c.enter().append("text");c.attr("class","xtitle").attr("transform","translate("+a+","+b+")").attr("dy","0.5em").text(function(a){return a});c.exit().remove()},
this).bindTo(a.x,a.y,a.titleText);b.title&&a.titleText(b.title);return a};w.charts.mixins.YTitle=function(b){var b=b||{},a=this.yTitle={};a.titleText=$R.value();a.top=$R(_.identity).bindTo(b.y||b.top||this.top);a.bottom=$R(_.identity).bindTo(b.y||b.bottom||this.bottom);a.left=$R(_.identity).bindTo(b.x||b.left||this.canvasX);a.right=$R(_.identity).bindTo(b.x||b.right||this.left);a.x=$R(function(a,b){return(b-a)/2+a}).bindTo(a.left,a.right);a.y=$R(function(a,b){return(b-a)/2+a}).bindTo(a.top,a.bottom);
var d=this.appendGroup();$R(function(a,b,c){c=d.selectAll(".ytitle").data(_.flatten([c]));c.enter().append("text");c.attr("class","ytitle").attr("transform","rotate(-90) translate("+-b+","+a+")").attr("dy","0.5em").text(function(a){return a});c.exit().remove()},this).bindTo(a.x,a.y,a.titleText);b.title&&a.titleText(b.title);return a}})();