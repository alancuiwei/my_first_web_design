var w=w||{};
w.homepage={initialize:function(a,b,c){this.allocation(b,a);this.allocationPieData.bindTo(this.allocation,c)},getArticle:function(a){a=(""+a).replace(/\D/,"").substring(0,2);return"11"==a||"18"==a||"8"==a.substring(0,1)?"an ":"a "},insertVimeoVideo:function(a){var a=$(a),b=a.find("#video-player");return b.length?b:$("<iframe>").attr({id:"video-player",src:"//player.vimeo.com/video/32847702?player_id=video-player&api=1&title=0&byline=0&portrait=0&color=5e9b00&autoplay=1",width:"100%",height:"100%",frameborder:"0",
webkitAllowFullScreen:"",mozallowfullscreen:"",allowFullScreen:""}).prependTo(a)},allocation:$R(w.plan.getAllocation),allocationPieData:$R(w.plan.allocationAsPie)};