<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../common.jsp"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>通道管理</title>

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
	<div id="ChannelHeader" class="pageHeader hiddenDiv"
		style="height: 70px; padding-top: 10px;">
		<div style="margin-left: 8px">
			短信供应商： <input id="SPSupplierQuery" class="easyui-textbox"
				style="width: 100px;"
				data-options="required:false,validType:'maxLength[20]'"> 
			账号：<input id="SPAccNoQuery" class="easyui-textbox" style="width: 100px;"
				data-options="required:false,validType:'maxLength[20]'">
			通道类型： <select id="channelTypeQuery" class="easyui-combobox"
				style="width: 105px;" editable="false" panelHeight="auto">
				<option value="" selected="selected">全部</option>
				<c:forEach var="channelTypeMap" items="${channelTypeMap}">
					<option value="${channelTypeMap.key}">${channelTypeMap.value}</option>
				</c:forEach>
			</select> 
			状态： <select id="statusQuery" class="easyui-combobox"
				style="width: 105px;" editable="false" panelHeight="auto">
				<option value="" selected="selected">全部</option>
				<c:forEach var="statusMap" items="${statusMap}">
					<option value="${statusMap.key}">${statusMap.value}</option>
				</c:forEach>
			</select> <a onclick="javascript:searchChannel();" class="easyui-linkbutton"
				iconCls="icon-search">查询</a> <a onclick="javascript:reset();"
				class="easyui-linkbutton" iconCls="icon-reset">重置</a>
		</div>
		<!--按钮权限控制  -->
		<div class="pageToolbar">
			<!-- 由于'查看'操作无需权限控制 对所有人开放 -->
			<a onclick="javascript:view();" class="easyui-linkbutton"
				iconCls="icon-view" plain="true">查看详情</a>
			<shiro:hasPermission name="system:channel:add">
				<a onclick="javascript:createChannel();" class="easyui-linkbutton"
					iconCls="icon-add" plain="true">添加</a>
			</shiro:hasPermission>
			<shiro:hasPermission name="system:channel:edit">
				<a onclick="javascript:editChannel();" class="easyui-linkbutton"
					iconCls="icon-edit" plain="true">编辑</a>
			</shiro:hasPermission>
			<shiro:hasPermission name="system:channel:enable">
				<a onclick="javascript:enableChannel();" class="easyui-linkbutton"
					iconCls="icon-ok" plain="true">启用</a>
			</shiro:hasPermission>
			<shiro:hasPermission name="system:channel:disable">
				<a onclick="javascript:disableChannel();" class="easyui-linkbutton"
					iconCls="icon-cancel" plain="true">停用</a>
			</shiro:hasPermission>
		</div>
	</div>
	<!--查询列表  -->
	<div class="hiddenDiv" style="width: 100%; height: 100%;">
		<table id="ChannelTable" class="easyui-datagrid"
			toolbar="#ChannelHeader" singleSelect="true" fitColumns="true"
			rownumbers="true" fit="true" pagination="true" collapsible="true"
			autoRowHeight="true" idField="channelId">
			<thead>
				<tr>
					<!-- <th field="id" width="10">用户编号</th> -->
					<th data-options="field:'channelNo'" width="5%">通道编号</th>
					<th data-options="field:'SPSupplier'" width="5%">短信供应商</th>
					<th data-options="field:'channelName'" width="5%">通道名称</th>
					<th data-options="field:'channelType'" width="5%">通道类型</th>
					<th data-options="field:'channelStatus'" width="4%">状态</th>
					<th data-options="field:'chanAccNum'" width="5%">子短号</th>
					<th data-options="field:'SPAccNo'" width="5%">账号</th>
					<th data-options="field:'creater'" width="5%">录入操作员</th>
					<th data-options="field:'creTime'" width="9%" formatter="XypayCommon.TimeFormatter">录入时间</th>
					<th data-options="field:'modifier'" width="7%">最后更新人员</th>
					<th data-options="field:'modTime'" width="9%" formatter="XypayCommon.TimeFormatter">最后更新时间</th>
				</tr>
			</thead>
		</table>
	</div>
	<!--用户资源区-->
	<div id="channelResourceDlg" class="easyui-dialog hiddenDiv"
		style="width: 400px; height: 420px; padding: 10px 20px;" closed="true"
		buttons="#channelResourceDlg-buttons">
		<form class="dlgForm" id="channelResourceForm" method="post">
			<div class="dlgFormItem" id="channelIdDiv">
				<label style="text-align: right; width: 100px">通道ID</label> <input
					class="easyui-textbox" type="text" name="channelId" id="channelId" 
			    ></input>
			</div>
			<div class="dlgFormItem" id="channelNoDiv">
				<label style="text-align: right; width: 100px">通道编号</label> <input
					class="easyui-textbox" type="text" name="channelNo" id="channelNo" 
					></input>
			</div>
			<div class="dlgFormItem">
				<label style="text-align: right; width: 100px">通道名称</label> <input
					class="easyui-textbox" type="text" name="channelName" id="channelName" 
					data-options="required:true,validType:'maxLength[20]'"></input>
			</div>
			<div class="dlgFormItem">
				<label style="text-align: right; width: 100px">通道类型</label> <select
					id="channelType" name="channelType" class="easyui-combobox"
					style="width: 105px;" editable="false" panelHeight="auto">
					<c:forEach var="channelTypeMap" items="${channelTypeMap}">
						<option value="${channelTypeMap.key}">${channelTypeMap.value}</option>
					</c:forEach>
				</select>
			</div>
			<div class="dlgFormItem">
				<label style="text-align: right; width: 100px">全/省网</label> <select
					id="internetType" name="internetType" class="easyui-combobox"
					style="width: 105px;" editable="false" panelHeight="auto">
					<c:forEach var="internetTypeMap" items="${internetTypeMap}">
						<option value="${internetTypeMap.key}">${internetTypeMap.value}</option>
					</c:forEach>
				</select>
			</div>
			<div class="dlgFormItem">
				<label style="text-align: right; width: 100px">是否支持长短信</label> <select
					id="isOrNot" name="isOrNot" class="easyui-combobox"
					style="width: 105px;" editable="false" panelHeight="auto">
					<c:forEach var="isOrNotMap" items="${isOrNotMap}">
						<option value="${isOrNotMap.key}">${isOrNotMap.value}</option>
					</c:forEach>
				</select>
			</div>
			<div class="dlgFormItem">
				<label style="text-align: right; width: 100px">账号</label> <select
					id="accNo" name="accNo" class="easyui-combobox"
					style="width: 105px;" editable="false" height="200px" overflow="auto" 
					requird="true" validType="selectValueRequired">
					<option value="" selected="selected">请选择</option>
					<c:forEach var="accListMap" items="${accListMap}">
						<option value="${accListMap.key}">${accListMap.value}</option>
					</c:forEach>
				</select>
			</div>
			<div class="dlgFormItem" style="display: none;">
				<label style="text-align: right; width: 100px">供应商</label> <select
					id="SPAcc" class="easyui-combobox" style="width: 105px;"
					editable="false" panelHeight="auto">
					<c:forEach var="accSpMap" items="${accSpMap}">
						<option value="${accSpMap.value}">${accSpMap.key}</option>
					</c:forEach>
				</select>
			</div>
			<div class="dlgFormItem">
				<label style="text-align: right; width: 100px">短信供应商</label> <label
					id="addSPName" style="text-align: left; width: 90px"></label>
			</div>
			<div class="dlgFormItem">
				<label style="text-align: right; width: 100px">子短号</label>
				 <input class="easyui-textbox" type="text" name="chanAccNum" id="chanAccNum" 
					data-options="required:true,validType:'numbers'"></input>
			</div>
			<div class="dlgFormItem">
				<label style="text-align: right; width: 100px">单条短信字数</label> <input
					class="easyui-textbox" style="width: 165px; height: 50px"
					name="singleMax" id="singleMax" data-options="required:true,validType:'number'"></input>
			</div>
			<div class="dlgFormItem">
				<label style="text-align: right; width: 100px">短信最大字数</label> <input
					class="easyui-textbox" style="width: 165px; height: 50px"
					name="totalMax" id="totalMax" data-options="required:true,validType:'number'"></input>
			</div>
			<div class="dlgFormItem">
				<label style="text-align: right; width: 100px">报备签名</label> <input
					class="easyui-textbox" style="width: 165px; height: 50px"
					name="sign" id="sign" data-options="required:true,validType:'maxLength[50]'"></input>
			</div>
			<div class="dlgFormItem">
				<label style="text-align: right; width: 100px">是否使用附加签名</label> <select
					id="chanIsbusisign" name="chanIsbusisign" class="easyui-combobox"
					style="width: 105px;" editable="false" panelHeight="auto">
					<c:forEach var="isOrNotMap" items="${isOrNotMap}">
						<option value="${isOrNotMap.key}">${isOrNotMap.value}</option>
					</c:forEach>
				</select>
			</div>
		</form>
	</div>
	<div id="channelResourceDlg-buttons" class="hiddenDiv">
		<a onclick="javascript:saveChannel()" class="easyui-linkbutton c6"
			iconCls="icon-ok" style="width: 90px">保存</a> <a
			class="easyui-linkbutton" iconCls="icon-cancel"
			onclick="javascript:$('#channelResourceDlg').dialog('close')"
			style="width: 90px">取消</a>
	</div>
	<!-- 用户资源form区域_查看操作  -->
	<div id="viewChannelResourceDlg" class="easyui-dialog hiddenDiv"
		style="width: 400px; height: 450px; padding: 10px 20px;" closed="true"
		buttons="#viewChannelResourceDlg-buttons">
		<form class="dlgForm" id="viewChannelResourceForm" method="post"
			novalidate>
			<div class="dlgFormItem">
				<label style="text-align: right; width: 100px"">通道编号</label> <input
					class="easyui-textbox" type="text" disabled="true"
					id="viewChannelNo"></input>
			</div>
			<div class="dlgFormItem">
				<label style="text-align: right; width: 100px"">通道名称</label> <input
					class="easyui-textbox" type="text" disabled="true"
					id="viewChannelName"></input>
			</div>
			<div class="dlgFormItem">
				<label style="text-align: right; width: 100px"">单条短信字数</label> <input
					class="easyui-textbox" type="text" disabled="true"
					id="viewSingleMax"></input>
			</div>
			<div class="dlgFormItem">
				<label style="text-align: right; width: 100px"">短信最大字数</label> <input
					class="easyui-textbox" type="text" disabled="true"
					id="viewTotalMax"></input>
			</div>
			<div class="dlgFormItem">
				<label style="text-align: right; width: 100px">全/省网</label> <select
					id="viewInternetType" name="viewInternetType" class="easyui-combobox"
					style="width: 105px;" editable="false" panelHeight="auto" disabled="true">
					<c:forEach var="internetTypeMap" items="${internetTypeMap}">
						<option value="${internetTypeMap.key}">${internetTypeMap.value}</option>
					</c:forEach>
				</select>
			</div>
			<div class="dlgFormItem">
				<label style="text-align: right; width: 100px">是否支持长短信</label> <select
					id="viewIsOrNot" name="viewIsOrNot" class="easyui-combobox"
					style="width: 105px;" editable="false" panelHeight="auto" disabled="true">
					<c:forEach var="isOrNotMap" items="${isOrNotMap}">
						<option value="${isOrNotMap.key}">${isOrNotMap.value}</option>
					</c:forEach>
				</select>
			</div>
			<div class="dlgFormItem">
				<label style="text-align: right; width: 100px"">报备签名</label> <input
					class="easyui-textbox" type="text" disabled="true" id="viewSign"></input>
			</div>
			<div class="dlgFormItem">
				<label style="text-align: right; width: 100px"">是否使用附加签名</label> <select
					id="viewIsBusiSign" name="viewIsBusiSign" class="easyui-combobox"
					style="width: 105px;" editable="false" panelHeight="auto" disabled="true">
					<c:forEach var="isOrNotMap" items="${isOrNotMap}">
						<option value="${isOrNotMap.key}">${isOrNotMap.value}</option>
					</c:forEach>
				</select>
			</div>
		</form>
	</div>
	<div id="viewChannelResourceDlg-buttons" class="hiddenDiv">
		<a class="easyui-linkbutton" iconCls="icon-cancel"
			onclick="javascript:$('#viewChannelResourceDlg').dialog('close')"
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
				//数值验证
				number : {
					validator : function(value) {
						var reg = /^[1-9]\d{0,2}$/;
						return reg.test(value);
					},
					message : '只能输入数字'
				},
				
				//数值验证
				numbers : {
					validator : function(value) {
						var reg = /^[0-9]+[0-2]*]*$/;
						return reg.test(value);
					},
					message : '只能输入数字'
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
			var options = $('#ChannelTable').datagrid('options');
			options.url = "channelPage.json";
			$('#ChannelTable').datagrid('reload', {
				SPSupplier : $('#SPSupplierQuery').val(),
				SPAccNo : $('#SPAccNoQuery').val(),
				channelType : $('#channelTypeQuery').combobox('getValue'),
				status : $('#statusQuery').combobox('getValue')
			});
		}

		function searchChannel() {
			$('#ChannelTable').datagrid('load', {
				SPSupplier : $('#SPSupplierQuery').val(),
				SPAccNo : $('#SPAccNoQuery').val(),
				channelType : $('#channelTypeQuery').combobox('getValue'),
				status : $('#statusQuery').combobox('getValue')
			});
		}

		function reset() {
			$('#SPSupplierQuery').textbox('setValue', '');
			$('#channelTypeQuery').combobox('setValue', '');
			$('#statusQuery').combobox('setValue', '');
			$('#SPAccNoQuery').textbox('setValue', '');
		}
		function enableChannel() {
			var obj = $('#ChannelTable');
			var rows = obj.datagrid('getSelections');
			if (XypayCommon.getSelectRowCurPage(obj) == false) {
				XypayCommon.MessageAlert('提示', '请选择一条信息!', 'warning');
				return;
			}
			var row = rows[0];
			//alert(JSON.stringify(row));
			if (row.channelStatus == '启用') {
				XypayCommon.MessageAlert('提示', '该条通道信息已经启用!', 'warning');
				return;
			}
			$.messager.confirm('确认', '确定要启用该条通道信息?', function(r) {
				if (r) {
					$.post('channel/enable', {
						channelId : row.channelId
					}, function(result) {
						result = XypayCommon.toJson(result);
						if (result.success) {
							$('#ChannelTable').datagrid('reload'); // reload the user data
							XypayCommon.MessageAlert('提示', '操作成功!', 'info');
						} else {
							XypayCommon.MessageAlert('提示', result.msg,
									'warning');
						}
					}, 'json');
				}
			});
		};
		function disableChannel() {

			var obj = $('#ChannelTable');
			var rows = obj.datagrid('getSelections');
			if (XypayCommon.getSelectRowCurPage(obj) == false) {
				XypayCommon.MessageAlert('提示', '请选择一条信息!', 'warning');
				return;
			}

			var row = rows[0];

			if (row.channelStatus == '停用') {
				XypayCommon.MessageAlert('提示', '该条通道信息已经停用!', 'warning');
				return;
			}

			$.messager.confirm('确认', '确定要停用该条通道信息?', function(r) {
				if (r) {
					$.post('channel/disable', {
						channelId : row.channelId
					}, function(result) {
						result = XypayCommon.toJson(result);
						if (result.success) {
							$('#ChannelTable').datagrid('reload'); // reload the user data
							XypayCommon.MessageAlert('提示', '操作成功!', 'info');
						} else {
							XypayCommon.MessageAlert('提示', result.msg,
									'warning');
						}
					}, 'json');
				}
			});
		}

		function createChannel() {
			$("#channelResourceDlg").dialog({
				title : "新增",
				closed : false,
				top : 0,
				width : 400,
				height : 500,
				modal : true
			});
			//隐藏UI
			$('#channelIdDiv').hide();	
			$('#channelNoDiv').hide();	
			//不可编辑UI 开启
			//$('#channelNo').textbox('readonly', false);
			$('#channelResourceForm').form('clear');
			/**初始化参数*/
			$('#addSPName').html("");
			$("#channelType").combobox('select',
			$('#channelType').combobox('getData')[0].value);
			$("#internetType").combobox('select',
			$('#internetType').combobox('getData')[0].value);
			$("#isOrNot").combobox('select',
			$('#isOrNot').combobox('getData')[0].value);
			$("#chanIsbusisign").combobox('select',
					$('#chanIsbusisign').combobox('getData')[0].value);
			/**为账号添加onselect事件*/
			$('#accNo').combobox({
				valueField : 'itemCode',
				textField : 'itemName',
				onSelect : function(params) {
					$.get('channel/getSPName', {
						accId : params.itemCode
					}, function(data) {
						$('#addSPName').html(data);
					}, 'json');
				}
			});
			
			
			url = "channel/add";
		}

		function saveChannel() {
			XypayCommon.genCsrfToken($('#channelResourceForm'));
			$('#channelResourceForm').form('submit', {
				url : url,
				onSubmit : function() {
					return $(this).form('validate');
				},
				success : function(result) {
					result = XypayCommon.toJson(result);
					if (result.success) {
						$('#channelResourceDlg').dialog('close'); // close the dialog
						$('#ChannelTable').datagrid('reload'); // reload the user data	
						XypayCommon.MessageAlert('提示', '操作成功!', 'info');
					} else {
						XypayCommon.MessageAlert('提示', result.msg, 'error');
					}
				}
			});
		}

		function editChannel() {
			var obj = $('#ChannelTable');
			var rows = obj.datagrid('getSelections');
			//alert(JSON.stringify(rows));
			if (XypayCommon.getSelectRowCurPage(obj) == false) {
				XypayCommon.MessageAlert('提示', '请选择一条信息!', 'warning');
				return;
			}
			var row = rows[0];
			//停用状态不允许编辑
			
			if (row.channelStatus == '停用') {
				XypayCommon.MessageAlert('提示', '停用状态不允许编辑!', 'warning');
				return;
			}
			//显示form表单
			//showFormUI();
			//不可编辑UI
			$('#channelNo').textbox('readonly', true);
			//隐藏UI
			$('#channelIdDiv').hide();
			//显示UI
			$('#channelNoDiv').show();	
			if (row) {
				$("#channelResourceDlg").dialog({
					title : "编辑",
					closed : false,
					top : 0,
					width : 400,
					height : 500,
					modal : true
				});	
				/**为账号添加onselect事件*/
				$('#accNo').combobox({
					valueField : 'itemCode',
					textField : 'itemName',
					onSelect : function(params) {
						$.get('channel/getSPName', {
							accId : params.itemCode
						}, function(data) {
							$('#addSPName').html(data);
						}, 'json');
					}
				});
				$('#channelResourceForm').form('clear');
				$.get("getChannelResourceById.json", {
					id : row.channelId
				}, function(data) {
					data = XypayCommon.toJson(data);
					//alert(JSON.stringify(data));
					//alert(JSON.stringify(data.chanNo));
					$('#channelResourceForm').form('load', data);
					$('#channelId').textbox('setValue',data.chanNo);
					$('#channelNo').textbox('setValue',data.chanNo);
			    	$('#channelName').textbox('setValue',data.chanName);	    	
			    	$('#channelType').combobox('setValue',data.chanType?data.chanType:'');
			    	$('#internetType').combobox('setValue',data.chanIsall?data.chanIsall:'');
			    	$('#isOrNot').combobox('setValue',data.chanIslong?data.chanIslong:'');
			    	$('#accNo').combobox('setValue',data.chanAccid?data.chanAccid:'');
			    	$('#singleMax').textbox('setValue',data.chanNum);
			    	$('#totalMax').textbox('setValue',data.chanMax);
			    	$('#sign').textbox('setValue',data.chanSign);
			    	$('#chanIsbusisign').combobox('setValue', data.chanIsbusisign);
			    	//alert(JSON.stringify(data));
			    	$('#addSPName').html(data.accPro);
			    	$('#chanAccNum').combobox('setValue', data.chanAccNum);
			    	
				});
				url = "channel/edit";
			}
		}
		function view() {
			var obj = $('#ChannelTable');
			var rows = obj.datagrid('getSelections');
			if (XypayCommon.getSelectRowCurPage(obj) == false) {
				XypayCommon.MessageAlert('提示', '请选择一条信息!', 'warning');
				return;
			}
			var row = rows[0];
			if (row) {
				$("#viewChannelResourceDlg").dialog({
					title : "查看",
					closed : false,
					top : 0,
					width : 400,
					height : 320,
					modal : true
				});

				$('#viewChannelResourceDlg').form('clear');
				//alert(JSON.stringify(row));
				$.get("getChannelResourceById.json", {
					id : row.channelId
				}, function(data) {
					data = XypayCommon.toJson(data);
					//alert(JSON.stringify(data));
					$('#viewChannelResourceForm').form('load', data);
					$('#viewChannelNo').textbox('setValue', data.chanNo);
					$('#viewChannelName').textbox('setValue', data.chanName);
					$('#viewSingleMax').textbox('setValue', data.chanNum);
					$('#viewTotalMax').textbox('setValue', data.chanMax);
					$('#viewInternetType').combobox('setValue', data.chanIsall);
					$('#viewIsOrNot').combobox('setValue', data.chanIslong);
					$('#viewSign').textbox('setValue', data.chanSign);
					$('#viewIsBusiSign').combobox('setValue', data.chanIsbusisign);
			    	$('#chanAccNum').combobox('setValue', data.chanAccNum);

				});
			}
		};
	</script>

</body>
</html>