package com.zhiye.service;

import java.util.List;

import com.zhiye.web.dto.BaseDataDto;
/**
 * 
 * <p>标题: 导出接口</p>
 * <p>描述: </p>
 * <p>版权: Copyright (c) 2016</p>
 * <p>公司: 智业软件股份有限公司</p>
 *
 * @version: 1.0
 * @author: zhouyw
 */
public interface IExcelDataOutputService {
	/**
	 * 导出excel数据
	 * @return
	 */
	List<? extends BaseDataDto> expExcelData();
}
