package com.zhiye.service;

import java.util.Date;
import java.util.List;
import java.util.Map;

import com.github.pagehelper.Page;
import com.zhiye.model.DataInfo;
import com.zhiye.util.common.PageQuery;
import com.zhiye.web.dto.KeywordsImpDto;
import com.zhiye.web.dto.ResponseDto;

public interface IKeywordsService {

	Page<Map<String, Object>> queryByCondition(Map<String, Object> condition);

	Page<Map<String, Object>> queryByCondition(Map<String, Object> condition,
			PageQuery pageQuery);

	int disableKeywords(String rowId, Integer user, Date datetime);

	int addKeywords(String content, String reason, Integer user, Date datetime);

	ResponseDto importKeywords(List<KeywordsImpDto> list, DataInfo dataInfo);

}
