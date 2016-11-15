package com.zhiye.enums;

import java.util.Map;
import java.util.TreeMap;

public enum BusinessTypeEnum {
	
	MESSAGE("0", "短信");	
	
	private final String status;
	private final String name;
	
	private BusinessTypeEnum(String status, String name){
		this.status = status;
		this.name = name;
	}
	
	public String getStatus() {
		return status;
	}

	public String getName() {
		return name;
	}

	public static Map<String, String> toMap() {
		
		Map<String, String> map = new TreeMap<String,String>();
		for (BusinessTypeEnum item : BusinessTypeEnum.values()) {
			map.put(item.getStatus(), item.getName());
		}

		return map;
	}

	public boolean equals(String status){
		return this.status.equals(status);		
	}
}
