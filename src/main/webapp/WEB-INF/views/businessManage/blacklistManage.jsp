<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../common.jsp"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>黑名单管理</title>
	
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
	<div id="blacklistHeader" class="pageHeader hiddenDiv" style="height:70px;padding-top: 10px;"> 
	    <div style="margin-left:8px"> 
	        手机号码：     
	        <input id="mobileQuery" class="easyui-textbox" style="width:100px;" data-options="required:false,validType:'maxLength[50]'">    
	     
	       状态： <select id="statusQuery" class="easyui-combobox" style="width:105px;" editable="false" panelHeight="auto">
	       	 			<option value="" selected="selected">全部</option>
	       	 			<c:forEach var="blacklistStatusType" items="${blacklistStatusMap}">
						<option value="${blacklistStatusType.key}">${blacklistStatusType.value}</option>
						</c:forEach>
       		  </select> 
                   创建时间：<input id="beginDate" class="easyui-datebox" style="width:100px" onchange="javascript:" editable="false">
             <label style=" text-align:left;margin-left:15px">到：</label>
             <input id="endDate" class="easyui-datebox" style="width:100px" editable="false">  
	        <a onclick="javascript:searchBlacklist();" class="easyui-linkbutton" iconCls="icon-search">查询</a>    
	        <a onclick="javascript:reset();" class="easyui-linkbutton" iconCls="icon-reset">重置</a>   
	    </div>  	   
	    <div class="pageToolbar">
	        <!-- 由于'查看'操作无需权限控制 对所有人开放 -->
	        
	    	<shiro:hasPermission name="business:blacklist:add">     
	        	<a onclick="javascript:createBlacklist();" class="easyui-linkbutton" iconCls="icon-add" plain="true">添加</a> 
	        </shiro:hasPermission>   
	        <shiro:hasPermission name="business:blacklist:stop">  
	        	<a onclick="javascript:disableBlacklist();" class="easyui-linkbutton" iconCls="icon-cancel" plain="true">停用</a> 
	        </shiro:hasPermission>   
	        <shiro:hasPermission name="business:blacklist:import">
	       	 	<a onclick="javascript:importBlacklist();" class="easyui-linkbutton" iconCls="icon-excel" plain="true">导入</a>
	    	</shiro:hasPermission>	        
	    </div>      
	</div> 
	<div class="hiddenDiv" style="width: 100%;height:100%;">
		<table id="blacklistTable" class="easyui-datagrid" toolbar="#blacklistHeader" singleSelect="true" fitColumns="true" rownumbers="true"
			   fit="true" pagination="true" collapsible="true" autoRowHeight="true" idField="id">
		    <thead>    
		        <tr>    
		            <!-- <th field="id" width="10">用户编号</th> --> 
		            <th data-options="field:'mobile'" width="10%">手机号</th> 
		            <th data-options="field:'reason'" width="10%">录入原因</th> 
		            <th data-options="field:'stt'" width="10%">状态</th>
		            <th data-options="field:'opUser'"  width="10%">录入操作员</th> 
		            <th data-options="field:'createdate'"  width="10%">录入时间</th> 
		            <th data-options="field:'lastUpdateUser'"  width="10%">最后更新人员</th>
		            <th data-options="field:'lastUpdatedate'" width="10%">最后更新时间</th> 
		        </tr>    
		    </thead>		
		</table>
	</div>
	
	 <div id="addBlacklistDlg" class="easyui-dialog hiddenDiv" style="width:400px;height:250px;padding:10px 20px;"
         closed="true" buttons="#addBlacklistDlg-buttons">
        <form class="dlgForm" id="addBlacklistForm" method="post" >
            <div class="dlgFormItem">
                <label style=" text-align: right">黑名单号码：</label>
                <input class="easyui-textbox" type="text" name="addMobile" data-options="required:true,validType:'mobileReg'"></input>
            </div>
            <div class="dlgFormItem">
                <label style=" text-align: right">录入原因：</label>
                <textarea class="easyui-textbox" style="width:165px;height:50px" name="addReason" data-options="required:true,multiline:true,validType:'maxLength[200]'"></textarea>
            </div>         
        </form>
    </div>
    <div id="addBlacklistDlg-buttons" class="hiddenDiv">
        <a onclick="javascript:saveBlacklist()" class="easyui-linkbutton c6" iconCls="icon-ok" style="width:90px">保存</a>
        <a class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#addBlacklistDlg').dialog('close')" style="width:90px">取消</a>
    </div>
    
    
    <!-- show window -->
    <div id="resourceDlg" class="easyui-dialog hiddenDiv" style="width:490px;height:150px;padding:10px 20px;"
         buttons="#resourceDlg-buttons" data-options="modal:true,closed:true,iconCls:'icon-excel'">
        <form class="dlgForm" id="resourceForm" method="post" enctype="multipart/form-data" novalidate >
        	<div class="dlgFormItem" id="uploadExcelProgress">
                <div id="progressbarExcel" style="color:red;font-weight:bold;text-align:center;">正在上传中，请稍等...</div>
            </div>
            <div class="dlgFormItem" id="uploadExcelShow">
                <label>请选择文件：</label>
                <input id="uploadExcel" name="uploadExcel" class="easyui-filebox" clear  multiple="multiple" required="true" style="width:280px" data-options="prompt:'请选择文件...'">
            </div>
        </form>
    </div>
    <div id="resourceDlg-buttons" class="hiddenDiv">
        <a onclick="javascript:uploadBlack();" class="easyui-linkbutton c6" id="saveOutBlack" iconCls="icon-ok" style="width:90px">提交</a>
        <a class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#resourceDlg').dialog('close');" style="width:90px">取消</a>
    </div>
    	
   <script type="text/javascript">

       //注册easyUI中select组件onchange事件
       $(document).ready(
    			function(){
    				$.extend($.fn.validatebox.defaults.rules, {    
    				     mobileReg: { //验证手机号   
    				         validator: function(value, param){ 
    				          return /^1[3-8]+\d{9}$/.test($.trim(value));
    				         },    
    				         message: '请输入正确的手机号码。'   
    				     } 
    			     });

    				//注册事件,当用户回车触发查询操作
    				document.onkeydown = function(e){ 
    				    var ev = document.all ? window.event : e;
    				    if(ev.keyCode==13) {
    				    	search();
    				     }
    				};
    				
       });

    </script>
    	
	<script>
	  
		//点击'用户管理'菜单即加载查询数据
	    $(function(){
	    	search();
		});
	    
		function search(){ 
	    	var options = $('#blacklistTable').datagrid('options');
	    	options.url = "blacklistPage.json";
	    	$('#blacklistTable').datagrid('reload',{
	    		mobile:$('#mobileQuery').val(),
	        	status:$('#statusQuery').combobox('getValue'),
	        	beginDate:$('#beginDate').datebox('getValue'),
	        	endDate:$('#endDate').datebox('getValue')
	    	});
		}
		
		function searchBlacklist(){  
	        $('#blacklistTable').datagrid('load',{  
	        	mobile:$('#mobileQuery').val(),
	        	status:$('#statusQuery').combobox('getValue'),
	        	beginDate:$('#beginDate').datebox('getValue'),
	        	endDate:$('#endDate').datebox('getValue')
	        });  
	    }
		
		function reset(){ 
	    	 $('#mobileQuery').textbox('setValue', '');
	    	 $('#statusQuery').combobox('setValue','');
	    	 $('#beginDate').datebox('setValue','');
	    	 $('#endDate').datebox('setValue','');
	    }  
		function disableBlacklist() {
			
			var obj = $('#blacklistTable');
			var rows = obj.datagrid('getSelections');
			if(XypayCommon.getSelectRowCurPage(obj) == false){
				XypayCommon.MessageAlert('提示', '请选择一条信息!','warning');
				return;
			}
			
			var row = rows[0];

			if(row.stt == '停用'){
				XypayCommon.MessageAlert('提示', '该条黑名单信息已经停用!','warning');
				return;
			}
			
			$.messager.confirm('确认', '确定要停用该条黑名单信息?', function(r) {
				if (r) {
					$.post('blacklist/disable', {
						rowId : row.rowId
					}, function(result) {
						result = XypayCommon.toJson(result);
						if (result.success) {
							$('#blacklistTable').datagrid('reload'); // reload the user data
							XypayCommon.MessageAlert('提示', '操作成功!','info');
						} else {
							XypayCommon.MessageAlert('提示', result.msg,'warning');
						}
					}, 'json');
				}
			});
		}
		
		function createBlacklist(){
			$('#addBlacklistDlg').dialog({
                title: "添加",  
                closed: false,
                top:0,
                width: 400,  
	    		height: 250,
                modal:true
		    });   
	        $('#addBlacklistForm').form('clear');
		}
		
		function saveBlacklist() {
			var url = "blacklist/add";
			XypayCommon.genCsrfToken($('#addBlacklistForm'));
			$('#addBlacklistForm').form('submit', {
				url : url,
				onSubmit : function() {
					return $(this).form('validate');
				},
				success : function(result) {
					result = XypayCommon.toJson(result);
					if (result.success) {
						$('#addBlacklistDlg').dialog('close'); // close the dialog
						$('#blacklistTable').datagrid('reload');    // reload the user data	
						XypayCommon.MessageAlert('提示', '操作成功!','info');
					} else {
						XypayCommon.MessageAlert('提示', result.msg,'error');
					}
				}
			});
		}
		function importBlacklist(){
	    	 $('#resourceDlg').dialog('open').dialog('center').dialog('setTitle','Excel导入');
	         $('#resourceForm span:last').html('选择文件');
			 $("#uploadExcelShow").show();
			 $("#uploadExcelProgress").hide();
			 $('#resourceForm').form('reset');
	         url = 'blacklist/importBlacklist';
	    }
		
		function uploadBlack() {
			   //得到上传文件的全路径  
		       var fileName= $('#uploadExcel').filebox('getValue'); 
		       //进行基本校验  
	           if(fileName==""){     
	              $.messager.alert('提示','请选择上传文件！','info');   
	           }else{  
	               //对文件格式进行校验  
	               var d1=/\.[^\.]+$/.exec(fileName);   
	               if(d1==".xls"||".xlsx"==d1){  
	            	   start();
	                    //提交表单  
	                    $('#resourceForm').form('submit', {
	        				url : url,
	        				onSubmit : function() {
	        					return $(this).form('validate');
	        				},
	        				success : function(result) {
	        					result = XypayCommon.toJson(result);
	        					$("#uploadExcelShow").show();
	    						$("#uploadExcelProgress").hide();
	    						$('#saveOutBlack').linkbutton('enable'); 
	        					if (result.success) {
	        						$('#resourceDlg').dialog('close'); // close the dialog
	        						$('#blacklistTable').datagrid('reload');  // reload the user data		
	        						XypayCommon.MessageAlert('提示', result.msg,'info');
	        						return;
	        					} else {
	        						$('#resourceDlg').dialog('close'); // 导入失败，为防止卡在  正在导入中，直接关闭导出弹出框
	        						$('#blacklistTable').datagrid('reload'); 		
	        						XypayCommon.MessageAlert('提示', result.msg,'error');
	        						return;
	        					}
	        				}
	        			});         
	              }else{  
	                  $.messager.alert('提示','请选择Excel2003或者Excel2007格式文件！','info');  
	              }  
	           }   
			}
		function start(){
			$("#uploadExcelShow").hide();
			$("#uploadExcelProgress").show();
			$("#saveOutBlack").linkbutton("disable");
		};
				
	</script>	
	
</body>
</html>