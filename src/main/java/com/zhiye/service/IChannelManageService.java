package com.zhiye.service;

import java.util.Date;
import java.util.List;
import java.util.Map;

import com.github.pagehelper.Page;
import com.zhiye.util.common.PageQuery;


public interface IChannelManageService {

	Page<Map<String, Object>> queryByCondition(Map<String, Object> condition);

	Page<Map<String, Object>> queryByCondition(Map<String, Object> condition,
			PageQuery pageQuery);

	int addChannel(Map<String,Object> param, String user, Date datetime);
    
	Map<String, Object> getChannelResourceByIdForView(String id);
	
	int disableChannel(String rowId, String operId, Date now);

	int enableChannel(String rowId, String operId, Date now);
	
	int updateChannel(Map<String,Object> param, String user, Date datetime);
	
	List<Map<String, String>> queryChanAccNumByCondition(Map<String, Object> condition);

}
