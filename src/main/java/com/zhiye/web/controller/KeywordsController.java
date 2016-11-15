package com.zhiye.web.controller;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import com.zhiye.aop.SysControllerLog;
import com.zhiye.common.excel.ExcelUtil;
import com.zhiye.constants.Constant;
import com.zhiye.constants.ErrorCode;
import com.zhiye.enums.BusinessStatusEnum;
import com.zhiye.model.DataInfo;
import com.zhiye.service.IKeywordsService;
import com.zhiye.util.common.FormatHelperUtil;
import com.zhiye.web.dto.KeywordsImpDto;
import com.zhiye.web.dto.ResponseDto;

@Controller
public class KeywordsController extends BaseController {
	
	@Autowired
	private IKeywordsService keywordsService;
	
	@RequestMapping("/hello")
	public String hello() {
		return "index";
	}
	/**
	 * 导入关键字信息
	 * @param uploadExcel
	 * @return
	 */
	@RequestMapping("/business/keywords/importKeywords")
	@ResponseBody
	@SysControllerLog(description="导入关键字信息")
	public ResponseDto importKeywords(
			@RequestParam("uploadExcel") CommonsMultipartFile uploadExcel) {
        InputStream in;  
        try {  
        	if(uploadExcel.getSize()>1048576){
        		ResponseDto obj = new ResponseDto();
    			obj.setSuccess(false);
    			obj.setMsg("导入文件过大,不能超过1M");
    			return obj;
        	}
            // 获取前台exce的输入流  
            in = uploadExcel.getInputStream();  
            String fileName=uploadExcel.getOriginalFilename();
            String prefix=fileName.substring(fileName.lastIndexOf(".")+1);
			ExcelUtil<KeywordsImpDto> util = new ExcelUtil<KeywordsImpDto>(
					KeywordsImpDto.class);
			List<KeywordsImpDto> list = null;
			String sheet ="关键字";
			if(Constant.OFFICE_EXCEL_2003_POSTFIX.equalsIgnoreCase(prefix)){
				list = util.importExcel2003(sheet, in);
			}else if(Constant.OFFICE_EXCEL_2010_POSTFIX.equalsIgnoreCase(prefix)){
				list = util.importExcel2007(sheet, in);
			}else{
				return new ResponseDto(false, ErrorCode.PARAM_ILLEGAL);
			}
			
			String error="";
			List<KeywordsImpDto> impList = new ArrayList<KeywordsImpDto>();
			//拆分list
			int j=0;
			int errorRow=0;
			for (int i=0;i<list.size();i++) {
				if (FormatHelperUtil.stringParse(((KeywordsImpDto)list.get(i)).getContent()).equals("")
						|| FormatHelperUtil.stringParse(((KeywordsImpDto)list.get(i)).getReason()).equals("")) {
					errorRow= i+2;
					error+="未导入：第"+ errorRow +"行存在空的关键字或关键字事由 未导入\n";
				}else{
					j++;
					impList.add(((KeywordsImpDto)list.get(i)));
				}
			}
			DataInfo dataInfo = new DataInfo();
			ResponseDto responseDto=keywordsService.importKeywords(impList, dataInfo);
			error="成功导入"+j+"条\n"+error;
			responseDto.setSuccess(true);
			responseDto.setMsg(error);
			return responseDto;
        } catch (Exception e1) {  
        	return new ResponseDto(false, ErrorCode.SYSTEM_ERROR);  
        }  
	}

}
