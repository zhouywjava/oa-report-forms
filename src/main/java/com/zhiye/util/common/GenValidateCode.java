package com.zhiye.util.common;

/**
 * @ClassName: GenValidateCode 
 * @Description: 生成校验码
 * @author lihui
 * @date 2015-12-16
 * @version	1.0
 */
public class GenValidateCode {
	
	int length = 6;
	boolean numberFlag = true;//true纯数字；false数字和字母
	//String scope = "0-9";// 可选 0-9|A-Z|a-z

	public String genValidateCode() {
		String randomString = getRandom(numberFlag, length);
		return randomString;
	}
	
	 public String getRandom(boolean numberFlag, int length){
		  String retStr = "";
		  String strTable = numberFlag ? "1234567890" : "1234567890ABCDEFGHIJKMNPQRSTUVWXYZ";
		  int len = strTable.length();
		  boolean bDone = true;
		  do {
		   retStr = "";
		   int count = 0;
		   for (int i = 0; i < length; i++) {
		    double dblR = Math.random() * len;
		    int intR = (int) Math.floor(dblR);
		    char c = strTable.charAt(intR);
		    if (('0' <= c) && (c <= '9')) {
		     count++;
		    }
		    retStr += strTable.charAt(intR);
		   }
		   if (count >= 2) {
		    bDone = false;
		   }
		  } while (bDone);
		 
		  return retStr;
	}
}
