package com.zhiye.aop;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.stereotype.Component;

import com.github.pagehelper.PageHelper;
import com.zhiye.util.common.PageQuery;

@Component
@Aspect
public class PageQueryAop {

	// 方法执行前调用
	@Before("execution (* com.zhiye.service.impl.*.*ByCondition*(java.util.Map, com.zhiye.util.common.PageQuery))")
	public void before(JoinPoint point) {
		Object[] args = point.getArgs();
		if (args[1] != null) {
			PageQuery pageQuery = (PageQuery) args[1];
			PageHelper.startPage(pageQuery.getStartPage(), pageQuery.getPageSize());
			PageHelper.orderBy(pageQuery.getOrderBy());
		}
	}

}
