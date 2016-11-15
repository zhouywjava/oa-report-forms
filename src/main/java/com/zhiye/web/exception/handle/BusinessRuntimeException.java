package com.zhiye.web.exception.handle;

import com.zhiye.constants.ErrorCode;

public class BusinessRuntimeException extends RuntimeException {
	private static final long serialVersionUID = 2598821537752560293L;
	
	private ErrorCode errorCode;
	
    public BusinessRuntimeException() {
        super();
    }

    public BusinessRuntimeException(ErrorCode errorCode) {
    	this.errorCode = errorCode;
    }

    public BusinessRuntimeException(String message) {
    	super(message);
    }
    
    public BusinessRuntimeException(Throwable cause) {
        super(cause);
    }

    public BusinessRuntimeException(String message, Throwable cause) {
        super(message, cause);
    }

	public ErrorCode getErrorCode() {
		return errorCode;
	}

	public void setErrorCode(ErrorCode errorCode) {
		this.errorCode = errorCode;
	}
}
