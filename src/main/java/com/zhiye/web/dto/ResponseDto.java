package com.zhiye.web.dto;

import java.io.Serializable;
import java.util.List;

import com.zhiye.constants.ErrorCode;

@SuppressWarnings("rawtypes")
public class ResponseDto extends BaseDataDto implements Serializable{
	private static final long serialVersionUID = 983389951099937464L;
	private boolean success = true;
	private String errorCode;
	private String msg;

	private Object data;

	private List dataList;

	public ResponseDto() {
		super();
	}

	public ResponseDto(boolean success, String errorCode, String msg) {
		super();
		this.success = success;
		this.errorCode = errorCode;
		this.msg = msg;
	}

	public ResponseDto(boolean success, ErrorCode errorCode) {
		super();
		this.success = success;
		this.errorCode = errorCode.getCode();
		this.msg = errorCode.getMsg();
	}

	public ResponseDto(boolean success, Object data) {
		super();
		this.success = success;
		this.data = data;
	}

	public ResponseDto(boolean success, List dataList) {
		super();
		this.success = success;
		this.dataList = dataList;
	}

	public boolean getSuccess() {
		return success;
	}

	public void setSuccess(boolean success) {
		this.success = success;
	}

	public String getErrorCode() {
		return errorCode;
	}

	public void setErrorCode(String errorCode) {
		this.errorCode = errorCode;
	}

	public String getMsg() {
		return msg;
	}

	public void setMsg(String msg) {
		this.msg = msg;
	}

	public Object getData() {
		return data;
	}

	public void setData(Object data) {
		this.data = data;
	}

	public List getDataList() {
		return dataList;
	}

	public void setDataList(List dataList) {
		this.dataList = dataList;
	}

}
