package com.zhiye.web.controller;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import com.zhiye.aop.SysControllerLog;
import com.zhiye.common.excel.ExcelUtil;
import com.zhiye.common.secure.UUIDGenerator;
import com.zhiye.common.time.TimeUtil;
import com.zhiye.constants.Constant;
import com.zhiye.constants.ErrorCode;
import com.zhiye.service.IExcelDataImputService;
import com.zhiye.util.common.FormatHelperUtil;
import com.zhiye.web.dto.ExcelDataImplDto;
import com.zhiye.web.dto.ExcelDataTotalDto;
import com.zhiye.web.dto.ResponseDto;

@Controller
public class ExcelDataController extends BaseController {
	
	@Autowired
	private IExcelDataImputService excelDataImputService;
	
	@RequestMapping("/exceldata")
	public String hello() {
		return "index";
	}
	/**
	 * 导入Excel信息
	 * @param uploadExcel 接受前端传过来的Excel文件处理类
	 * @param type 0:按创建时间统计,1:按计划完成时间统计
	 * @return
	 */
	@RequestMapping("/exceldata/importExcelData")
	@ResponseBody
	@SysControllerLog(description="导入excel数据")
	public ResponseDto importExcelData(
			@RequestParam("uploadExcel") CommonsMultipartFile uploadExcel,
			@RequestParam("type")String type) {
        InputStream in;  
        try {  
        	//===========导入文件校验与解析 start==========
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
			ExcelUtil<ExcelDataImplDto> util = new ExcelUtil<ExcelDataImplDto>(
					ExcelDataImplDto.class);
			List<ExcelDataImplDto> list = null;
			String sheet ="Sheet1";
			if(Constant.OFFICE_EXCEL_2003_POSTFIX.equalsIgnoreCase(prefix)){
				list = util.importExcel2003(sheet, in);
			}else if(Constant.OFFICE_EXCEL_2010_POSTFIX.equalsIgnoreCase(prefix)){
				list = util.importExcel2007(sheet, in);
			}else{
				return new ResponseDto(false, ErrorCode.PARAM_ILLEGAL);
			}
			
			String error="";
			List<ExcelDataImplDto> impList = new ArrayList<ExcelDataImplDto>();
			//拆分list,过滤掉缺少的数据
			int j=0;
			int errorRow=0;
			for (int i=0;i<list.size();i++) {
				if (FormatHelperUtil.stringParse(((ExcelDataImplDto)list.get(i)).getArea()).equals("")
					|| FormatHelperUtil.stringParse(((ExcelDataImplDto)list.get(i)).getProductName()).equals("")
					|| FormatHelperUtil.stringParse(((ExcelDataImplDto)list.get(i)).getStatus()).equals("")) {
					errorRow= i+2;
					error+="未导入：第"+ errorRow +"行存在空的大区或产品名称或状态未导入\n";
				}else{
					j++;
					ExcelDataImplDto addType = (ExcelDataImplDto)list.get(i);
					addType.setDatasource(type);
					addType.setUuid(UUIDGenerator.getUUID());
					impList.add(addType);					
				}
			}
			ResponseDto responseDto = new ResponseDto(); 
			if(j==0){
				responseDto.setSuccess(false);
				responseDto.setMsg(error);
				return responseDto;
			}
			error="成功导入"+j+"条\n"+error;
			responseDto.setSuccess(true);
			responseDto.setMsg(error);
			//===========导入文件校验与解析 end==========
			//数据进一步处理
			excelDataImputService.importExcelData(impList);
			return responseDto;
        } catch (Exception e1) {  
        	//return new ResponseDto(false, ErrorCode.SYSTEM_ERROR);  
        	throw new RuntimeException(e1.getMessage());
        }  
	}
	/**
	 * 导出数据处理结果
	 * @return
	 */
	@RequestMapping("expExcelData.json")
	@ResponseBody
	public ResponseDto expExcelData(
			HttpServletRequest request,HttpServletResponse response) {
		BufferedInputStream bis = null;
        BufferedOutputStream bos = null;
		try {
			String fileName="EXCEL_"+TimeUtil.format(TimeUtil.YMDHMS, new Date());
			ByteArrayOutputStream os = new ByteArrayOutputStream();
	
			// 创建工具类
			ExcelUtil<ExcelDataTotalDto> util = new ExcelUtil<ExcelDataTotalDto>(ExcelDataTotalDto.class);
			//汇总计算
			List<ExcelDataTotalDto> list = excelDataImputService.expExcelDataTotal();
			// 导出
			util.exportExcel(list, "OA需求处理情况汇总表", os); 
	        
	        byte[] content = os.toByteArray();
	        InputStream is = new ByteArrayInputStream(content);
	        // 设置response参数，可以打开下载页面
	        response.reset();
	        response.setContentType("application/vnd.ms-excel;charset=UTF-8");
	        response.setHeader("Content-Disposition", "attachment;filename="+ new String((fileName + ".xls").getBytes("UTF-8"), "iso-8859-1"));
	        ServletOutputStream out = response.getOutputStream();
	        
            bis = new BufferedInputStream(is);
            bos = new BufferedOutputStream(out);
            byte[] buff = new byte[2048];
            int bytesRead;
            // Simple read/write loop.
            while (-1 != (bytesRead = bis.read(buff, 0, buff.length))) {
                bos.write(buff, 0, bytesRead);
            }
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseDto(false, ErrorCode.SYSTEM_ERROR);
        } finally {
            try{
            	if (bis != null)
                    bis.close();
                if (bos != null)
                    bos.close();
            }catch(Exception e){
            	e.printStackTrace();
            }
        }
		return null;
	}
	
}
