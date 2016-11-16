package com.zhiye.web.dto;

import com.zhiye.common.excel.ExcelVOAttribute;
/**
 * 
 * <p>标题: Excel导出数据生成Dto(按产品分)</p>
 * <p>描述: </p>
 * <p>版权: Copyright (c) 2016</p>
 * <p>公司: 智业软件股份有限公司</p>
 *
 * @version: 1.0
 * @author: zhouyw
 */
public class ExcelDataByProductDto extends BaseDataDto{

	@ExcelVOAttribute(name = "需求号", column = "A")
	private String id;
	
	@ExcelVOAttribute(name = "阶段", column = "B")
	private String stage;
	
	@ExcelVOAttribute(name = "需求类别", column = "C")
	private String type;
	
	@ExcelVOAttribute(name = "产品名称", column = "D")
	private String productName;
	
	@ExcelVOAttribute(name = "客户名称", column = "E")
	private String cusName;
	
	@ExcelVOAttribute(name = "标题", column = "F")
	private String title;
	
	@ExcelVOAttribute(name = "关键字", column = "G")
	private String keyWord;
	
	@ExcelVOAttribute(name = "问题描述", column = "H")
	private String describe;
	
	@ExcelVOAttribute(name = "需求建议", column = "I")
	private String advice;
	
	@ExcelVOAttribute(name = "优先等级", column = "J")
	private String priority;
	
	@ExcelVOAttribute(name = "优先备注", column = "K")
	private String priorityMemo;
	
	@ExcelVOAttribute(name = "提交人", column = "L")
	private String creater;
	
	@ExcelVOAttribute(name = "提交时间", column = "M")
	private String createrTime;
	
	@ExcelVOAttribute(name = "提交部门", column = "N")
	private String createDept;
	
	@ExcelVOAttribute(name = "项目组", column = "O")
	private String projectTeam;
	
	@ExcelVOAttribute(name = "状态", column = "P")
	private String status;
	
	@ExcelVOAttribute(name = "处理人", column = "Q")
	private String handler;
	
	@ExcelVOAttribute(name = "解决人", column = "R")
	private String sovler;
	
	@ExcelVOAttribute(name = "发布人", column = "S")
	private String publisher;
	
	@ExcelVOAttribute(name = "发布时间", column = "T")
	private String publishTime;
	
	@ExcelVOAttribute(name = "计划完成时间", column = "U")
	private String planEndTime;
	
	@ExcelVOAttribute(name = "最迟完成时间", column = "V")
	private String laterEndTime;
	
	@ExcelVOAttribute(name = "实际完成时间", column = "W")
	private String realEndTime;
	
	@ExcelVOAttribute(name = "最近处理", column = "X")
	private String handleTime;
	
	@ExcelVOAttribute(name = "需求进度", column = "Y")
	private String schedule;
	
	@ExcelVOAttribute(name = "实际完成状态", column = "Z")
	private String rcStatus;
	
	@ExcelVOAttribute(name = "大区", column = "AA")
	private String area;
	
 

	public String getId() {
		return id;
	}



	public void setId(String id) {
		this.id = id;
	}



	public String getStage() {
		return stage;
	}



	public void setStage(String stage) {
		this.stage = stage;
	}



	public String getType() {
		return type;
	}



	public void setType(String type) {
		this.type = type;
	}



	public String getProductName() {
		return productName;
	}



	public void setProductName(String productName) {
		this.productName = productName;
	}



	public String getCusName() {
		return cusName;
	}



	public void setCusName(String cusName) {
		this.cusName = cusName;
	}



	public String getTitle() {
		return title;
	}



	public void setTitle(String title) {
		this.title = title;
	}



	public String getKeyWord() {
		return keyWord;
	}



	public void setKeyWord(String keyWord) {
		this.keyWord = keyWord;
	}



	public String getDescribe() {
		return describe;
	}



	public void setDescribe(String describe) {
		this.describe = describe;
	}



	public String getAdvice() {
		return advice;
	}



	public void setAdvice(String advice) {
		this.advice = advice;
	}



	public String getPriority() {
		return priority;
	}



	public void setPriority(String priority) {
		this.priority = priority;
	}



	public String getPriorityMemo() {
		return priorityMemo;
	}



	public void setPriorityMemo(String priorityMemo) {
		this.priorityMemo = priorityMemo;
	}



	public String getCreater() {
		return creater;
	}



	public void setCreater(String creater) {
		this.creater = creater;
	}



	public String getCreaterTime() {
		return createrTime;
	}



	public void setCreaterTime(String createrTime) {
		this.createrTime = createrTime;
	}



	public String getCreateDept() {
		return createDept;
	}



	public void setCreateDept(String createDept) {
		this.createDept = createDept;
	}



	public String getProjectTeam() {
		return projectTeam;
	}



	public void setProjectTeam(String projectTeam) {
		this.projectTeam = projectTeam;
	}



	public String getStatus() {
		return status;
	}



	public void setStatus(String status) {
		this.status = status;
	}



	public String getHandler() {
		return handler;
	}



	public void setHandler(String handler) {
		this.handler = handler;
	}



	public String getSovler() {
		return sovler;
	}



	public void setSovler(String sovler) {
		this.sovler = sovler;
	}



	public String getPublisher() {
		return publisher;
	}



	public void setPublisher(String publisher) {
		this.publisher = publisher;
	}



	public String getPublishTime() {
		return publishTime;
	}



	public void setPublishTime(String publishTime) {
		this.publishTime = publishTime;
	}



	public String getPlanEndTime() {
		return planEndTime;
	}



	public void setPlanEndTime(String planEndTime) {
		this.planEndTime = planEndTime;
	}



	public String getLaterEndTime() {
		return laterEndTime;
	}



	public void setLaterEndTime(String laterEndTime) {
		this.laterEndTime = laterEndTime;
	}



	public String getRealEndTime() {
		return realEndTime;
	}



	public void setRealEndTime(String realEndTime) {
		this.realEndTime = realEndTime;
	}



	public String getHandleTime() {
		return handleTime;
	}



	public void setHandleTime(String handleTime) {
		this.handleTime = handleTime;
	}



	public String getSchedule() {
		return schedule;
	}



	public void setSchedule(String schedule) {
		this.schedule = schedule;
	}



	public String getRcStatus() {
		return rcStatus;
	}



	public void setRcStatus(String rcStatus) {
		this.rcStatus = rcStatus;
	}



	public String getArea() {
		return area;
	}



	public void setArea(String area) {
		this.area = area;
	}



	@Override
	public String toString() {
		return "ExcelDataExcle [id=" + id
				+ ", stage=" + stage + ", toString()=" + super.toString() + "]";
	}

}
