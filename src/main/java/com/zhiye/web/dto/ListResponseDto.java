package com.zhiye.web.dto;

import java.util.List;

@SuppressWarnings("rawtypes")
public class ListResponseDto extends BaseDataDto {

	private long total;

	private List rows;

	public ListResponseDto() {
		super();
	}

	public ListResponseDto(long total, List rows) {
		super();
		this.total = total;
		this.rows = rows;
	}

	public long getTotal() {
		return total;
	}

	public void setTotal(long total) {
		this.total = total;
	}

	public List getRows() {
		return rows;
	}

	public void setRows(List rows) {
		this.rows = rows;
	}

}
