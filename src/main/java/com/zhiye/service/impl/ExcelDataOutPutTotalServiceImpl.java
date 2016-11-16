package com.zhiye.service.impl;

import java.util.List;
import java.util.Map;

import com.zhiye.cache.ExecelDataManager;
import com.zhiye.service.IExcelDataOutputService;
import com.zhiye.web.dto.BaseDataDto;

public class ExcelDataOutPutTotalServiceImpl implements IExcelDataOutputService {

	@Override
	public List<? extends BaseDataDto> expExcelData() {		
		Map<String, List<? extends BaseDataDto>> excelmap = ExecelDataManager.getExcelMapInstance();
		//如果存在两份文件才处理数据
		if(excelmap!=null && excelmap.size()==2){
			
		}
		return null;
	}
	
}
