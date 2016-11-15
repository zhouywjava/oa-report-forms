package com.zhiye.aop;

import java.lang.annotation.*;

/**
 * 自定义注解 拦截Controller
 */

@Target({ ElementType.PARAMETER, ElementType.METHOD })
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Inherited
public @interface SysControllerLog {
	String description() default "";

}