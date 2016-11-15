package com.zhiye.web.dto;

import java.util.Date;
import java.util.List;

/**
 * 资源权限树DTO
 * 
 * @author Administrator
 * 
 */
public class ResourceTreeDto {

	private String id;
	private String name;
	private String authCode;
	private String parentId;
	private String type;
	
	// ADD BY LIHUI
	private String typeNo;
	private Long orderNo;
	private List<ResourceTreeDto> children;
	
	private String lastUpdateUser; // 最后更新人员
	private Date lastUpdateTime;  // 最后更新时间
    private String lastUpdateTimeStr;
	
	public Date getLastUpdateTime() {
		return lastUpdateTime;
	}

	public void setLastUpdateTime(Date lastUpdateTime) {
		this.lastUpdateTime = lastUpdateTime;
	}

	public String getLastUpdateTimeStr() {
		return lastUpdateTimeStr;
	}

	public void setLastUpdateTimeStr(String lastUpdateTimeStr) {
		this.lastUpdateTimeStr = lastUpdateTimeStr;
	}

	public String getLastUpdateUser() {
		return lastUpdateUser;
	}

	public void setLastUpdateUser(String lastUpdateUser) {
		this.lastUpdateUser = lastUpdateUser;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getAuthCode() {
		return authCode;
	}

	public void setAuthCode(String authCode) {
		this.authCode = authCode;
	}

	public String getParentId() {
		return parentId;
	}

	public void setParentId(String parentId) {
		this.parentId = parentId;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getTypeNo() {
		return typeNo;
	}

	public void setTypeNo(String typeNo) {
		this.typeNo = typeNo;
	}

	public Long getOrderNo() {
		return orderNo;
	}

	public void setOrderNo(Long orderNo) {
		this.orderNo = orderNo;
	}

	public List<ResourceTreeDto> getChildren() {
		return children;
	}

	public void setChildren(List<ResourceTreeDto> children) {
		this.children = children;
	}

}
