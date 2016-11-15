package com.zhiye.aop;

import java.lang.annotation.*;

/**
 * 自定义注解 拦截service
 */

@Target({ ElementType.METHOD })
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface SysServiceLog {
	String description() default "";

}