<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../common.jsp"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>客户账户管理</title>

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
			账户号： <input id="cstAccNoQuery" class="easyui-textbox"
				style="width: 100px;"
				data-options="required:false,validType:'maxLength[20]'"> 
			客户名称：<input id="cstNameQuery" class="easyui-textbox" style="width: 100px;"
				data-options="required:false,validType:'maxLength[20]'">
			账户类型： <select id="cstAccTypeQuery" class="easyui-combobox"
				style="width: 105px;" editable="false" panelHeight="auto">
				<option value="" selected="selected">全部</option>
				<c:forEach var="cstAccTypeMap" items="${cstAccTypeMap}">
					<option value="${cstAccTypeMap.key}">${cstAccTypeMap.value}</option>
				</c:forEach>
			</select> 
			状态： <select id="statusQuery" class="easyui-combobox"
				style="width: 105px;" editable="false" panelHeight="auto">
				<option value="" selected="selected">全部</option>
				<c:forEach var="statusMap" items="${statusMap}">
					<option value="${statusMap.key}">${statusMap.value}</option>
				</c:forEach>
			</select> <a onclick="javascript:searchCondition();" class="easyui-linkbutton"
				iconCls="icon-search">查询</a> <a onclick="javascript:reset();"
				class="easyui-linkbutton" iconCls="icon-reset">重置</a>
		</div>
		<!--按钮权限控制  -->
		<div class="pageToolbar">
			<!-- 由于'查看'操作无需权限控制 对所有人开放 -->
			<shiro:hasPermission name="join:cstaccinf:add">
				<a onclick="javascript:create();" class="easyui-linkbutton"
					iconCls="icon-add" plain="true">添加</a>
			</shiro:hasPermission>
			<shiro:hasPermission name="join:cstaccinf:edit">
				<a onclick="javascript:edit();" class="easyui-linkbutton"
					iconCls="icon-edit" plain="true">编辑</a>
			</shiro:hasPermission>
			<shiro:hasPermission name="join:cstaccinf:enable">
				<a onclick="javascript:enable();" class="easyui-linkbutton"
					iconCls="icon-ok" plain="true">激活</a>
			</shiro:hasPermission>
			<shiro:hasPermission name="join:cstaccinf:disable">
				<a onclick="javascript:disable();" class="easyui-linkbutton"
					iconCls="icon-cancel" plain="true">冻结</a>
			</shiro:hasPermission>
			<shiro:hasPermission name="join:cstaccinf:remove">  
	        	<a onclick="javascript:removeAction();" class="easyui-linkbutton" iconCls="icon-remove" plain="true">注销</a> 
	        </shiro:hasPermission> 
		</div>
	</div>
	<!--查询列表  -->
	<div class="hiddenDiv" style="width: 100%; height: 100%;">
		<table id="Table" class="easyui-datagrid"
			toolbar="#Header" singleSelect="true" fitColumns="true"
			rownumbers="true" fit="true" pagination="true" collapsible="true"
			autoRowHeight="true" idField="cstAccNo">
			<thead>
				<tr>
					<!-- <th field="id" width="10">用户编号</th> -->
					<th data-options="field:'cstAccNo'" width="5%">账户号</th>
					<th data-options="field:'cstAccType'" width="4%">账户类型</th>
					<th data-options="field:'cstCstno'" width="5%">客户编号</th>
					<th data-options="field:'cstName'" width="8%">客户名称</th>
					<th data-options="field:'cstAccNum'" width="5%">子短号</th>
					<th data-options="field:'cstAccSign'" width="5%">附加签名</th>
					<th data-options="field:'cstAccRate'" width="3%">费率</th>
					<th data-options="field:'cstAccStatus'" width="3%">状态</th>
					<th data-options="field:'cstAccSpaccid'" width="5%">主账号</th>
					<th data-options="field:'accBalLast'" width="5%">客户余量</th>
					<th data-options="field:'cstAccMax'" width="5%">每日限额</th>
					<th data-options="field:'cstAccCre'" width="5%">录入操作员</th>
					<th data-options="field:'cstAccCretime'" width="10%" formatter="XypayCommon.TimeFormatter">录入时间</th>
					<th data-options="field:'cstAccModify'" width="8%">最后更新人员</th>
					<th data-options="field:'cstAccModtime'" width="10%" formatter="XypayCommon.TimeFormatter">最后更新时间</th>
				</tr>
			</thead>
		</table>
	</div>
	<!--用户资源区-->
	<div id="ResourceDlg" class="easyui-dialog hiddenDiv"
		style="width: 400px; height: 420px; padding: 10px 20px;" closed="true"
		buttons="#ResourceDlg-buttons">
		<form class="dlgForm" id="ResourceForm" method="post">
			<div class="dlgFormItem" id="cstAccIdDiv">
				<label style="text-align: right; width: 90px">账户号ID</label> <input
					class="easyui-textbox" type="text" name="cstAccId" id="cstAccId" 
			    ></input>
			</div>
			<div class="dlgFormItem" id="cstAccNoDiv">
				<label style="text-align: right; width: 90px">账户号</label> <input
					class="easyui-textbox" type="text" name="cstAccNo" id="cstAccNo" 
					></input>
			</div>
			<div class="dlgFormItem">
				<label style="text-align: right; width: 90px">账户类型</label> <select
					name="cstAccType" id = "cstAccType" class="easyui-combobox"
					style="width: 105px;" editable="false" panelHeight="auto">
					<c:forEach var="cstAccTypeMap" items="${cstAccTypeMap}">
						<option value="${cstAccTypeMap.key}">${cstAccTypeMap.value}</option>
					</c:forEach>
				</select>
			</div>
			<div class="dlgFormItem">
				<label style="text-align: right; width: 90px">客户名称</label> <select
					id="cstAccCstid" name="cstAccCstid" class="easyui-combobox" height="200px" overflow="auto" 
					style="width: 165px;" editable="false"
					requird="true" validType="selectValueRequired">
					<option value="" selected="selected">请选择</option>
					 <c:forEach var="cstAccInfMap" items="${cstAccInfMap}">
						<option value="${cstAccInfMap.key}">${cstAccInfMap.value}</option>
					</c:forEach> 
				</select>
			</div>
			<div class="dlgFormItem">
				<label style="text-align: right; width: 90px">附加签名</label>
				 <input class="easyui-textbox" type="text" name="cstAccSign" id="cstAccSign" 
					data-options="required:false,validType:'maxLength[50]'"></input>
			</div>
			<div class="dlgFormItem">
				<label style="text-align: right; width: 90px">费率</label>
				 <input class="easyui-numberbox" type="text" name="cstAccRate" id="cstAccRate" 
					data-options="required:true" missingMessage="费率不能超过合理值0.01-9.99" min="0.01" max="9.99" precision="2"></input>
			</div>
			<div class="dlgFormItem">
				<label style="text-align: right; width: 90px">每日限条</label>
				 <input class="easyui-numberbox" type="text" name="cstAccMax" id="cstAccMax" 
					data-options="required:false" min="1" max="99999999" precision="0"></input>
			</div>
			<div class="dlgFormItem">
				<label style="text-align: right; width: 90px">主账号</label> <select
					name="cstId" id = "cstId" class="easyui-combobox"
					style="width: 105px;" editable="false" height="200px" overflow="auto" panelHeight="auto"
					requird="true" validType="selectValueRequired">
					<option value="" selected="selected">请选择</option>
					<c:forEach var="AccInfMap" items="${AccInfMap}">
						<option value="${AccInfMap.key}">${AccInfMap.value}</option>
					</c:forEach>
				</select>
			</div>
			<div class="dlgFormItem">
				<label style="text-align: right; width: 90px">子短号</label>
				 <!-- <input class="easyui-textbox" type="text" name="cstAccNum" id="cstAccNum" 
					data-options="required:false,validType:'number'"></input> -->
				<select name="cstAccNum" id="cstAccNum" editable="false" requird="true" validType="selectValueRequired" class="easyui-combobox"  style="width: 105px;" panelHeight="auto">
	<%-- 			 <option value="" selected="selected">请选择</option>
				 <c:forEach var="data" items="${data}">
				   	<option value="${data.key}">${data.value}</option>
				 </c:forEach> --%>
				</select>
			</div>
		</form>
	</div>
	<div id="ResourceDlg-buttons" class="hiddenDiv">
		<a onclick="javascript:save()" class="easyui-linkbutton c6"
			iconCls="icon-ok" style="width: 90px">保存</a> <a
			class="easyui-linkbutton" iconCls="icon-cancel"
			onclick="javascript:$('#ResourceDlg').dialog('close')"
			style="width: 90px">取消</a>
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
			/**自定义校验类型*/
			$.extend($.fn.validatebox.defaults.rules, {
				selectValueRequired : {
					validator : function(value, param) {
						if (value == "" || value.indexOf('请选择') >= 0) {
							//alert(value);
							return false;
						} else {
							// alert(value);
							return true;
						}
					},
					message : '该下拉框为必选项'
				},
				//子短号验证
				number : {
					validator : function(value) {
						var reg = /^[0-9]\d{0,7}$/;
						return reg.test(value);
					},
					message : '只能输入最多8位数字'
				}
			});
		});
	</script>

	<script>
		//点击'用户管理'菜单即加载查询数据
		$(function() {
			//初始化查询
			search();			
		});

		function search() {
			var options = $('#Table').datagrid('options');
			options.url = "cstaccinfPage.json";
			$('#Table').datagrid('reload', {
				cstAccNoQuery : $('#cstAccNoQuery').val(),
				cstNameQuery : $('#cstNameQuery').val(),
				statusQuery : $('#statusQuery').combobox('getValue'),
				cstAccTypeQuery : $('#cstAccTypeQuery').combobox('getValue')
			});
		};

		function searchCondition() {
			$('#Table').datagrid('load', {
				cstAccNoQuery : $('#cstAccNoQuery').val(),
				cstNameQuery : $('#cstNameQuery').val(),
				statusQuery : $('#statusQuery').combobox('getValue'),
				cstAccTypeQuery : $('#cstAccTypeQuery').combobox('getValue'),
			});
		};

		function reset() {
			$('#cstAccNoQuery').textbox('setValue', '');
			$('#statusQuery').combobox('setValue', '');
			$('#cstNameQuery').textbox('setValue', '');
			$('#cstAccTypeQuery').combobox('setValue', '');
		};
		function enable() {
			var obj = $('#Table');
			var rows = obj.datagrid('getSelections');
			if (XypayCommon.getSelectRowCurPage(obj) == false) {
				XypayCommon.MessageAlert('提示', '请选择一条信息!', 'warning');
				return;
			}
			var row = rows[0];
			//alert(JSON.stringify(row));
			if (row.cstAccStatus != '冻结') {
				XypayCommon.MessageAlert('提示', '非冻结状态!', 'warning');
				return;
			}
			$.messager.confirm('确认', '确定要正常该条客户账户信息?', function(r) {
				if (r) {					
					$.post('cstaccinf/enable', {
						id : row.cstAccNo
					}, function(result) {
						result = XypayCommon.toJson(result);
						if (result.success) {
							$('#Table').datagrid('reload'); // reload the user data
							XypayCommon.MessageAlert('提示', '操作成功!', 'info');
						} else {
							XypayCommon.MessageAlert('提示', result.msg,
									'warning');
						}
					}, 'json');
				}
			});
		};
		function disable() {
			var obj = $('#Table');
			var rows = obj.datagrid('getSelections');
			if (XypayCommon.getSelectRowCurPage(obj) == false) {
				XypayCommon.MessageAlert('提示', '请选择一条信息!', 'warning');
				return;
			}

			var row = rows[0];

			if (row.cstAccStatus != '正常') {
				XypayCommon.MessageAlert('提示', '非正常状态!', 'warning');
				return;
			}

			$.messager.confirm('确认', '确定要冻结该条客户账户信息?', function(r) {
				if (r) {
					$.post('cstaccinf/disable', {
						id : row.cstAccNo
					}, function(result) {
						//alert(JSON.stringify(row));
						result = XypayCommon.toJson(result);
						if (result.success) {
							$('#Table').datagrid('reload'); // reload the user data
							XypayCommon.MessageAlert('提示', '操作成功!', 'info');
						} else {
							XypayCommon.MessageAlert('提示', result.msg,
									'warning');
						}
					}, 'json');
				}
			});
		}

		function create() {
			$("#ResourceDlg").dialog({
				title : "新增",
				closed : false,
				top : 0,
				width : 400,
				height : 350,
				modal : true
			});
			//隐藏UI
			$('#cstAccIdDiv').hide();
			$('#cstAccNoDiv').hide();
			//不可编辑UI 开启
			$('#cstAccType').textbox('enable', true);
			$('#cstAccCstid').textbox('enable', true);
			$('#ResourceForm').form('clear');
			/**初始化参数*/
			$("#cstAccType").combobox('setValue',
			$('#cstAccType').combobox('getData')[0].value);
			$("#cstAccCstid").combobox('setValue',
			$('#cstAccCstid').combobox('getData')[0].value);
			$('#cstAccNum').combobox('loadData', {});
			$('#cstAccNum').combobox('setText',"请选择");
			
			/**主账号关联子短号*/
			$('#cstId').combobox({
				valueField : 'itemCode',
				textField : 'itemName',
				onSelect : function(params) {
					$.get('getCstAccNum.json', {
						accId : params.itemCode
					}, function(data) {
						$('#cstAccNum').combobox({	
							data : data,
							valueField:'chanAccNumMap',
							textField:'chanAccNumMap',
						});
						$('#cstAccNum').combobox('setText',"请选择");
					}, 'json');
				}
			});

			url = "cstaccinf/add";
		}

		function save() {
			XypayCommon.genCsrfToken($('#ResourceForm'));
			$('#ResourceForm').form('submit', {
				url : url,
				onSubmit : function() {
					return $(this).form('validate');
				},
				success : function(result) {
					result = XypayCommon.toJson(result);
					if (result.success) {
						$('#ResourceDlg').dialog('close'); // close the dialog
						$('#Table').datagrid('reload'); // reload the user data	
						XypayCommon.MessageAlert('提示', '操作成功!', 'info');
					} else {
						XypayCommon.MessageAlert('提示', result.msg, 'error');
					}
				}
			});
		}

		function edit() {
			var obj = $('#Table');
			var rows = obj.datagrid('getSelections');
			if (XypayCommon.getSelectRowCurPage(obj) == false) {
				XypayCommon.MessageAlert('提示', '请选择一条信息!', 'warning');
				return;
			}
			var row = rows[0];
			//冻结状态不允许编辑
			//alert(JSON.stringify(row));
			if (row.cstAccStatus == '注销') {
				XypayCommon.MessageAlert('提示', '注销状态不允许编辑!', 'warning');
				return;
			}
			//显示form表单
			//showFormUI();
			//不可编辑UI 
			$('#cstAccNo').textbox('readonly', true);
			$('#cstAccType').textbox('disable', true);
			$('#cstAccCstid').textbox('disable', true);
			//隐藏UI
			$('#cstAccIdDiv').hide();
			if (row) {
				$("#ResourceDlg").dialog({
					title : "编辑",
					closed : false,
					top : 0,
					width : 400,
					height : 350,
					modal : true
				});	
				$('#ResourceForm').form('clear');
				$.post("getCstAccInfResourceById.json", {
					id : row.cstAccNo
				}, function(data) {
					data = XypayCommon.toJson(data);
					//alert(JSON.stringify(data));
					//alert(JSON.stringify(data.accType));
					$('#ResourceForm').form('load', data);					
					//$('#cstAccId').textbox('setValue',data.cstAccId);
					$('#cstAccNo').textbox('setValue',data.cstAccNo);
					$('#cstAccType').combobox('setValue',data.cstAccType?data.cstAccType:'');
					$('#cstAccCstid').combobox('setValue',data.cstAccCstno?data.cstAccCstno:'');
					$('#cstAccNum').combobox('clear');
			    	$('#cstAccNum').combobox('setValue',data.cstAccNum);
			    	$('#cstAccSign').textbox('setValue',data.cstAccSign);			    	
			    	$('#cstAccRate').textbox('setValue',data.cstAccRate);
			    	$('#cstAccMax').textbox('setValue',data.cstAccMax);
			    	$('#cstId').combobox('setValue',data.cstAccSpaccno?data.cstAccSpaccno:'');
				});
				$('#cstAccNum').combobox('loadData', {});
				$('#cstAccNum').combobox('setText',"请选择");
				/**主账号关联子短号*/
				$('#cstId').combobox({
					valueField : 'chanAccNumMapCode',
					textField : 'chanAccNumMapName',
					onSelect : function(params) {
						$.get('getCstAccNum.json', {
							accId : params.chanAccNumMapCode
						}, function(data) {
							$('#cstAccNum').combobox({	
								data : data,
								valueField:'chanAccNumMap',
								textField:'chanAccNumMap',
							});
							$('#cstAccNum').combobox('setText',"请选择");
						}, 'json');
					}
				});
				
				url = "cstaccinf/edit";
			}
		};
function removeAction() {
			
			var obj = $('#Table');
			var rows = obj.datagrid('getSelections');
			if(XypayCommon.getSelectRowCurPage(obj) == false){
				XypayCommon.MessageAlert('提示', '请选择一条信息!','warning');
				return;
			}
			
			var row = rows[0];
			//注销状态不允许编辑
			if(row.cstAccStatus == '注销'){
				XypayCommon.MessageAlert('提示', '注销状态无须注销操作!','warning');
				return;
			}
			
			$.messager.confirm('确认', '确定要注销该信息?', function(r) {
				if (r) {
					//var rowids = XypayCommon.GetIdsFromRow(rows);
					$.post('cstaccinf/remove', {
						id : row.cstAccNo
					}, function(result) {
						result = XypayCommon.toJson(result);
						if (result.success) {
							$('#Table').datagrid('reload'); // reload the user data
							//提示信息
							//XypayCommon.MessageBox('成功', '操作成功!');
							XypayCommon.MessageAlert('提示', '操作成功!','info');
						} else {
							//XypayCommon.MessageBox('错误', result.msg);
							XypayCommon.MessageAlert('提示', result.msg,'warning');
						}
					}, 'json');
				}
			});
		}
	</script>

</body>
</html>