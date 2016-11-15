package com.zhiye.service.impl;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.github.pagehelper.Page;
import com.zhiye.service.IChannelManageService;
import com.zhiye.util.common.FormatHelperUtil;
import com.zhiye.util.common.PageQuery;



@Service("channelManageService")
public class ChannelManageServiceImpl implements IChannelManageService {

	@Override
	public Page<Map<String, Object>> queryByCondition(Map<String, Object> condition) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Page<Map<String, Object>> queryByCondition(Map<String, Object> condition, PageQuery pageQuery) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public int addChannel(Map<String, Object> param, String user, Date datetime) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public Map<String, Object> getChannelResourceByIdForView(String id) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public int disableChannel(String rowId, String operId, Date now) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int enableChannel(String rowId, String operId, Date now) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int updateChannel(Map<String, Object> param, String user, Date datetime) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public List<Map<String, String>> queryChanAccNumByCondition(Map<String, Object> condition) {
		// TODO Auto-generated method stub
		return null;
	}
	
	


}
