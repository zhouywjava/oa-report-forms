var URL="/msgmgr/public/genCsrfToken";

//csrf令牌组件
function getGHeadToken(xhr){
	//获得token
	$.ajax({
        type: "GET",
        url:URL,
        cache:false,
        async : false,
        error: function(request) {
        	return;
        },
        success: function(data) {
        	data = ZhiyeCommon.toJson(data);
           	if(data.success){
           		var token = data.data.token;
           		xhr.setRequestHeader("csrftoken",token);
           		return token;
        	} else {  
        		return;
           	}
        }
    });		
}

//beforeSend handle
$(document).ajaxSend(function(e, xhr, opt){
	if(opt.url.indexOf(URL)>-1) {
		return;
	}
	
	getGHeadToken(xhr);
} );
