package com.zhiye.web.exception.handle;

import com.zhiye.constants.ErrorCode;

/**
 * 业务数据校验异常
 * @author linh
 * @date 2015/11/05
 */
public class ValidateRuntimeException extends RuntimeException {
	private static final long serialVersionUID = -4717908008350919810L;
	private ErrorCode errorCode;
	
    public ValidateRuntimeException() {
        super();
    }

    public ValidateRuntimeException(ErrorCode errorCode) {
    	this.errorCode = errorCode;
    }

    public ValidateRuntimeException(String message) {
    	super(message);
    }
    
    public ValidateRuntimeException(Throwable cause) {
        super(cause);
    }

    public ValidateRuntimeException(String message, Throwable cause) {
        super(message, cause);
    }

	public ErrorCode getErrorCode() {
		return errorCode;
	}

	public void setErrorCode(ErrorCode errorCode) {
		this.errorCode = errorCode;
	}
}
