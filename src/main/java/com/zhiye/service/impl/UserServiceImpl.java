package com.zhiye.service.impl;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Service;

import com.zhiye.service.IUserService;
import com.zhiye.web.dto.ResponseDto;

/**
 * 用户管理Service
 * @author linh
 * @date 2015/12/21
 */
@Service("userService")
public class UserServiceImpl implements IUserService {
	private final Log logger = LogFactory.getLog(getClass());
	public final static int MAX_LOGIN_TIMES = 5; //登陆5次失败冻结
	public final static int UNFREEZE_HOURS = 3;  //3小时候自动解冻
	@Override
	public ResponseDto login(String username, String password, String clientip) {
		// TODO Auto-generated method stub
		return null;
	}
	
	

}
