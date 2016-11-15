package com.zhiye.oper.interceptor;

import java.io.IOException;
import java.lang.reflect.Method;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.alibaba.fastjson.JSON;
import com.zhiye.constants.Constant;
import com.zhiye.web.dto.ResponseDto;


public class OperHandlerInterceptor extends HandlerInterceptorAdapter {
	protected final Log logger = LogFactory.getLog(getClass());
	
	String excludemethodstr=",genCsrfTokenhandle,genCryptkeyhandle,";
	
	@Override
	public boolean preHandle(HttpServletRequest request,
			HttpServletResponse response, Object handler) throws Exception {
		if(handler instanceof HandlerMethod)
		{
			/*List<String> excludemethods=Arrays.asList("login", "genCsrfToken", "genCryptkey");
			
			Method method = ((HandlerMethod) handler).getMethod();
		String methodname=method.getName().toString();
		logger.info(methodname);
		if(!excludemethods.contains(methodname))
		{
		ResponseBody responseBodyAnn = AnnotationUtils.findAnnotation(method,
				ResponseBody.class);
		// 如果是ajax的json请求，则返回json格式错误信息
		Subject subject =SecurityUtils.getSubject();
		if (!subject.isAuthenticated()) {
			// 如果权限不通过，直接进行之后的流程
			ErrorCode error=(ErrorCode)ErrorCode.USER_INVALID;
			writeJsonResponse(response, new ResponseDto(false, error));
			return false;
		}
		}*/
			Method method = ((HandlerMethod) handler).getMethod();
			String methodname=method.getName().toString();
			Subject currUser=SecurityUtils.getSubject();
			String loginname="";
			if(currUser!=null)
			{
			Session ss=currUser.getSession();
			
			/*if(ss!=null)
			{
				Collection keys=ss.getAttributeKeys();
				List<String> ls=(List) keys;
				for(String key:ls)
				{
					Object o=ss.getAttribute(key);
					if(o instanceof String)
					{
					String val=(String)o;
					logger.info("session ["+key+","+val+"] ");
					}
				}
				
				
			}*/
			}
			
		}
		
		return true;
	}

	private void writeJsonResponse(HttpServletResponse response,
			ResponseDto responseDto) throws IOException {
		response.setContentType("application/json;charset=UTF-8");
		response.getWriter().write(JSON.toJSONString(responseDto));
	}
	
	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {	
	}
 
	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {		
		Session ss=SecurityUtils.getSubject().getSession();
		
		String loginname="";
		
	}

}
