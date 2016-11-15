package com.zhiye.captcha;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;

import com.octo.captcha.service.CaptchaServiceException;
import com.octo.captcha.service.captchastore.FastHashMapCaptchaStore;

public class JCaptcha {
	public static final CaptchaService captchaService = new CaptchaService(
			new FastHashMapCaptchaStore(), new GMailEngine(), 180, 100000,
			75000);

	public static boolean validateResponse(HttpServletRequest request,
			String userCaptchaResponse) {
		if (request.getSession(false) == null)
			return false;
		boolean validated = false;
		try {
			String id = request.getSession().getId();
			validated = captchaService.validateResponseForID(id,
					StringUtils.lowerCase(userCaptchaResponse)).booleanValue();
		} catch (CaptchaServiceException e) {
			e.printStackTrace();
		}
		return validated;
	}

	public static boolean hasCaptcha(HttpServletRequest request,
			String userCaptchaResponse) {
		if (request.getSession(false) == null)
			return false;
		boolean validated = false;
		try {
			String id = request.getSession().getId();
			validated = captchaService.hasCapcha(id, userCaptchaResponse);
		} catch (CaptchaServiceException e) {
			e.printStackTrace();
		}
		return validated;
	}
}