/*************************************************************************************************************


IMPORTANT NOTES

1) all hooks are reset when the body object is reloaded -- clearAll() method is called

*add more as needed*



*************************************************************************************************************/

var urlRegex = /http[s]{0,1}:\/\/.+?(\/.*)/i;
var queryRegex = /(.*)\?(.*)/;

var smartasset = new Object();  // smartasset namespace
smartasset.tools = new Object(); // smartasset tools namespace -- do not remove

/////////////////////////////////
// page object
/////////////////////////////////
smartasset.page = new Object();
smartasset.inputs = new Object();

/////////////////////////////////
// page object
/////////////////////////////////
smartasset.event = new Object();
smartasset.event.queueset = new Object();

/////////////////////////////////
// general data object
/////////////////////////////////
smartasset.data = new Object();
smartasset.data.dataset = new Object();
smartasset.event.timerset = new Object();

smartasset.page.startuplist = [];

smartasset.page.headerId = null;
smartasset.page.bodyId = null;
smartasset.page.inputsId = null;
smartasset.page.url = null;

/////////////////////////////////
// inputs data object
/////////////////////////////////
smartasset.inputs.isforced = false;

smartasset.page.reset = function()
{
	smartasset.page.headerId = null;
	smartasset.page.bodyId = null;
	smartasset.page.inputsId = null;
};

smartasset.page.addToStartup = function(method)
{
	if (smartasset.page.startuplist == null)
	{
		smartasset.page.startuplist = [];
	}	
	
	smartasset.page.startuplist.push(method);
}

smartasset.page.runStartup = function()
{
    for(x in smartasset.page.startuplist)
    {
        if(smartasset.page.startuplist[x] != null)
        {
            smartasset.page.startuplist[x].call();
        }
    }
	
	// reset array
	smartasset.page.startuplist = [];
}

smartasset.data.set = function(k, v)
{	
	/*
	if (k.substr(0,1) != ".")
	{
		console.log("Setting: "+k+ " to: "+v);
	}
	*/
	smartasset.data.dataset[k] = v;
	//console.log(smartasset.data.dataset);
}

smartasset.data.get = function(k)
{
	//console.log("Getting: "+k);
	return smartasset.data.dataset[k];
}	

//
// page hooks
//

smartasset.page.hooks = new Object();

smartasset.page.hooks.add = function(key, method)
{
	if (smartasset.page.datamap == null)
	{
		smartasset.page.datamap = new Object();
	}
	
	if (smartasset.page.datamap[key] == null)
	{
		smartasset.page.datamap[key] = [];
	}
	
	for (var i=0; i<smartasset.page.datamap[key].length; i++)
	{
		if (String(smartasset.page.datamap[key][i]) == String(method))
		{
			removeItem(smartasset.page.datamap[key],i);
		}
	}
	
	smartasset.page.datamap[key].push(method);
}

// call functions listening to "key" and pass data through
smartasset.page.hooks.trigger = function(key, data)
{
	if (smartasset.page.datamap != null && smartasset.page.datamap[key] != null)
	{
		var list = smartasset.page.datamap[key];
		for (var i=0; i<list.length; i++)
		{
			//console.log(list[i]);
			list[i].call(this, data);
		}
	}
}

smartasset.page.hooks.clearAll = function()
{
	smartasset.page.datamap = new Object();
}

smartasset.page.hooks.clear = function(key)
{
	if (smartasset.page.datamap != null)
	{
		smartasset.page.datamap[key] = [];
	}
}

smartasset.event.queue = function(k, v)
{
	var hash = Sha256.hash(String(k));
	smartasset.event.queueset[hash] = {func: k, value: v};
	
	if (typeof(smartasset.event.timerset[hash]) != 'undefined')
	{
		clearTimeout(smartasset.event.timerset[hash]);
	}
	smartasset.event.timerset[hash] = setTimeout("smartasset.event.runtimer('"+hash+"')", 400);
}

smartasset.event.runtimer = function(k)
{
	//console.log("Timer "+k);
	var obj = smartasset.event.queueset[k];
	if (defined(obj) && defined(obj.func))
	{
		obj.func.call(this, obj.value);
	}
	
	smartasset.event.timerset[k] = null;
}

