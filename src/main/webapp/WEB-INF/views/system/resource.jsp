<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../common.jsp"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>资源管理</title>
	
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
	<div id="resourceHeader" class="pageHeader hiddenDiv" style="height:70px;padding-top: 10px;"> 
			    <div style="margin-left:6px">    
			        功能名称：    
			        <input id="resourcename" class="easyui-textbox" style="width:100px" data-options="required:false,validType:'maxLength[50]'">    
			        <a onclick="javascript:searchResource();" class="easyui-linkbutton" iconCls="icon-search">查询</a> 
			        <a onclick="javascript:reset();" class="easyui-linkbutton" iconCls="icon-reset">重置</a>    
			    </div>
			    <div class="pageToolbar">
			    	<%-- <shiro:hasPermission name="system:resource:create">     
			        	<a onclick="javascript:createResource();" class="easyui-linkbutton" iconCls="icon-add" plain="true">添加</a> 
			        </shiro:hasPermission> --%>   
			        <shiro:hasPermission name="system:resource:edit">
			        	<a onclick="javascript:editResource();" class="easyui-linkbutton" iconCls="icon-edit" plain="true">编辑</a> 
			        </shiro:hasPermission>  
			       <%--  <shiro:hasPermission name="system:resource:remove">  
			        	<a onclick="javascript:removeResource();" class="easyui-linkbutton" iconCls="icon-remove" plain="true">删除</a> 
			        </shiro:hasPermission> --%>   
			    </div>     
	</div>
	 
	<div id="resourceListDiv" class="hiddenDiv" style="width: 100%;height:100%;" >
	<table id="resourceTable" class="easyui-treegrid" toolbar="#resourceHeader" singleSelect="true" fitColumns="true"
			fit="true" pagination="false" collapsible="true" autoRowHeight="true" 
            data-options="
                url: 'resourcePageTreeList.json',
                method: 'post',
                rownumbers: false,
                idField: 'id',
                treeField: 'name',
                loadFilter: myLoadFilter">
        <thead>
            <tr>
                <th data-options="field:'name'" width="35%">功能名称</th>
                <th data-options="field:'id'" >编号</th>
                <th data-options="field:'type'">类型</th>
                <th data-options="field:'orderNo'">排序编号</th>
                <th data-options="field:'lastUpdateUser'" >最后更新人员</th> 
		        <th data-options="field:'lastUpdateTimeStr'" formatter="XypayCommon.TimeFormatter">最后更新时间</th>   
            </tr>
        </thead>
    </table>
	</div>
	
	<div id="resourceDlg" class="easyui-dialog hiddenDiv" style="width:400px;height:240px;padding:10px 20px;"
         closed="true" buttons="#resourceDlg-buttons">
        <!-- <div class="dlgFormTitle">资源属性</div> -->
        <form class="dlgForm" id="resourceForm" method="post" novalidate>
            <div class="dlgFormItem">
                <label style=" text-align: right">功能名称：</label>
                <input name="name" id="name" class="easyui-textbox" data-options="required:true,validType:'maxLength[30]'"/>
            </div>
             <div class="dlgFormItem">
                <label style=" text-align: right">编号：</label>
                <input name="id" id="id" class="easyui-numberbox" data-options="required:false,min:0,max:99999" disabled="disabled"/>
            </div>
            <div class="dlgFormItem">
                <label style=" text-align: right">类型：</label>
                <select name="type" id="nodeType" class="easyui-combobox" style="width:164px;" required="true" editable="false" panelHeight="auto">
					<c:forEach var="resourceType" items="${resourceTypeMap}">
					<option value="${resourceType.key}">${resourceType.value}</option>
					</c:forEach>
				</select>
            </div>
           <!--  <div class="dlgFormItem">
                <label style=" text-align: right">父资源编号：</label>
                <input name="parentId" id="parentId" class="easyui-numberbox" data-options="required:false,min:0,max:99999"/>
            </div>  -->
            <!-- 新增排序编号 -->
            <div class="dlgFormItem">
                <label style=" text-align: right">排序编号：</label>
                <input name="orderNo" id="orderNo" class="easyui-numberbox" data-options="required:true,min:0,max:99999"/>
                <input name="csrftoken" id="csrftoken" type="hidden"/>
            </div>          
        </form>
    </div>
    <div id="resourceDlg-buttons" class="hiddenDiv">
        <a onclick="javascript:saveResource()" class="easyui-linkbutton c6" iconCls="icon-ok" style="width:90px">保存</a>
        <a class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#resourceDlg').dialog('close')" style="width:90px">取消</a>
    </div>
    
    <script>	
	
    //ADD BY LIHUI 2015.12.30
    //注册easyUI中select组件onchange事件
    $(document).ready(
 		   function(){
 			   $('#nodeType').combobox({
 				    onChange:function(newValue,oldValue){
 				        if(newValue == 0){ //主菜单
 				        	$('#orderNo').textbox('setValue','');
 				        	$('#orderNo').textbox('enable',true);
  				            $('#orderNo').textbox({required:true});
  				            //ADD BY LIHUI 2015.12.31
  				            $('#parentId').textbox('setValue','');
  				            $('#parentId').textbox('disable',true);
  				            $('#parentId').textbox({required:false});
 				        }else if(newValue == 1){ //子菜单
 				        	$('#orderNo').textbox('setValue','');
 				        	$('#orderNo').textbox('enable',true);
  				            $('#orderNo').textbox({required:true});
  				            //ADD BY LIHUI 2015.12.31
  				            $('#parentId').textbox('enable',true);
  				            $('#parentId').textbox({required:true});
 				        }else{ //其他类型
 				        	$('#orderNo').textbox('setValue','');
 				        	$('#orderNo').textbox('disable',true);
  				            $('#orderNo').textbox({required:false});
  				            //ADD BY LIHUI 2015.12.31
  				            $('#parentId').textbox('enable',true);
  				            $('#parentId').textbox({required:true});
 				        }
 				    }
 				});
 			   
 			    //注册事件,当用户回车触发查询操作
 				document.onkeydown = function(e){ 
 				    var ev = document.all ? window.event : e;
 				    if(ev.keyCode==13) {
 				    	searchResource();
 				     }
 				};
 	});
    
    //动态加载查询
    //ADD BY LIHUI 2015-12-09
    function myLoadFilter(data,parentId){
    	
    			function setData(data){
    				var todo = [];
    				for(var i=0; i<data.length; i++){
    					todo.push(data[i]);
    				}
    				while(todo.length){
    					var node = todo.shift();
    					if (node.children){
    						node.state = 'closed';
    						node.children1 = node.children;
    						node.children = undefined;
    						todo = todo.concat(node.children1);
    					}
    				}
    			}
    			
    			setData(data);
    			
    			var tg = $(this);
    			var opts = tg.treegrid('options');
    			opts.onBeforeExpand = function(row){
    				if (row.children1){
    					tg.treegrid('append',{
    						parent: row[opts.idField],
    						data: row.children1
    					});
    					row.children1 = undefined;
    				    tg.treegrid('expand', row[opts.idField]);
    				}
    				return row.children1 == undefined;
    			};
    			return data;
    	}
        
	    //动态加载查询
	    function dynamicLoadTreeNode(selectNode){
	    	var parentId = $('#resourceTable').treegrid('getParent', selectNode.id).id;
	    	$('#resourceTable').treegrid('select', selectNode.id);
	    	$('#resourceTable').treegrid('expand', parentId);
	    }
	    
		var url;
	    function searchResource(){ 
	        $('#resourceTable').treegrid('load',{  
	        	resourcename:$('#resourcename').val()
	        }); 
	    }  	

	    //ADD BY LIHUI 2015-12-08
	    //新增一子菜单节点
	    function createSubMenuNodeResource(id,parentId,nodeTypeId){
	        	
	    	$('#parentId').textbox({required:true});
	    	$('#resourceDlg').dialog('open').dialog('center').dialog('setTitle','添加');
	        $('#resourceForm').form('clear');
			$.get("getResourceById.json", {id:id}, function (data){
				    //$('#resourceForm').form('load', data);
					//节点类型不可编辑
					data = XypayCommon.toJson(data);
					$('#nodeType').combobox({required:true,disabled:false});
					$('#nodeType').combobox('setValue',(parseInt(nodeTypeId,10)+1)+'');
					
					$("#parentId").textbox('setValue', data.id);
					///设置disable字段后台获取不到值,所以用ReadOnly设置只读;
					$('#parentId').textbox('disable',true); 
					
					//ADD BY LIHUI 2015.12.14
					$("#name").textbox('setValue', '');
			});
			
			url = 'createResource';
	    }
	    
	    //ADD BY LIHUI 2015-12-08
	    //新增一子菜单下节点(列表项或按钮项节点)
	    function createSubRightNodeResource(id,parentId,nodeTypeId){
	    	
	    	$('#parentId').textbox({required:true});
	    	$('#resourceDlg').dialog('open').dialog('center').dialog('setTitle','添加');
	        $('#resourceForm').form('clear');
			$.get("getResourceById.json", {id:id}, function (data){
				//$('#resourceForm').form('load', data);
				//节点类型不可编辑
				data = XypayCommon.toJson(data);
				$('#nodeType').combobox({required:true,disabled:false});
				$('#nodeType').combobox('setValue',(parseInt(nodeTypeId,10)+1)+'');
				
				$("#parentId").textbox('setValue', data.id);
				//设置disable字段后台获取不到值,所以用ReadOnly设置只读;
				$('#parentId').textbox('disable',true); 
				
				//ADD BY LIHUI 2015.12.14
				$("#name").textbox('setValue', '');
		    });
			
			url = 'createResource';
	    }
	    
	    //ADD BY LIHUI 2015-12-08
	    //在某节点(模块节点或是子菜单节点)上新增一子节点(子菜单或是子菜单下权限项)
	    function createSubNodeResource(id,parentId,nodeTypeId){
	    	
	    	switch(parseInt(nodeTypeId,10)){
	    	
		    	case 0:
		    		createSubMenuNodeResource(id,parentId,nodeTypeId);
		    		break;
		    	case 1:
		    		createSubRightNodeResource(id,parentId,nodeTypeId);
		    		break;
		    	case 2:
		    	case 3:
		    		XypayCommon.MessageBox('错误', '不能添加任何子节点资源!');
		    		break;
		    	default:
		    		break;
		    	}
	    }
	    
	    var flag = 'new';
	    function createResource(){  
	    	 flag = 'new';
	    	 //ADD BY LIHUI 2015-12-08
	    	 //判断是否新增一父节点或是子节点(包含子菜单和权限控制项)
	    	 var rows = $('#resourceTable').datagrid('getSelections');
	    	 var row = rows[0];
	    	 if(row){
	    		var id = row.id;
	            var parentId = row.parentId;
	            var nodeTypeId = row.typeNo;
	            //ADD BY LIHUI 2015.12.31
	    		createSubNodeResource(id,parentId,nodeTypeId);
	    	 }else{
	    		//ADD BY LIHUI 2015.12.31
	    		$("#parentId").textbox('setValue', '');
				$('#parentId').textbox('disable',true);
				$('#parentId').textbox({required:false});
				
	    		$('#resourceDlg').dialog('open').dialog('center').dialog('setTitle','添加');
		        $('#resourceForm').form('clear');
		        url = 'createResource'; 
	    	 }
	    } 
          
	    var selectNode;
		function editResource() {
			flag = 'edit';
			selectNode = $("#resourceTable").treegrid('getSelected');
			var rows = $('#resourceTable').datagrid('getSelections');
			if(rows.length == 0){
				XypayCommon.MessageAlert('提示', '请选择一条信息!','warning');
				return;
			}
			if(rows.length > 1){
				XypayCommon.MessageAlert('提示', '只能选择一条信息进行此操作!','warning');
				return;
			}
			var row = rows[0];	
			//alert(JSON.stringify(row));
			if (row) {
				//非模态窗口模式
				//$('#resourceDlg').dialog('open').dialog('center').dialog('setTitle','编辑');
				$("#resourceDlg").dialog({
	                title: "编辑",  
	                closed: false,
	                top:50,
	                width: 400,  
		    		height: 250,
	                modal:true
			    });
				//$('#resourceForm').form('load', 'getResourceById.json?id='+row.id);
				 $('#resourceForm').form('clear');
			     $.get("getResourceById.json", {id:row.id}, function (data){
			    	 data = XypayCommon.toJson(data);
			    	// alert(JSON.stringify(data));
			    	$('#nodeType').combobox({required:true,disabled:true});
					$('#nodeType').combobox('setValue',data.rscType);
					//不可编辑部分
					//$("#parentId").textbox('setValue', data.parentId);
					$("#id").textbox('setValue', data.rscId);
					//仅有一级菜单和二级菜单可以修改排序号
					if(data.rscType == 0){ // 一级菜单 父亲节点不可修改且排序号不为空(必输项)
						//$('#parentId').textbox('disable',true);
						$('#orderNo').textbox('enable',true);
					}else if(data.rscType == 1){ // 二级菜单 父亲节点不可为空可编辑且排序号不为空可编辑(必输项)
						//$('#parentId').textbox('disable',true);
						$('#orderNo').textbox('enable',true);
					}else{//其他选择项
						//$('#parentId').textbox('disable',true);
						$('#orderNo').textbox('disable',true);
					}
					//可编辑部分
					$("#name").textbox('setValue', data.rscName);
					$("#orderNo").textbox('setValue', data.rscOrderNo);
			     });
			    tempId = row.id;
			    url = 'updateResource?id=' + row.id+'&type='+row.typeNo;
			}
		}

		function saveResource() {
			//tempParentId = $('#parentId').textbox('getValue');
		    XypayCommon.genCsrfToken($('#resourceForm'));
			$('#resourceForm').form('submit', {
				//url : (flag=='new')?(url+'?parentId='+tempParentId):(url+'&parentId='+tempParentId),
				url : url,
				onSubmit : function() {
					return $(this).form('validate');
				},
				success : function(result) {
					result = XypayCommon.toJson(result);
					if (result.success) {
						$('#resourceDlg').dialog('close'); // close the dialog
						$('#resourceTable').treegrid('reload'); // reload the user data	
						//动态刷新加载指定节点下子节点且展开当前节点树
						//dynamicLoadTreeNode(selectNode);
						//提示信息
						//XypayCommon.MessageBox('成功', '操作成功!');
						XypayCommon.MessageAlert('提示', '操作成功!','info');
						return;
					} else {
						//XypayCommon.MessageBox('错误', result.msg);
						XypayCommon.MessageAlert('提示', result.msg,'error');
						return;
					}
				}
			});
		}

		function removeResource() {
			var rows = $('#resourceTable').datagrid('getSelections');
			if (rows.length == 0) {
				XypayCommon.MessageBox('错误', '请选择一条信息!');
				return;
			}

			$.messager.confirm('确认', '确定要删除所选中资源信息?', function(r) {
				if (r) {
					var rowids = XypayCommon.GetIdsFromRow(rows);
					$.post('deleteResource', {
						ids : rowids
					}, function(result) {
						result = XypayCommon.toJson(result);
						if (result.success) {
							$('#resourceTable').treegrid('reload'); // reload the user data
							//提示信息
							XypayCommon.MessageBox('提示', '操作成功!');
						} else {
							XypayCommon.MessageBox('错误', result.msg);
						}
					}, 'json');
				}
			});
		}

		function reset(){  
	    	 $('#resourceHeader').form('clear');
	    }
	</script>
		
</body>
</html>