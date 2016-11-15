package com.zhiye.aop;

import java.lang.reflect.Method;

import javax.servlet.ServletRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.core.annotation.AnnotationUtils;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.ResponseBody;

import com.zhiye.constants.ErrorCode;
import com.zhiye.web.dto.ResponseDto;

public class ControllerAop {
	Log logger = LogFactory.getLog(getClass());
	//@Around("execution (* com.zhiye.web.controller.*Controller.*(..))")
	public Object around1(ProceedingJoinPoint pjp) throws Throwable {
		MethodSignature signature = (MethodSignature) pjp.getSignature();
		Method method = signature.getMethod();
		ResponseBody responseBodyAnn = AnnotationUtils.findAnnotation(method,
				ResponseBody.class);
		// 针对ajax请求，统一处理返回
		if(responseBodyAnn != null){
			Method getRequest = pjp.getTarget().getClass().getMethod("getRequest", null);
			if(getRequest != null){
				ServletRequest req = (ServletRequest) getRequest.invoke(pjp.getTarget(), null);
				ErrorCode errorCode = (ErrorCode) req.getAttribute("error");
				if (errorCode != null) {
					return new ResponseDto(false, errorCode);
				}
			}
		}

		return pjp.proceed();
	}

}
