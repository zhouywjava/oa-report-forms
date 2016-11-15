<%@ page language="java" isErrorPage="true" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>  
<%@ page isELIgnored="false"  %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">  
<html>  
    <head>  
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">  
        <title>登出</title>  
    </head>  
    <body bgcolor="#FFFFFF">  
        <div align="center">  
            <br>  
            <br>  
            <h2>  
             	会话已过期
            </h2>  
            <hr>  
            <p>  
            	系统将会在<strong id="endtime"></strong>秒后跳转到登录页！
            <br>  
            <br>  
            <br>   
        </div>  
        
		<script type="text/javascript">  
		var i = 3;  
		function remainTime(){  
			if(i==0){  
				top.window.location.href="login";  
			}  
			document.getElementById('endtime').innerHTML=i--;  
			setTimeout("remainTime()",1000);  
		}  
		remainTime();  
		</script> 
    </body>  
</html>