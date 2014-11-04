/***********************************************
* Author: 	Don Citarella
*         	era404 Creative Group, Inc.
*			www.era404.com
************************************************
* Client: 	Leslie Schnur
*			The Beth Kopliner Company
***********************************************/

(function($) {
	// variables
	var w = $(window).width();
	var avpos = [200, 320, 410, 520, 634];
	var sw = 192;
	var oldie = false;
	if ($.browser.msie && $.browser.version < 9){
		oldie = true;
	}
	var hoverChild = null;
	var activeArticle = null;
	var activeSection = null;
	var sarr;
	var loaded = false;
	
	// Window Resize Listener
	$(window).resize(function() {
		w = $(window).width();
		delay(function(){
			if (activeSection){
				activateSection(activeSection, true);
			}else{
				if (activeArticle){
					resetPosition();
				}
			}
		}, 250);
	});
	
	/* Helper Functions */
	
	// Needle/Haystack to determine the index of active section
	// Triggered by activateSection
	function activeIndex(s){
		var needle = 10000;
		jQuery.each(sarr, function(ind){
			if ($(sarr[ind])[0] == $(s)[0]){
				needle = ind;
			};
		});
		return needle;
	};
	
	// Methods for drawing canvas shapes
	function getTrigY(el){
		return $(el).position().top + 12;
	}
	function getY(el){
		return $(el).position().top;
	}
	function getH(el){
		return $(el).position().top + $(el).outerHeight();
		
	} 
	
	// Method to fix issue with FF not supporting "background-position-y"
	function currX(bg){
		var myx = 0;
		if(oldie) {
		   myx = $(bg).css('background-position-x');
		} else {
		   myx = $(bg).css('background-position').split(" ")[0];
		}
		return myx
	}
	
	// Delay function to prevent constant updates on screen resize
	var delay = (function(){
	  var timer = 0;
	  return function(callback, ms){
		clearTimeout (timer);
		timer = setTimeout(callback, ms);
	  };
	})();
	
	// Handle Home Page hovers
	// Triggered by home child hover
	function navOver(c){
		if (!activeArticle){
			if (hoverChild != null){
				currX($(hoverChild));
				$(hoverChild).css({"background-position": currX(hoverChild)+" 0", "z-index": "500"});
				hoverChild = null;
			}
			$("#avatars div").each(function(i){
				$(this).css({"background-position": currX($(this))+" -1200px"});
			});
			
			$(c).css({"background-position": currX($(c))+" -600px", "z-index": "1000"});
			hoverChild = c;
		}
	}
	function navOut(){
		if (!activeArticle){
			$("#avatars div").each(function(i){
				$(this).css({"background-position": currX($(this))+" 0", "z-index": "500"});
			});
		}
	}
	
	// Activate avatar for selected section, hide others
	// Triggered by clicking avatar or navigation item
	function activateAvatar(av){
		if(loaded){
			$("#avatars").css({"z-index" : 0});
			$("#wrapper").css({"z-index" : 10000});
			var newX = "-1200px";
			$("#avatars div").each(function(){
				if($(this).attr("name") == $(av).attr("name")){
					$(this).css({"background-position": currX($(this))+" -1200px", display: "block"});
					$(this).animate({"left": "0", "opacity": 1}, 350, "easeOutQuart");
					newX = "1200px";
				}else{
					$(this).animate({"left": newX, "opacity": 0}, 350, "easeOutQuart", function(){$(this).css({display: "none"})});
				}
			});
		}
	}
	
	// Loads articles
	// Triggered by navigation click
	function activateArticle(a){
		if(loaded){
			// First, reset the previous article (if one is selected)
			var finX = 1600;
			if (activeArticle != null){
				$(activeArticle).children('section').each(function(i){
					$(this).children('aside').css({"display": "none"});
				});
				resetPosition();
				if($(a).index() > $(activeArticle).index()){
					finX = -finX;
				}
				$(activeArticle).animate({left: finX+"px", opacity: 0}, 250, 'easeOutQuad', function(){$(this).css({display: "none"})});
				activeArticle = null;
				finX = -finX
			};
			activeArticle = a;
			sarr = new Array();
			$(activeArticle).children('section').each(function(i){
				sarr.push(this);
			});
			resetPosition();
			$(activeArticle).css({"display": "block", "top": "0", "opacity": 0, "left": finX+"px"});
			$(activeArticle).animate({left: 0, opacity: 1}, 250, 'easeOutQuad');
			// Update: Keep Presidential Seal on ALL Pages
			// $("#branding a").css({"backgroundPosition": "0 -125px"});
		}
			
	}
	
	// Toggles Navigation active status
	// Triggered by navigation click
	function activateNavigation(n){
		if(loaded){
			$("nav ul li").each(function(){
				$(this).removeClass("active");
			});
			$(n).parent().parent().addClass("active");
		}
	}
		
	// Show Milestones
	// Triggered by clicking section "Activities" button
	function activateSection(s, resized){
		if(loaded){
			// Open or close? (if coming from a resize, resized = true and prevents closure)
			if ($(activeSection).attr("id") == $(s).attr("id") && !resized){
				$(activeSection).children("aside").animate({opacity: 0, width: "1px"}, 250, "easeOutQuad");
				deactivateSection(activeSection);
				resetPosition();
			}else{
				if ($(activeSection) && !resized){
					deactivateSection(activeSection);
				};
				activeSection = s;
				var ai = activeIndex(s);
				jQuery.each(sarr, function(i){
					var ap = (w-1024)/2 + 200;
					var ba = i < ai ? ((ai-i)* -192) - 160 : 0;
					var aap = i > ai ? (i-ai)* 192 + 482 : 0;
					var l = ap+ba+aap;
					$(sarr[i]).animate({left: l}, 230, 'easeOutQuad');
				});
				if (!resized){
					$(activeSection).children("aside").css({display: "block", width: "1px", opacity: 0});
					$(activeSection).children("aside").animate({opacity: .99, width: "490px"}, 250, "easeOutQuad");
				}
			};
		}
	};
	
	// Hides article and returns us to home page
	// Triggered by clicking home link
	function deactivateArticle(a){
		if(loaded){
			$(a).animate({
				left: "1600px",
				opacity: 0
				}, 500, 'easeOutQuad', function(){
					activeArticle = null;
					$(this).css({display: "none"});
				}
			);
			// Reset navigation to home version
			$("nav ul li").each(function(){$(this).removeClass("active")});
			// Reset avatars location and hover states
			$("#avatars div").each(function(i){
				$(this).css({"background-position": currX($(this))+" 0", display: "block"});
				$(this).animate({left: avpos[i]+"px", "opacity": 1}, 350, 'easeOutQuart');
			});
			$("nav").addClass("home");
			$("#wrapper").css({"z-index" : 0});
			$("#avatars").css({"z-index" : 10000});
			// Update: Keep Presidential Seal on ALL Pages
			// $("#branding a").css({"backgroundPosition": "0 0"});
		}
	};
	
	// Hides milestones for open session, sets active section to null
	function deactivateSection(s){
		if(loaded){
			$(s).children("aside").animate({width: "1px"}, 250, "easeOutQuad", function(){$(s).children("aside").css({"display": "none"})});
			activeSection = null;
		}
	};
	
	// Resets Position of visible sections
	// Triggered by clicking "close" or "activities" on active milestones/section
	function resetPosition(){
		jQuery.each(sarr, function(i){
			$(sarr[i]).animate({
				left: ((w-1024)/2 + (sw*i) + 200)
				}, 250, 'easeOutQuad'
			);
		});
	}	
	
	// Show lightbox
	// Triggered by footer link click or link within a (different) lightbox
	function showLightbox(lb, lnk){
		if(loaded){
			$("#smokescreen").css({display: "block"});
			$("footer a").each(function(){
				//console.log($(this).attr("name")+" = "+$(lnk).attr("name")+" ? "+($(this).attr("name") != $(lnk).attr("name")));
				if($(this).attr("name") != $(lnk).attr("name")){
					$(this).removeClass("hovered");
				}else{
					$(this).addClass("hovered");
				}
			});
			$(".lightbox").each(function(){
				if($(this).attr("id") != lb){
					$(this).animate({"opacity": 0},200, "linear", function(){$(this).css({"display": "none"})});
				}else{
					$(this).css({display: "block"});
					$(this).css({opacity: 0});
					$(this).css({top: "130px"});
					$(this).animate({"opacity":1},400);
				}
			});
		}
	}
	function hideLightbox(){
		$("#smokescreen").css({display: "none"});
		$(".lightbox").each(function(){
			$(this).animate({"opacity": 0},200,"linear", function(){$(this).css({display: "none"})});
		});
		$("footer a").each(function(){
			$(this).removeClass("hovered");
		});
	}
	
	/* DOCUMENT READY (INIT/CONSTRUCTOR) --------------------------------------------------------- */
	
	$(document).ready( function() {
	
		// Restyle Footer buttons for Blackberry Users
		
		var ua = navigator.userAgent;
		var checker = {
			blackberry: ua.match(/BlackBerry/),
			ios: ua.match(/iPad/) || ua.match(/iPhone/) || ua.match(/iPod/)
		};
		if (checker.blackberry){
			$("footer div").css("width", "915px");
			$("footer div ul li").css("vertical-align", "top");
			$("footer div ul li a").css({"vertical-align" : "top", "letter-spacing" : "0", "font-size" : "11px", "padding" : "7px 2px 6px", "font-family" :"'Din-Regular', Arial, Helvetica, Verdana, sans-serif", "font-weight" : "normal"});
		}
		if (checker.ios){
			$("footer div").css("width", "1010px");
			$("footer div ul li a").css({"padding" : "7px 11px 6px"});
		};
		
		
		// Hides scrollbars when screen is greater than 1024px
		
		var wt = $(window).width();
		var ht = $(window).height();
		
		if (wt < 1025) {
			$("#container").css({"width": "1024px", "overflow-x": "hidden"});
			$("body").css({"overflow-x": "scroll"});
		} else {
			$("#container").css({"width": "100%", "overflow-x": "hidden"});
			$("body").css({"overflow-x": "hidden"});
		}
		if (ht < 800) {
			$("#container").css({"height": "820px", "overflow-y": "hidden"});
			$("body").css({"overflow-y": "scroll"});
		} else {
			$("#container").css({"height": "100%", "overflow-y": "hidden"});
			$("body").css({"overflow-y": "hidden"});
		}

		$(window).bind('resize', function() {
			var wt = $(window).width();
			var ht = $(window).height();
			if (wt < 1025) {
				$("#container").css({"width": "1024px", "overflow-x": "hidden"});
				$("body").css({"overflow-x": "scroll"});
			} else {
				$("#container").css({"width": "100%", "overflow-x": "hidden"});
				$("body").css({"overflow-x": "hidden"});
			}
			if (ht < 800) {
				$("#container").css({"height": "800px", "overflow-y": "hidden"});
				$("body").css({"overflow-y": "scroll"});
			} else {
				$("#container").css({"height": "100%", "overflow-y": "hidden"});
				$("body").css({"overflow-y": "hidden"});
			}
		});
		
		/* Listener Functions ------------------------------------------------------------------ */
		
		$("nav ul li h2 a").hover(
			function(){
				if(loaded){
					if (!activeArticle){
						// If on the home, light the child that matches the hovered navigation item
						var i = $('nav ul li').index($(this).parent().parent());
						navOver($("#avatars div").eq(i));
					}
				}
			}, 
			function(){
				// ...and unlight when moused out
				navOut();
			}
		);
		$("nav ul li h2 a").click(function(){
			if(loaded){
				$("nav").removeClass("home");
				var art = $(this).attr("name");
				activateArticle(art);
				activateNavigation($(this));
				var i = $('nav ul li').index($(this).parent().parent());
				activateAvatar($("#avatars div").eq(i));
			}
		});
		$(".trigger").hover(function(){
			//alert(getTrigY($(this)));
		});
		/* Deprecated: Used to toggle visibility of "Activies" using button
		   Now, we use the function below.
		$(".trigger").click(function(){
			if(loaded){
				activateSection($(this).parent());
			}
		});
		*/
		$("section").hover(
		function(evt){
			if(loaded && evt.target.nodeName != "A"){
				$(this).children("a").addClass("active");
			}
		},
		function(evt){		
			if(loaded){
				$(this).children("a").removeClass("active");
			}
		});
		// Prevent Aside from clicking/hovering
		$("aside").mouseenter(function(evt){
			return false;
		});
		$("aside").click(function(evt){
			if(evt.target.nodeName != "A"){
				return false;
			}
		});
		$("section").click(function(evt){
			if(loaded){
				activateSection($(this));
			}
		});
		$(".close").click(function(){
			deactivateSection(activeSection);
			resetPosition();
		});
		$("#avatars div").hover(
			function(){
				if(loaded){
					// If on home, light the navigation element that matches the hovered child
					var i = $('#avatars div').index($(this));
					$("nav ul li h2 a").each(function(){
						$(this).removeClass("hovered");
					});
					$("nav ul li").eq(i).children("h2").addClass("hovered");
					navOver($(this));
				}
			}, 
			function(){
				if(loaded){
					// ...and unlight when moused out
					$("nav ul li").each(function(){
						$(this).children("h2").removeClass("hovered");
					});
					navOut();
				}
			}
		);
		$("#avatars div").click(function(){
			if(loaded){
				if (!activeArticle){
					$("nav").removeClass("home");
					var art = $(this).attr("name");
					activateArticle(art);
					var i = $('#avatars div').index($(this));
					activateNavigation($("nav ul li").eq(i).children("h2").children("a"));
					activateAvatar($(this));
				}
			}
		});
		$("#branding a").click(function(){
			if(activeArticle){
				deactivateSection(activeSection);
				resetPosition();
				deactivateArticle(activeArticle);
			}
		});
		// Footer Links (hash options below)
		$("footer a").click(function(){
			if(loaded){
				showLightbox($(this).attr("name"), $(this));
			}
		});
		$(".lightbox p a").click(function(){
			var clicked = $(this);
			var fl = null;
			$("footer a").each(function(){
				if($(this).attr("name") == $(clicked).attr("name")){
					fl = $(this);
				}
			});
			showLightbox($(this).attr("name"), fl);
		});
		$(".closeLB, #smokescreen").click(function(){
			hideLightbox();
		});
		// Click listener is for Tablet Devices only
		$(".posterLinks").bind("hover click", function(){
			var active = this;
			var thumb = $(this).attr("data-thumb");
			$(".posterLinks").each(function(){
				if(this == active){
					$(this).addClass("active");
				}else{
					$(this).removeClass("active");
				}
			});
			$(".thumb").each(function(){
				if ($(this).attr('id') == thumb){
					$(this).addClass("active");
				}else{
					$(this).removeClass("active");
				}
			});
		});
		
	});
	$(window).load( function(){
		// Draw custom shapes on milestones
		var count = 0;
		//var colors = ["#E99D2B", "#68AAB6", "#855CA0", "#5BAF46", "#CE4663"];
		var colors = ["rgba(233, 157, 43, .6)", "rgba(104, 170, 182, .6)", "rgba(133, 92, 160, .6)", "rgba(91, 175, 70, .6)", "rgba(206, 70, 99, .6)"];
		
		$('article').each(function(){
			$(this).children('section').each(function(){
				var sect = $(this);
				var header = $(this).children('aside').children('h1');
				// Add offset to account for boxes that are too tall.
				var as = $(this).children('aside');
				var os = (350-$(as).outerHeight()) / 2;
				$(as).css({"margin-top": os+"px"});
				if ($(as).outerHeight() > 340){
					os = Math.abs(os);
				}else{
					os = -os;
				}
				var ct = $(this).children("aside").children("canvas")[0].getContext("2d");
				var trig = $(this).children(".trigger");
				var list = $(this).children('aside').children('ul').children("li");
				ct.fillStyle = colors[count];
				ct.beginPath();
				ct.moveTo(0, (getTrigY(trig)+os)); 
				ct.lineTo(72, getY(header));
				ct.lineTo(72, getH(header));
				ct.lineTo(0, (getTrigY(trig)+os)); 
				$(list).each(function(){
					ct.lineTo(72, getY(this));
					ct.lineTo(72, getH(this));
					ct.lineTo(0, getTrigY(trig)+os); 
				});
				ct.closePath();
				ct.fill();
				$(this).children('aside').css({"display": "none"});
			});
			count++;
		});
		/* Custom Scrollbars */
		$(".scrollCon").jScrollPane();
		loaded = true;
		
		/* Check for address hash options (e.g., show poster lightbox) */
		$("footer a").each(function(){
			if(window.location.hash == "#"+$(this).attr("data-hash")){
				$(this).trigger("click");
			}
		});
	});
})(jQuery);

