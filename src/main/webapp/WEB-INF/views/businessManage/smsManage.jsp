<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../common.jsp"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>短信收发记录查询</title>
	
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
	<div id="smsHeader" class="pageHeader hiddenDiv" style="height:70px;padding-top: 10px;"> 
	    <div style="margin-left:8px"> 
	        手机号码：     
	        <input id="mobileQuery" class="easyui-textbox" style="width:100px;" data-options="required:false,validType:'maxLength[50]'">
	      收发标志： <select id="smsTypeQuery" class="easyui-combobox" panelHeight="auto"  style="width:105px;" editable="false">
	       	 			<option value="" selected="selected">全部</option>
	       	 			<c:forEach var="typeMap" items="${typeMap}">
						<option value="${typeMap.key}">${typeMap.value}</option>
						</c:forEach>
       		  </select>   
	
	       短信状态： <select id="smsStatusQuery" class="easyui-combobox" panelHeight="auto" style="width:105px;" editable="false">
	       	 			<option value="" selected="selected">全部</option>
	       	 			<c:forEach var="statusMap" items="${statusMap}">
						<option value="${statusMap.key}">${statusMap.value}</option>
						</c:forEach>
       		  </select> 
                    发送/接收时间：<input id="beginDate" class="easyui-datebox" style="width:100px" onchange="javascript:" editable="false">
             <label style=" text-align:left;margin-left:15px">到：</label>
             <input id="endDate" class="easyui-datebox" style="width:100px" editable="false">  
	        <a onclick="javascript:searchSMS();" class="easyui-linkbutton" iconCls="icon-search">查询</a>    
	        <a onclick="javascript:reset();" class="easyui-linkbutton" iconCls="icon-reset">重置</a>   
	    </div>  	   
	    <div class="pageToolbar">
	        <!-- 由于'查看'操作无需权限控制 对所有人开放 -->
	        	<a onclick="javascript:view();" class="easyui-linkbutton" iconCls="icon-view" plain="true">查看详情</a>
	       <shiro:hasPermission name="business:smsquery:export">  
	        	<a onclick="javascript:expSMS();" class="easyui-linkbutton" iconCls="icon-excel" plain="true">导出</a> 
	       </shiro:hasPermission>    
	    </div>      
	</div> 
	<div class="hiddenDiv" style="width: 100%;height:100%;">
		<table id="smsTable" class="easyui-datagrid" toolbar="#smsHeader" singleSelect="true" fitColumns="true" rownumbers="true"
			   fit="true" pagination="true" collapsible="true" autoRowHeight="true" idField="id">
		    <thead>    
		        <tr>    
		            <!-- <th field="id" width="10">用户编号</th> -->
		            <th data-options="field:'smsNo'" width="10%">短信编号</th>
		            <th data-options="field:'batchNo'" width="10%">批次号</th>
		            <th data-options="field:'mobileNo'" width="10%">手机号码</th> 
		            <th data-options="field:'smsType'" width="10%">收发标志</th>
		            <th data-options="field:'cstId'" width="10%">客户编号</th>
		            <th data-options="field:'accPro'" width="10%">短信供应商</th>
		            <th data-options="field:'accAccno'" width="10%">账号</th>
		            <th data-options="field:'operTime'"  width="10%">发送/接收时间</th> 
					<th data-options="field:'smsStatus'" width="10%">状态</th>
		        </tr>    
		    </thead>		
		</table>
	</div>
	<div id="resourceDlg" class="easyui-dialog hiddenDiv" style="width:820px;height:550px;padding:10px 20px;"
         closed="true" >
    <form class="dlgForm" id="resourceForm" method="post" novalidate> </form>
	
	 <!-- 用户资源form区域 -->
    <div id="smsResourceDlg" class="easyui-dialog hiddenDiv" style="width:400px;height:420px;padding:10px 20px;"
         closed="true" buttons="#smsResourceDlg-buttons">
        <form class="dlgForm" id="smsResourceForm" method="post" novalidate>
             <div class="dlgFormItem">
                <label style=" text-align: right">客户编号：</label>
                <input id="cstId" class="easyui-textbox" data-options="" disabled="disabled"/>
            </div>
            <div class="dlgFormItem">
                <label style=" text-align: right">客户名称：</label>
                <input id="cstName" class="easyui-textbox" data-options="" disabled="disabled"/>
            </div>
           <div class="dlgFormItem">
                <label style=" text-align: right">手机号码：</label>
                <input id="mobile" class="easyui-textbox" data-options="" disabled="disabled"/>
            </div>
            <div class="dlgFormItem">
                <label style=" text-align: right">收发标志：</label>
                <input id="smsType" class="easyui-textbox" data-options="" disabled="disabled"/>
            </div>           
            <div class="dlgFormItem">
                <label style=" text-align: right">短信内容：</label>
                <input id="content" class="easyui-textbox" style="height:50px;" data-options="multiline:true" disabled="disabled"/>
            </div>
            <div  class="dlgFormItem" hidden="true">
                <label style=" text-align: right">通道名称：</label>
                <input id="chanName" class="easyui-textbox" data-options="" disabled="disabled"/>
            </div>
            <div class="dlgFormItem">
                <label style=" text-align: right">状态：</label>
                <input id="smsStatus" class="easyui-textbox" data-options="" disabled="disabled"/>
            </div>
            <div class="dlgFormItem">
                <label style=" text-align: right">失败原因：</label>
                <input id="reason" class="easyui-textbox" style="height:50px;" data-options="multiline:true" disabled="disabled"/>
            </div>       
        </form>
    </div>
    <div id="smsResourceDlg-buttons" class="hiddenDiv">      
        <a class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#smsResourceDlg').dialog('close')" style="width:90px">取消</a>
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
	    	init();
	    	search();
		});
	    
		function search(){ 
	    	var options = $('#smsTable').datagrid('options');
	    	options.url = "smsquery.json";
	    	$('#smsTable').datagrid('reload',{
	    		mobile:$('#mobileQuery').val(),
	    		smsType:$('#smsTypeQuery').combobox('getValue'),
	        	smsStatus:$('#smsStatusQuery').combobox('getValue'),
	        	beginDate:$('#beginDate').datebox('getValue'),
	        	endDate:$('#endDate').datebox('getValue')
	    	});
		}
		
		function searchSMS(){  
	        $('#smsTable').datagrid('load',{  
	        	mobile:$('#mobileQuery').val(),
	    		smsType:$('#smsTypeQuery').combobox('getValue'),
	        	smsStatus:$('#smsStatusQuery').combobox('getValue'),
	        	beginDate:$('#beginDate').datebox('getValue'),
	        	endDate:$('#endDate').datebox('getValue')
	        });  
	    }
		
		function reset(){ 
	    	 $('#mobileQuery').textbox('setValue', '');
	    	 $('#smsTypeQuery').combobox('setValue', '');
	    	 $('#smsStatusQuery').combobox('setValue','');
	    	 $('#beginDate').datebox('setValue','');
	    	 $('#endDate').datebox('setValue','');
	    	 init();
	    } 
		
		function view() {
			
			var obj = $('#smsTable');
			var rows = obj.datagrid('getSelections');
			if(XypayCommon.getSelectRowCurPage(obj) == false){
				XypayCommon.MessageAlert('提示', '请选择一条信息!','warning');
				return;
			}
			var row = rows[0];
			
			if (row) {
				$("#smsResourceDlg").dialog({
	                title: "查看",  
	                closed: false,
	                top:0,
	                width: 400,  
		    		height: 420,
	                modal:true
			    });  
				
				$('#smsResourceDlg').form('clear');
				$.get("getSmsById.json", {id:row.rowId}, function (data){
					data = XypayCommon.toJson(data);
					$('#smsResourceForm').form('load', data);
			    	
			    	$('#cstId').textbox('setValue',data.smsCstno);
			    	$('#cstName').textbox('setValue',data.cstName);
			    	$('#mobile').textbox('setValue',data.smsMobile);
			    	$('#smsType').textbox('setValue',data.smsType);
			    	$('#content').textbox('setValue',data.smsContent);
			    	$('#chanName').textbox('setValue',data.chanName);
			    	$('#smsStatus').textbox('setValue',data.smsStatus);
			    	$('#reason').textbox('setValue',data.smsReason);
				});    
			}		
		}
		function expSMS() {
			
			var param="?mobile="+$('#mobileQuery').val() + 
					"&smsType=" + $('#smsTypeQuery').combobox('getValue') +
					"&smsStatus=" + $('#smsStatusQuery').combobox('getValue') +
					"&beginDate=" + $('#beginDate').datebox('getValue') + 
					"&endDate=" + $('#endDate').datebox('getValue');

		    $('#resourceForm').form('submit', {
				type:"post", 
				url : "expSms.json" + param,
				onSubmit : function() {
					return $(this).form('validate');
				},
				success : function(result) {
					var result = eval('(' + result + ')');
					if (result.success) {
						XypayCommon.MessageAlert('提示', '操作成功!','info');
						return;
					} else {
						XypayCommon.MessageAlert('提示', result.msg,'error');
						return;
					}
				}
			});
		}
		
	</script>
	
	<script type="text/javascript">
	function init(){
		//默认日期
		var curr_time = new Date();
	   	var beginDate = curr_time.getFullYear()+"-";
	   	    beginDate += curr_time.getMonth()+1+"-";
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