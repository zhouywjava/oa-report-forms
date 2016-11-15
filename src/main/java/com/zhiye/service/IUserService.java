package com.zhiye.service;

import com.zhiye.web.dto.ResponseDto;

/**
 * 用户管理Service
 * @author linh
 * @date 2015/12/21
 */
public interface IUserService {
	/**
	 * 登录
	 * @param username 用户名
	 * @param password 密码
	 * @param clientip IP地址
	 * @return
	 */
	public ResponseDto login(String username, String password,String clientip);
}
