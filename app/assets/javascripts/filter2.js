$(function() {

		//初始化select标签
		$("select[initVal]").each(function() {
			var val = $(this).attr("initVal");
			if ($.trim(val) != '') {
				$(this).val(val);
			} //Chrome will be set blank select tag when the value is blank
		});

		//由于某些额外的参数需要动态传递，所以在设计的时候需要在页面内新建一个元素来保存这些动态数据
		$("select[initVal]").change(function() {
			$("dl.fore dd a.currbg:first").trigger("click");
		});

		var str=window.location.href;
		strs = str.split("/");
		var jump_url = strs[4];
	      
		//alert(str);
		//选择筛选条件
		var options = {
			url : "/bankinvest/" + jump_url,
			traversal : ".currbg",
			paramInput : '#paramInputEle'
		};
		$("dl.fore dd a").sFilter(options);

		//删除筛选条件
		$("#selected div[cid]").click(function() {
			var originId = "#" + $(this).attr("cid");
			var $simulateDom = $(originId).find("a").not("[condition]");
			$simulateDom.sFilter(options).trigger('click');
		})

	});

