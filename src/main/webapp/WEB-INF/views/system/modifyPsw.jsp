<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../common.jsp"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>资源管理</title>
	
	<!-- jquery easyui -->
	<link rel="stylesheet" type="text/css" href="<%=root%>/static/css/common.css">
	<link rel="stylesheet" type="text/css" href="<%=theme%>/easyui.css">
	<link rel="stylesheet" type="text/css" href="<%=root%>/static/js/easyui/themes/icon.css">
	<script type="text/javascript" src="<%=root%>/static/js/easyui/js/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="<%=root%>/static/js/easyui/js/easyui-lang-zh_CN.js"></script>
	<style type="text/css">
	.lbl{float:left;text-align:right;width:80px; line-height:28px; margin-right:10px;}
	.rmk{color: gray;margin-left:5px;}
	input[type=password]{border:1px solid #ccc;border-radius:3px; height:24px;}
	</style>
</head>
<body style="margin:0 auto;">
	 <form class="dlgForm" id="modifyPswForm" action="updatePsw" method="post" novalidate>
	 	<div class="easyui-panel" style="width:800px;padding:10px 70px 20px 0px;border:none;display:none;" id="tip">
	 		<b>修改成功</b>，可以继续浏览页面或点此 <a href="javascript:logout();">重新登录</a></br></br>
	 		页面将会在<strong id="endtime"></strong>秒后关闭
	 	</div>
		<div class="easyui-panel" style="width:800px;padding:10px 70px 20px 0px;border:none;" id="pswDiv">
			<c:if test="${HTTP_SESSION_ID.usrInitpwd=='0'}">
		    	<div style="margin-bottom: 20px;color: #aaa;background-color: #f8f8f8;padding: 8px 15px;display: inline-block;border-radius: 5px;"><span style="color: red">*</span>密码为初始密码，为保障账号安全，建议您修改密码</div>
	    	</c:if>
	        <div style="margin-bottom:10px">
	        	<label class="lbl">原密码：</label>
 				<input class="psw" name="oldPsw" type="password" maxlength="32">
 				<label class="rmk"><span style="color: red">*</span>请填写原来的密码</label>
 			</div>
	        <div style="margin-bottom:10px">
	        	<label class="lbl">新密码：</label>
 				<input class="psw" name="newPsw" type="password" maxlength="32">
 				<label class="rmk"><span style="color: red">*</span>请输入8-32位数字与字母组合</label>
 			</div>
 			<div style="margin-bottom:10px">
	        	<label class="lbl">确认密码：</label>
 				<input class="psw" name="confirmPsw" type="password" maxlength="32">
 				<label class="rmk"><span style="color: red">*</span>请确保与刚输入的密码一致</label>
 			</div>
	       
	        <div>
	        	<label class="lbl">&nbsp;</label>
	        	<!-- ADD BY LIHUI 2016.01.19 -->
	            <a id="confirmUpdateId" class="easyui-linkbutton" style="">
	                <span style="font-size:12px;">确认修改</span>
	            </a>
	            <span style="margin-left:10px;color:red;" id="error"></div>        
	        </div>
	    </div>
    </form>
    
    <script>
    
    $(document).ready(function() {
		 
		$('#confirmUpdateId').click(function() {
			submit();
		});
		
	});
    
    function submit() {
    	//验证
    	var oldPsw =$("input[name='oldPsw']").val();
    	var newPsw =$("input[name='newPsw']").val();
    	var confirmPsw =$("input[name='confirmPsw']").val();
    	if(XypayCommon.isEmpty(oldPsw)) {
    		$('#error').html('原密码不能为空');
    		return;
    	}
    	if(XypayCommon.isEmpty(newPsw)) {
    		$('#error').html('新密码不能为空');
    		return;
    	}
    	if(XypayCommon.isEmpty(confirmPsw)) {
    		$('#error').html('确认密码不能为空!');
    		return;
    	}
    	var regex = new RegExp("^(?!^\\d+$)(?!^[a-zA-Z]+$)[0-9a-zA-Z]{8,32}$");
    	if(!regex.test(newPsw)){
    		$('#error').html('新密码格式不符!');
    		return;
    	}
    	
    	if(newPsw != confirmPsw){
    		$('#error').html('两次密码输入不一致!');
    		return;
    	}
    	
    	//提交Form
    	/* $.ajax({
	        type: "POST",
	        url: 'updatePsw',
	        data: $('#modifyPswForm').serialize(),
	        error: function(request) {
	        	alert("网络连接断开！");
	        },
	        success: function(data) {
	        	alert(data);
	        	data = XypayCommon.toJson(data);
	        	alert(data);
	        	if(data.success) {
	        		$('#pswDiv').css('display', 'none');
					$('#tip').css('display', 'block');
					remainTime();
	        	} else {
	        		$('#error').html('修改失败，原密码错误');
					$("input[name='oldPsw']").val('');
					$("input[name='oldPsw']").focus();
	        	}
	        }
	    });  */
    	
	    XypayCommon.genCsrfToken($('#modifyPswForm'));
    	$('#modifyPswForm').form('submit', {
			url : 'updatePsw',
			onSubmit : function() {
				return $(this).form('validate');
			},
			success : function(result) {
				result = XypayCommon.toJson(result);
				if(result.success) {
	        		$('#pswDiv').css('display', 'none');
					$('#tip').css('display', 'block');
					remainTime();
	        	} else {
	        		$('#error').html('修改失败，原密码错误!');
					$("input[name='oldPsw']").val('');
					$("input[name='oldPsw']").focus();
	        	}
			}
		});
    }
    
    function logout() {
    	top.window.location.href="../logout";  
    }
    
    var i = 3;  
	function remainTime(){  
		if(i==0){  
	      parent.$('#centerTab').tabs('close','修改密码');;
	      return;
		}  
		document.getElementById('endtime').innerHTML=i--;  
		setTimeout("remainTime()",1000);  
	}  
    </script>
	
</body>
</html>