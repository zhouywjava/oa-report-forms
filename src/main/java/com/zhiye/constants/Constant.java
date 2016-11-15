package com.zhiye.constants;

/**
 * 通用常量类
 *
 */
public class Constant{
	
	/**
	 * 当前登陆用户的ID
	 */
	static final public String HTTP_SESSION_ID ="HTTP_SESSION_ID";
	
	/**
	 * 上次登录时间
	 */
	static final public String LAST_LOGON_TIME ="LAST_LOGON_TIME";
	
	/**
	 * 上次登录IP
	 */
	static final public String LAST_LOGON_IP ="LAST_LOGON_IP";
	
	static final public String RSK_BRANCH_ID = "88888888";
	
	static final public String RSK_COMMON_VALIDATE =  "999999999999";
	
	public static final String OFFICE_EXCEL_2003_POSTFIX = "xls";
	
	public static final String OFFICE_EXCEL_2010_POSTFIX = "xlsx";
	
	//线下交易记录排除掉交易状态
	public static final  String RSK_EXCLUDE_TRANS_STATUS = "50,70,71,72,80,81,91,92,93,94,90,31,S0,S1,10,20,60,A0,A1,95,01,02,3A";
	
	//邮件发送四个code值
	public static final String EMAIL_HOST = "EMAIL_HOST";
	public static final String EMAIL_FROM_EMAIL = "EMAIL_FROM_EMAIL";
	public static final String EMAIL_SENDDER = "EMAIL_SENDDER";
	public static final String EMAIL_PWD = "EMAIL_PWD";
	
}