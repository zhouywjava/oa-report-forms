package com.zhiye.dao;

import java.util.List;

import com.zhiye.model.OaReuirementInfo;
import com.zhiye.web.dto.ExcelDataImplDto;
import com.zhiye.web.dto.ExcelDataTotalDto;

public interface OaReuirementInfoMapper {
    int deleteByPrimaryKey(String oriUuid);

    int insert(OaReuirementInfo record);

    int insertSelective(OaReuirementInfo record);

    OaReuirementInfo selectByPrimaryKey(String oriUuid);

    int updateByPrimaryKeySelective(OaReuirementInfo record);

    int updateByPrimaryKey(OaReuirementInfo record);
    
    int insertBatch(List<ExcelDataImplDto> recordlist);
    
    List<ExcelDataTotalDto> expExcelDataTotal();
}