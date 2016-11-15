package com.zhiye.enums;

import java.util.HashMap;
import java.util.Map;

/**
 * 启用状态
 * @author linh
 * @date 2015/11/3
 */
public enum StatusEnum {

	ACTIVE("1", "启用"), 
	DISABLE("0", "禁用");

	private final String type;
	private final String name;

	private StatusEnum(String type, String name) {
		this.type = type;
		this.name = name;
	}

	public String getType() {
		return type;
	}

	public String getName() {
		return name;
	}

	public static Map<String, String> toMap() {
		Map<String, String> map = new HashMap<String, String>();
		for (StatusEnum item : StatusEnum.values()) {
			map.put(item.getType(), item.getName());
		}

		return map;
	}

	public boolean equals(String type){
		return this.type.equals(type);		
	}
	
}
