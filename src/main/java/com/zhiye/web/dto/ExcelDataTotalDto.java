package com.zhiye.web.dto;

import com.zhiye.common.excel.ExcelVOAttribute;
/**
 * 
 * <p>标题: Excel导出数据生成Dto(汇总)</p>
 * <p>描述: </p>
 * <p>版权: Copyright (c) 2016</p>
 * <p>公司: 智业软件股份有限公司</p>
 *
 * @version: 1.0
 * @author: zhouyw
 */
public class ExcelDataTotalDto extends BaseDataDto{

	@ExcelVOAttribute(name = "序号", column = "A")
	private String id;
	
	@ExcelVOAttribute(name = "大区", column = "B")
	private String area;
	
	@ExcelVOAttribute(name = "对象", column = "C")
	private String object;
	
	@ExcelVOAttribute(name = "当月完成率", column = "D")
	private String monthCompleteRate;
	
	@ExcelVOAttribute(name = "当月按时率", column = "E")
	private String monthOnTimeRate;

	@ExcelVOAttribute(name = "完成", column = "F")
	private String completeNum;
	
	@ExcelVOAttribute(name = "暂缓", column = "G")
	private String postphoneNum;
	
	@ExcelVOAttribute(name = "否决", column = "H")
	private String rejectNum;
	
	@ExcelVOAttribute(name = "在执行", column = "I")
	private String progressNum;
	
	@ExcelVOAttribute(name = "总数", column = "J")
	private String total;
	
	private String ontimeNum;//按时完成数
	
	private String ontimeTotal;//技术类按时率不能按照上面的总数，得重新计算

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getArea() {
		return area;
	}

	public void setArea(String area) {
		this.area = area;
	}

	public String getObject() {
		return object;
	}

	public void setObject(String object) {
		this.object = object;
	}

	public String getMonthCompleteRate() {
		return monthCompleteRate;
	}

	public void setMonthCompleteRate(String monthCompleteRate) {
		this.monthCompleteRate = monthCompleteRate;
	}

	public String getMonthOnTimeRate() {
		return monthOnTimeRate;
	}

	public void setMonthOnTimeRate(String monthOnTimeRate) {
		this.monthOnTimeRate = monthOnTimeRate;
	}

	public String getCompleteNum() {
		return completeNum;
	}

	public void setCompleteNum(String completeNum) {
		this.completeNum = completeNum;
	}

	public String getPostphoneNum() {
		return postphoneNum;
	}

	public void setPostphoneNum(String postphoneNum) {
		this.postphoneNum = postphoneNum;
	}

	public String getRejectNum() {
		return rejectNum;
	}

	public void setRejectNum(String rejectNum) {
		this.rejectNum = rejectNum;
	}

	public String getProgressNum() {
		return progressNum;
	}

	public void setProgressNum(String progressNum) {
		this.progressNum = progressNum;
	}

	public String getTotal() {
		return total;
	}

	public void setTotal(String total) {
		this.total = total;
	}

	public String getOntimeNum() {
		return ontimeNum;
	}

	public void setOntimeNum(String ontimeNum) {
		this.ontimeNum = ontimeNum;
	}

	public String getOntimeTotal() {
		return ontimeTotal;
	}

	public void setOntimeTotal(String ontimeTotal) {
		this.ontimeTotal = ontimeTotal;
	}
	
}
