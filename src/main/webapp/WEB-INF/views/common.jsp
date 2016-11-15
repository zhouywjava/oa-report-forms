<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN" "http://www.w3.org/TR/html4/strict.dtd"> 
<metahttp-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="0"> 
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<meta http-equiv="x-ua-compatible" content="IE=8">  
<%@ page isELIgnored="false"  %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<% String root = request.getContextPath(); %>
<% String theme = root + "/static/js/easyui/themes/bootstrap"; %>
<script type="text/javascript" src="<%=root%>/static/js/jquery.min.js"></script>
<script type="text/javascript" src="<%=root%>/static/js/moment.js"></script>
<script type="text/javascript" src="<%=root%>/static/js/common.js"></script>
<script type="text/javascript" src="<%=root%>/static/js/common-footer.js"></script>
<script type="text/javascript">
 var root = "<%=root%>"; //js中存放当前页面的root路径方便调用
 var theme = "<%=theme%>"; //样式根目录
 $.ajaxSetup ({
    cache: false //关闭AJAX相应的缓存
 });
</script>
