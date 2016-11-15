package com.zhiye.aop;

import java.lang.reflect.Method;

import javax.servlet.http.HttpServletRequest;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.annotation.AnnotationUtils;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import com.alibaba.fastjson.JSON;


/**
 * 切点类
 */
@Aspect
@Component
public class SysLogAspect {
	
	// 本地异常日志记录对象
	private static final Logger logger = LoggerFactory
			.getLogger(SysLogAspect.class);

	/**
	 * 用于拦截Controller层记录用户的操作
	 */
	@Around("execution (* com.xypay.msg.web.controller.*Controller.*(..))")
	public Object addControllerLog(ProceedingJoinPoint joinPoint)
			throws Throwable {
		Object result = null;
		try {
			String description = getControllerMethodDescription(joinPoint, "SysControllerLog");
			if ("-1".equals(description)) {
				logger.debug("No need to add a log");
				result = joinPoint.proceed();
				return result;
			}
			HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder
					.getRequestAttributes()).getRequest();
			String logIp = request.getRemoteAddr();
			String reqParam = getReqParam(joinPoint);
			logger.debug(String.format("addControllerLog请求类.方法：%s,方法描述：%s,请求IP：%s,用户名：%s", (joinPoint.getTarget().getClass().getName() + "."
							+ joinPoint.getSignature().getName() + "()"),description,request.getRemoteAddr(),""));
			logger.info(String.format("请求的参数：%s", reqParam));
			// 取业务编号
			String value = getResourcesMethodAnnotation(joinPoint);
			result = joinPoint.proceed();
			
		} catch (Exception e) {
			e.printStackTrace();
			// 记录本地异常日志
			logger.error("addControllerLog异常信息:{}", e.getMessage());
		}
		return result;
	}

	/**
	 * 用于拦截service层记录日志
	 * 
	 * @param joinPoint
	 * @throws Throwable
	 */
	@Around(value = "execution(* com.xypay.msg.service.impl.*.*(..)) && @annotation(log)")
	public Object aroundMethod(ProceedingJoinPoint joinPoint, SysServiceLog log)
			throws Throwable {
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder
				.getRequestAttributes()).getRequest();
		Object result = null;
		try {
			String logIp = request.getRemoteAddr();
			String reqParam = getReqParam(joinPoint);
			logger.debug(String.format("addControllerLog请求类.方法：%s,方法描述：%s,请求IP：%s,用户名：%s", (joinPoint.getTarget().getClass().getName() + "."
					+ joinPoint.getSignature().getName() + "()"), log.description(), request.getRemoteAddr(), ""));
			logger.info(String.format("请求的参数：%s", reqParam));
			// 添加日志
			result = joinPoint.proceed();
			
		} catch (Exception ex) {
			logger.error("aroundMethod()异常信息:{}", ex.getMessage());
		}
		return result;
	}
	/**
	 * 
	 * @param joinPoint
	 * @return
	 * @author:wangj
	 * @email:wangjian@xiangyu.cn
	 * @创建日期:2015年12月25日
	 * @功能说明：获取请求的参数
	 */
	public String getReqParam(ProceedingJoinPoint joinPoint){
		String params = "";
		if (joinPoint.getArgs() != null && joinPoint.getArgs().length > 0) {
			for (int i = 0; i < joinPoint.getArgs().length; i++) {
				if(joinPoint.getArgs()[i] instanceof CommonsMultipartFile) {
					params += ((CommonsMultipartFile)joinPoint.getArgs()[i]).getFileItem().getName() + ";";
				}else if(joinPoint.getArgs()[i] != null){
					params += JSON.toJSONString(joinPoint.getArgs()[i]) + ";";
				}
			}
		}
		return params;
	}
	/**
	 * 获取注解中对方法的描述信息 用于Controller层注解
	 * 
	 */
	@SuppressWarnings("rawtypes")
	public static String getResourcesMethodAnnotation(JoinPoint joinPoint)
			throws Exception {
		String targetName = joinPoint.getTarget().getClass().getName();
		Class targetClass = Class.forName(targetName);
		String methodName = joinPoint.getSignature().getName();
		Method[] methods = targetClass.getMethods();
		String description = "-1";
		for (Method method : methods) {//使用查找
			if (method.getName().equals(methodName)) {
				RequiresPermissions sysLog = AnnotationUtils.findAnnotation(method, RequiresPermissions.class);
				//System.out.println(sysLog.value().length);
				if(sysLog != null){
					return sysLog.value()[0];
				}
			}
		}
		return description;
	}
	
	/**
	 * 获取注解中对方法的描述信息 用于Controller层注解
	 * 
	 * @param joinPoint  切点
	 * @return 方法描述
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	public static String getControllerMethodDescription(JoinPoint joinPoint,String object)
			throws Exception {
		String targetName = joinPoint.getTarget().getClass().getName();
		String methodName = joinPoint.getSignature().getName();
		Object[] arguments = joinPoint.getArgs();
		Class targetClass = Class.forName(targetName);
		Method[] methods = targetClass.getMethods();
		String description = "-1";
		for (Method method : methods) {
			if (method.getName().equals(methodName)) {
				/*Annotation[] annotations = method.getAnnotations();// 获取所有注解信息
				for(Annotation annotation : annotations) {
					System.out.println(annotation.annotationType().getSimpleName());
				}*/
				Class[] clazzs = method.getParameterTypes();
				if (clazzs.length == arguments.length && "SysControllerLog".equals(object)){
					SysControllerLog sysLog = method.getAnnotation(SysControllerLog.class);
					if (sysLog != null) {
						return method.getAnnotation(SysControllerLog.class).description();
					}
				}else if (clazzs.length == arguments.length && "RequiresPermissions".equals(object)){
					RequiresPermissions sysLog = AnnotationUtils.findAnnotation(method,RequiresPermissions.class);
					if (sysLog != null) {
						return method.getAnnotation(RequiresPermissions.class).value()[0];
					}
				}
			}
		}
		return description;
	}
}