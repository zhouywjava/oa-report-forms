var curHeight = 0;
$(function() {
	//窗口自适应，logo回主页
	var menu = new ULMenu("#leftNav");
	var currentWindow = new WindowInfo(menu);
	currentWindow.init();
	//点击logo回主页
	$('.logo').click(function(){
		window.location.href="index"; 
	});
	
	//绑定TAB页关闭事件
	bindTabCloseListener();
	curHeight = $(window).height();
	//TAB右边按钮弹出关闭菜单
	$('#centerTab').tabs({
		tools:[{
			iconCls:'icon-back',
			handler: function(e){
				//ADD BY LIHUI 2016.01.19
				e = e || window.event;
				//alert('test=yes'+',e.pageX='+e.pageX+',e.pageY='+e.pageY+',e.x='+e.x+',e.y='+e.y+',e.clientX='+e.clientX+',e.clientY='+e.clientY);
				if ( e.pageX == null && e.clientX != null ) {
					var doc = document.documentElement, body = document.body;
					e.pageX = e.clientX +
							  (doc && doc.scrollLeft || body && body.scrollLeft || 0) -
							  (doc && doc.clientLeft || body && body.clientLeft || 0);
					e.pageY = e.clientY +
							  (doc && doc.scrollTop || body && body.scrollTop || 0) -
							  (doc && doc.clientTop || body && body.clientTop || 0);
				}
                //alert('e.pageX='+e.pageX+',e.pageY='+e.pageY);
				$('#rcmenu').menu('show', {
			           left: e.pageX,
			           top: e.pageY
			    });
			}
		}]
	});
});

//自适应高度
window.onresize = function () {
	var winHeight = $(window).height();
	if(winHeight > curHeight) {
		var height = $(window).height()-$('.head').outerHeight();
		$('.left_nav_i').css('height', height - 1);
		$('#content_main').css('height',height);
		curHeight = winHeight;
	}
	setScroller();
};

function setScroller (){
    if($(document).width() == screen.availWidth){
       $('html').css("cssText","overflow-y:hidden!important");
       return true;// 全屏
    }
    $('html').css("cssText","overflow-y:auto!important");
    return false; // 不是全屏
};

//获取页面的高度、宽度
function getPageSize() {
    var xScroll, yScroll;
    if (window.innerHeight && window.scrollMaxY) {
        xScroll = window.innerWidth + window.scrollMaxX;
        yScroll = window.innerHeight + window.scrollMaxY;
    } else {
        if (document.body.scrollHeight > document.body.offsetHeight) { // all but Explorer Mac    
            xScroll = document.body.scrollWidth;
            yScroll = document.body.scrollHeight;
        } else { // Explorer Mac...would also work in Explorer 6 Strict, Mozilla and Safari    
            xScroll = document.body.offsetWidth;
            yScroll = document.body.offsetHeight;
        }
    }
    var windowWidth, windowHeight;
    if (self.innerHeight) { // all except Explorer    
        if (document.documentElement.clientWidth) {
            windowWidth = document.documentElement.clientWidth;
        } else {
            windowWidth = self.innerWidth;
        }
        windowHeight = self.innerHeight;
    } else {
        if (document.documentElement && document.documentElement.clientHeight) { // Explorer 6 Strict Mode    
            windowWidth = document.documentElement.clientWidth;
            windowHeight = document.documentElement.clientHeight;
        } else {
            if (document.body) { // other Explorers    
                windowWidth = document.body.clientWidth;
                windowHeight = document.body.clientHeight;
            }
        }
    }       
    // for small pages with total height less then height of the viewport    
    if (yScroll < windowHeight) {
        pageHeight = windowHeight;
    } else {
        pageHeight = yScroll;
    }    
    // for small pages with total width less then width of the viewport    
    if (xScroll < windowWidth) {
        pageWidth = xScroll;
    } else {
        pageWidth = windowWidth;
    }
    arrayPageSize = new Array(pageWidth, pageHeight, windowWidth, windowHeight);
    return arrayPageSize;
}

/**
 * 绑定TAB页关闭事件
 */
function bindTabCloseListener() {
	
	//TAB页绑定右键菜单
	$(".tabs").bind('contextmenu',function(e){
        e.preventDefault();
        $('#rcmenu').menu('show', {
            left: e.pageX,
            top: e.pageY
        });
    });
	
    //关闭当前标签页
    $("#closecur").bind("click",function(){
        var tab = $('#centerTab').tabs('getSelected');
        var index = $('#centerTab').tabs('getTabIndex',tab);
        closeTab(index);
    });
    //关闭所有标签页
    $("#closeall").bind("click",function(){
        var tablist = $('#centerTab').tabs('tabs');
        for(var i=tablist.length-1;i>=0;i--){
        	closeTab(i);
        }
    });
    //关闭非当前标签页（先关闭右侧，再关闭左侧）
    $("#closeother").bind("click",function(){
        var tablist = $('#centerTab').tabs('tabs');
        var tab = $('#centerTab').tabs('getSelected');
        var index = $('#centerTab').tabs('getTabIndex',tab);
        for(var i=tablist.length-1;i>index;i--){
        	closeTab(i);
        }
        var num = index-1;
        for(var i=num;i>0;i--){
        	closeTab(i);
        }
        $('#centerTab').tabs('select', 1); 
    });
    //关闭当前标签页右侧标签页
    $("#closeright").bind("click",function(){
        var tablist = $('#centerTab').tabs('tabs');
        var tab = $('#centerTab').tabs('getSelected');
        var index = $('#centerTab').tabs('getTabIndex',tab);
        for(var i=tablist.length-1;i>index;i--){
        	closeTab(i);
        }
    });
    
}

/**
 * 关闭标签页，[首页]不关闭
 * @param index
 */
function closeTab(index) {
	if(index == 0) {
		return;
	}
	$('#centerTab').tabs('close',index);
}

/**
 * 创建新选项卡
 * @param tabId    选项卡id
 * @param title    选项卡标题
 * @param url      选项卡远程调用路径
 */
function addTab(tabId,title,url){
	//如果当前id的tab不存在则创建一个tab
	if($("#"+tabId).html()==null){
		var name = 'iframe_'+tabId;
		$('#centerTab').tabs('add',{
			title: title,         
			closable:true,
			cache : false,
			//注：使用iframe即可防止同一个页面出现js和css冲突的问题
			content : '<iframe name="'+name+'"id="'+tabId+'"src="'+url+'" width="100%" height="100%" marginwidth="0" marginheight="0" frameborder="0" scrolling="auto" calss="mainIframe"></iframe>'
		});
	} else {
		$('#centerTab').tabs('select', title); 
	}
}
