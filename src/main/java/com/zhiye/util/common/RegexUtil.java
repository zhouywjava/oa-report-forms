package com.zhiye.util.common;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class RegexUtil {
	
	public static boolean validate(String re, String text) {
		try{
			Pattern pattern = Pattern.compile(re);
			Matcher matcher = pattern.matcher(text);
			return matcher.matches();
		}catch(Exception e) {
			return false;
		}
	}
	
	public static void main(String[] args) {
		System.out.println(validate("", null));
	}
}
