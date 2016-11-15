package com.zhiye.web.exception.handle;

import java.io.IOException;
import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.UnauthorizedException;
import org.springframework.core.annotation.AnnotationUtils;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.ModelAndView;

import com.alibaba.fastjson.JSON;
import com.zhiye.constants.ErrorCode;
import com.zhiye.web.dto.ResponseDto;


@ControllerAdvice
public class SystemExceptionHandler {

	@ExceptionHandler(Exception.class)
	public ModelAndView handleException(Exception re,
			HttpServletRequest request, HttpServletResponse response,
			HandlerMethod handlerMethod) throws IOException {
		Method method = handlerMethod.getMethod();
		ResponseBody responseBodyAnn = AnnotationUtils.findAnnotation(method,
				ResponseBody.class);

		ErrorCode error = generateErrorCodeByException(re);

		// 如果是ajax的json请求，则返回json格式错误信息
		if (responseBodyAnn != null) {
			writeJsonResponse(response, new ResponseDto(false, error));
			return new ModelAndView();
		}

		Map<String, Object> model = new HashMap<String, Object>();
		model.put("error", error);
		return new ModelAndView("error/500", model);
	}

	private ErrorCode generateErrorCodeByException(Exception e) {
		if (e instanceof UnauthorizedException) {
			return ErrorCode.UNAUTH_ERROR;
		} else if (e instanceof ValidateRuntimeException) {
			ValidateRuntimeException re = (ValidateRuntimeException)e;
			return re.getErrorCode();
		}
		return ErrorCode.SYSTEM_ERROR;
	}

	private void writeJsonResponse(HttpServletResponse response,
			ResponseDto responseDto) throws IOException {
		response.setContentType("application/json;charset=UTF-8");
		response.getWriter().write(JSON.toJSONString(responseDto));
	}

	private static String getAuthCodeFromErrMsg(String msg) {
		Pattern pattern = Pattern.compile("\\[(.*?)\\]");
		Matcher matcher = pattern.matcher(msg);
		if (matcher.find()) {
			return matcher.group(1);
		}
		return "";
	}

	public static void main(String[] args) {
		String aaa = "Subject does not have permission [system:resource:create]";
		System.out.println(getAuthCodeFromErrMsg(aaa));
	}

}
