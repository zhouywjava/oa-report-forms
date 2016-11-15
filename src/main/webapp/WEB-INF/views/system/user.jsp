<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../common.jsp"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>用户管理</title>
	
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
	<div id="userHeader" class="pageHeader hiddenDiv" style="height:70px;padding-top: 10px;"> 
	    <div style="margin-left:8px"> 
	        所属角色： <select id="roleQuery" class="easyui-combobox" style="width:100px;" editable="false">
	       	 			<option value="" selected="selected">全部</option>
	       	 			<!-- 支持动态生成 -->
       					<c:forEach var="userRoleType" items="${userRoleTypeMap}">
						<option value="${userRoleType.key}">${userRoleType.value}</option>
						</c:forEach>
       			 </select>
	    <!-- 所属机构: <select id="orgQuery" class="easyui-combobox" style="width:150px;" >
	       	 			<option value="" selected="selected">全部</option>
       					<option value="88888888">象屿支付有限公司</option> 
       			 </select>   -->
	        登录名：     
	        <input id="logonNameQuery" class="easyui-textbox" style="width:100px;" data-options="required:false,validType:'maxLength[50]'">    
	        用户姓名：     
	        <input id="userNameQuery" class="easyui-textbox" style="width:100px;" data-options="required:false,validType:'maxLength[50]'"> 
	       状态： <select id="statusQuery" class="easyui-combobox" style="width:105px;" editable="false" panelHeight="auto">
	       	 			<option value="" selected="selected">全部</option>
	       	 			<c:forEach var="userStatusType" items="${userStatusTypeMap}">
						<option value="${userStatusType.key}">${userStatusType.value}</option>
						</c:forEach>
       		  </select>   
	        <a onclick="javascript:searchUser();" class="easyui-linkbutton" iconCls="icon-search">查询</a>    
	        <a onclick="javascript:reset();" class="easyui-linkbutton" iconCls="icon-reset">重置</a>   
	    </div>  	   
	    <div class="pageToolbar">
	        <!-- 由于'查看'操作无需权限控制 对所有人开放 -->
	        <shiro:hasPermission name="system:user:view">     
	        	<a onclick="javascript:viewUser();" class="easyui-linkbutton" iconCls="icon-view" plain="true">查看</a> 
	        </shiro:hasPermission> 
	    	<shiro:hasPermission name="system:user:create">     
	        	<a onclick="javascript:createUser();" class="easyui-linkbutton" iconCls="icon-add" plain="true">添加</a> 
	        </shiro:hasPermission>   
	        <shiro:hasPermission name="system:user:edit">
	        	<a onclick="javascript:editUser();" class="easyui-linkbutton" iconCls="icon-edit" plain="true">编辑</a> 
	        </shiro:hasPermission>  
	        <shiro:hasPermission name="system:user:remove">  
	        	<a onclick="javascript:removeUser();" class="easyui-linkbutton" iconCls="icon-remove" plain="true">注销</a> 
	        </shiro:hasPermission>   
	        <shiro:hasPermission name="system:user:resetPsw">
	       	 	<a onclick="javascript:resetPsw();" class="easyui-linkbutton" iconCls="icon-reset" plain="true">重置密码</a>
	    	</shiro:hasPermission>	        
	    </div>      
	</div> 
	<div class="hiddenDiv" style="width: 100%;height:100%;">
		<table id="userTable" class="easyui-datagrid" toolbar="#userHeader" singleSelect="true" fitColumns="true" rownumbers="true"
			   fit="true" pagination="true" collapsible="true" autoRowHeight="true" idField="usrId">
		    <thead>    
		        <tr>    
		            <!-- <th field="id" width="10">用户编号</th> --> 
		            <th data-options="field:'usrLogonname'" width="10%">登录名</th>    
		            <th data-options="field:'usrName'" width="10%">用户姓名</th> 
		            <th data-options="field:'userRoleName'" width="10%">所属角色</th> 
		            <!-- <th field="branchid" width="10">所属机构</th>  -->
		            <th data-options="field:'usrStt'" width="10%">状态</th>
		            <th data-options="field:'createdatefmt'" formatter="XypayCommon.TimeFormatter">创建时间</th> 
		            <th data-options="field:'firstLogonTimefmt'" formatter="XypayCommon.TimeFormatter">最后登录时间</th>
		            <th data-options="field:'lastupdateuser'" >最后更新人员</th> 
		            <th data-options="field:'lastUpdateTimeStr'" formatter="XypayCommon.TimeFormatter">最后更新时间</th>    
		        </tr>    
		    </thead>		
		</table>
	</div>
    
    <!-- 用户资源form区域 -->
    <div id="userResourceDlg" class="easyui-dialog hiddenDiv" style="width:400px;height:420px;padding:10px 20px;"
         closed="true" buttons="#userResourceDlg-buttons" >
        <form class="dlgForm" id="userResourceForm" method="post">
            <div class="dlgFormItem" id="userIdDiv" style="display:none" >
                <label style=" text-align: right">用户编号：</label>
                <input name="usrId" id="userId" class="easyui-textbox"/>
            </div>
            <div class="dlgFormItem">
                <label style=" text-align: right">登录名：</label>
                <input name="usrLogonname" id="logonName" class="easyui-textbox" data-options="required:true,validType:'maxLength[20]'"/>
            </div>
            <div class="dlgFormItem">
                <label style=" text-align: right">用户姓名：</label>
                <input name="usrName" id="userName" class="easyui-textbox" data-options="required:true,validType:'maxLength[15]'"/>
            </div>
            <div class="dlgFormItem" id="emailDiv">
                <label style=" text-align: right">邮箱：</label>
                <input name="email" id="email" type="text" class="easyui-textbox" data-options="required:true,validType:'emailReg'"/>
            </div>
            <div class="dlgFormItem" id="emailConfirmDiv">
                <label style=" text-align: right">确认邮箱：</label>
                <input name="emailConfirm" id="emailConfirm" type="text" class="easyui-textbox" data-options="required:true,validType:'emailReg'"/>
            </div>
            <div class="dlgFormItem" id="emailOriginalDiv"  >
                <label style=" text-align: right">原邮箱：</label>
                <input name="emailOriginal" id="emailOriginal" class="easyui-textbox" data-options="required:false,validType:['email','maxLength[30]']"/>
            </div>
            <div class="dlgFormItem" id="newEmailDiv" style="display:none" >
                <label style=" text-align: right">修改邮箱：</label>
                <input name="newEmail" id="newEmail" class="easyui-textbox" data-options="required:false,validType:['email','maxLength[30]']"/>
            </div>
            <div class="dlgFormItem" id="newEmailConfirmDiv" style="display:none" >
                <label style=" text-align: right">确认邮箱：</label>
                <input name="newEmailConfirm" id="newEmailConfirm" class="easyui-textbox" data-options="required:false,validType:['email','maxLength[30]']"/>
            </div>
            <div class="dlgFormItem" id="createDateDiv"  >
                <label style=" text-align: right">注册时间：</label>
                <input name="createdatefmt" id="createdatefmt" class="easyui-textbox"/>
            </div>
            <div class="dlgFormItem" style="display:none" >
                <label style=" text-align: right">所属机构：</label>
                <input name="usrBranchid" id="branchid" class="easyui-textbox"/>
            </div>
            <div class="dlgFormItem">
                <label style=" text-align: right">状态：</label>
                <select name="statusId" id="statusId" class="easyui-combobox" style="width:164px;" required="true" editable="false" panelHeight="auto">
					<c:forEach var="userStatusType" items="${userStatusTypeMap}">
					<option value="${userStatusType.key}">${userStatusType.value}</option>
					</c:forEach>
				</select>
            </div>
            <div class="dlgFormItem">
                <label style=" text-align: right">所属角色：</label>
                <select name="roleId" id="roleId" class="easyui-combobox" height="200px" style="width:164px;" data-options="required:true" editable="false">
					<!-- <option value="" selected="selected">&nbsp;</option> -->
					<c:forEach var="userRoleType" items="${userRoleTypeMap}">
					<option value="${userRoleType.key}">${userRoleType.value}</option>
					</c:forEach>
				</select>
            </div>
            <div class="dlgFormItem">
                <label style=" text-align: right">手机号码：</label>
                <input name="usrMobile" id="mobile" class="easyui-textbox" data-options="validType:'mobileReg'"/>
            </div>
            <div class="dlgFormItem">
                <label style=" text-align: right">固定电话：</label>
                <input name="usrPhone" id="phone" class="easyui-textbox" data-options="validType:'phoneReg'"/>
            </div>
            <div class="dlgFormItem">
                <label style=" text-align: right">地址：</label>
                <input name="usrAddress" id="address" class="easyui-textbox" data-options="required:false,validType:'maxLength[100]'"/>
            </div>
            <div class="dlgFormItem">
                <label style=" text-align: right">证件类型：</label>
                <select name="usrCerttype" id="certId" class="easyui-combobox" style="width:164px;" required="ture" editable="false" panelHeight="auto" >
					<option value="" selected="selected">&nbsp;</option>
					<c:forEach var="userCertType" items="${userCertTypeMap}">
					<option value="${userCertType.key}">${userCertType.value}</option>
					</c:forEach>
				</select>
            </div>
            <div class="dlgFormItem">
                <label style=" text-align: right">证件号码：</label>
                <input name="usrCertno" id="certno" class="easyui-textbox" 
                data-options="required:true,validType:'maxLength[30]'"/>
            </div>
        </form>
    </div>
    <div id="userResourceDlg-buttons" class="hiddenDiv">
        <a onclick="javascript:saveUser()" class="easyui-linkbutton c6" iconCls="icon-ok" id="btnSave" style="width:90px">保存</a>
        <a class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#userResourceDlg').dialog('close')" style="width:90px">取消</a>
    </div>
    <!-- 用户资源form区域_查看操作  -->
    <div id="viewUserResourceDlg" class="easyui-dialog hiddenDiv" style="width:400px;height:450px;padding:10px 20px;"
         closed="true" buttons="#viewUserResourceDlg-buttons">
        <form class="dlgForm" id="viewUserResourceForm" method="post" novalidate>
            <div class="dlgFormItem">
                <label style=" text-align: right">用户编号：</label>
                <input class="easyui-textbox" type="text" disabled="true" id="viewUserId" ></input>
            </div>
            <div class="dlgFormItem">
                <label style=" text-align: right">登录名：</label>
                <input class="easyui-textbox" type="text" disabled="true" id="viewLogonname" ></input>
            </div>
            <div class="dlgFormItem">
                <label style=" text-align: right">用户姓名：</label>
                <input class="easyui-textbox" type="text" disabled="true" id="viewUserName" ></input>
            </div>
            <div class="dlgFormItem">
                <label style=" text-align: right">邮箱：</label>
                <input class="easyui-textbox" type="text" disabled="true" id="viewEmail" ></input>
            </div>
            <div class="dlgFormItem">
                <label style=" text-align: right">注册时间：</label>
                <input class="easyui-textbox" type="text" disabled="true" id="viewCreatedatefmt" ></input>
            </div>
            <div class="dlgFormItem" style="display:none">
                <label style=" text-align: right">所属机构：</label>
                <input class="easyui-textbox" type="text" disabled="true" id="viewBranchName" ></input>
            </div>
            <div class="dlgFormItem">
                <label style=" text-align: right">状态：</label>
                <input class="easyui-textbox" type="text" disabled="true" id="viewStatusName" ></input>
            </div>
            <div class="dlgFormItem">
                <label style=" text-align: right">所属角色：</label>
                <input class="easyui-textbox" type="text" disabled="true" id="viewRoleName" ></input>
            </div>
            <div class="dlgFormItem">
                <label style=" text-align: right">手机号码：</label>
                <input class="easyui-textbox" type="text" disabled="true" id="viewMobile" ></input>
            </div>
            <div class="dlgFormItem">
                <label style=" text-align: right">固定电话：</label>
                <input class="easyui-textbox" type="text" disabled="true" id="viewPhone" ></input>
            </div>
            <div class="dlgFormItem">
                <label style=" text-align: right">地址：</label>
                <input class="easyui-textbox" type="text" disabled="true" id="viewAddress" ></input>
            </div>
            <div class="dlgFormItem">
                <label style=" text-align: right">证件类型：</label>
                <input class="easyui-textbox" type="text" disabled="true" id="viewCertType" ></input>
            </div>
            <div class="dlgFormItem">
                <label style=" text-align: right">证件号码：</label>
                <input class="easyui-textbox" type="text" disabled="true" id="viewCertNo" ></input>
            </div>
        </form>
    </div>
    <div id="viewUserResourceDlg-buttons" class="hiddenDiv">
        <a class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#viewUserResourceDlg').dialog('close')" style="width:90px">取消</a>
    </div>
    
    <!-- 授权角色资源form区域   -->
    <div id="authRoleDlg" class="easyui-dialog hiddenDiv" style="width:400px;height:280px;padding:10px 20px;"
         closed="true" buttons="#authRoleDlg-buttons" title="授权资源">
    </div> 
    <div id="authRoleDlg-buttons" class="hiddenDiv">
        <a onclick="javascript:saveAuthRole()" class="easyui-linkbutton c6" iconCls="icon-ok" style="width:90px">保存</a>
        <a class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#authRoleDlg').dialog('close')" style="width:90px">取消</a>
    </div>
    	
   <script type="text/javascript">
       
       var city = {11:"北京",12:"天津",13:"河北",14:"山西",15:"内蒙古",21:"辽宁",22:"吉林",23:"黑龙江",31:"上海",32:"江苏",33:"浙江",34:"安徽",35:"福建",36:"江西",37:"山东",41:"河南",42:"湖北",43:"湖南",44:"广东",45:"广西",46:"海南",50:"重庆",51:"四川",52:"贵州",53:"云南",54:"西藏",61:"陕西",62:"甘肃",63:"青海",64:"宁夏",65:"新疆",71:"台湾",81:"香港",82:"澳门",91:"国外"};  
       
       function isLegalID(sId){   
    	       var iSum=0 ;  
    	       if(!/^\d{17}(\d|x)$/i.test(sId)) return "你输入的身份证长度或格式错误!";   
    	       sId=sId.replace(/x$/i,"a");   
    	       if(city[parseInt(sId.substr(0,2))]==null) return "你的身份证地区非法!";   
    	       sBirthday=sId.substr(6,4)+"-"+Number(sId.substr(10,2))+"-"+Number(sId.substr(12,2));   
    	       var d=new Date(sBirthday.replace(/-/g,"/")) ;  
    	       if(sBirthday!=(d.getFullYear()+"-"+ (d.getMonth()+1) + "-" + d.getDate())) return "身份证上的出生日期非法!";   
    	       for(var i = 17;i>=0;i --) iSum += (Math.pow(2,i) % 11) * parseInt(sId.charAt(17 - i),11) ;  
    	       if(iSum%11!=1) return "你输入的身份证号非法!";   
    	       return true;
       }
       
       //注册easyUI中select组件onchange事件
       $(document).ready(
    		   function(){
    			   $('#certId').combobox({
    				    onChange:function(newValue,oldValue){
    				    	if(newValue==""){
        				    	//alert(newValue);
    				    		$('#certno').textbox({
    				            	required:false
    				            });
    				    	}else if(newValue == 1){ //身份证类型校验规则
    				        	$('#certno').textbox('setValue',$('#certno').textbox('getValue'));
    				            $('#certno').textbox({
    				            	required:true,
    				            	validType:'IDReg'
    				            });
    				        }else{ //其他证证类型校验规则
    				        	$('#certno').textbox('setValue',$('#certno').textbox('getValue'));
	    				        $('#certno').textbox({
	    				        	required:true,
					            	validType:'maxLength[30]'
					            });
    				        }
    				    }
    				});
    	});	   
       
       $(document).ready(
    			function(){
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
    				     mobileANDphoneReg:{ //既验证手机号，又验证座机号
    				      validator: function(value, param){ 
    				           return /(^(0[0-9]{2,3}\-)?([2-9][0-9]{6,7})+(\-[0-9]{1,4})?$)|(^((\d3)|(\d{3}\-))?(1[358]\d{9})$)/.test($.trim(value));
    				          },    
    				          message: '请输入正确的电话号码。' 
    				     }, 
    				     
    					emailReg : {   
    					      validator: function(value){   
    					            return /^[a-zA-Z0-9_+.-]+\@([a-zA-Z0-9-]+\.)+[a-zA-Z0-9]{2,4}$/i.test($.trim(value));   
    					      },   
    					        message: '电子邮箱格式错误'  
    					},
    					IDReg: {     
 					       validator: function(value,param){    
 					            var flag = false;  
 					            //仅对身份证号码验证
 					            var certType = $('#certId').combobox('getValue');
 					            if(certType == 1){
 					            	flag = isLegalID($.trim(value));
 					            }else{
 					            	//当时长度需要控制30字符以内
 					            	flag = true;  //其他证件类型不检验证件号码
 					            }
 					            return flag==true?true:false;    
 					        },     
 					        message: '不是有效的身份证号码。'    
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
	
	    var url;
		//隐藏
	    function hideFormUI(){
	    	$('#userIdDiv').hide();
	    	$('#emailOriginalDiv').hide();
	    	$('#newEmailDiv').hide();
	    	$('#newEmailConfirmDiv').hide();
	    	$('#createDateDiv').hide();
	    }
	    
		//显示
	    function showFormUI(){
	    	$('#userIdDiv').show();
	    	$('#emailOriginalDiv').show();
	    	$('#newEmailDiv').show();
	    	$('#newEmailConfirmDiv').show();
	    	$('#createDateDiv').show();
	    }
	    
	    //ADD BY LIHUI 2016.01.26
	    //注册easyUI中select组件onchange事件
	    $(document).ready(
	 		   function(){
	 			   $('#statusId').combobox({
	 				    onChange:function(newValue,oldValue){
	 				    	if(newValue == 5 && oldValue && oldValue != 5){
	 				    		$('#btnSave').linkbutton({disabled:true});
	 				    		XypayCommon.MessageAlert('提示', '不允许修改为暂时冻结状态!','warning');
	 				    		return;
	 				        }else{
	 				        	$('#btnSave').linkbutton({disabled:false});
	 				        }
	 				    }
	 				});
	 	});
	  
		//点击'用户管理'菜单即加载查询数据
	    $(function(){
	    	search();
		});
	    
		function search(){ 
	    	var options = $('#userTable').datagrid('options');
	    	options.url = "userPageList.json";
	    	$('#userTable').datagrid('reload',{
	        	roleId:$('#roleQuery').combobox('getValue'),
	        	/* orgId:$('#orgQuery').combobox('getValue'), */
	        	userName:$('#userNameQuery').val(),
	        	logonName:$('#logonNameQuery').val(),
	        	status:$('#statusQuery').combobox('getValue')
	    	});
		}
		
		function searchUser(){  
	        $('#userTable').datagrid('load',{  
	        	roleId:$('#roleQuery').combobox('getValue'),
	        	/* orgId:$('#orgQuery').combobox('getValue'), */
	        	userName:$('#userNameQuery').val(),
	        	logonName:$('#logonNameQuery').val(),
	        	status:$('#statusQuery').combobox('getValue')
	        });  
	    }
	
		//新增用户(去掉'暂时冻结'状态选项)
		function createUser(){  
			
			//隐藏form表单
			hideFormUI();
			
			//显示
			$('#emailDiv').show();
	    	$('#emailConfirmDiv').show();
	    	//回复可编辑
	    	$('#logonName').textbox('enable',true);
	    	
	    	//非模态窗口形式
	   		//$('#userResourceDlg').dialog('open').dialog('center').dialog('setTitle','添加');
	   		$("#userResourceDlg").dialog({
                title: "添加",  
                closed: false,
                top:0,
                width: 400,  
	    		height: 420,
                modal:true
		    });   
	        $('#userResourceForm').form('clear');
	        //初始化
	        $('#statusId').combobox('setValue',0); //初始化为'正常'状态
	        $('#roleId').combobox('setValue','');
			$('#certId').combobox('setValue','');  //初始化为'身份证'类型
			$('#certno').textbox({required:false});
	        
			url = 'createUserResource'; 
			
			$('#btnSave').linkbutton({disabled:false});
	    } 
         
		//查看用户(保留'暂时冻结'状态选项)
		function viewUser(){
			
			var obj = $('#userTable');
			var rows = obj.datagrid('getSelections');
			if(XypayCommon.getSelectRowCurPage(obj) == false){
				XypayCommon.MessageAlert('提示', '请选择一条信息!','warning');
				return;
			}
			
			var row = rows[0];
			//alert(JSON.stringify(rows));
			if (row) {
				//非模态窗口形式
				//$('#viewUserResourceDlg').dialog('open').dialog('center').dialog('setTitle','查看');
				$("#viewUserResourceDlg").dialog({
	                title: "查看",  
	                closed: false,
	                top:0,
	                width: 400,  
		    		height: 450,
	                modal:true
			    });  
				//$('#viewUserResourceForm').form('load', 'getUserResourceById.json?id='+row.usrId);
				$('#viewUserResourceForm').form('clear');
				$.get("getUserResourceById.json", {id:row.usrId}, function (data){
					//alert(JSON.stringify(row));
					data = XypayCommon.toJson(data);
					//alert(JSON.stringify(data));
					$('#viewUserResourceForm').form('load', data);
					//设置用户编号
			    	$('#viewUserId').textbox('setValue',row.usrId);
					//设置用户登录名
			    	$('#viewLogonname').textbox('setValue',data.usrLogonname);
					//设置用户姓名
					$('#viewUserName').textbox('setValue',data.usrName);
					//设置邮箱URL
					$('#viewEmail').textbox('setValue',data.usrEmail?data.usrEmail:data.emailOriginal);
					//设置注册时间
					$('#viewCreatedatefmt').textbox('setValue',data.createdatefmt);
					//设置机构名称
					$('#viewBranchName').textbox('setValue',data.usrBranchid);
					//设置状态
					$('#viewStatusName').textbox('setValue',data.sttName);
					//所属角色
					$('#viewRoleName').textbox('setValue',data.userRoleName);
					//设置手机号码
					$('#viewMobile').textbox('setValue',data.usrMobile);
					//设置固定号码
					$('#viewPhone').textbox('setValue',data.usrPhone);
					//设置地址
					$('#viewAddress').textbox('setValue',data.usrAddress);
					//设置证件类型
					$('#viewCertType').textbox('setValue',data.certTypeName);
					//设置证件号码
					$('#viewCertNo').textbox('setValue',data.usrCertno);
				});
			}
		}
		
		//编辑用户(去掉'暂时冻结'状态选项)
		function editUser() {
			
			var obj = $('#userTable');
			var rows = obj.datagrid('getSelections');
			if(XypayCommon.getSelectRowCurPage(obj) == false){
				XypayCommon.MessageAlert('提示', '请选择一条信息!','warning');
				return;
			}
			
			var row = rows[0];
			//注销状态不允许编辑
			if(row.sttNo == 3){
				XypayCommon.MessageAlert('提示', '注销状态不允许编辑!','warning');
				return;
			}
		
			//显示form表单
			showFormUI();
			//隐藏原邮件UI
			$('#emailDiv').hide();
	    	$('#emailConfirmDiv').hide();
	    	
	    	//不可编辑UI
	    	$('#userId').textbox('disable',true);
	    	$('#logonName').textbox('disable',true);
	    	$('#createdatefmt').textbox('disable',true);
	    	$('#emailOriginal').textbox('disable',true);
	    	
			if (row) {
				//非模态窗口形式
				//$('#userResourceDlg').dialog('open').dialog('center').dialog('setTitle','编辑');
				$("#userResourceDlg").dialog({
	                title: "编辑",  
	                closed: false,
	                top:0,
	                width: 400,  
		    		height: 500,
	                modal:true
			    });  
				//$('#userResourceForm').form('load', 'getUserResourceById.json?id='+row.usrId);
				$('#userResourceForm').form('clear');
				$.get("getUserResourceById.json", {id:row.usrId}, function (data){
					data = XypayCommon.toJson(data);
					//alert(JSON.stringify(data));
					$('#userResourceForm').form('load', data);
			    	//解决不了textbox required = false情况下
			    	$('#emailConfirm').textbox('setValue',data.emailOriginal?data.emailOriginal:'test@163.com');
			    	//邮箱
			    	$('#email').textbox('setValue',data.emailOriginal?data.emailOriginal:'test@163.com');
					//角色设置
					$('#roleId').combobox('setValue',data.userRoleId?data.userRoleId:'');
					//状态设置
					$('#statusId').combobox('setValue',data.usrStt?data.usrStt:'');
					//证件类型设置
					$('#certId').combobox('setValue',data.usrCerttype?data.usrCerttype:'');
					if(data.usrCerttype != 1){ //非身份证
						$('#certno').textbox({required:false});
					}else{
						
					}
				});
			    url = 'updateUserResource?id='+row.usrId;
			}
			
			$('#btnSave').linkbutton({disabled:false});
		}

		function saveUser() {
			//$('#btnSave').linkbutton({disabled:true});
			XypayCommon.genCsrfToken($('#userResourceForm'));
			$('#userResourceForm').form('submit', {
				url : url,
				//async: false, 属性无效
				onSubmit : function() {
					//var flag = $(this).form('validate');
					return $(this).form('validate');

					/* if(!flag) {
						flag = true;
						$('#btnSave').linkbutton({disabled:false});
					}
					return flag; */
				},
				success : function(result) {
					result = XypayCommon.toJson(result);
					if (result.success) {
						$('#userResourceDlg').dialog('close'); // close the dialog
						$('#userTable').datagrid('reload');    // reload the user data	
						//提示信息
						//XypayCommon.MessageBox('成功', '操作成功!');
						if(url!='createUserResource'){
							XypayCommon.MessageAlert('提示', '操作成功!','info');
						}else{
							XypayCommon.MessageAlert('提示', '操作成功，密码已经发送到您的邮箱','info');
						}
					} else {
						//XypayCommon.MessageBox('错误', result.msg);
						XypayCommon.MessageAlert('提示', result.msg,'warning');
					}
					
					
					//$('#btnSave').linkbutton({disabled:false});
				}
			});
		}

		function removeUser() {
			
			var obj = $('#userTable');
			var rows = obj.datagrid('getSelections');
			if(XypayCommon.getSelectRowCurPage(obj) == false){
				XypayCommon.MessageAlert('提示', '请选择一条信息!','warning');
				return;
			}
			
			var row = rows[0];
			//alert(JSON.stringify(row));
			//注销状态不允许编辑
			if(row.sttNo == 3){
				XypayCommon.MessageAlert('提示', '注销状态无须注销操作!','warning');
				return;
			}
			
			$.messager.confirm('确认', '确定要注销用户状态信息?', function(r) {
				if (r) {
					$.post('deleteUserResource', {
						ids : row.usrId
					}, function(result) {
						result = XypayCommon.toJson(result);
						if (result.success) {
							$('#userTable').datagrid('reload'); // reload the user data
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
		
		//重置密码
		function resetPsw() {
			
			var obj = $('#userTable');
			var rows = obj.datagrid('getSelections');
			if(XypayCommon.getSelectRowCurPage(obj) == false){
				XypayCommon.MessageAlert('提示', '请选择一条信息!','warning');
				return;
			}
			
			//注销状态不允许重置密码
			if(rows[0].sttNo == 3){
				XypayCommon.MessageAlert('提示', '该用户已注销，不可重置操作!','warning');
				return;
			}
			
			$.messager.confirm('确认', '确认重置密码？', function(r) {
				if (r) {
					var row = $('#userTable').datagrid('getSelected');
					$.post('resetPsw', {
						usrId : row.usrId
					}, function(result) {
						result = XypayCommon.toJson(result);
						if (result.success) {
							$('#userTable').datagrid('reload');    // reload the user data	
							//XypayCommon.MessageBox('成功', '已将新密码发送至用户邮箱!');
							XypayCommon.MessageAlert('提示', '已将新密码发送至用户邮箱!','info');
						} else {
							//XypayCommon.MessageBox('错误', result.msg);
							XypayCommon.MessageAlert('提示', result.msg,'warning');
						}
					}, 'json');
				}
			});
		}
		
		function reset(){  
	    	 $('#userHeader').form('clear');
	    	 $('#roleQuery').combobox('setValue','');
	    	 $('#orgQuery').combobox('setValue','');
	    	 $('#statusQuery').combobox('setValue','');
	    }
		
		var selectUserId = '';
		function authRole() {
			
			var obj = $('#userTable');
			var rows = obj.datagrid('getSelections');
			if(XypayCommon.getSelectRowCurPage(obj) == false){
				XypayCommon.MessageAlert('提示', '请选择一条信息!','warning');
				return;
			}
			
			var row = rows[0];
			if (row) {
				selectUserId = row.usrId;
				var _url = 'roleSelect?userId='+row.usrId;
				$('#authRoleDlg').dialog({
				    cache: false,
				    href: _url
				});
				$('#authRoleDlg').dialog('options').href = _url;
				$('#authRoleDlg').dialog('open').dialog('center');
			}
		}	
		
		function saveAuthRole(){
			var roleIds = $('#roleSelectTree').combotree('getValues');
			$.post('authRole', {
				roleIds : roleIds.join(','),
				userId : selectUserId
			}, function(result) {
				result = XypayCommon.toJson(result);
				if (result.success) {
					$('#authRoleDlg').dialog('close'); // close the dialog
					$('#userTable').datagrid('reload'); // reload the user data
					selectUserId = '';
					//提示信息
					//XypayCommon.MessageBox('成功', '操作成功!');
					XypayCommon.MessageAlert('提示', '已将新密码发送至用户邮箱!','info');
				} else {
					//XypayCommon.MessageBox('错误', result.msg);
					XypayCommon.MessageAlert('提示', result.msg,'warning');
				}
			}, 'json');
		}
	</script>	
	
</body>
</html>