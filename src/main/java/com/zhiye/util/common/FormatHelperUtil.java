package com.zhiye.util.common;

import java.math.BigDecimal;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import javax.servlet.http.HttpServletRequest;


/*
 * Copyright 2016
 * All Rights Reserved.
 * 文件名称： FormatHelperUtil.java
 * 摘 要：
 * 作 者： lichangxing
 * 创建时间: 2016年4月22日--上午9:51:35
 */

public class FormatHelperUtil {
	public static boolean isNumeric(String str) {
		Pattern pattern = Pattern.compile("[0-9.]*");
		Matcher isNum = pattern.matcher(str);
		if (!isNum.matches()) {
			return false;
		}
		return true;
	}

	public static String stringParse(Object pObject) {
		if (pObject == null) {
			return "";
		}
		return pObject.toString();
	}

	public static String stringParse(int pInt) {
		return String.valueOf(pInt);
	}

	public static int intParse(String pStr) {
		int result = 0;
		String resultString = pStr;

		if (resultString == null) {
			return 0;
		}

		if (isNumeric(resultString)) {
			if (resultString.length() == 0)
				return 0;
			if (resultString.length() >= Integer.parseInt("10")) {
				resultString = resultString.substring(0, Integer.parseInt("10"));
				if (resultString.compareTo(String.valueOf(2147483647)) > 0)
					result = 2147483647;
				else
					result = Integer.parseInt(resultString);
			} else {
				result = Integer.parseInt(resultString);
			}

			if (pStr.startsWith("-")) {
				return result * -1;
			}
			return result;
		}

		return 0;
	}

	public static int intParse(Object obj) {
		return intParse(stringParse(obj));
	}

	public static long longParse(String pStr) {
		long result = 0L;
		try {
			result = Long.parseLong(pStr);
		} catch (Exception localException) {
		}
		return result;
	}

	public static long longParse(Object obj) {
		return longParse(stringParse(obj));
	}

	public static BigDecimal bigDecimalParse(Object obj) {
		return bigDecimalParse(stringParse(obj));
	}

	public static BigDecimal bigDecimalParse(String pStr) {
		BigDecimal result = new BigDecimal(0);
		try {
			result = new BigDecimal(pStr);
		} catch (Exception localException) {
		}
		return result;
	}

	public static double doubleParse(String pStr) {
		double result = 0.0D;
		try {
			result = Double.parseDouble(pStr);
		} catch (Exception localException) {
		}
		return result;
	}

	public static double doubleParse(Object obj) {
		return doubleParse(stringParse(obj));
	}

	public static String stringReplace(String str) {
		String returnStr = str.replaceAll("'", "''");
		return returnStr;
	}

	public static String getNotNullRequest(String parameterValue, Object parameter) {
		String result = "";

		if (parameter != null)
			result = parameterValue;
		else {
			result = stringParse(parameter);
		}
		return result;
	}

	public static String getUrlInfo(String serviceUrl, Map paramMap) {
		String url = serviceUrl;

		if (serviceUrl.indexOf("?") > 0) {
			url = serviceUrl.substring(0, serviceUrl.indexOf("?"));

			String param = serviceUrl.substring(serviceUrl.indexOf("?") + 1, serviceUrl.length());
			String[] arr = param.split("&");
			for (int i = 0; i < arr.length; i++) {
				String s = arr[i];
				paramMap.put(s.substring(0, s.indexOf("=")), s.substring(s.indexOf("=") + 1, s.length()));
			}
		}

		return url;
	}
	
	
	public static String getRemoteHost(HttpServletRequest request) {
		String ip = request.getHeader("x-forwarded-for");
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getHeader("Proxy-Client-IP");
		}
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getHeader("WL-Proxy-Client-IP");
		}
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getRemoteAddr();
		}
		return ip.equals("0:0:0:0:0:0:0:1") ? "127.0.0.1" : ip;
	}

}
