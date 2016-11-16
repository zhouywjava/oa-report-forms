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
	private Double monthCompleteRate;
	
	@ExcelVOAttribute(name = "当月按时率", column = "E")
	private Double monthInTimeRate;

	@ExcelVOAttribute(name = "完成", column = "F")
	private Double completeNum;
	
	@ExcelVOAttribute(name = "暂缓", column = "G")
	private Double postphoneNum;
	
	@ExcelVOAttribute(name = "否决", column = "H")
	private Double rejectNum;
	
	@ExcelVOAttribute(name = "在执行", column = "I")
	private Double progressNum;
	
	@ExcelVOAttribute(name = "总数", column = "J")
	private Double total;

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

	public Double getMonthCompleteRate() {
		return monthCompleteRate;
	}

	public void setMonthCompleteRate(Double monthCompleteRate) {
		this.monthCompleteRate = monthCompleteRate;
	}

	public Double getMonthInTimeRate() {
		return monthInTimeRate;
	}

	public void setMonthInTimeRate(Double monthInTimeRate) {
		this.monthInTimeRate = monthInTimeRate;
	}

	public Double getCompleteNum() {
		return completeNum;
	}

	public void setCompleteNum(Double completeNum) {
		this.completeNum = completeNum;
	}

	public Double getPostphoneNum() {
		return postphoneNum;
	}

	public void setPostphoneNum(Double postphoneNum) {
		this.postphoneNum = postphoneNum;
	}

	public Double getRejectNum() {
		return rejectNum;
	}

	public void setRejectNum(Double rejectNum) {
		this.rejectNum = rejectNum;
	}

	public Double getProgressNum() {
		return progressNum;
	}

	public void setProgressNum(Double progressNum) {
		this.progressNum = progressNum;
	}

	public Double getTotal() {
		return total;
	}

	public void setTotal(Double total) {
		this.total = total;
	}
	
}
