package com.zhiye.web.dto;

import com.zhiye.common.excel.ExcelVOAttribute;

public class KeywordsImpDto {

	@ExcelVOAttribute(name = "关键字", column = "A")
	private String content;

	@ExcelVOAttribute(name = "关键字事由", column = "B")
	private String reason;

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getReason() {
		return reason;
	}

	public void setReason(String reason) {
		this.reason = reason;
	}

	@Override
	public String toString() {
		return "KeywordsExcle [content=" + content
				+ ", reason=" + reason + ", toString()=" + super.toString() + "]";
	}

}
