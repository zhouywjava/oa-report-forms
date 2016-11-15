<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../common.jsp"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>账号对账</title>

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
	<div id="Header" class="pageHeader hiddenDiv"
		style="height: 70px; padding-top: 10px;">
		<div style="margin-left: 8px">
			短信供应商： <input id="SPSupplierQuery" class="easyui-textbox"
				style="width: 100px;"
				data-options="required:false,validType:'maxLength[20]'"> 
			账号：<input id="SPAccNoQuery" class="easyui-textbox" style="width: 100px;"
				data-options="required:false,validType:'maxLength[20]'">
			账号类型： <select id="SPAccTypeQuery" class="easyui-combobox"
				style="width: 105px;" editable="false" panelHeight="auto">
				<option value="" selected="selected">全部</option>
				<c:forEach var="cstAccTypeMap" items="${cstAccTypeMap}">
					<option value="${cstAccTypeMap.key}">${cstAccTypeMap.value}</option>
				</c:forEach>
			</select> 
			 开始时间：<input id="beginDate" class="easyui-datebox" style="width:100px" onchange="javascript:" editable="false">
             <label style=" text-align:left;margin-left:15px">到：</label>
             <input id="endDate" class="easyui-datebox" style="width:100px" editable="false">
			
			<a onclick="javascript:searchCondition();getTotal();" class="easyui-linkbutton"
				iconCls="icon-search">查询</a> <a onclick="javascript:reset();"
				class="easyui-linkbutton" iconCls="icon-reset">重置</a>
		</div>
		<!--总计  -->
		<div class="pageToolbar">
			<div class="dlgFormItem" id="totalCountDiv">
				<label style="text-align: right; width: 90px;color:#ff0000;">总计：</label> <label
					id="total" style="text-align: left; width: 90px;color:#ff0000;"></label>
			</div>
		</div>
	</div>
	<!--查询列表  -->
	<div class="hiddenDiv" style="width: 100%; height: 100%;">
		<table id="Table" class="easyui-datagrid"
			toolbar="#Header" singleSelect="true" fitColumns="true"
			rownumbers="true" fit="true" pagination="true" collapsible="true"
			autoRowHeight="true" idField="id">
			<thead>
				<tr>
					<!-- <th field="id" width="10">用户编号</th> -->
					<th data-options="field:'accNo'" width="5%">账号</th>
					<th data-options="field:'accPro'" width="8%">短信供应商</th>
					<th data-options="field:'accType'" width="5%">账号类型</th>
					<th data-options="field:'accRate'" width="5%">费率</th>
					<th data-options="field:'sucNum'" width="5%">成功条数</th>
					<th data-options="field:'amt'" width="5%">金额</th>					
				</tr>
			</thead>
		</table>
	</div>
	<script type="text/javascript">
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
		//点击'用户管理'菜单即加载查询数据
		$(function() {
			//初始化条件
			init();
			//初始化查询
			search();			
		});

		function search() {
			var options = $('#Table').datagrid('options');
			options.url = "cstAccCheckPage.json";
			$('#Table').datagrid('reload', {
				SPSupplierQuery : $('#SPSupplierQuery').val(),
				SPAccNoQuery : $('#SPAccNoQuery').val(),				
				SPAccTypeQuery : $('#SPAccTypeQuery').combobox('getValue'),
				beginDate:$('#beginDate').datebox('getValue'),
	        	endDate:$('#endDate').datebox('getValue')
			});
			getTotal();
		};

		function searchCondition() {
			$('#Table').datagrid('load', {
				SPSupplierQuery : $('#SPSupplierQuery').val(),
				SPAccNoQuery : $('#SPAccNoQuery').val(),
				SPAccTypeQuery : $('#SPAccTypeQuery').combobox('getValue'),
				beginDate:$('#beginDate').datebox('getValue'),
	        	endDate:$('#endDate').datebox('getValue')
			});
			getTotal();
		};

		function reset() {
			$('#SPSupplierQuery').textbox('setValue', '');
			$('#SPAccNoQuery').textbox('setValue', '');
			$('#SPAccTypeQuery').combobox('setValue', '');
			$('#beginDate').datebox('setValue', '');
        	$('#endDate').datebox('setValue', '');
        	init();
		};
		
		function getTotal(){
			$.get('acccheck/getTotal', {
				SPSupplierQuery : $('#SPSupplierQuery').val(),
				SPAccNoQuery : $('#SPAccNoQuery').val(),
			    SPAccTypeQuery : $('#SPAccTypeQuery').combobox('getValue'),
			    beginDate : $('#beginDate').datebox('getValue'),
			    endDate: $('#endDate').datebox('getValue')	
			}, function(data) {
				$('#total').html(data);
			}, 'json');
		};
	</script>
	<script type="text/javascript">
	function init(){
		//默认日期
		var curr_time = new Date();
	   	var beginDate = curr_time.getFullYear()+"-";
	   	    beginDate += curr_time.getMonth()+"-";
		    beginDate += curr_time.getDate()+"-";
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
	</script>	
	

</body>
</html>