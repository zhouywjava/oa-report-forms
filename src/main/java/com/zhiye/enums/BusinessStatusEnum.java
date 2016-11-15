package com.zhiye.enums;

import java.util.Map;
import java.util.TreeMap;

public enum BusinessStatusEnum {
	
	ENABLE("1", "启用"), 
	DISABLE("2", "停用");
	
	private final String status;
	private final String name;
	
	private BusinessStatusEnum(String status, String name){
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
		for (BusinessStatusEnum item : BusinessStatusEnum.values()) {
			map.put(item.getStatus(), item.getName());
		}

		return map;
	}

	public boolean equals(String status){
		return this.status.equals(status);		
	}
}
