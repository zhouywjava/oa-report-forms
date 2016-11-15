package com.zhiye.service.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.github.pagehelper.Page;
import com.zhiye.common.time.TimeUtil;
import com.zhiye.common.valid.XssAndSqlUtil;
import com.zhiye.enums.BusinessStatusEnum;
import com.zhiye.model.DataInfo;
import com.zhiye.model.MsgKeywords;
import com.zhiye.service.IKeywordsService;
import com.zhiye.util.common.PageQuery;
import com.zhiye.web.dto.KeywordsImpDto;
import com.zhiye.web.dto.ResponseDto;

@Service("keywordsService")
public class KeywordsServiceImpl implements IKeywordsService {
	
	

	@Override
	@Transactional
	public ResponseDto importKeywords(List<KeywordsImpDto> list, DataInfo dataInfo) {
		MsgKeywords record=null;
		StringBuffer returnVal=new StringBuffer();
		
		//两个for循环，第一个校验出所有不规范的数据。if 有不规范的数据,返回错误,并提示哪些不规范,  else  第二个for循环数据插入数据库。
		for (int i=0;i<list.size();i++) {
			KeywordsImpDto keyw=list.get(i);
			
			if(StringUtils.isNotEmpty(keyw.getContent())&&keyw.getContent().length()>50){
				returnVal=returnVal.append("第").append(i+1).append("行的手机号码超出50个字符;\r\n");
			}else if(StringUtils.isNotEmpty(keyw.getContent())&&XssAndSqlUtil.cleanXSSAndSql(keyw.getContent()).length()>50){
				returnVal=returnVal.append("第").append(i+1).append("行的手机号码含有特殊字符，替换后超出50个字符;\r\n");
			}
			if(StringUtils.isNotEmpty(keyw.getReason())&&keyw.getReason().length()>200){
				returnVal=returnVal.append("第").append(i+1).append("行的黑名单事由超出200个字符;\r\n");
			}else if(StringUtils.isNotEmpty(keyw.getReason())&&XssAndSqlUtil.cleanXSSAndSql(keyw.getReason()).length()>200){
				returnVal=returnVal.append("第").append(i+1).append("行的黑名单事由含有特殊字符，替换后超出200个字符;\r\n");
			}
		}
		if(returnVal!=null&&returnVal.length()>0){
			ResponseDto obj = new ResponseDto();
			obj.setSuccess(false);
			obj.setMsg(returnVal.toString());
			return obj;
		}else{
			ArrayList<MsgKeywords> recordlist = new ArrayList<MsgKeywords>();
			for (KeywordsImpDto k : list) {
				record = new MsgKeywords();
				if(StringUtils.isNotEmpty(k.getContent())){
					record.setKwContent(XssAndSqlUtil.cleanXSSAndSql(k.getContent()));
				}
				if(StringUtils.isNotEmpty(k.getReason())){
					record.setKwReason(XssAndSqlUtil.cleanXSSAndSql(k.getReason()));
				}
				//record.setKwId(UUIDGenerator.getUUID());
				record.setKwCreater(1);
				record.setKwStatus(BusinessStatusEnum.ENABLE.getStatus());
				record.setKwModify(1);
				record.setKwCretime(TimeUtil.getNow());
				record.setKwModtime(TimeUtil.getNow());
				recordlist.add(record);
			}
			
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
	public int disableKeywords(String rowId, Integer user, Date datetime) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int addKeywords(String content, String reason, Integer user, Date datetime) {
		// TODO Auto-generated method stub
		return 0;
	}
}
