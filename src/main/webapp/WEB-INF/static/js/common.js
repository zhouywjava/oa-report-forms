var ZhiyeCommon = (function(){
	
	var TimeFormatter = function (value) {
        if (value == undefined) {
            return "";
        }
        var time = moment(value, "YYYYMMDDHHmmss");
        return time.format("YYYY-MM-DD HH:mm:ss");
    };	
	
    var DateFormatter = function (value) {
        if (value == undefined) {
            return "";
        }
        var time = moment(value, "YYYYMMDD");
        return time.format("YYYY-MM-DD");
    };
    
    function cellStyler(value,row,index){
		if (value != "" && row.reviewStatus == '0'){
            return 'color:red;';
        }
    }
    
    function cellStylerStatus(value,row,index){
		if (row.reviewStatus == '0'){
            return 'color:red;';
        }
    }
    
    var MessageBox = function (title, msg) {
		$.messager.show({
			title : title,
			msg : msg,
			showType:'slide',
			timeout:2000,
			style:{
				right:'',
				top:document.body.scrollTop+document.documentElement.scrollTop,
				bottom:''
			}							
		});    	
    };
   
    //icon四种设置："error"、"info"、"question"、"warning"
    var MessageAlert = function (title, msg, icon) {
    	if(icon == "error" || icon == "warning") {
			$.messager.show({
				title : title,
				msg : "<span style=\"color:#bd4247\">" + msg + "</span>",
				icon : icon,
				showType:'slide',
				timeout:1500,
				style:{
					right:'',
					top:document.body.scrollTop+document.documentElement.scrollTop,
					bottom:''
				}							
			});
    	} else {
    		$.messager.show({
				title : title,
				msg: msg,
				icon : icon,
				showType:'slide',
				timeout:1500,
				style:{
					right:'',
					top:document.body.scrollTop+document.documentElement.scrollTop,
					bottom:''
				}							
			});
    	}
    };
    
    var getSelectRowCurPage = function(obj) {
    	
    	var options = obj.datagrid('getPager').data("pagination").options;  
    	
    	var pageNumber = options.pageNumber;  
    	var pageSize = options.pageSize;
    	//var total = options.total;         //总记录数
    	var beginIndex = (pageNumber-1)*pageSize; //开始索引值
    	var endIndex = pageNumber*pageSize-1;     //结束索引值
		
		var row = obj.datagrid('getSelected');
		var rowIndex = obj.datagrid('getRowIndex', row);
		
		//当前页选中项索引
		var currentIndex = (pageNumber-1)*pageSize+rowIndex;
		
		if((currentIndex <= endIndex) && (currentIndex >= beginIndex)) {
			return true;
		} else {
			return false;
		}
    };
    
    var GetIdsFromRow = function (rows){
		var ids = [];
        for(var i=0; i<rows.length; i++){
            ids.push(rows[i].id);
        }
        return ids.join(',');
	};
	

	var CreateMask = function() {
		var height = window.screen.height - 250;
		var width = window.screen.width;
		var leftW = 300;
		if (width > 1200) {

			leftW = 500;
		} else if (width > 1000) {

			leftW = 350;
		} else {

			leftW = 100;
		}

		var _html = "<div id='loading' style='position:absolute;left:0;width:100%;height:"
				+ height
				+ "px;top:0;background:#E0ECFF;opacity:0.8;filter:alpha(opacity=80);'> <div style='position:absolute;cursor1:wait;left:"
				+ leftW
				+ "px;top:200px;width:auto;height:16px;padding:12px 5px 10px 30px;background:#fff url('easyui/themes/default/images/pagination_loading.gif') no-repeat scroll 5px 10px;border:2px solid #ccc;color:#000;'>正在加载，请等待...</div></div>";
		document.write(_html);
		return;
	};
	
	var RemoveMask = function() {
		var _mask = document.getElementById('loading');
		_mask.parentNode.removeChild(_mask);
		$("div").removeClass("hiddenDiv");
		return;
	};
	
	var Trim = function (value) {
		return value .replace(/^\s\s*/, '' ).replace(/\s\s*$/, '' );
	};
	
	var isEmpty = function (value) {
		if (value=='' || typeof(value)=="undefined" || value==null || Trim(value)=='') {
			return true;
		} else {
			return false;
		}
	};
	
	var toJson = function (value) {
		var isJson = typeof(value) == "object" && Object.prototype.toString.call(value).toLowerCase() == "[object object]" && !value.length;
		if(!isJson) {
			return  eval('(' + value + ')'); 
		} else {
			return value;
		}
	};
	
	
	var genCsrfToken = function (form) {
		if(typeof(form) == "undefined"){
			form = $("form");
		} 
		var csrfToken = form.children("input[name='csrftoken']");
   		var length = csrfToken.length;
   		if(length == 0) {
   			form.append("<input type='hidden' name='csrftoken' id='csrftoken'/>");
   		}
		//获得token
		$.ajax({
	        type: "GET",
	        url: "/msgmgr/public/genCsrfToken",
	        cache:false,
	        async:false,
	        error: function(request) {
	        	return;
	        },
	        success: function(data) {
	        	data = ZhiyeCommon.toJson(data);
	           	if(data.success){
	           		var token = data.data.token;
	           		$('#csrftoken').val(token);
	        	} else {  
	        		return;
	           	}
	        }
	    });	
	};
	
	/**
	 * 日期控件格式化，为空取当前日期
	 */
	var dateParser = function(s){
		if (!s) return new Date();
		var ss = (s.split('-'));
		var y = parseInt(ss[0],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[2],10);
		if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
			return new Date(y,m-1,d);
		} else {
			return new Date();
		}
	};
	
	return {
		TimeFormatter : TimeFormatter,
		DateFormatter : DateFormatter,
		MessageBox : MessageBox,
		MessageAlert : MessageAlert,
		GetIdsFromRow : GetIdsFromRow,
		CreateMask : CreateMask,
		RemoveMask : RemoveMask,
		Trim : Trim,
		genCsrfToken : genCsrfToken,
		isEmpty : isEmpty,
		toJson : toJson,
		dateParser : dateParser,
		cellStyler : cellStyler,
		cellStylerStatus : cellStylerStatus,
		getSelectRowCurPage : getSelectRowCurPage
	};		
})();
