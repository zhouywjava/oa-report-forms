package com.zhiye.constants;

public class RiskRegex {
	/*密码8-32位数字和字母组合*/
	public static final String	PWD_LOGIN = "^(?!^\\d+$)(?!^[a-zA-Z]+$)[0-9a-zA-Z]{8,32}$";
	
	/**
	 * 手机号码regex
	 */
	public static final String RE_MOBILE = "^1[3-8]+\\d{9}$";
}