//////
// might need to optimize this -- do not load files twice, etc
////////////////
smartasset.page.is_loading = false;

smartasset.page.isLoading = function()
{
	smartasset.page.is_loading = true;
}

smartasset.page.isReady = function()
{
	smartasset.page.is_loading = false;
}

function isOldIEx()
{
  return (navigator.userAgent.match(/MSIE\s(?!9.0)/));
}

smartasset.page.loadJsList = new Object();
smartasset.page.loadJs = function(files, trigger)
{
	if (!isOldIEx())
	{
		smartasset.page.loadJsList[trigger] = files.length;
		
		for (i=0; i<files.length; i++)
		{
			var v = files[i];
			var s = document.createElement("script"); 
			s.setAttribute("src", v); 
			s.onload = function() 
			{
				var c = smartasset.page.loadJsList[trigger]-1;
				if (c < 1)
				{
					if (smartasset.page.is_loading)
					{
						setTimeout("eval("+trigger+")", 100);
					}
					else
					{
						eval(trigger);
					}
				}
				smartasset.page.loadJsList[trigger] = c;
			} 
			
			document.head.appendChild(s); 
		}
	}
	else
	{
		eval(trigger);
	}
}

//////////////////////////////////////////////////////////////////////////
///////////////////////// TEST COOKIE HANDLER ////////////////////////////
//////////////////////////////////////////////////////////////////////////
var checkTestCookieFlag = true;

function eventTrack(key, data, note)
{
	//if (!checkTestCookie() && typeof(mixpanel) != "undefined")
	if (typeof(mixpanel) != "undefined")
	{
		if (data == null)
		{
			if (note != null)
			{
				mixpanel.track(key, {mp_note: note, abversion: getABVersion()});	
			}
			else
			{
				mixpanel.track(key, {abversion: getABVersion()});
			}
		}
		else
		{
			if (typeof(data) == "object")
			{
				if (typeof(data.mp_note) == "undefined")
				{
					data.mp_note = note;
					data.abversion = getABVersion();
				}
				mixpanel.track(key, data);		
			}
			else
			{
				mixpanel.track(key, {data: data, mp_note: note, abversion: getABVersion()});
			}
		}

		if (typeof(_gaq) != "undefined")
		{
			_gaq.push(['_trackEvent', key, note]);
		}
	}

	//mpq.track("Link Click", {mp_note: "Clicked on "+name, name: name, url: url});
}

function getABVersion()
{
	if (typeof(abVersion) == "string")
	{
		return abVersion;
	}
	return "0";
}

// checks whether user has TEST cookie set. 
function checkTestCookie()
{
	return checkTestCookieFlag;
}

function initCheckTestCookie()
{
	var ca = document.cookie.split(';');
	for(var i=0;i < ca.length;i++) {
		var c = ca[i];		
		c = c.replace(/\s/g,"");
		if (c == "_sa_trk=test")
		{
			checkTestCookieFlag = true;
			return;
		}
	}
	checkTestCookieFlag = false;
}

/*
function googleEventTrack(category, action, label)
{
	if (typeof(_gaq) != "undefined")
	{
		_gaq.push(['_trackEvent', category, action, label]);
	}
}
*/

function parseUrl(url)
{
	var tu = urlRegex.exec(url);
	if (tu != null && tu.length == 2)
	{
		// get query string
		var qs = queryRegex.exec(tu[1]);
		if (qs != null && qs.length == 3)
		{ 
			return qs[1];
		}
		else
		{
			return tu[1];
		}
	}
	else
	{
		return url;
	}	
}

/**
 * Use to send a Virtual Page View Event to Google.
 */
function googleVPViewEvent(pageKey)
{
    var key = pageKey;
    // if pagekey is null or blank use the href
    if (pageKey == null || pageKey == "")
	{
		key = parseUrl(document.URL);
        key = key.replace("/page/#", "");
	}
    else
    {
        key = "/" + pageKey;
    }
    
    if (typeof(_gaq) != "undefined")
	{
//        clog("Sending event "+ "/virtual"+url);
        _gaq.push(['_trackPageview', "/virtual"+key]);
    }
}

function clog(s)
{
	console.log(s); 
}

$(function()
{
	initCheckTestCookie();
});	

