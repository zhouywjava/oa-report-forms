<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../common.jsp"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>账号管理</title>

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
	<div id="spaccHeader" class="pageHeader hiddenDiv"
		style="height: 70px; padding-top: 10px;">
		<div style="margin-left: 8px">
			短信供应商： <input id="SPSupplierQuery" class="easyui-textbox"
				style="width: 100px;"
				data-options="required:false,validType:'maxLength[20]'"> 
			账号：<input id="SPAccNoQuery" class="easyui-textbox" style="width: 100px;"
				data-options="required:false,validType:'maxLength[20]'">
			账号类型： <select id="spAccTypeQuery" class="easyui-combobox"
				style="width: 105px;" editable="false" panelHeight="auto">
				<option value="" selected="selected">全部</option>
				<c:forEach var="spAccTypeMap" items="${spAccTypeMap}">
					<option value="${spAccTypeMap.key}">${spAccTypeMap.value}</option>
				</c:forEach>
			</select> 
			状态： <select id="statusQuery" class="easyui-combobox"
				style="width: 105px;" editable="false" panelHeight="auto">
				<option value="" selected="selected">全部</option>
				<c:forEach var="statusMap" items="${statusMap}">
					<option value="${statusMap.key}">${statusMap.value}</option>
				</c:forEach>
			</select> <a onclick="javascript:searchAcc();" class="easyui-linkbutton"
				iconCls="icon-search">查询</a> <a onclick="javascript:reset();"
				class="easyui-linkbutton" iconCls="icon-reset">重置</a>
		</div>
		<!--按钮权限控制  -->
		<div class="pageToolbar">
			<!-- 由于'查看'操作无需权限控制 对所有人开放 -->
			<shiro:hasPermission name="system:spacc:view">  
	        	<a onclick="javascript:view();" class="easyui-linkbutton"
	        	    iconCls="icon-view" plain="true">查看</a> 
	        </shiro:hasPermission>
			<shiro:hasPermission name="system:spacc:add">
				<a onclick="javascript:createAcc();" class="easyui-linkbutton"
					iconCls="icon-add" plain="true">添加</a>
			</shiro:hasPermission>
			<shiro:hasPermission name="system:spacc:edit">
				<a onclick="javascript:editAcc();" class="easyui-linkbutton"
					iconCls="icon-edit" plain="true">编辑</a>
			</shiro:hasPermission>
			<shiro:hasPermission name="system:spacc:enable">
				<a onclick="javascript:enableAcc();" class="easyui-linkbutton"
					iconCls="icon-ok" plain="true">启用</a>
			</shiro:hasPermission>
			<shiro:hasPermission name="system:spacc:disable">
				<a onclick="javascript:disableAcc();" class="easyui-linkbutton"
					iconCls="icon-cancel" plain="true">停用</a>
			</shiro:hasPermission>
		</div>
	</div>
	<!--查询列表  -->
	<div class="hiddenDiv" style="width: 100%; height: 100%;">
		<table id="AccTable" class="easyui-datagrid"
			toolbar="#spaccHeader" singleSelect="true" fitColumns="true"
			rownumbers="true" fit="true" pagination="true" collapsible="true"
			autoRowHeight="true" idField="accId">
			<thead>
				<tr>
					<!-- <th field="id" width="10">用户编号</th> -->
					<th data-options="field:'accNo'" width="5%">账号</th>
					<th data-options="field:'accPro'" width="5%">短信供应商</th>
					<th data-options="field:'accPwd'" width="5%">密码</th>
					<th data-options="field:'accType'" width="5%">账号类型</th>
					<th data-options="field:'accRate'" width="5%">费率</th>
					<th data-options="field:'accStatus'" width="5%">状态</th>
					<th data-options="field:'accCode'" width="8%">业务代码</th>
					<th data-options="field:'creater'" width="5%">录入操作员</th>
					<th data-options="field:'creTime'" width="10%" formatter="XypayCommon.TimeFormatter">录入时间</th>
					<th data-options="field:'modifier'" width="5%">更新人员</th>
					<th data-options="field:'modTime'" width="10%" formatter="XypayCommon.TimeFormatter">最后更新时间</th>
				</tr>
			</thead>
		</table>
	</div>
	<!--用户资源区-->
	<div id="spaccResourceDlg" class="easyui-dialog hiddenDiv"
		style="width: 400px; height: 420px; padding: 10px 20px;" closed="true"
		buttons="#spaccResourceDlg-buttons">
		<form class="dlgForm" id="spaccResourceForm" method="post">
			<div class="dlgFormItem" id="accIdDiv">
				<label style="text-align: right; width: 90px">账号ID</label> <input
					class="easyui-textbox" type="text" name="accId" id="accId" 
			    ></input>
			</div>
				<div class="dlgFormItem">
				<label style="text-align: right; width: 90px">账号</label> <input
					class="easyui-textbox" type="text" name="accNo" id="accNo" 
					data-options="required:true,validType:'maxLength[20]'"></input>
			</div>
			<div class="dlgFormItem">
				<label style="text-align: right; width: 90px">短信供应商</label> <input
					class="easyui-textbox" type="text" name="accPro" id="accPro" 
					data-options="required:true,validType:'maxLength[20]'"></input>
			</div>	
			<div class="dlgFormItem">
				<label style="text-align: right; width: 90px">密码</label> <input
					class="easyui-textbox" type="text" name="accPwd" id="accPwd" 
					data-options="required:true,validType:'maxLength[32]'"></input>
			</div>
			<div class="dlgFormItem">
				<label style="text-align: right; width: 90px">账号类型</label> <select
					name="accType" id = "accType" class="easyui-combobox"
					style="width: 105px;" editable="false" panelHeight="auto">
					<c:forEach var="spAccTypeMap" items="${spAccTypeMap}">
						<option value="${spAccTypeMap.key}">${spAccTypeMap.value}</option>
					</c:forEach>
				</select>
			</div>
			<div class="dlgFormItem">
				<label style="text-align: right; width: 90px">费率</label>
				 <input class="easyui-numberbox" type="text" name="accRate" id="accRate" 
					data-options="required:true"  missingMessage="费率不能超过合理值0.01-9.99"  min="0.01" max="9.99" precision="2"></input>
			</div>
			<div class="dlgFormItem">
				<label style="text-align: right; width: 90px">业务代码</label>
				 <input class="easyui-textbox" type="text" name="accCode" id="accCode" 
					data-options="required:false,validType:'maxLength[50]'"></input>
			</div>
			<div class="dlgFormItem">
				<label style="text-align: right; width: 90px">发送短信url</label>
				 <input class="easyui-textbox" type="text" name="accSendurl" id="accSendurl" 
					data-options="required:false,validType:'maxLength[200]'"></input>
			</div>
		</form>
	</div>
	<div id="spaccResourceDlg-buttons" class="hiddenDiv">
		<a onclick="javascript:saveAcc()" class="easyui-linkbutton c6"
			iconCls="icon-ok" style="width: 90px">保存</a> <a
			class="easyui-linkbutton" iconCls="icon-cancel"
			onclick="javascript:$('#spaccResourceDlg').dialog('close')"
			style="width: 90px">取消</a>
	</div>
	<div id="viewResourceDlg" class="easyui-dialog hiddenDiv"
		style="width: 400px; height: 450px; padding: 10px 20px;" closed="true"
		buttons="viewResourceDlg-buttons">
		<form class="dlgForm" id="viewResourceForm" method="post"
			novalidate>
			<div class="dlgFormItem">
				<label style="text-align: right; width: 90px"">发送URL</label> <input
					class="easyui-textbox" type="text" disabled="true"
					id="viewAccSendurl"></input>
			</div>
		</form>
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
			//初始化查询
			search();			
		});

		function search() {
			var options = $('#AccTable').datagrid('options');
			options.url = "spaccPage.json";
			$('#AccTable').datagrid('reload', {
				SPSupplier : $('#SPSupplierQuery').val(),
				SPAccNo : $('#SPAccNoQuery').val(),
				status : $('#statusQuery').combobox('getValue'),
				SPAccType : $('#spAccTypeQuery').combobox('getValue')
			});
		}

		function searchAcc() {
			$('#AccTable').datagrid('load', {
				SPSupplier : $('#SPSupplierQuery').val(),
				SPAccNo : $('#SPAccNoQuery').val(),
				status : $('#statusQuery').combobox('getValue'),
				SPAccType : $('#spAccTypeQuery').combobox('getValue'),
			});
		}

		function reset() {
			$('#SPSupplierQuery').textbox('setValue', '');
			$('#statusQuery').combobox('setValue', '');
			$('#SPAccNoQuery').textbox('setValue', '');
			$('#spAccTypeQuery').combobox('setValue', '');
		}
		function enableAcc() {
			var obj = $('#AccTable');
			var rows = obj.datagrid('getSelections');
			if (XypayCommon.getSelectRowCurPage(obj) == false) {
				XypayCommon.MessageAlert('提示', '请选择一条信息!', 'warning');
				return;
			}
			var row = rows[0];
			//alert(JSON.stringify(row));
			if (row.accStatus == '启用') {
				XypayCommon.MessageAlert('提示', '该条账号信息已经启用!', 'warning');
				return;
			}
			$.messager.confirm('确认', '确定要启用该条账号信息?', function(r) {
				if (r) {
					$.post('spacc/enable', {
						accId : row.accId
					}, function(result) {
						result = XypayCommon.toJson(result);
						if (result.success) {
							$('#AccTable').datagrid('reload'); // reload the user data
							XypayCommon.MessageAlert('提示', '操作成功!', 'info');
						} else {
							XypayCommon.MessageAlert('提示', result.msg,
									'warning');
						}
					}, 'json');
				}
			});
		};
		function disableAcc() {
			var obj = $('#AccTable');
			var rows = obj.datagrid('getSelections');
			if (XypayCommon.getSelectRowCurPage(obj) == false) {
				XypayCommon.MessageAlert('提示', '请选择一条信息!', 'warning');
				return;
			}

			var row = rows[0];

			if (row.accStatus == '停用') {
				XypayCommon.MessageAlert('提示', '该条账号信息已经停用!', 'warning');
				return;
			}
           // alert(JSON.stringify(row));
			$.messager.confirm('确认', '确定要停用该账号信息?', function(r) {
				if (r) {
					$.post('spacc/disable', {
						accId : row.accId
					}, function(result) {
						result = XypayCommon.toJson(result);
						if (result.success) {
							$('#AccTable').datagrid('reload'); // reload the user data
							XypayCommon.MessageAlert('提示', '操作成功!', 'info');
						} else {
							XypayCommon.MessageAlert('提示', result.msg,
									'warning');
						}
					}, 'json');
				}
			});
		}

		function createAcc() {
			$("#spaccResourceDlg").dialog({
				title : "新增",
				closed : false,
				top : 0,
				width : 400,
				height : 300,
				modal : true
			});
			//隐藏UI
			$('#accIdDiv').hide();			
			//不可编辑UI 开启
			$('#accNo').textbox('enable', true);
			$('#accPro').textbox('enable', true);
			$('#spaccResourceForm').form('clear');
			/**初始化参数*/
			$("#accType").combobox('select',
			$('#accType').combobox('getData')[0].value);

			url = "spacc/add";
		}

		function saveAcc() {
			XypayCommon.genCsrfToken($('#spaccResourceForm'));
			$('#spaccResourceForm').form('submit', {
				url : url,
				onSubmit : function() {
					return $(this).form('validate');
				},
				success : function(result) {
					result = XypayCommon.toJson(result);
					if (result.success) {
						$('#spaccResourceDlg').dialog('close'); // close the dialog
						$('#AccTable').datagrid('reload'); // reload the user data	
						XypayCommon.MessageAlert('提示', '操作成功!', 'info');
					} else {
						XypayCommon.MessageAlert('提示', result.msg, 'error');
					}
				}
			});
		}

		function editAcc() {
			var obj = $('#AccTable');
			var rows = obj.datagrid('getSelections');
			if (XypayCommon.getSelectRowCurPage(obj) == false) {
				XypayCommon.MessageAlert('提示', '请选择一条信息!', 'warning');
				return;
			}
			var row = rows[0];
			//停用状态不允许编辑
			//alert(JSON.stringify(row));
			if (row.accStatus == '停用') {
				XypayCommon.MessageAlert('提示', '停用状态不允许编辑!', 'warning');
				return;
			}
			//显示form表单
			//showFormUI();
			//不可编辑UI accPro
			$('#accNo').textbox('disable', true);
			$('#accPro').textbox('disable', true);	
			//隐藏UI
			$('#accIdDiv').hide();
			if (row) {
				$("#spaccResourceDlg").dialog({
					title : "编辑",
					closed : false,
					top : 0,
					width : 400,
					height : 300,
					modal : true
				});	
				$('#spaccResourceForm').form('clear');
				$.get("getAccResourceById.json", {
					id : row.accId
				}, function(data) {
					data = XypayCommon.toJson(data);
					//alert(JSON.stringify(data));
					//alert(JSON.stringify(data.accType));
					$('#spaccResourceForm').form('load', data);
					$('#accId').textbox('setValue',data.accAccid);
					$('#accNo').textbox('setValue',data.accAccno);
			    	$('#accPro').textbox('setValue',data.accPro);
			    	$('#accPwd').textbox('setValue',data.accPwd);
			    	$('#accType').combobox('setValue',data.accType?data.accType:'');
			    	$('#accRate').textbox('setValue',data.accRate);
			    	$('#accCode').textbox('setValue',data.accCode);
			    	$('#accSendurl').textbox('setValue',data.accSendurl);
				});
				url = "spacc/edit";
			}
		}
		 function view() {
				var obj = $('#AccTable');
				var rows = obj.datagrid('getSelections');
				if (XypayCommon.getSelectRowCurPage(obj) == false) {
					XypayCommon.MessageAlert('提示', '请选择一条信息!', 'warning');
					return;
				}
				if(rows.length>1){
					XypayCommon.MessageAlert('提示', '请只选择一条需要查看的信息!', 'warning');
					return;
				}
				var row = rows[0];
				if (row) {
					$("#viewResourceDlg").dialog({
						title : "查看",
						closed : false,
						top : 0,
						width : 400,
						height : 150,
						modal : true
					});

					$('#viewResourceDlg').form('clear');
					//alert(JSON.stringify(row));
					$.get("getAccResourceById.json", {
						id : row.accId 
					}, function(data) {
						data = XypayCommon.toJson(data);
						//alert(JSON.stringify(data));
						$('#viewResourceForm').form('load', data);
						$('#viewAccSendurl').textbox('setValue', data.accSendurl);
					});
				}
			};
	</script>

</body>
</html>