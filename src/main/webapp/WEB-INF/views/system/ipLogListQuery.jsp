<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../common.jsp"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>IP白名单名单管理</title>

<!-- jquery easyui -->
<link rel="stylesheet" type="text/css"
	href="<%=root%>/static/css/common.css">
<link rel="stylesheet" type="text/css" href="<%=theme%>/easyui.css">
<link rel="stylesheet" type="text/css"
	href="<%=root%>/static/js/easyui/themes/icon.css">
<script type="text/javascript"
	src="<%=root%>/static/js/easyui/js/jquery.easyui.min.js"></script>
<script type="text/javascript"
	src="<%=root%>/static/js/easyui/js/easyui-lang-zh_CN.js"></script>
<script type="text/javascript"
	src="<%=root%>/static/js/easyui/js/easyui-validator.js"></script>

<script>
	XypayCommon.CreateMask();
</script>
</head>
<body style="margin: 0 auto;" onload="XypayCommon.RemoveMask();">
	<div id="ipWhiteListHeader" class="pageHeader hiddenDiv"
		style="height: 70px; padding-top: 10px;">
		<div style="margin-left: 8px">
			开始时间：<input id="beginDate" class="easyui-datebox" style="width:100px" editable="ture">
                                    结束时间：<input id="endDate" class="easyui-datebox" style="width:100px" editable="ture">		    
		</div>
		<div style="margin-left:8px;margin-top: 5px;">
		   	 客户编码：<input id="userNo" class="easyui-textbox" style="width:100px" editable="true">
			操作描述：<input id="operateDetail" class="easyui-textbox" style="width:100px" editable="true">
			<a onclick="javascript:onSearchIPLoglist();" class="easyui-linkbutton" iconCls="icon-search">查询</a>
			<a onclick="javascript:reset();" class="easyui-linkbutton" iconCls="icon-reset">重置</a>
		</div>
			
	</div>

	<div class="hiddenDiv" style="width: 100%;height:100%;">
		<table id="ipLogListTbl" class="easyui-datagrid" toolbar="#ipWhiteListHeader" singleSelect="true" fitColumns="true" rownumbers="true"
			   fit="true" pagination="true" collapsible="true" autoRowHeight="true" idField="id">
		  <thead>
				<tr>
					<th data-options="field:'userNo'" width="10%">客户编码</th>
					<th data-options="field:'csName'" width="10%">客户名称</th>
					<th data-options="field:'operateTime'" width="10%">操作时间</th>
<!-- 					<th data-options="field:'result'" width="10%">操作结果</th>
 -->					<th data-options="field:'operateIp'" width="10%">操作IP</th>
					<th data-options="field:'operateDetail'" width="10%">操作描述</th>
				</tr>
			</thead>
		</table>	
	</div>

	<script type="text/javascript">
		//注册easyUI中select组件onchange事件
		$(document).ready(function() {
			//注册事件,当用户回车触发查询操作
			document.onkeydown = function(e) {
				var ev = document.all ? window.event : e;
				if (ev.keyCode == 13) {
					search();
				}
			};

		});
	</script>

	<script>	
		
		$(function() {
			initDatebox();
			onSearchIPLoglist();

		});

		function onSearchIPLoglist() {
			var options = $('#ipLogListTbl').datagrid('options');
			options.url = "whiteList.json";
			$('#ipLogListTbl').datagrid('reload', {
				beginDate : $('#beginDate').datebox('getValue'),
				endDate : $('#endDate').datebox('getValue'),
				userNo : $('#userNo').val(),
				operateDetail : $('#operateDetail').val()
			});
		}


		/* function onSearchIPLoglist() {
			$('#ipLogListTbl').datagrid('load', {
				beginDate : $('#beginDate').datebox('getValue'),
				endDate : $('#endDate').datebox('getValue'),
				userNo : $('#userNo').val(),
				operateDetail : $('#operateDetail').val()
			});
		}
 */
		//重置
		function reset() {
			$('#userNo').textbox('setValue', '');
			$('#operateDetail').textbox('setValue', '');
			initDatebox();
		}

		function initDatebox() {
			//默认日期
			var curr_time = new Date();
			var beginDate = curr_time.getFullYear() + "-";
			beginDate += curr_time.getMonth() + "-";
			beginDate += curr_time.getDate() + 1 + "-";
			beginDate += curr_time.getHours() + ":";
			beginDate += curr_time.getMinutes() + ":";
			beginDate += curr_time.getSeconds();
			var endDate = curr_time.getFullYear() + "-";
			endDate += curr_time.getMonth() + 1 + "-";
			endDate += curr_time.getDate() + "-";
			endDate += curr_time.getHours() + ":";
			endDate += curr_time.getMinutes() + ":";
			endDate += curr_time.getSeconds();
			$("#beginDate").datebox("setValue", beginDate);
			$("#endDate").datebox("setValue", endDate);
		}
	</script>
	
	
</body>
</html>