var gaCats = new Array();
	gaCats[0 ]="Section Links";
	gaCats[1 ]="Footer Links";
	gaCats[2 ]="Download Links";
	gaCats[3 ]="Email Links";
	gaCats[4 ]="Offsite Links";

var gaEvts = new Array();
	gaEvts[0 ]="3-5yrs";
	gaEvts[1 ]="3-5yrs - Activity 1";
	gaEvts[2 ]="3-5yrs - Activity 2";
	gaEvts[3 ]="3-5yrs - Activity 3";
	gaEvts[4 ]="3-5yrs - Activity 4";
	
	gaEvts[5 ]="6-10yrs";
	gaEvts[6 ]="6-10yrs - Activity 5";
	gaEvts[7 ]="6-10yrs - Activity 6";
	gaEvts[8 ]="6-10yrs - Activity 7";
	gaEvts[9 ]="6-10yrs - Activity 8";
	
	gaEvts[10]="11-13yrs";
	gaEvts[11]="11-13yrs - Activity 9";
	gaEvts[12]="11-13yrs - Activity 10";
	gaEvts[13]="11-13yrs - Activity 11";
	gaEvts[14]="11-13yrs - Activity 12";
	
	gaEvts[15]="14-18yrs";
	gaEvts[16]="14-18yrs - Activity 13";
	gaEvts[17]="14-18yrs - Activity 14";
	gaEvts[18]="14-18yrs - Activity 15";
	gaEvts[19]="14-18yrs - Activity 16";
	
	gaEvts[20]="18+yrs";
	gaEvts[21]="18+yrs - Activity 17";
	gaEvts[22]="18+yrs - Activity 18";
	gaEvts[23]="18+yrs - Activity 19";
	gaEvts[24]="18+yrs - Activity 20";
	
	gaEvts[25]="Home";
	gaEvts[26]="What is Money As You Grow?";
	gaEvts[27]="How Can You Use Money As You Grow?";
	gaEvts[28]="Partners";
	gaEvts[29]="Sources & Acknowledgements";
	gaEvts[30]="Poster";
	gaEvts[31]="Milestones - Letter/Download";
	gaEvts[32]="Milestones - Letter/Print";
	gaEvts[33]="Want to Get Involved?";

	gaEvts[34]="Association of Library Services to Children";
	gaEvts[35]="Public Library Association";
	gaEvts[36]="Smart Investing @ Your Library";
	gaEvts[37]="American Savings Education Council";
	gaEvts[38]="Federal Reserve Bank of Chicago";
	gaEvts[39]="FINRA Investor Education Foundation";
	gaEvts[40]="Junior Achievement USA";
	gaEvts[41]="National Association of Elementary School Principals";
	gaEvts[42]="National Endowment for Financial Education";
	gaEvts[43]="Parent Teacher Association";
	gaEvts[44]="USDA National Institute of Food and Agriculture";
	gaEvts[45]="Women's Institute for a Secure Retirement";
	gaEvts[46]="Federal Trade Commission Identity Theft Information";
	gaEvts[47]="U.S. Securities and Exchange Commission";
	gaEvts[48]="Federal Reserve	Credit Card Repayment Calculator";
	gaEvts[49]="Consumer Financial Protection Bureau";
	gaEvts[50]="FAFSA on the Web";
	gaEvts[51]="Federal Student Aid";
	gaEvts[52]="MyMoney.gov - Your trusted source for financial Information";
	gaEvts[53]="Federal Reserve";
	gaEvts[54]="Compound Interest Calculator";
	gaEvts[55]="Annual Credit Report";
	gaEvts[56]="Credit Card Rules";
	gaEvts[57]="Health Insurance Options";
	gaEvts[58]="Tools and Information for Future Saving";
	
	//posters, contd
	gaEvts[59]="Milestones - Tabloid/Download";
	gaEvts[60]="Milestones - Tabloid/Print";
	gaEvts[61]="Milestones - Poster/Download";
	gaEvts[62]="Milestones - Poster/Print";
	gaEvts[63]="Milestones & Activities - Poster/Download";
	gaEvts[64]="Milestones & Activities - Poster/Print";


function trE(trArray){
	var cat = trArray[0];
	var evt = trArray[1];
	//alert(gaCats[cat]+" : "+gaEvts[evt]);
	_gaq.push(['_trackEvent', 'Action: Click', gaCats[cat], gaEvts[evt]]);
	return;
}

	
