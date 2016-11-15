<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../common.jsp"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>对账申请与审核</title>

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
			账号： <input id="accNoQuery" class="easyui-textbox"
				style="width: 100px;"
				data-options="required:false,validType:'maxLength[20]'"> 
			申请开始时间：<input id="beginDate" class="easyui-datebox" style="width:100px" onchange="javascript:" editable="false">
           	申请结束时间：<input id="endDate" class="easyui-datebox" style="width:100px" editable="false">
		状态： <select id="statusQuery" class="easyui-combobox"
				style="width: 105px;" editable="false" panelHeight="auto">
				<option value="" selected="selected">全部</option>
				<c:forEach var="statusMap" items="${statusMap}">
					<option value="${statusMap.key}">${statusMap.value}</option>
				</c:forEach>
			</select> 
			<a onclick="javascript:searchCondition();" class="easyui-linkbutton"
				iconCls="icon-search">查询</a> <a onclick="javascript:reset();"
				class="easyui-linkbutton" iconCls="icon-reset">重置</a>
		</div>
		<!--按钮权限控制  -->
		<div class="pageToolbar">
			<!-- 由于'查看'操作无需权限控制 对所有人开放 -->
			<shiro:hasPermission name="account:apply:view">  
	        	<a onclick="javascript:view();" class="easyui-linkbutton"
	        	    iconCls="icon-view" plain="true">查看</a> 
	        </shiro:hasPermission>
			<shiro:hasPermission name="account:apply:add">
				<a onclick="javascript:create();" class="easyui-linkbutton"
					iconCls="icon-add" plain="true">新增</a>
			</shiro:hasPermission>
			<shiro:hasPermission name="account:apply:edit">
				<a onclick="javascript:edit();" class="easyui-linkbutton"
					iconCls="icon-edit" plain="true">修改</a>
			</shiro:hasPermission>
			<shiro:hasPermission name="account:apply:remove">  
	        	<a onclick="javascript:removeAction();" class="easyui-linkbutton"
	        	    iconCls="icon-remove" plain="true">删除</a> 
	        </shiro:hasPermission>
	        <shiro:hasPermission name="account:apply:commit">
				<a onclick="javascript:commitAction();" class="easyui-linkbutton"
					iconCls="icon-ok" plain="true">提交审核</a>
			</shiro:hasPermission>
	        <shiro:hasPermission name="account:apply:pass">  
	        	<a onclick="javascript:passAction();" class="easyui-linkbutton"
	        	    iconCls="icon-ok" plain="true">审核通过</a> 
	        </shiro:hasPermission>
	        <shiro:hasPermission name="account:apply:refuse">  
	        	<a onclick="javascript:refuseAction();" class="easyui-linkbutton"
	        	    iconCls="icon-no" plain="true">审核拒绝</a> 
	        </shiro:hasPermission> 
		</div>
	</div>
	<!--查询列表  -->
	<div class="hiddenDiv" style="width: 100%; height: 100%;">
		<table id="Table" class="easyui-datagrid"
			toolbar="#Header" fitColumns="true"
			rownumbers="true" fit="true" pagination="true" collapsible="true"
			autoRowHeight="true" idField="accCheNo">
			<thead>
				<tr>
					<!-- <th field="id" width="10">用户编号</th> -->
					<th data-options="field:'accCheNo'" width="5%">申请编号</th>
					<th data-options="field:'accNo'" width="5%">账号</th>
					<th data-options="field:'accCheTotal'" width="3%">总条数</th>
					<th data-options="field:'accCheSuc'" width="3%">成功数</th>
					<th data-options="field:'accCheAmt'" width="3%">金额</th>
					<th data-options="field:'accCheRate'" width="3%">费率</th>
					<th data-options="field:'accCheDiff'" width="3%">差异</th>
					<th data-options="field:'accCheStatus'" width="5%">状态</th>
					<th data-options="field:'accCheStarttime'" width="10%" formatter="XypayCommon.TimeFormatter">对账开始时间</th>
					<th data-options="field:'accCheEndtime'" width="10%" formatter="XypayCommon.TimeFormatter">对账结束时间</th>
					<th data-options="field:'accCheApplier'" width="3%">申请人</th>
					<th data-options="field:'accCheApptime'" width="10%" formatter="XypayCommon.TimeFormatter">申请时间</th>
					<th data-options="field:'accCheChecker'" width="3%">审核人</th>
					<th data-options="field:'accCheChecktime'" width="10%" formatter="XypayCommon.TimeFormatter">审核时间</th>
				</tr>
			</thead>
		</table>
	</div>
	<!--用户资源区-->
	<div id="ResourceDlg" class="easyui-dialog hiddenDiv"
		style="width: 400px; height: 420px; padding: 10px 20px;" closed="true"
		buttons="#ResourceDlg-buttons">
		<form class="dlgForm" id="ResourceForm" method="post">
			<div class="dlgFormItem" id="accCheIdDiv">
				<label style="text-align: right; width: 95px">申请ID</label> <input
					class="easyui-textbox" type="text" name="accCheId" id="accCheId" 
			    ></input>
			</div>
			<div class="dlgFormItem" id="accCheNoDiv">
				<label style="text-align: right; width: 95px">申请订单号</label> <input
					class="easyui-textbox" type="text" name="accCheNo" id="accCheNo" 
				></input>
			</div>
			<div class="dlgFormItem">
				<label style="text-align: right; width: 95px">短信供应商账号</label> 
				<select
					id="accCheSpaccid" name="accCheSpaccid" class="easyui-combobox"
					style="width: 105px;" editable="false" height="200px" overflow="auto"
					required="true" validType="selectValueRequired">
					<option value="" selected="selected">请选择</option>
					<c:forEach var="accCheSpaccidMap" items="${accCheSpaccidMap}">
						<option value="${accCheSpaccidMap.key}">${accCheSpaccidMap.value}</option>
					</c:forEach>
				</select>
			</div>
			<div class="dlgFormItem">
				<label style="text-align: right; width: 95px">账号费率</label> <input
					class="easyui-numberbox" type="text" name="accCheRate" id="accCheRate" 
					data-options="required:true" min="0.01" max="10" precision="2">
			</div>
			<div class="dlgFormItem">
				<label style="text-align: right; width: 95px">对账开始时间</label> <input id="accCheStarttime" name="accCheStarttime" class="easyui-datebox" style="width:100px" editable="false" required="true">
			</div>	
			<div class="dlgFormItem">
				<label style="text-align: right; width: 95px">对账结束时间</label> <input id="accCheEndtime" name="accCheEndtime" class="easyui-datebox" style="width:100px" editable="false" required="true">
			</div>			
			<div class="dlgFormItem">
				<label style="text-align: right; width: 95px">总条数</label> <input
					class="easyui-numberbox" type="text" name="accCheTotal" id="accCheTotal" 
					data-options="required:true" min="1" max="999999999" precision="0"></input>
			</div>
			<div class="dlgFormItem">
				<label style="text-align: right; width: 95px">成功条数</label>  <input
					class="easyui-numberbox" type="text" name="accCheSuc" id="accCheSuc" 
					data-options="required:true" min="1" max="999999999" precision="0">
			</div>
			<div class="dlgFormItem">
				<label style="text-align: right; width: 95px">金额</label><input
					class="easyui-numberbox" type="text" name="accCheAmt" id="accCheAmt" 
					data-options="required:true" min="0.01" max="999999999" precision="2">
			</div>
			<div class="dlgFormItem">
				<label style="text-align: right; width: 95px">差异</label> <input
					class="easyui-numberbox" type="text" name="accCheDiff" id="accCheDiff" 
					data-options="required:true" min="0.00" max="1" precision="2">
			</div>
			<div class="dlgFormItem">
				<label style="text-align: right; width: 95px">差异原因</label> <textarea
					class="easyui-textbox" style="width:165px;height:50px" data-options="multiline:true" name="accCheReason" id="accCheReason" 
				></textarea>
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
	<div id="viewResourceDlg" class="easyui-dialog hiddenDiv"
		style="width: 400px; height: 450px; padding: 10px 20px;" closed="true"
		buttons="viewResourceDlg-buttons">
		<form class="dlgForm" id="viewResourceForm" method="post"
			novalidate>
			<div class="dlgFormItem">
				<label style="text-align: right; width: 90px"">差异原因</label> <textarea
					class="easyui-textbox"style="width:165px;height:50px"  data-options="multiline:true" disabled="true"
					id="viewAccCheReason"></textarea>
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
			//初始化查询条件
			init();
			//初始化查询
			search();			
		});

		function search() {
			var options = $('#Table').datagrid('options');
			options.url = "checkApplyPage.json";
			$('#Table').datagrid('reload', {
				accNoQuery : $('#accNoQuery').val(),
				beginDate:$('#beginDate').datebox('getValue'),
	        	endDate:$('#endDate').datebox('getValue'),
	        	statusQuery : $('#statusQuery').combobox('getValue')
			});
		};

		function searchCondition() {
			$('#Table').datagrid('load', {
				accNoQuery : $('#accNoQuery').val(),
				beginDate:$('#beginDate').datebox('getValue'),
	        	endDate:$('#endDate').datebox('getValue'),
	        	statusQuery : $('#statusQuery').combobox('getValue')
			});
		};

		function reset() {
			$('#accNoQuery').textbox('setValue', '');			
			$('#beginDate').datebox('setValue',''),
        	$('#endDate').datebox('setValue',''),
        	$('#statusQuery').combobox('setValue','')
        	init();
		};
		function create() {
			$("#ResourceDlg").dialog({
				title : "新增",
				closed : false,
				top : 0,
				width : 400,
				height : 400,
				modal : true
			});
			//隐藏UI
			$('#accCheIdDiv').hide();	
			$('#accCheNoDiv').hide();	
			//开启可编辑UI
			$('#accCheSpaccid').combobox('enable', true);
			$('#accCheRate').numberbox('readonly', true);
			$('#accCheDiff').numberbox('readonly', true);		
			$('#ResourceForm').form('clear');
			/**初始化输入*/
			//alert(JSON.stringify($('#cstName').combobox('getData'))); 
			$('#accCheSpaccid').combobox('setText',"请选择"); 			
			$('#accCheRate').numberbox('clear');
			$('#accCheDiff').numberbox('clear');
			$('#accCheSpaccid').combobox({
				valueField : 'accId',
				textField : 'accAccno',
				onSelect : function(params) {
					$.get('getRate.json', {
						accCheSpaccid : params.accId
					}, function(data) {
						$('#accCheRate').numberbox('setValue',data.accRate);
					}, 'json');
				}
             }); 
			$('#accCheAmt').textbox({
				onChange : function(newValue,oldValue){
					$.get('getDiff.json', {
						accCheSpaccid : $('#accCheSpaccid').combobox('getValue'),
						accCheAmt : newValue ,
						accCheStarttime : $('#accCheStarttime').datebox('getValue'),
						accCheEndtime : $('#accCheEndtime').datebox('getValue'),
					}, function(data) {						
						$('#accCheDiff').numberbox('setValue',data);
					}, 'json');
				}	
				});
			
			url = "apply/add";
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
				//alert(obj);
				XypayCommon.MessageAlert('提示', '请选择一条信息!', 'warning');
				return;
			}
			if(rows.length>1){
				XypayCommon.MessageAlert('提示', '请只选择一条需要修改的信息!', 'warning');
				return;
			}
			var row = rows[0];			
			//冻结，注销状态不允许编辑
			
			if (row.accCheStatus != '初始状态') {
				XypayCommon.MessageAlert('提示', '初始状态才能编辑!', 'warning');
				return;
			}
			//显示div
			//不可编辑UI
			$('#accCheSpaccid').combobox('readonly', true);
			$('#accCheRate').numberbox('readonly', true);
			$('#accCheDiff').numberbox('readonly', true);	
			$('#accCheNo').numberbox('readonly', true);
			//隐藏UI
			$('#accCheIdDiv').hide();
			if (row) {
				$("#ResourceDlg").dialog({
					title : "编辑",
					closed : false,
					top : 0,
					width : 400,
					height : 400,
					modal : true
				});	
				
				$('#ResourceForm').form('clear');
				$.get("getApplyResourceById.json", {
					accCheId : row.accCheNo
				}, function(data) {
					data = XypayCommon.toJson(data);
					//alert(JSON.stringify(data));
					$('#ResourceForm').form('load', data);
					$('#accCheSpaccid').combobox('setValue',data.accId);    	
			    	$('#accCheRate').numberbox('setValue',data.accCheRate);
			    	$('#accCheTotal').numberbox('setValue',data.accCheTotal);
			    	$('#accCheSuc').numberbox('setValue',data.accCheSuc);
			    	$('#accCheAmt').numberbox('setValue','');
			    	$('#accCheDiff').numberbox('setValue',data.accCheDiff);
			    	$('#accCheReason').textbox('setValue',data.accCheReason);  
			    	$('#accCheStarttime').datebox('setValue',data.accCheStarttime);  
			    	$('#accCheEndtime').datebox('setValue',data.accCheEndtime);  
			    	$('#accCheId').textbox('setValue',data.accCheNo);
				});
				$('#accCheAmt').textbox({
					onChange : function(newValue,oldValue){
						//alert(JSON.stringify($('#accCheStarttime').datebox('getValue')));
						$.get('getDiff.json', {							
							accCheSpaccid : $('#accCheSpaccid').combobox('getValue'),
							accCheAmt : newValue ,
							accCheStarttime : $('#accCheStarttime').datebox('getValue'),
							accCheEndtime : $('#accCheEndtime').datebox('getValue'),
						}, function(data) {	
							//alert(data);
							$('#accCheDiff').numberbox('setValue',data);
						}, 'json');
					}	
					});
				url = "apply/edit";
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
			//待审核才能删除
			if(row.accCheStatus != '初始状态'){
				XypayCommon.MessageAlert('提示', '只有初始状态才能删除操作!','warning');
				return;
			}
			
			//只能删除单条
			if(rows.length>1){
				XypayCommon.MessageAlert('提示', '请只选择一条需要删除的信息!', 'warning');
				return;
			}
			
			$.messager.confirm('确认', '确定要删除该信息?', function(r) {
				if (r) {
					$.post('apply/remove', {
						accCheId : row.accCheNo
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
        function passAction(){
 	       // alert(1);
 			var obj = $('#Table');
 			var rows = obj.datagrid('getSelections');
 			if(XypayCommon.getSelectRowCurPage(obj) == false){
 				XypayCommon.MessageAlert('提示', '请选择一条信息!','warning');
 				return;
 			}

 			$.messager.confirm('确认', '确定要审批通过该信息?', function(r) {
 				if (r) {
 					for(var i=0; i<rows.length; i++){ 			
 			 			var row = rows[i];
 			//待审核才能审批通过
 			if(row.accCheStatus != '待审核'){
 				XypayCommon.MessageAlert('提示', '只有待审核状态才能审批通过操作!','warning');
 				continue;
 			}
 					$.post('apply/pass', {
 						accCheId : row.accCheNo
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
 				}
 			});
 		}
        function refuseAction(){
 	       // alert(1);
 			var obj = $('#Table');
 			var rows = obj.datagrid('getSelections');
 			if(XypayCommon.getSelectRowCurPage(obj) == false){
 				XypayCommon.MessageAlert('提示', '请选择一条信息!','warning');
 				return;
 			}
 			$.messager.confirm('确认', '确定要审批拒绝该信息?', function(r) {
 				if (r) {
 					for(var i=0; i<rows.length; i++){ 			
 			 			var row = rows[i];
 			 			//待审核才能审批拒绝
 			 			if(row.accCheStatus != '待审核'){
 			 				XypayCommon.MessageAlert('提示', '只有待审核状态才能审批拒绝操作!','warning');
 			 				continue;
 			 			}
 					$.post('apply/refuse', {
 						accCheId : row.accCheNo
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
 				}
 			});
 		}
        function view() {
			var obj = $('#Table');
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
				$.get("getApplyResourceById.json", {
					accCheId : row.accCheNo
				}, function(data) {
					data = XypayCommon.toJson(data);
					//alert(JSON.stringify(data));
					$('#viewResourceForm').form('load', data);
					$('#viewAccCheReason').textbox('setValue', data.accCheReason);
				});
			}
		};
		
		function commitAction() {
			var obj=$('#Table');
			var rows=obj.datagrid('getSelections');
			if(XypayCommon.getSelectRowCurPage(obj) == false){
 				XypayCommon.MessageAlert('提示', '请选择一条信息!','warning');
 				return;
 			}
			$.messager.confirm('确认', '确定要提交该信息审核?', function(r) {
				if (r) {
					for(var i=0; i<rows.length; i++){
						var row = rows[i];
 			 			//待审核才能审批拒绝
 			 			if(row.accCheStatus != '初始状态'){
 			 				XypayCommon.MessageAlert('提示', '只有初始状态才能提交审批!','warning');
 			 				continue;
 			 			}
 			 			$.post('apply/commit', {
 	 						accCheId : row.accCheNo
 	 					}, function(result) {
 	 						result = XypayCommon.toJson(result);
 	 						if (result.success) {
 	 							$('#Table').datagrid('reload');
 	 							//提示信息
 	 							XypayCommon.MessageAlert('提示', '提交成功!','info');
 	 						} else {
 	 							XypayCommon.MessageAlert('提示', result.msg,'warning');
 	 						}
 	 					}, 'json');
 	 					}
					}
				}
			);
		}
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