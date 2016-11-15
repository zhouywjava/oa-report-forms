package com.zhiye.constants;

import java.util.Map;
import java.util.TreeMap;

public enum ErrorCode {

	PARAM_EMPTY("10001", "参数不完整"),
	UNAUTH_ERROR("10002", "没有权限"), 
	DATA_REPEAT("10003", "数据维护重复"),
	OVER_LIMIT("10004", "超过限额"),
	NOT_NULL("10005", "必输字段为空"),
	CAPTCHA_ERROR("10006", "验证码错误"),
	REFERER_ILLEGAL("10007", "请求来源非法"),
	TOKEN_INVALID("10008", "TOKEN无效"),
	PARAM_ILLEGAL("10009", "参数非法"),
	LOGON_FAIL("10010", "用户名或密码错误"),
	USER_DISABLED("10010", "用户已注销"),
	USER_FREEZE("10011", "用户已冻结"),
	USER_FREEZE_TEMP("10012", "用户已临时冻结"),
	
	USER_INVALID("20001", "用户已失效"),
	SEND_MAIL_FAIL("20002", "邮件发送失败"),
	
	SYSTEM_LOGONSUC("99997", "登录成功"),
	SYSTEM_LOGONFAIL("99998", "登录失败"),
	SYSTEM_ERROR("99999", "系统错误"),
	SYSTEM_SUCCESS("00000", "操作成功")
	;

	private final String code;
	private final String msg;

	private ErrorCode(String code, String msg) {
		this.code = code;
		this.msg = msg;
	}

	public static Map<String, String> toMap() {
		Map<String, String> map = new TreeMap<String,String>();
		for (ErrorCode item : ErrorCode.values()) {
			map.put(item.getCode(), item.getMsg());
		}

		return map;
	}

	public String getCode() {
		return code;
	}

	public String getMsg() {
		return msg;
	}
	

}
