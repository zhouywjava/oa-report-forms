<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../common.jsp"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>角色管理</title>
	
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
	<div id="roleHeader" class="pageHeader hiddenDiv" style="height:70px;padding-top: 10px;"> 
	    <div style="margin-left:6px">     
	         角色名称：    
			<input id="roleResourceName" class="easyui-textbox" style="width:100px" data-options="required:false,validType:'maxLength[50]'">      
	        <a onclick="javascript:searchRole();" class="easyui-linkbutton" iconCls="icon-search">查询</a>  
	        <a onclick="javascript:reset();" class="easyui-linkbutton" iconCls="icon-reset">重置</a>   
	    </div>  	   
	    <div class="pageToolbar">
	    	<shiro:hasPermission name="system:role:create">     
	        	<a onclick="javascript:createRole();" class="easyui-linkbutton" iconCls="icon-add" plain="true">添加</a> 
	        </shiro:hasPermission>   
	        <shiro:hasPermission name="system:role:edit">
	        	<a onclick="javascript:editRole();" class="easyui-linkbutton" iconCls="icon-edit" plain="true">编辑</a> 
	        </shiro:hasPermission>  
	        <shiro:hasPermission name="system:role:remove">  
	        	<a onclick="javascript:removeRole();" class="easyui-linkbutton" iconCls="icon-remove" plain="true">删除</a> 
	        </shiro:hasPermission>   
	        <shiro:hasPermission name="system:role:authResource">
	       	 	<a onclick="javascript:authResource();" class="easyui-linkbutton" iconCls="icon-man" plain="true">授权资源</a>
	    	</shiro:hasPermission>
	    </div>      
	</div> 
	<div style="width: 100%;height:100%;" class="hiddenDiv">
		<table id="roleTable" class="easyui-datagrid" toolbar="#roleHeader" singleSelect="true" fitColumns="true" 
		       rownumbers="true" fit="true" pagination="true" collapsible="true" autoRowHeight="true" idField="rolId">
		    <thead>    
		        <tr>    
		            <!-- <th data-options="field:'id'" width="10%">角色编号</th> -->    
		            <th data-options="field:'rolName'" width="15%">角色名称</th> 
		            <th data-options="field:'rolAddtimeStr'" width="15%" formatter="XypayCommon.TimeFormatter">创建时间</th> 
		            <th data-options="field:'rolDesc'" >角色描述</th>
		            <th data-options="field:'lastupdateuser'" >最后更新人员</th> 
		            <th data-options="field:'lastUpdateTimeStr'" formatter="XypayCommon.TimeFormatter">最后更新时间</th>  
		        </tr>    
		    </thead>		
		</table>
	</div>

    <!-- 角色资源form区域 -->
    <div id="roleResourceDlg" class="easyui-dialog hiddenDiv" style="width:400px;height:200px;padding:10px 20px;"
         closed="true" buttons="#roleResourceDlg-buttons">
        <form class="dlgForm" id="roleResourceForm" method="post" novalidate>
            <!-- <div class="dlgFormItem">
                <label style=" text-align: right">角色编号：</label>
                <input name="id" id="roleId" class="easyui-numberbox" data-options="required:true,validType:'maxLength[8]'"/>
            </div> -->
            <div class="dlgFormItem">
                <label style=" text-align: right">角色名称：</label>
                <input name="rolName" id="roleName" class="easyui-textbox" data-options="required:true,validType:'maxLength[12]'"/>
            </div>
            <div class="dlgFormItem">
                <label style=" text-align: right">角色描述：</label>
                <input name="rolDesc" id="roleDesc" class="easyui-textbox" style="width:165px;height:50px" data-options="required:true,multiline:true,validType:'maxLength[100]'" style="width:200px;height:60px"/>
            </div>
        </form>
    </div>
    <div id="roleResourceDlg-buttons" class="hiddenDiv">
        <a onclick="javascript:saveRole()" class="easyui-linkbutton c6" iconCls="icon-ok" style="width:90px">保存</a>
        <a class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#roleResourceDlg').dialog('close')" style="width:90px">取消</a>
    </div>
    
    <!-- 授权资源form区域 -->
    <div id="authResourceDlg" class="easyui-dialog hiddenDiv" style="width:400px;height:380px;padding:10px 0px"
         closed="true" buttons="#authResourceDlg-buttons" title="授权资源">
    </div>
    <div id="authResourceDlg-buttons" class="hiddenDiv">
        <a onclick="javascript:saveAuthResource()" class="easyui-linkbutton c6" iconCls="icon-ok" style="width:90px">保存</a>
        <a class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#authResourceDlg').dialog('close')" style="width:90px">取消</a>
    </div>
	
	<script>
	
		$(document).ready(function() {
			//注册事件,当用户回车触发查询操作
			document.onkeydown = function(e){ 
			    var ev = document.all ? window.event : e;
			    if(ev.keyCode==13) {
			    	search();
			     }
			};
		});
		
		//点击'角色管理'菜单即加载查询数据
	    $(function(){
	    	search();
		});
	    
		function search(){
	    	var options = $('#roleTable').datagrid('options');
	    	options.url = "rolePageList.json";
	    	$('#roleTable').datagrid('reload',{
	    		rolename:$('#roleResourceName').val()
	    	});
		}
	
	    var url;
	    function searchRole(){  
	        $('#roleTable').datagrid('load',{  
	        	rolename:$('#roleResourceName').val()
	        });  
	    } 
	    
	    function createRole(){  
	    	//角色编号不可编辑
			//$('#roleId').textbox('enable',true);
	    	//非模态窗口模式
	   		//$('#roleResourceDlg').dialog('open').dialog('center').dialog('setTitle','添加');
	   		$("#roleResourceDlg").dialog({
                title: "添加",  
                closed: false,
                top:50,
                width: 400,  
	    		height: 200,
                modal:true
		    });
	        $('#roleResourceForm').form('clear');
	        url = 'createRoleResource'; 
	    } 
         
		function editRole() {
			
			var obj = $('#roleTable');
			var rows = obj.datagrid('getSelections');
			if(XypayCommon.getSelectRowCurPage(obj) == false){
				XypayCommon.MessageAlert('提示', '请选择一条信息!','warning');
				return;
			}

			var row = rows[0];
			//alert(JSON.stringify(row));
			if (row) {
				//非模态窗口模式
				//$('#roleResourceDlg').dialog('open').dialog('center').dialog('setTitle','编辑');
				$("#roleResourceDlg").dialog({
	                title: "编辑",  
	                closed: false,
	                top:50,
	                width: 400,  
		    		height: 200,
	                modal:true
			    });
				//ADD BY LIHUI 2015-12-15
				//$('#roleResourceForm').form('load', 'getRoleResourceById.json?id='+row.rolId);
				$('#roleResourceForm').form('clear');
				$.get("getRoleResourceById.json", {id:row.rolId}, function (data){
					data = XypayCommon.toJson(data);
					$('#roleResourceForm').form('load', data);
					//角色编号不可编辑
					//$('#roleId').textbox('disable',true);
				});
			    url = 'updateRoleResource?id=' + row.rolId;
			}
		}

		function saveRole() {
			XypayCommon.genCsrfToken($('#roleResourceForm'));
			$('#roleResourceForm').form('submit', {
				url : url,
				onSubmit : function() {
					return $(this).form('validate');
				},
				success : function(result) {
					result = XypayCommon.toJson(result);
					if (result.success) {
						$('#roleResourceDlg').dialog('close'); // close the dialog
						$('#roleTable').datagrid('reload');    // reload the user data	
						//XypayCommon.MessageBox('成功', '操作成功!');
						XypayCommon.MessageAlert('提示', '操作成功!','info');
					} else {
						//XypayCommon.MessageBox('错误', result.msg);
						XypayCommon.MessageAlert('提示', result.msg,'error');
					}
				}
			});
		}

		function removeRole() {
			
			var obj = $('#roleTable');
			var rows = obj.datagrid('getSelections');
			if(XypayCommon.getSelectRowCurPage(obj) == false){
				XypayCommon.MessageAlert('提示', '请选择一条信息!','warning');
				return;
			}
			
			$.messager.confirm('确认', '确定要删除所选中角色信息?', function(r) {
				if (r) {
					var row = rows[0];
					//alert(JSON.stringify(row));
					$.post('deleteRoleResource', {
						ids : row.rolId
					}, function(result) {
						result = XypayCommon.toJson(result);
						if (result.success) {
							$('#roleTable').datagrid('reload'); // reload the user data
							//XypayCommon.MessageBox('成功', '操作成功!');
							XypayCommon.MessageAlert('提示', '操作成功!','info');
						} else {
							//XypayCommon.MessageBox('错误', result.msg);
							XypayCommon.MessageAlert('提示', result.msg,'error');
						}
					}, 'json');
				}
			});
		}
		
		function reset(){  
	    	 $('#roleHeader').form('clear');
	    }
		
		var selectRoleId = '';
		function authResource() {
			
			var obj = $('#roleTable');
			var rows = obj.datagrid('getSelections');
			if(XypayCommon.getSelectRowCurPage(obj) == false){
				XypayCommon.MessageAlert('提示', '请选择一条信息!','warning');
				return;
			}
			
			var row = rows[0];
			if (row) {
				selectRoleId = row.rolId;
				var _url = 'resourceSelect?roleId='+row.rolId;
				$('#authResourceDlg').dialog({
				    cache: false,
				    href: _url
				});
				$('#authResourceDlg').dialog('options').href = _url;
				$('#authResourceDlg').dialog('open').dialog('center');
			}
		}	
		
		function saveAuthResource(){
			var nodes = $('#resourceSelectTree').tree('getChecked');
	            var s = '';
	            for(var i=0; i<nodes.length; i++){
	                if (s != '') s += ',';
	                s += nodes[i].id;
	            }
			$.post('authResource', {
				rscIds : s,
				roleId : selectRoleId
			}, function(result) {
				result = XypayCommon.toJson(result);
				if (result.success) {
					$('#authResourceDlg').dialog('close'); // close the dialog
					$('#roleTable').datagrid('reload'); // reload the user data
					selectRoleId = '';
					//XypayCommon.MessageBox('成功', '操作成功!');
					XypayCommon.MessageAlert('提示', '操作成功!','info');
				} else {
					//XypayCommon.MessageBox('错误', result.msg);
					XypayCommon.MessageAlert('提示', result.msg,'error');
				}
			}, 'json');
		}
	</script>
	
</body>
</html>