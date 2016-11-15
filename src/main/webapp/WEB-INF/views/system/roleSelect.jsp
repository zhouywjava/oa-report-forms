<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../common.jsp"%>
<!DOCTYPE html>
<html>
<head>
	<link rel="stylesheet" type="text/css" href="<%=root%>/static/css/common.css">
	<link rel="stylesheet" type="text/css" href="<%=theme%>/easyui.css">
	<link rel="stylesheet" type="text/css" href="<%=root%>/static/js/easyui/themes/icon.css">
	<script type="text/javascript" src="<%=root%>/static/js/easyui/js/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="<%=root%>/static/js/easyui/js/easyui-lang-zh_CN.js"></script>
</head>
<body>
	<select id="roleSelectTree" class="easyui-combotree" data-options="url:'roleSelectTree.json?userId=${userId}',method:'get',cascadeCheck:false" multiple style="width:200px;"></select>
</body>
</html>