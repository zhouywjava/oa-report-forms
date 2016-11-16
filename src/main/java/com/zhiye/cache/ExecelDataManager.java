package com.zhiye.cache;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.zhiye.web.dto.BaseDataDto;
/**
 * 
 * <p>标题: 导入数据管理器</p>
 * <p>描述: 用于在内存中存放导入的数据</p>
 * <p>版权: Copyright (c) 2016</p>
 * <p>公司: 智业软件股份有限公司</p>
 *
 * @version: 1.0
 * @author: zyw
 */
public class ExecelDataManager {
	
	private ExecelDataManager(){};
	
	private static class ExecelDataManagerHolder{
		private static Map<String,List<? extends BaseDataDto >> excelmap = new HashMap<String,List<? extends BaseDataDto >>();
	    private static void cleanMap(){
	    	ExecelDataManagerHolder.excelmap.clear();
	    }
	}
    /**
     * 采用单例模式获取ExcelMap的实例，用于在内存当中保持导入的Excel数据表
     * @param String tag(0:按创建时间导入的数据，1:按计划完成时间导入的数据)
     * @param List 导入Excel得到数据
     * @return 一个单例
     */
	public static Map<String,List<? extends BaseDataDto >> getExcelMapInstance(){
		return ExecelDataManagerHolder.excelmap;
	}
	
	/**
	 * 清空Map
	 */
	public static void cleanMap(){
		ExecelDataManagerHolder.cleanMap();
	}
}
