package com.zhiye.service;

import java.util.List;

import com.zhiye.web.dto.ExcelDataImplDto;
import com.zhiye.web.dto.ExcelDataTotalDto;
import com.zhiye.web.dto.ResponseDto;
/**
 * 
 * <p>标题: 导入服务层</p>
 * <p>描述: </p>
 * <p>版权: Copyright (c) 2016</p>
 * <p>公司: 智业软件股份有限公司</p>
 *
 * @version: 1.0
 * @author: zhouyw
 */
public interface IExcelDataImputService {
	/**
	 * 导入excel数据
	 * @param list 导入的数据列表
	 * @return
	 */
	ResponseDto importExcelData(List<ExcelDataImplDto> list);
	/**
	 * 导出excel汇总数据
	 * @return
	 */
	List<ExcelDataTotalDto> expExcelDataTotal();
}
