<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="./common.jsp"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>导入</title>
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
<body style="margin:0 auto;" onload="ZhiyeCommon.RemoveMask();">
	<div id="keywordsHeader" class="pageHeader hiddenDiv" style="height:70px;padding-top: 10px;"> 
	    <div class="pageToolbar">
	       	 	<a onclick="javascript:importExcelData();" class="easyui-linkbutton" iconCls="icon-excel" plain="true">将待处理的数据导入</a>	       	 	
	       	 	<a onclick="javascript:expResult();" class="easyui-linkbutton" iconCls="icon-excel" plain="true">结果导出</a>	         	         
	    </div>      
	</div> 

    <!-- show window -->
    <div id="resourceDlg" class="easyui-dialog hiddenDiv" style="width:490px;height:200px;padding:10px 20px;"
         buttons="#resourceDlg-buttons" data-options="modal:true,closed:true,iconCls:'icon-excel'">
          <form class="dlgForm" id="expresourceForm" method="post" novalidate> </form>
        <form class="dlgForm" id="resourceForm" method="post" enctype="multipart/form-data" novalidate >
        	<div class="dlgFormItem" id="uploadExcelProgress">
                <div id="progressbarExcel" style="color:red;font-weight:bold;text-align:center;">正在上传中，请稍等...</div>
            </div>
             <div class="dlgFormItem" id="uploadType">
                <label>上传类型</label>
                 <select id="type" class="easyui-combobox" name="type"
				      style="width:200px;" editable="false" panelHeight="auto">
				      <option value="0" selected="selected">按创建时间导出的数据源</option>
				      <option value="1" >按计划完成时间导出的数据源</option>
			      </select> 
            </div>
            <div class="dlgFormItem" id="uploadExcelShow">
                <label>请选择文件：</label>
                <input id="uploadExcel" name="uploadExcel" class="easyui-filebox" clear  multiple="multiple" required="true" style="width:280px" data-options="prompt:'请选择文件...'">
            </div>
        </form>
    </div>
    <div id="resourceDlg-buttons" class="hiddenDiv">
        <a onclick="javascript:uploadExcelData();" class="easyui-linkbutton c6" id="saveKeywords" iconCls="icon-ok" style="width:90px">提交</a>
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
		}
		
        function expResult() {
		    $('#expresourceForm').form('submit', {
		    	type:"post",
				url : "expExcelData.json",
				onSubmit : function() {
					return $(this).form('validate');
				},
				success : function(result) {
					var result = eval('(' + result + ')');
					if (result.success) {
						ZhiyeCommon.MessageAlert('提示', '操作成功!','info');
						return;
					} else {
						ZhiyeCommon.MessageAlert('提示', result.msg,'error');
						return;
					}
				}
			});
		}
		
		function importExcelData(){
	    	 $('#resourceDlg').dialog('open').dialog('center').dialog('setTitle','Excel导入');
	         $('#resourceForm span:last').html('选择文件');
			 $("#uploadExcelShow").show();
			 $("#uploadType").show();
			 $("#uploadExcelProgress").hide();
			 $('#resourceForm').form('reset');
	         url = 'exceldata/importExcelData';
	    }
		
		function uploadExcelData() {
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
	        					result = ZhiyeCommon.toJson(result);
	        					$("#uploadExcelShow").show();
	        					$("#uploadType").show();
	    						$("#uploadExcelProgress").hide();
	    						$('#saveKeywords').linkbutton('enable'); 
	        					if (result.success) {
	        						$('#resourceDlg').dialog('close'); // close the dialog
	        						$('#keywordsTable').datagrid('reload');  // reload the user data		
	        						ZhiyeCommon.MessageAlert('提示', result.msg,'info');
	        						return;
	        					} else {
	        						$('#resourceDlg').dialog('close'); // 导入失败，为防止卡在  正在导入中，直接关闭导出弹出框
	        						$('#keywordsTable').datagrid('reload'); 		
	        						ZhiyeCommon.MessageAlert('提示', result.msg,'error');
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
			$("#uploadType").hide();
			$("#uploadExcelProgress").show();
			$("#saveKeywords").linkbutton("disable");
		};
				
	</script>	
	
</body>
</html>