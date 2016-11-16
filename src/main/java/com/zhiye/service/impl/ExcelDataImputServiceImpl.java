package com.zhiye.service.impl;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.github.pagehelper.Page;
import com.zhiye.cache.ExecelDataManager;
import com.zhiye.common.valid.XssAndSqlUtil;
import com.zhiye.service.IExcelDataImputService;
import com.zhiye.util.common.PageQuery;
import com.zhiye.web.dto.BaseDataDto;
import com.zhiye.web.dto.ExcelDataImplDto;
import com.zhiye.web.dto.ResponseDto;

@Service("excelDataService")
public class ExcelDataImputServiceImpl implements IExcelDataImputService {
	@Override
	@Transactional
	public ResponseDto importExcelData(List<ExcelDataImplDto> list,String type) {
		//将数据List<ExcelDataImplDto>存入内存当中待处理
		Map<String, List<? extends BaseDataDto>>  exceldataMap = ExecelDataManager.getExcelMapInstance();
		exceldataMap.put(type,list);
		//返回成功
		ResponseDto resultD=new ResponseDto();
		String msg="导入成功";
		if(list.size()==0){
			 resultD.setSuccess(false);
			 msg="导入文档为空";
		}else{
			msg="导入完成，成功导入"+list.size()+"条数据。";
		}
		resultD.setMsg(msg);
		return resultD;
		
	}
}
