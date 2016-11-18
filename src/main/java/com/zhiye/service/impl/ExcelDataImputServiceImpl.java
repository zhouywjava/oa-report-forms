package com.zhiye.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.zhiye.dao.OaReuirementInfoMapper;
import com.zhiye.service.IExcelDataImputService;
import com.zhiye.web.dto.ExcelDataImplDto;
import com.zhiye.web.dto.ExcelDataTotalDto;
import com.zhiye.web.dto.ResponseDto;

@Service("excelDataService")
public class ExcelDataImputServiceImpl implements IExcelDataImputService {
	
	@Autowired
	private OaReuirementInfoMapper oaReuirementInfoMapper;
	
	@Override
	@Transactional
	public ResponseDto importExcelData(List<ExcelDataImplDto> list) {		
		ResponseDto resultD=new ResponseDto();
		String msg="导入成功";
		if(list.size()==0){
			 resultD.setSuccess(false);
			 msg="导入文档为空";
		}else{
			//将数据持久化到数据库
			oaReuirementInfoMapper.insertBatch(list);
			msg="导入完成，成功导入"+list.size()+"条数据。";
		}
		resultD.setMsg(msg);
		return resultD;
		
	}

	@Override
	public List<ExcelDataTotalDto> expExcelDataTotal() {
		// TODO Auto-generated method stub
		return oaReuirementInfoMapper.expExcelDataTotal();
	}
}
