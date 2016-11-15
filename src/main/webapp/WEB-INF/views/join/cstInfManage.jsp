<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../common.jsp"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>客户信息管理</title>

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
			客户编号： <input id="cstCstnoQuery" class="easyui-textbox"
				style="width: 100px;"
				data-options="required:false,validType:'maxLength[20]'"> 
			客户名称：<input id="cstNameQuery" class="easyui-textbox" style="width: 100px;"
				data-options="required:false,validType:'maxLength[20]'">
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
			<a onclick="javascript:view();" class="easyui-linkbutton"
				iconCls="icon-view" plain="true">查看详情</a>
			<shiro:hasPermission name="join:cstinf:add">
				<a onclick="javascript:create();" class="easyui-linkbutton"
					iconCls="icon-add" plain="true">添加</a>
			</shiro:hasPermission>
			<shiro:hasPermission name="join:cstinf:edit">
				<a onclick="javascript:edit();" class="easyui-linkbutton"
					iconCls="icon-edit" plain="true">编辑</a>
			</shiro:hasPermission>
		    <shiro:hasPermission name="join:cstinf:enable">
				<a onclick="javascript:enable();" class="easyui-linkbutton"
					iconCls="icon-ok" plain="true">激活</a>
			</shiro:hasPermission>
			<shiro:hasPermission name="join:cstinf:disable">
				<a onclick="javascript:disable();" class="easyui-linkbutton"
					iconCls="icon-cancel" plain="true">冻结</a>
			</shiro:hasPermission>
			<shiro:hasPermission name="join:cstinf:remove">  
	        	<a onclick="javascript:removeAction();" class="easyui-linkbutton"
	        	    iconCls="icon-remove" plain="true">注销</a> 
	        </shiro:hasPermission> 
	        <shiro:hasPermission name="join:cstinf:reflashTocken">  
	        	<a onclick="javascript:reflashTocken();" class="easyui-linkbutton"
	        	 iconCls="icon-reload"    plain="true">刷新接入令牌</a> 
	        </shiro:hasPermission>
	        <shiro:hasPermission name="join:cstinf:reflashKey">  
	        	<a onclick="javascript:reflashKey();" class="easyui-linkbutton"
	        	 iconCls="icon-reload"    plain="true">刷新key</a> 
	        </shiro:hasPermission>
		</div>
	</div>
	<!--查询列表  -->
	<div class="hiddenDiv" style="width: 100%; height: 100%;">
		<table id="Table" class="easyui-datagrid"
			toolbar="#Header" singleSelect="true" fitColumns="true"
			rownumbers="true" fit="true" pagination="true" collapsible="true"
			autoRowHeight="true" idField="cstId">
			<thead>
				<tr>
					<!-- <th field="id" width="10">用户编号</th> -->
					<th data-options="field:'cstCstno'" width="5%">客户编号</th>
					<th data-options="field:'cstName'" width="10%">客户名称</th>
					<th data-options="field:'cstTocken'" width="15%">接入令牌</th>
					<th data-options="field:'cstKey'" width="10%">key</th>
					<th data-options="field:'cstStatus'" width="5%">状态</th>
					<th data-options="field:'cstCreater'" width="10%">录入操作员</th>
					<th data-options="field:'cstIsEncByKey'" width="5%">是否加密</th>
					<th data-options="field:'cstCretime'" width="10%" formatter="XypayCommon.TimeFormatter">录入时间</th>
					<th data-options="field:'cstModifier'" width="8%">最后更新人员</th>
					<th data-options="field:'cstModtime'" width="10%" formatter="XypayCommon.TimeFormatter">最后更新时间</th>
				</tr>
			</thead>
		</table>
	</div>
	<!--用户资源区-->
	<div id="ResourceDlg" class="easyui-dialog hiddenDiv"
		style="width: 400px; height: 420px; padding: 10px 20px;" closed="true"
		buttons="#ResourceDlg-buttons">
		<form class="dlgForm" id="ResourceForm" method="post">
			<div class="dlgFormItem" id="cstIdDiv">
				<label style="text-align: right; width: 90px">客户ID</label> <input
					class="easyui-textbox" type="text" name="cstId" id="cstId" 
			    ></input>
			</div>
			<div class="dlgFormItem" id="cstCstnoDiv">
				<label style="text-align: right; width: 90px">客户编号</label> <input
					class="easyui-textbox" type="text" name="cstCstno" id="cstCstno" 
				></input>
			</div>
			<div class="dlgFormItem">
				<label style="text-align: right; width: 90px">客户名称</label> <input
					class="easyui-textbox" type="text" name="cstName" id="cstName" 
					data-options="required:true,validType:'maxLength[20]'"></input>
			</div>
			<div class="dlgFormItem">
				<label style="text-align: right; width: 90px">联系人</label> <input
					class="easyui-textbox" type="text" name="cstCon" id="cstCon" 
					data-options="required:true,validType:'maxLength[50]'"></input>
			</div>
			<div class="dlgFormItem">
				<label style="text-align: right; width: 90px">联系人手机</label> <input
					class="easyui-textbox" type="text" name="cstMobile" id="cstMobile" 
					data-options="required:true,validType:'mobile'"></input>
			</div>
			<div class="dlgFormItem">
				<label style="text-align: right; width: 90px">联系人QQ</label> <input
					class="easyui-textbox" type="text" name="cstQq" id="cstQq" 
					data-options="required:true,validType:'number'"></input>
			</div>
			<div class="dlgFormItem">
				<label style="text-align: right; width: 90px">联系人邮箱</label> <input
					class="easyui-textbox" type="text" name="cstEmail" id="cstEmail" 
					data-options="required:true,validType:'email'"></input>
			</div>
			<div class="dlgFormItem">
				<label style="text-align: right;width: 90px">是否加密</label> 
				<select id="cstIsEncByKey" name="cstIsEncByKey" 
				    class="easyui-combobox" panelHeight="auto"
					style="width: 105px;" editable="false"
					requird="true" validType="selectValueRequired">
					<option value="请选择" selected="selected">请选择</option>
					<c:forEach var="isEncByKeyType" items="${isEncByKeyMap}">
						<option value="${isEncByKeyType.key}">${isEncByKeyType.value}</option>
					</c:forEach>
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
	<!-- 用户资源form区域_查看操作  -->
	<div id="viewResourceDlg" class="easyui-dialog hiddenDiv"
		style="width: 400px; height: 450px; padding: 10px 20px;" closed="true"
		buttons="#viewResourceDlg-buttons">
		<form class="dlgForm" id="viewResourceForm" method="post"
			novalidate>
			<div class="dlgFormItem">
				<label style="text-align: right; width: 90px"">客户编号</label> <input
					class="easyui-textbox" type="text" disabled="true"
					id="viewCstCstno"></input>
			</div>
			<div class="dlgFormItem">
				<label style="text-align: right; width: 90px"">客户名称</label> <input
					class="easyui-textbox" type="text" disabled="true"
					id="viewCstName"></input>
			</div>
			<div class="dlgFormItem">
				<label style="text-align: right; width: 90px"">联系人</label> <input
					class="easyui-textbox" type="text" disabled="true"
					id="viewCstCon"></input>
			</div>
			<div class="dlgFormItem">
				<label style="text-align: right; width: 90px"">联系人手机</label> <input
					class="easyui-textbox" type="text" disabled="true"
					id="viewCstMobile"></input>
			</div>
			<div class="dlgFormItem">
				<label style="text-align: right; width: 90px">QQ</label> <input
					class="easyui-textbox" type="text" disabled="true"
					id="viewCstQq"></input>
			</div>
			<div class="dlgFormItem">
				<label style="text-align: right; width: 90px">电子邮箱</label> <input
					class="easyui-textbox" type="text" disabled="true"
					id="viewCstEmail"></input>
			</div>
			
			<div class="dlgFormItem">
				<label style="text-align: right; width: 90px">是否加密</label> 
				<select id="isEncByKeyView" class="easyui-combobox"
					style="width: 105px;" disabled="true" panelHeight="auto">
					<%-- <c:forEach var="isEncByKeyViewType" items="${isEncByKeyViewMap}">
						<option value="${isEncByKeyViewType.value}">${isEncByKeyViewType.value}</option>
					</c:forEach> --%>
					<c:forEach var="isEncByKeyType" items="${isEncByKeyMap}">
						<option value="${isEncByKeyType.key}">${isEncByKeyType.value}</option>
					</c:forEach>
				</select>
			</div>
			
		</form>
	</div>
	<div id="viewResourceDlg-buttons" class="hiddenDiv">
		<a class="easyui-linkbutton" iconCls="icon-cancel"
			onclick="javascript:$('#viewResourceDlg').dialog('close')"
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
						var reg = /^[1-9]\d{0,20}$/;
						return reg.test(value);
					},
					message : '只能输入数字'
				},
				 //手机号码验证  
			    mobile: {//value值为文本框中的值  
			        validator: function (value) {  
			            var reg = /^1[3-9]\d{9}$/;  
			            return reg.test(value);  
			        },  
			        message: '输入手机号码格式不准确.'  
			    },
			    email : {   
			        validator: function(value){   
			            return /^[a-zA-Z0-9_+.-]+\@([a-zA-Z0-9-]+\.)+[a-zA-Z0-9]{2,4}$/i.test($.trim(value));   
			        },   
			        message: '电子邮箱格式错误'  
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
			options.url = "cstinfPage.json";
			$('#Table').datagrid('reload', {
				cstCstnoQuery : $('#cstCstnoQuery').val(),
				cstNameQuery : $('#cstNameQuery').val(),				
				statusQuery : $('#statusQuery').combobox('getValue')
			});
		};

		function searchCondition() {
			$('#Table').datagrid('load', {
				cstCstnoQuery : $('#cstCstnoQuery').val(),
				cstNameQuery : $('#cstNameQuery').val(),
				statusQuery : $('#statusQuery').combobox('getValue')
			});
		};

		function reset() {
			$('#cstCstnoQuery').textbox('setValue', '');
			$('#statusQuery').combobox('setValue', '');
			$('#cstNameQuery').textbox('setValue', '');
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
			if (row.cstStatus != '冻结') {
				XypayCommon.MessageAlert('提示', '非冻结状态!', 'warning');
				return;
			}
			$.messager.confirm('确认', '确定要正常该条客户信息?', function(r) {
				if (r) {
					$.post('cstinf/enable', {
						id : row.cstId
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
			//alert(JSON.stringify(row));
			if (row.cstStatus != '正常') {
				XypayCommon.MessageAlert('提示', '非正常状态!', 'warning');
				return;
			}

			$.messager.confirm('确认', '确定要冻结该条客户信息?', function(r) {
				if (r) {
					$.post('cstinf/disable', {
						id : row.cstId
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
		} 

		function create() {
			$("#ResourceDlg").dialog({
				title : "新增",
				closed : false,
				top : 0,
				width : 400,
				height : 300,
				modal : true
			});
			//隐藏UI
			$('#cstIdDiv').hide();
			$('#cstCstnoDiv').hide();
			//开启可编辑UI
		    $('#cstName').textbox('enable', true);
			$('#ResourceForm').form('clear');
			$('#cstIsEncByKey').combobox('setText',"请选择"); 
			
			url = "cstinf/add";
		}

		function save() {
			//alert(url);
			XypayCommon.genCsrfToken($('#ResourceForm'));
			$('#ResourceForm').form('submit', {				
				url : url,
				onSubmit : function() {
					//alert($(this).form('validate'));					
					return $(this).form('validate');
				},
				success : function(result) {
					result = XypayCommon.toJson(result);
					//alert(result);
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
			//alert(JSON.stringify(rows));
			if (XypayCommon.getSelectRowCurPage(obj) == false) {
				XypayCommon.MessageAlert('提示', '请选择一条信息!', 'warning');
				return;
			}
			var row = rows[0];
			//冻结，注销状态不允许编辑
			
			if (row.cstStatus != '正常') {
				XypayCommon.MessageAlert('提示', '该状态不允许编辑!', 'warning');
				return;
			}
			//显示div
			$('#cstCstnoDiv').show();
			//不可编辑UI
			$('#cstCstno').textbox('disable', true);
			$('#cstName').textbox('disable', true);
			//隐藏UI
			$('#cstIdDiv').hide();
			if (row) {
				$("#ResourceDlg").dialog({
					title : "编辑",
					closed : false,
					top : 0,
					width : 400,
					height : 300,
					modal : true
				});	
				
				$('#ResourceForm').form('clear');
				$.get("getCstInfResourceById.json", {
					id : row.cstId
				}, function(data) {
					data = XypayCommon.toJson(data);
					//alert(JSON.stringify(data));
					//alert(JSON.stringify(data.chanNo));
					$('#ResourceForm').form('load', data);
					$('#cstId').textbox('setValue',data.cstCstno);
			    	$('#cstCon').combobox('setValue',data.cstCon);
			    	$('#cstMobile').combobox('setValue',data.cstMobile);
			    	$('#cstQq').combobox('setValue',data.cstQq);
			    	$('#cstEmail').combobox('setValue',data.cstEmail);
			    	$('#cstEmail').combobox('setValue',data.cstEmail);
			    	$('#isEncByKeyView').combobox('setValue',data.cstIsEncByKey);
			    				    	
				});
				url = "cstinf/edit";
			}
		}
		function view() {
			var obj = $('#Table');
			var rows = obj.datagrid('getSelections');
			if (XypayCommon.getSelectRowCurPage(obj) == false) {
				XypayCommon.MessageAlert('提示', '请选择一条信息!', 'warning');
				return;
			}
			var row = rows[0];
			if (row) {
				$("#viewResourceDlg").dialog({
					title : "查看",
					closed : false,
					top : 0,
					width : 400,
					height : 320,
					modal : true
				});

				$('#viewResourceDlg').form('clear');
				//alert(JSON.stringify(row));
				$.get("getCstInfResourceById.json", {
					id : row.cstId
				}, function(data) {
					data = XypayCommon.toJson(data);
					//alert(JSON.stringify(data));
					$('#viewResourceForm').form('load', data);
					$('#viewCstCstno').textbox('setValue', data.cstCstno);
					$('#viewCstName').textbox('setValue', data.cstName);
					$('#viewCstCon').textbox('setValue', data.cstCon);
					$('#viewCstMobile').textbox('setValue', data.cstMobile);
					$('#viewCstQq').textbox('setValue', data.cstQq);
					$('#viewCstEmail').textbox('setValue', data.cstEmail);
					$('#isEncByKeyView').combobox('setValue',data.cstIsEncByKey);
				});
			}
		}

        function removeAction(){
	       // alert(1);
			var obj = $('#Table');
			var rows = obj.datagrid('getSelections');
			if(XypayCommon.getSelectRowCurPage(obj) == false){
				XypayCommon.MessageAlert('提示', '请选择一条信息!','warning');
				return;
			}
			
			var row = rows[0];
			//注销状态不允许编辑
			if(row.cstStatus == '注销'){
				XypayCommon.MessageAlert('提示', '注销状态无须注销操作!','warning');
				return;
			}
			
			$.messager.confirm('确认', '确定要注销该信息?', function(r) {
				if (r) {
					$.post('cstinf/remove', {
						id : row.cstId
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
        function reflashTocken(){
 	       // alert(1);
 			var obj = $('#Table');
 			var rows = obj.datagrid('getSelections');
 			if(XypayCommon.getSelectRowCurPage(obj) == false){
 				XypayCommon.MessageAlert('提示', '请选择一条信息!','warning');
 				return;
 			}
 			
 			var row = rows[0];
 			//注销状态不允许编辑
 			if(row.cstStatus == '注销'){
 				XypayCommon.MessageAlert('提示', '注销状态无法操作!','warning');
 				return;
 			}
 			
 			$.messager.confirm('确认', '确定要刷新该信息的令牌?', function(r) {
 				if (r) {
 					$.post('cstinf/reflashTocken', {
 						id : row.cstId
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
        function reflashKey(){
 	       // alert(1);
 			var obj = $('#Table');
 			var rows = obj.datagrid('getSelections');
 			if(XypayCommon.getSelectRowCurPage(obj) == false){
 				XypayCommon.MessageAlert('提示', '请选择一条信息!','warning');
 				return;
 			}
 			
 			var row = rows[0];
 			//注销状态不允许编辑
 			if(row.cstStatus == '注销'){
 				XypayCommon.MessageAlert('提示', '注销状态无法操作!','warning');
 				return;
 			}
 			
 			$.messager.confirm('确认', '确定要刷新该信息的key?', function(r) {
 				if (r) {
 					$.post('cstinf/reflashKey', {
 						id : row.cstId
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