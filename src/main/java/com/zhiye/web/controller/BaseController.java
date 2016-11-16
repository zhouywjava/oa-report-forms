package com.zhiye.web.controller;

import java.util.Collection;
import java.util.List;

import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;
import org.apache.shiro.web.subject.WebSubject;
import org.springframework.stereotype.Controller;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

@Controller
public class BaseController {
	
	protected final Log logger = LogFactory.getLog(getClass());

	/*public String decryptOcxPassword(HttpSession session, String password) {
		String randomKey = (String) session.getAttribute("randomKey");
		String result = AESWithJCE.getResult(randomKey, password);
		return result;
	}*/
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public void removeAllSession()
	{
		Subject currentUser=SecurityUtils.getSubject(); 
		Session session = currentUser.getSession(); 
		
		Collection keys=session.getAttributeKeys();
		List<String> ls=(List) keys;
		for(String key:ls)
		{
			session.removeAttribute(key);
			logger.info("session ["+key+"] removed");
		}
		logger.info("session removed all");
	
	}
	
/*	public MsgUser getUserinfo()
	{
		return (MsgUser)SecurityUtils.getSubject().getSession().getAttribute(Constant.HTTP_SESSION_ID);
	}*/
	
	/**
	 * ADD BY LIHUI 2016.01.07
	 * @return
	 */
	/*public String getUserCode()
	{
		return ((MsgUser)SecurityUtils.getSubject().getSession().getAttribute(Constant.HTTP_SESSION_ID)).getUsrLogonname();
	}*/
	
	public Session getSession()
	{
		return SecurityUtils.getSubject().getSession();
	}
	
	public ServletRequest getRequest()
	{
		return ((WebSubject)SecurityUtils.getSubject()).getServletRequest();
		
	}
	public ServletResponse getResponse()
	{
		return ((WebSubject)SecurityUtils.getSubject()).getServletResponse();
	}
	
	public WebApplicationContext getContext()
	{
		HttpSession httpSession=this.getHttpSession();
		return WebApplicationContextUtils.getWebApplicationContext(httpSession.getServletContext());  
	}
	public HttpSession getHttpSession()
	{
		return ((HttpServletRequest)getRequest()).getSession();   
		
	}


}
