package com.zhiye.util.common;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Random;

public class DateUtil {

	static final String formatPattern = "yyyy-MM-dd";

	static final String formatPattern_Short = "yyyyMMdd";
	
	static final String formatPattern14 = "yyyyMMddHHmmss";

	/**
	 * 获取当前日期
	 * 
	 * @return
	 */
	public static String now() {
		SimpleDateFormat format = new SimpleDateFormat(formatPattern14);
		return format.format(new Date());
	}
	/**
	 * 生成随机数
	 * 
	 * @return
	 */
	public static String getRandomString(int length){
	     StringBuffer buffer=new StringBuffer("0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ");
	     StringBuffer sb=new StringBuffer();
	     Random r=new Random();
	     int range=buffer.length();
	     for(int i=0;i<length;i++){
	    	 sb.append(buffer.charAt(r.nextInt(range)));
	     }
	     return sb.toString();
	}

}
