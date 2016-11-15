package com.zhiye.enums;

import java.util.HashMap;
import java.util.Map;

/**
 * 卡限额类型
 * @author linh
 * @date 2015/11/6
 */
public enum YesNoEnum {
	YES("1", "是"), 
	NO("0", "否");

	private final String type;
	private final String name;

	private YesNoEnum(String type, String name) {
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
		for (YesNoEnum item : YesNoEnum.values()) {
			map.put(item.getType(), item.getName());
		}

		return map;
	}

	public boolean equals(String type){
		return this.type.equals(type);		
	}
	
}
