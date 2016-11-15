package com.zhiye.util.common;

public class PageQuery {

	public static int defaultStartPage = 1;
	public static int defaultPageSize = 10;

	private int startPage;
	private int pageSize;
	private String orderBy;

	public PageQuery() {
		super();
	}

	public PageQuery(int startPage, int pageSize) {
		super();
		this.startPage = startPage == 0 ? defaultStartPage : startPage;
		this.pageSize = pageSize == 0 ? defaultPageSize : pageSize;
	}

	public PageQuery(int startPage, int pageSize, String orderBy) {
		super();
		this.startPage = startPage == 0 ? defaultStartPage : startPage;
		this.pageSize = pageSize == 0 ? defaultPageSize : pageSize;
		this.orderBy = orderBy;
	}

	public int getStartPage() {
		return startPage;
	}

	public void setStartPage(int startPage) {
		this.startPage = startPage;
	}

	public int getPageSize() {
		return pageSize;
	}

	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}

	public String getOrderBy() {
		return orderBy;
	}

	public void setOrderBy(String orderBy) {
		this.orderBy = orderBy;
	}

}
