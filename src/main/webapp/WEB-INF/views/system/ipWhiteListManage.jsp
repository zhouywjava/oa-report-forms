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
			<label style="text-align: right">IP：</label> <input id="ipNo"
				class="easyui-textbox" style="width: 100px" editable="true">
				<label style="text-align: right">客户编号：</label> <input id="cstNo"
				class="easyui-textbox" style="width: 100px" editable="true">
			
			<label style="text-align: right">状态：</label> <select id="statusQuery" class="easyui-combobox"
				style="width: 105px;" editable="true" panelHeight="auto">
				<option value="" selected="selected">全部</option>
				<c:forEach var="iplistStatusType" items="${ipWhiteStatusMap}">
					<option value="${iplistStatusType.key}">${iplistStatusType.value}</option>
				</c:forEach>
			</select> <a onclick="javascript:onSearchIPWhitelist();"
				class="easyui-linkbutton" iconCls="icon-search">查询</a> <a
				onclick="javascript:reset();" class="easyui-linkbutton"
				iconCls="icon-reset">重置</a>
		</div>
		<div class="pageToolbar">
			<!-- 由于'查看'操作无需权限控制 对所有人开放 -->

			<shiro:hasPermission name="system:ipwhite:add">
				<a onclick="javascript:createIplist();" class="easyui-linkbutton"
					iconCls="icon-add" plain="true">添加</a>
			</shiro:hasPermission>
			<shiro:hasPermission name="system:ipwhite:edit">
				<a onclick="javascript:editWhilst();" class="easyui-linkbutton"
					iconCls="icon-edit" plain="true">编辑</a>
			</shiro:hasPermission>
			
			<shiro:hasPermission name="system:ipwhite:disable">
				<a onclick="javascript:disableWhiteList();"
					class="easyui-linkbutton" iconCls="icon-cancel" plain="true">停用</a>
			</shiro:hasPermission>
			
			<shiro:hasPermission name="system:ipwhite:start">
				<a onclick="javascript:startIpList();" class="easyui-linkbutton"
					iconCls="icon-ok" plain="true">启用</a>
			</shiro:hasPermission>
		</div>
	</div>

	<div class="hiddenDiv" style="width: 100%; height: 100%;">
		<table id="ipWhiteListTbl" class="easyui-datagrid"
			toolbar="#ipWhiteListHeader" singleSelect="true" fitColumns="true"
			rownumbers="true" fit="true" pagination="true" collapsible="true"
			autoRowHeight="true" idField="whiteListId">
			<thead>
				<tr>
					<th data-options="field:'ipWhi'" width="10%">IP</th>
					<th data-options="field:'cstCstno'" width="10%">客户编号</th>
					<th data-options="field:'cstName'" width="10%">客户名称</th>
					<th data-options="field:'status'" width="10%">状态</th>
				</tr>
			</thead>
		</table>
	</div>

	<div id="addWhitelistDlg" align="ce" class="easyui-dialog hiddenDiv"
		style="width: 400px; height: 250px; padding: 10px 20px;" closed="true"
		buttons="#addWhiltelistDlg-buttons">
		<form class="dlgForm" id="addWhiteListForm" method="post">
			<div>
				<div class="dlgFormItem">
					<label style="text-align: right">IP：</label> <input
						class="easyui-textbox" name="ipNoEdit" id="ipNoEdit"
						style="width: 165px; height: 50px"
						data-options="required:true,validType:'maxLength[200]'"></input>
				</div>
				<div class="dlgFormItem">
					<label style="text-align: right">客户编号：</label> <select
						name="userNoLst" id="userNoLst" class="easyui-combobox" height="200px" overflow="auto"
						style="width: 105px;" editable="true" required="true"
						>
						<c:forEach var="userNoList" items="${userNoMap}">
							<option value="${userNoList.key}">${userNoList.key}</option>
						</c:forEach>
					</select>
				</div>
				<div class="dlgFormItem">
					<label style="text-align: right">客户名称：</label> <input
						class="easyui-textbox" type="text" name="userNameList"
						id="userNameList" editable="ture"
						data-options="validType:'maxLength[200]'"></input>
				</div>
			</div>
		</form>
	</div>


	<div id="addWhiltelistDlg-buttons" class="hiddenDiv"
		style="text-align: center">
		<a onclick="javascript:saveWhiteList()" class="easyui-linkbutton c6"
			iconCls="icon-ok" style="width: 90px">保存</a> <a
			class="easyui-linkbutton" iconCls="icon-cancel"
			onclick="javascript:$('#addWhitelistDlg').dialog('close')"
			style="width: 90px">取消</a>
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
			onSearchIPWhitelist();
		});

		function onSearchIPWhitelist() {
			var options = $('#ipWhiteListTbl').datagrid('options');
			
			options.url = "ipwhitelist.json";
			$('#ipWhiteListTbl').datagrid('reload', {
				ipNo : $('#ipNo').val(),
				userNo : $('#cstNo').val(),
				statusQuery : $('#statusQuery').combobox('getValue')
			});
		}

		//重置
		function reset() {
			$('#ipNo').textbox('setValue', '');
			$('#cstNo').textbox('setValue', '');
			$('#statusQuery').combobox('setValue', '');
		}

		function createIplist() {
			$('#addWhitelistDlg').dialog({
				title : "添加",
				closed : false,
				top : 0,
				width : 400,
				height : 250,
				modal : true
			});

			$('#addWhiteListForm').form('clear');
			$('#userNoLst').combobox('setValue', "");
			$('#userNameList').textbox('setValue', "");
			$('#ipNoEdit').textbox('setValue', "");

			$('#userNoLst').combobox({
				valueField : 'itemCode',
				textField : 'itemName',
				onSelect : function(params) {
					$.get('whitelist/changeUserNo', {
						userNoLst : params.itemCode
					}, function(data) {
						$('#userNameList').textbox("setValue", data);
					}, 'json');
				}
			});
			url = "whitelist/add";
		}

		function saveWhiteList() {
			url: url, XypayCommon.genCsrfToken($('#addWhiteListForm'));
			$('#addWhiteListForm').form('submit', {
				url : url,
				onSubmit : function() {
					return $(this).form('validate');
				},
				success : function(result) {
					result = XypayCommon.toJson(result);
					if (result.success) {
						$('#addWhitelistDlg').dialog('close'); // close the dialog
						$('#ipWhiteListTbl').datagrid('reload'); // reload the user data	
						XypayCommon.MessageAlert('提示', '保存成功!', 'info');
					} else {
						XypayCommon.MessageAlert('提示', result.msg, 'error');
					}
				}
			});
		}

		function startIpList() {

			var obj = $('#ipWhiteListTbl');
			var rows = obj.datagrid('getSelections');
			if (XypayCommon.getSelectRowCurPage(obj) == false) {
				XypayCommon.MessageAlert('提示', '请选择一条信息!', 'warning');
				return;
			}
			var row = rows[0];

			if (row.status == '启用') {
				XypayCommon.MessageAlert('提示', '该条IP白名单信息已经启用!', 'warning');
				return;
			}

			$.messager.confirm('确认', '确定要启用该条IP白名单信息?', function(r) {
				if (r) {
					$.post('white/start', {
						whiteListId : row.whiteListId
					}, function(result) {
						result = XypayCommon.toJson(result);
						if (result.success) {
							$('#ipWhiteListTbl').datagrid('reload'); // reload the user data
							XypayCommon.MessageAlert('提示', '操作成功!', 'info');
						} else {
							XypayCommon.MessageAlert('提示', result.msg,
									'warning');
						}
					}, 'json');
				}
			});
		}

		function disableWhiteList() {

			var obj = $('#ipWhiteListTbl');
			var rows = obj.datagrid('getSelections');
			if (XypayCommon.getSelectRowCurPage(obj) == false) {
				XypayCommon.MessageAlert('提示', '请选择一条信息!', 'warning');
				return;
			}
			var row = rows[0];

			if (row.status == '停用') {
				XypayCommon.MessageAlert('提示', '该条IP白名单信息已经停用!', 'warning');
				return;
			}

			$.messager.confirm('确认', '确定要停用该条IP白名单信息?', function(r) {
				if (r) {
					$.post('white/disable', {
						whiteListId : row.whiteListId
					}, function(result) {
						result = XypayCommon.toJson(result);
						if (result.success) {
							$('#ipWhiteListTbl').datagrid('reload'); // reload the user data
							XypayCommon.MessageAlert('提示', '操作成功!', 'info');
						} else {
							XypayCommon.MessageAlert('提示', result.msg,
									'warning');
						}
					}, 'json');
				}
			});
		}

		function editWhilst() {
			var obj = $('#ipWhiteListTbl');
			var rows = obj.datagrid('getSelections');
			//alert(JSON.stringify(rows));
			if (XypayCommon.getSelectRowCurPage(obj) == false) {
				XypayCommon.MessageAlert('提示', '请选择一条信息!', 'warning');
				return;
			}
			var row = rows[0];
			//停用状态不允许编辑

			if (row.status == '停用') {
				XypayCommon.MessageAlert('提示', '停用状态不允许编辑!', 'warning');
				return;
			}
			//显示form表单
			//隐藏UI
			$('#channelIdDiv').hide();
			if (row) {
				$('#addWhitelistDlg').dialog({
					title : "编辑",
					closed : false,
					top : 0,
					width : 400,
					height : 250,
					modal : true
				});
				$('#userNoLst').combobox({
					valueField : 'itemCode',
					textField : 'itemName',
					onSelect : function(params) {
						$.get('whitelist/changeUserNo', {
							userNoLst : params.itemCode
						}, function(data) {
							$('#userNameList').textbox("setValue", data);
						}, 'json');
					}
				});

				$('#addWhiteListForm').form('clear');
				$.get("whitelist/getipwhiteListById.json", {
					id : row.whiteListId
				}, function(data) {
					data = XypayCommon.toJson(data);

					$('#addWhiteListForm').form('load', data);
					$('#ipNoEdit').textbox('setValue', data.ipWhi);
					$('#userNoLst').combobox('setValue',
							data.cstCstno ? data.cstCstno : '');
					$('#userNameList').textbox('setValue', data.cstName);

				});
				url = "white/edit?id=" + row.whiteListId;
			}
		}
	</script>


</body>
</html>