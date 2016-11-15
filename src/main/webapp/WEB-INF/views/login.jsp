<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<%=root%>/static/css/login.css">
<script type="text/javascript" src="<%=root%>/static/js/password.js"></script>
<style type="text/css">
html { overflow-y: hidden; }
.psw {
	height: 37px !important;
    width: 230px !important;
    float: right !important;
    background: transparent !important;    
}
</style>
<script type="text/javascript">
if(window !=top){  
    top.location.href=location.href;  
}
</script>
<title>象屿支付-短信管理系统</title>
</head>
<body class="loginPage">
<form id="loginForm" action="doLogin" method="POST">
 	<input type="hidden" id="password" name="password">
   <div class="clearfix">
      <div class="login_top">
         <div class="wrap">
            <img src="<%=root%>/static/images/logo2.png" />
         </div>
      </div>
      <div class="login_cont">
         <div class="bg">
            <div class="bg_img">
               <div class="wrap clearfix">
                  <div class="left">
                     <img src="<%=root%>/static/images/logo3.png" />
                  </div>
                  <div class="login_box">
                     <span class="corner_l"></span>
                     <span class="corner_r"></span>
                     <div class="hd">用户登录</div>
                     <div class="bd">
                        <div class="input_box">
                           <img src="<%=root%>/static/images/icon_5.png" />
                           <input type="text" id="username" name="username" value="" maxlength="20"  placeholder="" style="background: none;" tabindex="1"/>
                        </div>
                        <div class="input_box">
                           <img src="<%=root%>/static/images/icon_6.png" />
                           <span>
                           <input type="password" maxlength="32" class="ui-pwd" value="" name="psw" tabindex="2"/>
                           </span>
                        </div>
                        <img class="captcha-btn captcha-img"  style="cursor:hand;float:right;heigh:39px; margin-right:0px;" src="captcha.jpg" title="点击更换验证码" />
                        <div class="input_box" style="width:130px;" >
                           <input type="text" id="captcha" name="captcha" maxlength="4" placeholder="验证码" style="background: none; width: 100px;" tabindex="3"/>
                        </div>
                        
                        <div class="error_info">${error}</div>
                        <div class="act clearfix">
                           <a style="cursor: pointer;" class="login_btn">登&nbsp;录</a>
                        </div>
                        <div class="link">
                           <a href="#"></a> 
                           &nbsp;&nbsp;&nbsp;
                           <a href="#"></a>
                        </div>
                     </div>
                  </div>
               </div>
            </div>
         </div>
      </div>
   </div>
</form>
<script>	
	$(document).ready(function() {
		if(window !=top){ 
		    top.location.href=location.href;  
		}
// 		loadPasswordOCX("ui-pwd");
		document.onkeydown = function(e){ 
		    var ev = document.all ? window.event : e;
		    if(ev.keyCode==13) {
		         submit();
		     }
		};
		 
		$('.login_btn').click(function() {
			submit();
		});
		
		// 验证码组件
		$('.captcha-btn').click(function() {
			var url = $(".captcha-img").attr("src");
			var array = url.split("?");
			url = array[0];
			$(".captcha-img").attr("src", url + "?" + new Date().getTime());
		});
	});
	
	function submit() {
		var username = $('#username').val();
// 		var loginPsw = pgeditors[0].pwdResult();
		var loginPsw = $("input[name='psw']").val();
		var captcha = $("input[name='captcha']").val();
		var errMsg = '';
		if(XypayCommon.isEmpty(username)) {
			errMsg = '请输入登录账号';
		} else if(XypayCommon.isEmpty(loginPsw)) {
			errMsg = '请输入密码';
		} else if(XypayCommon.isEmpty(captcha)) {
			errMsg = '请输入验证码';
		}
		if(!XypayCommon.isEmpty(errMsg)) {
			$('.error_info').html(errMsg);
			$('.error_info').css('display', 'block');
			return;
		}
		
		$("#password").val(loginPsw);
		$.ajax({
		    type: "POST",
		    url: 'checkSession',
		    success: function(data) {
		    	data = XypayCommon.toJson(data); 
		    	if(data.success) {
		    		window.location.href="index"; 
		    		return;
		    	}
		    }
		}); 
		//提交Form
    	$.ajax({
	        type: "POST",
	        url: 'doLogin',
	        data: $('#loginForm').serialize(),
	        success: function(data) {
	        	data = XypayCommon.toJson(data); 
	        	if(data.success) {
	        		window.location.href="index"; 
	        	} else {
	        		$("input[name='captcha']").val('');
	        		$('.error_info').html(data.msg);
	        		$('.captcha-btn').click();
	        		//loadPasswordOCX("ui-pwd");
	        	}
	        }
	    }); 
	}
</script>

</body>
</html>