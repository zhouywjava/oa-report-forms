<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../common.jsp"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>操作日志查询</title>
	
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
</head>
<!-- serach terms -->
<body style="margin:0 auto;" onload="XypayCommon.RemoveMask();">
	<div id="searchHeader" class="pageHeader hiddenDiv" style="height:70px;padding-top: 10px;"> 
	    <div style="margin-left:18px">      
	        <label style=" text-align: right">登陆名：</label><input id="loginName" class="easyui-textbox" style="width:100px" data-options="required:false,validType:'maxLength[50]'">
	                操作员名称：<input id="usrName" class="easyui-textbox" style="width:100px" data-options="required:false,validType:'maxLength[50]'">
	                操作描述：<input id="logIfo" class="easyui-textbox" style="width:102px" data-options="required:false,validType:'maxLength[50]'">
	    </div>   
	    <div style="margin-left:6px;margin-top: 5px;">      
	               操作时间：<input id="beginDate" class="easyui-datebox" style="width:100px" onchange="javascript:" editable="false">
	                <label style=" text-align:left;margin-left:45px">到：</label>
	                <input id="endDate" class="easyui-datebox" style="width:100px" editable="false">
	        <label style="margin-left:36px;">&nbsp;</label>
	        <a onclick="javascript:searchMerLimit();" class="easyui-linkbutton" iconCls="icon-search">查询</a> 
	        &nbsp;&nbsp;   
	        <a onclick="javascript:reset();" class="easyui-linkbutton" iconCls="icon-reset">重置</a> 
	    </div>     
	</div> 
    
    <!-- serach list -->
	<div id="searchListDiv" class="hiddenDiv" style="width: 100%;height:100%;">
		<table id="searchTable" class="easyui-datagrid" toolbar="#searchHeader" singleSelect="true" fitColumns="true" striped="true"
			fit="true" pagination="true" collapsible="true" autoRowHeight="true" rownumbers="true" idField="ID">
		    <thead>    
		        <tr>    
		            <th field="USR_ID" >操作员编号</th>       
		            <th field="USR_LOGONNAME" >登陆名</th>   
		            <th field="USR_NAME" >操作员名称</th>  
		            <th field="LOG_DATETIME_STR">操作时间</th>
		            <th field="ROL_NAME" >角色名称</th>
		            <th field="LOG_RESULT">操作结果</th> 
		            <th field="LOG_IP" >操作IP</th>
		            <th field="LOG_INFO" >操作描述</th>
		        </tr>    
		    </thead>		
		</table>
	</div>
    
	<script type="text/javascript">
		
		$(document).ready(function() {
			//注册事件,当用户回车触发查询操作
			document.onkeydown = function(e){ 
			    var ev = document.all ? window.event : e;
			    if(ev.keyCode==13) {
			    	searchMerLimit();
			     }
			};
		});
		
	    var url;
		$(function(){
			searchMerLimit();
			validateDate();
			init();
		});
		
		function init(){
			//默认日期
			var curr_time = new Date();
		   	var beginDate = curr_time.getFullYear()+"-";
		   	    beginDate += curr_time.getMonth()+"-";
			    beginDate += curr_time.getDate()+1+"-";
			    beginDate += curr_time.getHours()+":";
			    beginDate += curr_time.getMinutes()+":";
			    beginDate += curr_time.getSeconds();
		    var endDate = curr_time.getFullYear()+"-";
		        endDate += curr_time.getMonth()+1+"-";
		        endDate += curr_time.getDate()+"-";
		        endDate += curr_time.getHours()+":";
		        endDate += curr_time.getMinutes()+":";
		        endDate += curr_time.getSeconds();								
			$("#beginDate").datebox("setValue",beginDate);
			$("#endDate").datebox("setValue", endDate);
		}
		
	   var searchMerLimit = function (){  
	    	var options = $('#searchTable').datagrid('options');
	    	options.url = "riskLogPageList.json";
	        $('#searchTable').datagrid('reload',{  
	        	usrName:$('#usrName').val(),
	        	loginName:$('#loginName').val(),
	        	logIfo:$('#logIfo').val(),
	        	beginDate:$('#beginDate').datebox('getValue'),
	        	endDate:$('#endDate').datebox('getValue')
	        });  
	    };  	
	    
	    function reset(){  
	    	 $('#searchHeader').form('clear');
	    	 $('#mlStatus').combobox('setValue','1');
	    	 init();
	    }
	    
	    var validateDate = function (){
	    	$('#beginDate').datebox().datebox('calendar').calendar({
				validator: function(date){
					var endDate = XypayCommon.dateParser($('#endDate').datebox('getValue'));
					var d1 = new Date(endDate.getFullYear(), endDate.getMonth(), endDate.getDate());
					return date<=d1;
				}
			});
	    	$('#endDate').datebox().datebox('calendar').calendar({
				validator: function(date){
			    	var beginDate = XypayCommon.dateParser($('#beginDate').datebox('getValue'));
					var d1 = new Date(beginDate.getFullYear(), beginDate.getMonth(), beginDate.getDate());
					return d1<=date;
				}
			});
	    };
	    
	</script>	
			
</body>
</html>