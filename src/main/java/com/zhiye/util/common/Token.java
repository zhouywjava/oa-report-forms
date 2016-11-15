package com.zhiye.util.common;

import java.io.Serializable;

public class Token implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 7124137393812865625L;
	
	public String token;
	public long createTime;

	public Token() {
		super();
	}

	public Token(String token, long createTime) {
		super();
		this.token = token;
		this.createTime = createTime;
	}

	public Token(String token) {
		super();
		this.token = token;
	}

	public String getToken() {
		return token;
	}

	public void setToken(String token) {
		this.token = token;
	}

	public long getCreateTime() {
		return createTime;
	}

	public void setCreateTime(long createTime) {
		this.createTime = createTime;
	}
	
	@Override
	public boolean equals(Object obj) {
		return this.token.equals(obj.toString());
	}
	
	@Override
	public String toString() {
		return this.token;
	}
}
