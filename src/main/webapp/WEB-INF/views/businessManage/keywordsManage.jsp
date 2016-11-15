<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../common.jsp"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>关键字管理</title>
	
	<!-- jquery easyui -->
	<link rel="stylesheet" type="text/css" href="<%=root%>/static/css/common.css">
	<link rel="stylesheet" type="text/css" href="<%=theme%>/easyui.css">
	<link rel="stylesheet" type="text/css" href="<%=root%>/static/js/easyui/themes/icon.css">
	<script type="text/javascript" src="<%=root%>/static/js/easyui/js/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="<%=root%>/static/js/easyui/js/easyui-lang-zh_CN.js"></script>
	<script type="text/javascript" src="<%=root%>/static/js/easyui/js/easyui-validator.js"></script>
	
	<script>
		ZhiyeCommon.CreateMask();
	</script>
</head>
<body style="margin:0 auto;" onload="XypayCommon.RemoveMask();">
	<div id="keywordsHeader" class="pageHeader hiddenDiv" style="height:70px;padding-top: 10px;"> 
	    <div style="margin-left:8px"> 
	        关键字内容：     
	        <input id="contentQuery" class="easyui-textbox" style="width:100px;" data-options="required:false,validType:'maxLength[50]'">    
	     
	       状态： <select id="statusQuery" class="easyui-combobox" style="width:105px;" panelHeight="auto" editable="false">
	       	 			<option value="" selected="selected">全部</option>
	       	 			<c:forEach var="keyStatusType" items="${statusMap}">
						<option value="${keyStatusType.key}">${keyStatusType.value}</option>
						</c:forEach>
       		  </select> 
                   创建时间：<input id="beginDate" class="easyui-datebox" style="width:100px" onchange="javascript:" editable="false">
             <label style=" text-align:left;margin-left:15px">到：</label>
             <input id="endDate" class="easyui-datebox" style="width:100px" editable="false">  
	        <a onclick="javascript:searchKeywords();" class="easyui-linkbutton" iconCls="icon-search">查询</a>    
	        <a onclick="javascript:reset();" class="easyui-linkbutton" iconCls="icon-reset">重置</a>   
	    </div>  	   
	    <div class="pageToolbar">
	        <!-- 由于'查看'操作无需权限控制 对所有人开放 -->
	        
	    	<shiro:hasPermission name="business:keywords:add">     
	        	<a onclick="javascript:createKeywords();" class="easyui-linkbutton" iconCls="icon-add" plain="true">添加</a> 
	        </shiro:hasPermission>   
	        <shiro:hasPermission name="business:keywords:stop">  
	        	<a onclick="javascript:disableKeywords();" class="easyui-linkbutton" iconCls="icon-cancel" plain="true">停用</a> 
	        </shiro:hasPermission>   
	        <shiro:hasPermission name="business:keywords:import">
	       	 	<a onclick="javascript:importKeywords();" class="easyui-linkbutton" iconCls="icon-excel" plain="true">导入</a>
	    	</shiro:hasPermission>	        
	    </div>      
	</div> 
	<div class="hiddenDiv" style="width: 100%;height:100%;">
		<table id="keywordsTable" class="easyui-datagrid" toolbar="#keywordsHeader" singleSelect="true" fitColumns="true" rownumbers="true"
			   fit="true" pagination="true" collapsible="true" autoRowHeight="true" idField="id">
		    <thead>    
		        <tr>    
		            <!-- <th field="id" width="10">用户编号</th> --> 
		            <th data-options="field:'content'" width="10%">关键字内容</th> 
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
	
	 <div id="addKeywordsDlg" class="easyui-dialog hiddenDiv" style="width:400px;height:250px;padding:10px 20px;"
         closed="true" buttons="#addKeywordsDlg-buttons">
        <form class="dlgForm" id="addKeywordsForm" method="post" >
            <div class="dlgFormItem">
                <label style=" text-align: right">关键字内容：</label>
                <input class="easyui-textbox" type="text" name="addContent" data-options="required:true,validType:'maxLength[50]'"></input>
            </div>
            <div class="dlgFormItem">
                <label style=" text-align: right">录入原因：</label>
                <input class="easyui-textbox" style="width:165px;height:50px" name="addReason" data-options="required:true,validType:'maxLength[200]'"></input>
            </div>         
        </form>
    </div>
    <div id="addKeywordsDlg-buttons" class="hiddenDiv">
        <a onclick="javascript:saveKeywords()" class="easyui-linkbutton c6" iconCls="icon-ok" style="width:90px">保存</a>
        <a class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#addKeywordsDlg').dialog('close')" style="width:90px">取消</a>
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
        <a onclick="javascript:uploadKeywords();" class="easyui-linkbutton c6" id="saveKeywords" iconCls="icon-ok" style="width:90px">提交</a>
        <a class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#resourceDlg').dialog('close');" style="width:90px">取消</a>
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
    				
       });

    </script>
    	
	<script>
	  
		//点击'用户管理'菜单即加载查询数据
	    $(function(){
	    	search();
		});
	    
		function search(){ 
	    	var options = $('#keywordsTable').datagrid('options');
	    	options.url = "keywordsPage.json";
	    	$('#keywordsTable').datagrid('reload',{
	    		content:$('#contentQuery').val(),
	        	status:$('#statusQuery').combobox('getValue'),
	        	beginDate:$('#beginDate').datebox('getValue'),
	        	endDate:$('#endDate').datebox('getValue')
	    	});
		}
		
		function searchKeywords(){  
	        $('#keywordsTable').datagrid('load',{  
	        	content:$('#contentQuery').val(),
	        	status:$('#statusQuery').combobox('getValue'),
	        	beginDate:$('#beginDate').datebox('getValue'),
	        	endDate:$('#endDate').datebox('getValue')
	        });  
	    }
		
		function reset(){ 
	    	 $('#contentQuery').textbox('setValue', '');
	    	 $('#statusQuery').combobox('setValue','');
	    	 $('#beginDate').datebox('setValue','');
	    	 $('#endDate').datebox('setValue','');
	    }  
		function disableKeywords() {
			
			var obj = $('#keywordsTable');
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
					$.post('keywords/disable', {
						rowId : row.rowId
					}, function(result) {
						result = XypayCommon.toJson(result);
						if (result.success) {
							$('#keywordsTable').datagrid('reload'); // reload the user data
							XypayCommon.MessageAlert('提示', '操作成功!','info');
						} else {
							XypayCommon.MessageAlert('提示', result.msg,'warning');
						}
					}, 'json');
				}
			});
		}
		
		function createKeywords(){
			$('#addKeywordsDlg').dialog({
                title: "添加",  
                closed: false,
                top:0,
                width: 400,  
	    		height: 250,
                modal:true
		    });   
	        $('#addKeywordsForm').form('clear');
		}
		
		function saveKeywords() {
			var url = "keywords/add";
			XypayCommon.genCsrfToken($('#addKeywordsForm'));
			$('#addKeywordsForm').form('submit', {
				url : url,
				onSubmit : function() {
					return $(this).form('validate');
				},
				success : function(result) {
					result = XypayCommon.toJson(result);
					if (result.success) {
						$('#addKeywordsDlg').dialog('close'); // close the dialog
						$('#keywordsTable').datagrid('reload');    // reload the user data	
						XypayCommon.MessageAlert('提示', '操作成功!','info');
					} else {
						XypayCommon.MessageAlert('提示', result.msg,'error');
					}
				}
			});
		}
		function importKeywords(){
	    	 $('#resourceDlg').dialog('open').dialog('center').dialog('setTitle','Excel导入');
	         $('#resourceForm span:last').html('选择文件');
			 $("#uploadExcelShow").show();
			 $("#uploadExcelProgress").hide();
			 $('#resourceForm').form('reset');
	         url = 'keywords/importKeywords';
	    }
		
		function uploadKeywords() {
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
	    						$('#saveKeywords').linkbutton('enable'); 
	        					if (result.success) {
	        						$('#resourceDlg').dialog('close'); // close the dialog
	        						$('#keywordsTable').datagrid('reload');  // reload the user data		
	        						XypayCommon.MessageAlert('提示', result.msg,'info');
	        						return;
	        					} else {
	        						$('#resourceDlg').dialog('close'); // 导入失败，为防止卡在  正在导入中，直接关闭导出弹出框
	        						$('#keywordsTable').datagrid('reload'); 		
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
			$("#saveKeywords").linkbutton("disable");
		};
				
	</script>	
	
</body>
</html>