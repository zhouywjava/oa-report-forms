<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../common.jsp"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>短信报表</title>
	
	<!-- jquery easyui -->
	<link rel="stylesheet" type="text/css" href="<%=root%>/static/css/common.css">
	<link rel="stylesheet" type="text/css" href="<%=theme%>/easyui.css">
	<link rel="stylesheet" type="text/css" href="<%=root%>/static/js/easyui/themes/icon.css">
	<script type="text/javascript" src="<%=root%>/static/js/easyui/js/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="<%=root%>/static/js/easyui/js/easyui-lang-zh_CN.js"></script>
	<script type="text/javascript" src="<%=root%>/static/js/easyui/js/easyui-validator.js"></script>
	
	<script>
		XypayCommon.CreateMask();
	</script>
	<style>
.center_o {
    width:200px;
    height:200px;
    top:50%;
    left:50%;
    position:absolute;
}
.center_i {
    width:200px;
    height:200px;
    background:#ccc;
    margin-left:-100px;
    margin-top:-100px;
    word-wrap:break-word;
}
</style>
</head>
<body style="margin:0 auto;" onload="XypayCommon.RemoveMask();">
	
	 <div id="addselectDlg"  style="padding:10px 20px;text-align:center;padding-top:15%"
         closed="true" buttons="#selectDlg-buttons">
        <form  id="addselectForm" method="post" >
            <div class="dlgFormItem">
                <label style=" text-align: right">报表名称：</label>
                <select id="designFile" name="designFile" style="width: 206px;">
						<option value="querySmsByCstRpt.rptdesign">客户发送情况统计</option>
					    <option value="querySmsByChanRpt.rptdesign">账号发送情况统计</option>
				</select>
            </div> 
            <br/>
            <br/>
            <div class="dlgFormItem">
            	<a onclick="javascript:view()" class="easyui-linkbutton c6" iconCls="icon-ok" style="width:90px">查看</a> 
            </div>                 
        </form>
        
        <form id="queryRpt" autocomplete='off' name="submitForm" method="post" action="" target="_blank">
			<input type="hidden" name="__report" value="">
			<input type="hidden" name="format" value="html">
			<input type="hidden" name="reportFile" value="report">
		</form>
    </div>
    
    
	<script>
		function view() {
			document.submitForm.__report.value = document.getElementById("designFile").value;
			var path=getRootPath();
			document.submitForm.action=path+"/frameset";  
			document.submitForm.submit();
		}
		function getRootPath(){
		    var curWwwPath=window.document.location.href;
		    var pathName=window.document.location.pathname;
		    var pos=curWwwPath.indexOf(pathName);
		    var localhostPaht=curWwwPath.substring(0,pos);
		    var projectName=pathName.substring(0,pathName.substr(1).indexOf('/')+1);
		    return(localhostPaht+projectName);
		}
	</script>	
	
</body>
</html>