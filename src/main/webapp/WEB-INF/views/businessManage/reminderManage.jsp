<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../common.jsp"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>余额提醒管理</title>
	
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
<body style="margin:0 auto;" onload="XypayCommon.RemoveMask();">
	<div id="reminderHeader" class="pageHeader hiddenDiv" style="height:70px;padding-top: 10px;"> 
	    <div style="margin-left:8px">
	       客户账户号：     
	        <input id="cstAccNoQuery" class="easyui-textbox" style="width:100px;" data-options="required:false,validType:'maxLength[50]'">  
	        客户编号：     
	        <input id="cstIdQuery" class="easyui-textbox" style="width:100px;" data-options="required:false,validType:'maxLength[50]'">    
	        客户名称：     
	        <input id="cstNameQuery" class="easyui-textbox" style="width:100px;" data-options="required:false,validType:'maxLength[50]'">  
	       状态： <select id="statusQuery" class="easyui-combobox" style="width:105px;" editable="false" panelHeight="auto">
	       	 			<option value="" selected="selected">全部</option>
	       	 			<c:forEach var="statusType" items="${statusMap}">
						<option value="${statusType.key}">${statusType.value}</option>
						</c:forEach>
       		  </select> 
                   创建时间：<input id="beginDate" class="easyui-datebox" style="width:100px" onchange="javascript:" editable="false">
             <label style=" text-align:left;margin-left:15px">到：</label>
             <input id="endDate" class="easyui-datebox" style="width:100px" editable="false">  
	        <a onclick="javascript:searchReminder();" class="easyui-linkbutton" iconCls="icon-search">查询</a>    
	        <a onclick="javascript:reset();" class="easyui-linkbutton" iconCls="icon-reset">重置</a>   
	    </div>  	   
	    <div class="pageToolbar">
	        <!-- 由于'查看'操作无需权限控制 对所有人开放 -->
	        	<a onclick="javascript:view();" class="easyui-linkbutton" iconCls="icon-view" plain="true">查看详情</a> 
	    	<shiro:hasPermission name="business:reminder:add">     
	        	<a onclick="javascript:createReminder();" class="easyui-linkbutton" iconCls="icon-add" plain="true">添加</a> 
	        </shiro:hasPermission>   
	        <shiro:hasPermission name="business:reminder:edit">
	        	<a onclick="javascript:editReminder();" class="easyui-linkbutton" iconCls="icon-edit" plain="true">编辑</a>        	
	        </shiro:hasPermission>
	        <shiro:hasPermission name="business:reminder:enable">   
	        	<a onclick="javascript:enableReminder();" class="easyui-linkbutton" iconCls="icon-ok" plain="true">启用</a>   
	    	</shiro:hasPermission>  
	        <shiro:hasPermission name="business:reminder:disable">  
	        	<a onclick="javascript:disableReminder();" class="easyui-linkbutton" iconCls="icon-cancel" plain="true">停用</a>   
	        </shiro:hasPermission>
	       
	    </div>      
	</div> 
	<div class="hiddenDiv" style="width: 100%;height:100%;">
		<table id="reminderTable" class="easyui-datagrid" toolbar="#reminderHeader" singleSelect="true" fitColumns="true" rownumbers="true"
			   fit="true" pagination="true" collapsible="true" autoRowHeight="true" idField="rowId">
		    <thead>    
		        <tr>    
		            <!-- <th field="id" width="10">用户编号</th> -->
		            <th data-options="field:'cstNo'" width="10%">客户编号</th> 
		            <th data-options="field:'cstName'" width="10%">客户名称</th>
		            <th data-options="field:'cstAccNo'" width="5%">客户账户号</th>
		            <th data-options="field:'cstAccType'" width="5%">账户类型</th>		        		            
		            <th data-options="field:'stt'" width="5%">状态</th>
		            <th data-options="field:'opUser'"  width="5%">录入操作员</th> 
		            <th data-options="field:'createdate'"  width="10%">录入时间</th> 
		            <th data-options="field:'lastUpdateUser'"  width="10%">最后更新人员</th>
		            <th data-options="field:'lastUpdatedate'" width="10%">最后更新时间</th> 
		        </tr>    
		    </thead>		
		</table>
	</div>
	
	 <!-- 用户资源form区域 -->
    <div id="remResourceDlg" class="easyui-dialog hiddenDiv" style="width:400px;height:420px;padding:10px 20px;"
         closed="true" buttons="#remResourceDlg-buttons">
        <form class="dlgForm" id="remResourceForm" method="post" novalidate>
            <div class="dlgFormItem" id="remIdDiv" style="display:none" >
                <label style=" text-align: right">余额提醒编号：</label>
                <input name="remId" id="remId" class="easyui-textbox"/>
            </div>
             <div class="dlgFormItem">
				<label style="text-align: right;">客户名称：</label> <select
					id="cstName" name="cstName" class="easyui-combobox"
					style="width: 105px;" editable="false" height="200px" overflow="auto" 
					requird="true" validType="selectValueRequired">
					<option value="" selected="selected">请选择</option>
					<c:forEach var="cstAccInfMap" items="${cstAccInfMap}">
						<option value="${cstAccInfMap.key}">${cstAccInfMap.value}</option>
					</c:forEach>
				</select>
			</div>
			<div class="dlgFormItem">
				<label style="text-align: right;">账户类型：</label> <select
					id="cstAccType" name="cstAccType" class="easyui-combobox"
					style="width: 105px;" editable="false" panelHeight="auto"
					requird="true" validType="selectValueRequired">					
				</select>
			</div>
			<div class="dlgFormItem">
				<label style="text-align: right;">客户账户：</label> 
				<select
					id="cstAccId" name="cstAccId" class="easyui-combobox"
					style="width: 105px;" editable="false" panelHeight="auto"
					requird="true" validType="selectValueRequired">
				</select>
			</div>	
            <div class="dlgFormItem" id="remLimitDiv">
                <label style=" text-align: right">提醒限额：</label>
                <input name="remLimit" id="remLimit" class="easyui-textbox" data-options="required:true,validType:['digitalReg', 'maxLength[30]']"/>
            </div>
            <div class="dlgFormItem" id="remPerDiv">
                <label style=" text-align: right">提醒号码：</label>
                <input name="remPer" id="remPer" class="easyui-textbox" style="height:50px;" data-options="multiline:true,required:true,validType:['maxLength[200]']"/>
            </div>
            <div class="dlgFormItem" id="remConDiv"  >
                <label style=" text-align: right">提醒内容：</label>
                <input name="remCon" id="remCon" class="easyui-textbox" style="height:50px;" data-options="multiline:true,required:true,validType:['maxLength[200]']"/>
            </div>         
            
            <div class="dlgFormItem">
                <label style=" text-align: right">提醒方式：</label>
                <select name="remType" id="remType" class="easyui-combobox" style="width:164px;" required="true" editable="false" panelHeight="auto">
					<c:forEach var="remType" items="${remTypeMap}">
					<option value="${remType.key}">${remType.value}</option>
					</c:forEach>
				</select>
            </div>
           
        </form>
    </div>
    <div id="remResourceDlg-buttons" class="hiddenDiv">
        <a onclick="javascript:saveRem()" class="easyui-linkbutton c6" iconCls="icon-ok" id="btnSave" style="width:90px">保存</a>
        <a class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#remResourceDlg').dialog('close')" style="width:90px">取消</a>
    </div>
 	
   <script type="text/javascript">

       //注册easyUI中select组件onchange事件
       $(document).ready(
    			function(){
    			
    				//注册事件,当用户回车触发查询操作
    				document.onkeydown = function(e){ 
    				    var ev = document.all ? window.event : e;
    				    if(ev.keyCode==13) {
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
		var url;
	  
		//点击'用户管理'菜单即加载查询数据
	    $(function(){
	    	$.extend($.fn.validatebox.defaults.rules, {    
			     mobileReg: { //验证手机号   
			         validator: function(value, param){ 
			          return /^1[3-8]+\d{9}$/i.test($.trim(value));
			         },    
			         message: '请输入正确的手机号码。'   
			     },
			     phoneReg: { //验证固定号码   
			         validator: function(value, param){ 
			          return /^((0\d{2,3})-)(\d{7,8})(-(\d{3,}))?$/i.test($.trim(value));
			         },    
			         message: '请输入正确的固定电话号码。'   
			     },
			     digitalReg:{ //既验证手机号，又验证座机号
			      validator: function(value, param){ 
			           return /^[1-9]\d*$/.test($.trim(value));
			          },    
			          message: '请输入正整数。' 
			     }  
		     });
	    	
	    	search();
		});
	    
		function search(){ 
	    	var options = $('#reminderTable').datagrid('options');
	    	options.url = "reminderPage.json";
	    	$('#reminderTable').datagrid('reload',{
	    		cstAccNo:$('#cstAccNoQuery').val(),
	    		cstId:$('#cstIdQuery').val(),
	    		cstName:$('#cstNameQuery').val(),
	        	status:$('#statusQuery').combobox('getValue'),
	        	beginDate:$('#beginDate').datebox('getValue'),
	        	endDate:$('#endDate').datebox('getValue')
	    	});
		}
		
		function searchReminder(){  
	        $('#reminderTable').datagrid('load',{
	        	cstAccNo:$('#cstAccNoQuery').val(),
	        	cstId:$('#cstIdQuery').val(),
	    		cstName:$('#cstNameQuery').val(),
	        	status:$('#statusQuery').combobox('getValue'),
	        	beginDate:$('#beginDate').datebox('getValue'),
	        	endDate:$('#endDate').datebox('getValue')
	        });  
	    }
		
		function reset(){
			 $('#cstAccNoQuery').textbox('setValue', '');
	    	 $('#cstIdQuery').textbox('setValue', '');
	    	 $('#cstNameQuery').textbox('setValue', '');
	    	 $('#statusQuery').combobox('setValue','');
	    	 $('#beginDate').datebox('setValue','');
	    	 $('#endDate').datebox('setValue','');
	    } 
		
		function enableReminder() {
			var obj = $('#reminderTable');
			var rows = obj.datagrid('getSelections');
			if(XypayCommon.getSelectRowCurPage(obj) == false){
				XypayCommon.MessageAlert('提示', '请选择一条信息!','warning');
				return;
			}
			var row = rows[0];
			if(row.stt == '启用'){
				XypayCommon.MessageAlert('提示', '该条关键字信息已经启用!','warning');
				return;
			}
			$.messager.confirm('确认', '确定要启用该条关键字信息?', function(r) {
				if (r) {
					$.post('reminder/enable', {
						rowId : row.rowId
					}, function(result) {
						result = XypayCommon.toJson(result);
						if (result.success) {
							$('#reminderTable').datagrid('reload'); // reload the user data
							XypayCommon.MessageAlert('提示', '操作成功!','info');
						} else {
							XypayCommon.MessageAlert('提示', result.msg,'warning');
						}
					}, 'json');
				}
			});
		}
		function disableReminder() {
			var obj = $('#reminderTable');
			var rows = obj.datagrid('getSelections');
			if(XypayCommon.getSelectRowCurPage(obj) == false){
				XypayCommon.MessageAlert('提示', '请选择一条信息!','warning');
				return;
			}
			var row = rows[0];
			if(row.stt == '停用'){
				XypayCommon.MessageAlert('提示', '该条关键字信息已经停用!','warning');
				return;
			}
			$.messager.confirm('确认', '确定要停用该条关键字信息?', function(r) {
				if (r) {
					$.post('reminder/disable', {
						rowId : row.rowId
					}, function(result) {
						result = XypayCommon.toJson(result);
						if (result.success) {
							$('#reminderTable').datagrid('reload'); // reload the user data
							XypayCommon.MessageAlert('提示', '操作成功!','info');
						} else {
							XypayCommon.MessageAlert('提示', result.msg,'warning');
						}
					}, 'json');
				}
			});
		}
		

		function saveRem() {
			//$('#remCstId').textbox('enable',true);
			XypayCommon.genCsrfToken($('#remResourceForm'));
			$('#remResourceForm').form('submit', {
				url : url,
				onSubmit : function() {
					return $(this).form('validate');
				},
				success : function(result) {
					result = XypayCommon.toJson(result);
					if (result.success) {
						$('#remResourceDlg').dialog('close'); // close the dialog
						$('#reminderTable').datagrid('reload');    // reload the user data	
						XypayCommon.MessageAlert('提示', '操作成功!','info');
					} else {
						XypayCommon.MessageAlert('提示', result.msg,'error');
					}
				}
			});
		}
		
		function createReminder(){  
	   		$("#remResourceDlg").dialog({
                title: "添加",  
                closed: false,
                top:0,
                width: 400,  
	    		height: 400,
                modal:true
		    });
	   		//可编辑
	   		$('#cstAccId').combobox('enable', true);
			$('#cstName').combobox('enable', true);
			$('#cstAccType').combobox('enable', true);
			
	        $('#remResourceForm').form('clear');
	        $('#cstAccType').combobox('loadData', {});
			$('#cstAccId').combobox('loadData', {}); 
			$('#cstAccType').combobox('setText',"请选择");
			$('#cstAccId').combobox('setText',"请选择");	
	        $('#remType').combobox('setValue',0); 
	       // $('#remCstId').textbox('enable',true);
	    	$('#remPer').textbox('enable',true);
	    	$('#remLimit').textbox('enable',true);
	    	$('#remCon').textbox('enable',true);
	    	$('#remType').combobox('enable',true);
			$('#btnSave').linkbutton({disabled:false});
			$('#cstName').combobox({
				valueField : 'itemCode',
				textField : 'itemName',
				onSelect : function(params) {
					$.get('getCstAccInfo.json', {
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
   								    editable: false
								});							
								$('#cstAccId').combobox('setText',"请选择");						
							},
							editable: false
							});						
						$('#cstAccType').combobox('setText',"请选择");
						$('#cstAccId').combobox('loadData', {}); 
						$('#cstAccId').combobox('setText',"请选择");									
					}, 'json');
				}
         }); 
			url = "reminder/add";
	    } 
	
		function editReminder() {
			
			var obj = $('#reminderTable');
			var rows = obj.datagrid('getSelections');
			if(XypayCommon.getSelectRowCurPage(obj) == false){
				XypayCommon.MessageAlert('提示', '请选择一条信息!','warning');
				return;
			}
			var row = rows[0];
			//注销状态不允许编辑
			if(row.stt == '启用'){
				XypayCommon.MessageAlert('提示', '请先停用后再进行编辑!','warning');
				return;
			}
			
	    	//$('#remCstId').textbox('disable',true);
	    	$('#cstAccId').combobox('disable', true);
			$('#cstName').combobox('disable', true);
			$('#cstAccType').combobox('disable', true);
	    	$('#remPer').textbox('enable',true);
	    	$('#remLimit').textbox('enable',true);
	    	$('#remCon').textbox('enable',true);
	    	$('#remType').combobox('enable',true);
	    	
			if (row) {
				$("#remResourceDlg").dialog({
	                title: "编辑",  
	                closed: false,
	                top:0,
	                width: 400,  
		    		height: 320,
	                modal:true
			    });  
				
				$('#remResourceDlg').form('clear');
				$.get("getRemById.json", {id:row.rowId}, function (data){
					data = XypayCommon.toJson(data);
					$('#userResourceForm').form('load', data);
					//alert(JSON.stringify(data));
			    	$('#remId').textbox('setValue',data.remId);
			    	//$('#remCstId').textbox('setValue',data.balRemCstid);
			    	$('#remLimit').textbox('setValue',data.balRemBal);
			    	$('#remPer').textbox('setValue',data.balRemMobile);
			    	$('#remCon').textbox('setValue',data.balRemContent);
					$('#remType').combobox('setValue',data.balRemType?data.balRemType:'');
					$('#cstName').combobox('setText',data.cstName);
			    	$('#cstAccType').combobox('setValue',data.cstAccType);
			    	$('#cstAccId').combobox('setText',data.cstAccNo);
			
				});
			    url = 'reminder/update';
			}
			
			$('#btnSave').linkbutton({disabled:false});
		}
		
		function view() {
			
			var obj = $('#reminderTable');
			var rows = obj.datagrid('getSelections');
			if(XypayCommon.getSelectRowCurPage(obj) == false){
				XypayCommon.MessageAlert('提示', '请选择一条信息!','warning');
				return;
			}
			var row = rows[0];
			$('#cstAccId').combobox('disable', true);
			$('#cstName').combobox('disable', true);
			$('#cstAccType').combobox('disable', true);
	    	//$('#remCstId').textbox('disable',true);
	    	$('#remPer').textbox('disable',true);
	    	$('#remLimit').textbox('disable',true);
	    	$('#remCon').textbox('disable',true);
	    	$('#remType').combobox('disable',true);
	    
			if (row) {
				$("#remResourceDlg").dialog({
	                title: "查看",  
	                closed: false,
	                top:0,
	                width: 400,  
		    		height: 400,
	                modal:true
			    });  
				
				$('#remResourceDlg').form('clear');
				$.get("getRemById.json", {id:row.rowId}, function (data){
					data = XypayCommon.toJson(data);
					$('#userResourceForm').form('load', data);
					//alert(JSON.stringify(data));
			    	$('#cstName').combobox('setText',data.cstName);
			    	$('#cstAccType').combobox('setValue',data.cstAccType);
			    	$('#cstAccId').combobox('setText',data.cstAccNo);
			    	
			    	$('#remLimit').textbox('setValue',data.balRemBal);
			    	$('#remPer').textbox('setValue',data.balRemMobile);
			    	$('#remCon').textbox('setValue',data.balRemContent);
					$('#remType').combobox('setValue',data.balRemType?data.balRemType:'');
			
				});    
			}
			
			$('#btnSave').linkbutton({disabled:true});
		}
		
	</script>	
</body>
</html>