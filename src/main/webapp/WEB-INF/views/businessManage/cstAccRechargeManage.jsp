<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../common.jsp"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>充值申请与审核</title>

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
			客户名称： <input id="cstNameQuery" class="easyui-textbox"
				style="width: 100px;"
				data-options="required:false,validType:'maxLength[20]'"> 
			客户账户：<input id="cstAccNoQuery" class="easyui-textbox" style="width: 100px;"
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
			<shiro:hasPermission name="business:recharge:add">
				<a onclick="javascript:create();" class="easyui-linkbutton"
					iconCls="icon-add" plain="true">新增</a>
			</shiro:hasPermission>
			<shiro:hasPermission name="business:recharge:edit">
				<a onclick="javascript:edit();" class="easyui-linkbutton"
					iconCls="icon-edit" plain="true">修改</a>
			</shiro:hasPermission>
			<shiro:hasPermission name="business:recharge:remove">  
	        	<a onclick="javascript:removeAction();" class="easyui-linkbutton"
	        	    iconCls="icon-remove" plain="true">删除</a> 
	        </shiro:hasPermission>
			<shiro:hasPermission name="business:recharge:commit">
				<a onclick="javascript:commitAction();" class="easyui-linkbutton"
					iconCls="icon-ok" plain="true">提交审核</a>
			</shiro:hasPermission>
			<shiro:hasPermission name="business:recharge:pass">  
	        	<a onclick="javascript:passAction();" class="easyui-linkbutton"
	        	    iconCls="icon-ok" plain="true">审核通过</a> 
	        </shiro:hasPermission>
	        <shiro:hasPermission name="business:recharge:refuse">  
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
			autoRowHeight="true" idField="rchId">
			<thead>
				<tr>
					<!-- <th field="id" width="10">用户编号</th> -->
					<th data-options="field:'orderNo'" width="10%">充值订单号</th>
					<th data-options="field:'cstAccNo'" width="5%">客户账户</th>
					<th data-options="field:'cstName'" width="5%">客户名称</th>
					<th data-options="field:'cstAccType'" width="5%">账户类型</th>
					<th data-options="field:'amt'" width="5%">金额</th>
					<th data-options="field:'rate'" width="5%">费率</th>
					<th data-options="field:'count'" width="5%">条数</th>
					<th data-options="field:'status'" width="5%">状态</th>
					<th data-options="field:'applier'" width="5%">申请人</th>
					<th data-options="field:'apptime'" width="10%" formatter="XypayCommon.TimeFormatter">申请时间</th>
					<th data-options="field:'checker'" width="8%">审核人</th>
					<th data-options="field:'checktime'" width="10%" formatter="XypayCommon.TimeFormatter">审核时间</th>
				</tr>
			</thead>
		</table>
	</div>
	<!--用户资源区-->
	<div id="ResourceDlg" class="easyui-dialog hiddenDiv"
		style="width: 400px; height: 420px; padding: 10px 20px;" closed="true"
		buttons="#ResourceDlg-buttons">
		<form class="dlgForm" id="ResourceForm" method="post">
			<div class="dlgFormItem" id="rchIdDiv">
				<label style="text-align: right; width: 90px">充值ID</label> <input
					class="easyui-textbox" type="text" name="rchId" id="rchId" 
			    ></input>
			</div>
			<div class="dlgFormItem" id="orderNoDiv">
				<label style="text-align: right; width: 90px">充值订单号</label> <input
					class="easyui-textbox" type="text" name="orderNo" id="orderNo" 
				></input>
			</div>
			<div class="dlgFormItem">
				<label style="text-align: right; width: 90px">客户名称</label> <select
					id="cstName" name="cstName" class="easyui-combobox" height="200px"
					style="width: 105px;" editable="false"
					requird="true" validType="selectValueRequired">
					<option value="" selected="selected">请选择</option>
					<c:forEach var="cstAccInfMap" items="${cstAccInfMap}">
						<option value="${cstAccInfMap.key}">${cstAccInfMap.value}</option>
					</c:forEach>
				</select>
			</div>
			<div class="dlgFormItem">
				<label style="text-align: right; width: 90px">账户类型</label> <select
					id="cstAccType" name="cstAccType" class="easyui-combobox"
					style="width: 105px;" editable="false" panelHeight="auto"
					requird="true" validType="selectValueRequired">					
				</select>
			</div>
			<div class="dlgFormItem">
				<label style="text-align: right; width: 90px">客户账户</label> 
				<select
					id="cstAccId" name="cstAccId" class="easyui-combobox"
					style="width: 105px;" editable="false" panelHeight="auto"
					requird="true" validType="selectValueRequired">
				</select>
			</div>		
			<div class="dlgFormItem">
				<label style="text-align: right; width: 90px">金额</label> <input
					class="easyui-numberbox" type="text" name="amt" id="amt" 
					data-options="required:true" min="0.01" max="999999999" precision="2"></input>
			</div>
			<div class="dlgFormItem">
				<label style="text-align: right; width: 90px">费率</label>  <input
					class="easyui-numberbox" type="text" name="rate" id="rate" 
					data-options="required:true" min="0.01" max="10" precision="2">
			</div>
			<div class="dlgFormItem">
				<label style="text-align: right; width: 90px">条数</label><input
					class="easyui-numberbox" type="text" name="count" id="count" 
					data-options="required:true" min="0.0" validType="number" max="999999999.9" precision="1">
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
				//数值验证
				number : {
					validator : function(value) {
						if(value<=0){
							return false;
						}else{
							return true;
						}
					},
					message : '充值需大于0条小于999999999.9'
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
			options.url = "rechargePage.json";
			$('#Table').datagrid('reload', {
				cstNameQuery : $('#cstNameQuery').val(),
				cstAccNoQuery : $('#cstAccNoQuery').val(),				
				statusQuery : $('#statusQuery').combobox('getValue')
			});
		};

		function searchCondition() {
			$('#Table').datagrid('load', {
				cstNameQuery : $('#cstNameQuery').val(),
				cstAccNoQuery : $('#cstAccNoQuery').val(),
				statusQuery : $('#statusQuery').combobox('getValue')
			});
		};

		function reset() {
			$('#cstNameQuery').textbox('setValue', '');			
			$('#cstAccNoQuery').textbox('setValue', '');
			$('#statusQuery').combobox('setValue', '');
		};
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
			$('#rchIdDiv').hide();	
			$('#orderNoDiv').hide();	
			//开启可编辑UI
			$('#cstAccId').combobox('enable', true);
			$('#cstName').combobox('enable', true);
			$('#cstAccType').combobox('enable', true);
			$('#rate').numberbox('readonly', true);
			$('#count').numberbox('readonly', true);		
			$('#ResourceForm').form('clear');
			/**初始化输入*/
			//alert(JSON.stringify($('#cstName').combobox('getData')));
			$('#cstAccType').combobox('loadData', {});
			$('#cstAccId').combobox('loadData', {}); 
			$('#cstAccType').combobox('setText',"请选择"); 
			$('#cstAccId').combobox('setText',"请选择");			
			$('#rate').numberbox('clear');
			$('#count').numberbox('clear');
			$('#cstName').combobox({
					valueField : 'itemCode',
					textField : 'itemName',
					onSelect : function(params) {
						$.get('getCstAccInf.json', {
							cstId : params.itemCode
						}, function(data) {
							//alert(JSON.stringify(data));
							$('#cstAccType').combobox({								
								data : data,
								valueField:'cstAccType',
								textField:'cstAccTypeName',
								onSelect : function(params){
									$('#cstAccId').combobox({	
										data:data,
										valueField:'cstAccId',
										textField:'cstAccNo',
										rate:'rate',
										onSelect : function(params){
											$('#rate').numberbox('setValue',params.rate);										
										},
										editable: false
									});
									$('#cstAccId').combobox('setText',"请选择");
									$('#rate').numberbox('clear');	
								},
								editable: false
								});	
							$('#cstAccType').combobox('setText',"请选择");
							$('#cstAccId').combobox('loadData', {}); 
							$('#cstAccId').combobox('setText',"请选择");
							$('#rate').numberbox('clear');				
						}, 'json');
					}
             }); 
			$('#amt').textbox({
				onChange : function(newValue,oldValue){
					$('#count').numberbox('setValue',parseFloat($('#amt').numberbox('getValue')/$('#rate').numberbox('getValue')));
					if($('#count').numberbox('getValue')>999999999.9){
						XypayCommon.MessageAlert('提示', '充值条数最多不能超过999999999.9条', 'info');
					}
				}
				
				});
			$('#rate').textbox({
				onChange : function(newValue,oldValue){
					if(newValue!=""){
						$('#count').numberbox('setValue',parseFloat($('#amt').numberbox('getValue')/$('#rate').numberbox('getValue')));
					}else{
						$('#count').numberbox('setValue',"")
					}
					if($('#count').numberbox('getValue')>999999999.9){
						XypayCommon.MessageAlert('提示', '充值条数最多不能超过999999999.9条', 'info');
					}
				}	
				});
			
			
			
			url = "recharge/add";
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
			if(rows.length>1){
				XypayCommon.MessageAlert('提示', '请只选择一条需要修改的信息!', 'warning');
				return;
			}
			var row = rows[0];
			//冻结，注销状态不允许编辑
			
			if (row.status != '初始状态') {
				XypayCommon.MessageAlert('提示', '初始状态才能编辑!', 'warning');
				return;
			}
			//显示div
			//不可编辑UI
			$('#rchId').textbox('readonly', true);
			$('#orderNo').textbox('disable', true);
			$('#cstAccId').combobox('disable', true);
			$('#cstName').combobox('disable', true);
			$('#cstAccType').textbox('disable', true);
			$('#rate').numberbox('readonly', true);
			$('#count').numberbox('readonly', true);
			
			//隐藏UI
			$('#rchIdDiv').hide();
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
				$.get("getRechargeResourceById.json", {
					id : row.rchId
				}, function(data) {
					data = XypayCommon.toJson(data);
					//alert(JSON.stringify(data));
					//alert(JSON.stringify(data.chanNo));
					$('#ResourceForm').form('load', data);
					$('#orderNo').textbox('setValue',data.orderNo);    	
			    	$('#cstAccId').combobox('setValue',data.cstAccNo);
			    	$('#cstName').combobox('setValue',data.cstName);
			    	$('#cstAccType').combobox('setValue',data.cstAccType);
			    	$('#amt').textbox('setValue',data.amt);
			    	$('#rate').textbox('setValue',data.rate);
			    	$('#count').textbox('setValue',data.count);  
			    	$('#rchId').textbox('setValue',data.rchId);
				});
				$('#amt').textbox({
					onChange : function(newValue,oldValue){
						//alert(newValue);
						$('#count').numberbox('setValue',parseFloat($('#amt').numberbox('getValue')/$('#rate').numberbox('getValue')));
						if($('#count').numberbox('getValue')>999999999.9){
							XypayCommon.MessageAlert('提示', '充值条数最多不能超过999999999.9条', 'info');
						}
					}	
					});
				
				$('#rate').textbox({
					onChange : function(newValue,oldValue){
						if(newValue!=""){
							$('#count').numberbox('setValue',parseFloat($('#amt').numberbox('getValue')/$('#rate').numberbox('getValue')));
						}else{
							$('#count').numberbox('setValue',"")
						}
						if($('#count').numberbox('getValue')>999999999.9){
							XypayCommon.MessageAlert('提示', '充值条数最多不能超过999999999.9条', 'info');
						}
					}	
					});
				
				url = "recharge/edit";
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
			
			if(rows.length>1){
				XypayCommon.MessageAlert('提示', '请只选择一条需要删除的信息!', 'warning');
				return;
			}
			
			var row = rows[0];
			//待审核才能删除
			if(row.status != '初始状态'){
				XypayCommon.MessageAlert('提示', '只有初始状态状态才能删除操作!','warning');
				return;
			}
			
			$.messager.confirm('确认', '确定要删除该信息?', function(r) {
				if (r) {
					$.post('recharge/remove', {
						id : row.rchId
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
 			if(row.status != '待审核'){
 				XypayCommon.MessageAlert('提示', '只有待审核状态才能审批通过操作!','warning');
 				continue;
 			}
 					$.post('recharge/pass', {
 						id : row.rchId,
 						cstAccId : row.cstAccId,
 						count : row.count
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
 			 			if(row.status != '待审核'){
 			 				XypayCommon.MessageAlert('提示', '只有待审核状态才能审批拒绝操作!','warning');
 			 				continue;
 			 			}
 					$.post('recharge/refuse', {
 						id : row.rchId
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
 			 			if(row.status != '初始状态'){
 			 				XypayCommon.MessageAlert('提示', '只有初始状态才能提交审批!','warning');
 			 				continue;
 			 			}
 			 			$.post('recharge/commit', {
 	 						id : row.rchId
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

</body>
</html>