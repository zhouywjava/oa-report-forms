package com.zhiye.web.controller;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.github.pagehelper.Page;
import com.zhiye.aop.SysControllerLog;
import com.zhiye.common.time.TimeUtil;
import com.zhiye.enums.BusinessStatusEnum;
import com.zhiye.enums.BusinessTypeEnum;
import com.zhiye.service.IChannelManageService;
import com.zhiye.util.common.FormatHelperUtil;
import com.zhiye.util.common.PageQuery;
import com.zhiye.web.dto.ListResponseDto;
import com.zhiye.web.dto.ResponseDto;

@Controller
public class ChannelManageController extends BaseController {

	@Autowired
	private IChannelManageService channelManageService;
	
	/**静态变量*/
	private static Map<String, String> accSpMap;

	@RequestMapping("/system/channel")
	@RequiresPermissions(value = "system:channel:view")
	public String channellist(ModelMap model) {
		
		return "system/channelManage";
	}

	@RequestMapping("/system/channelPage.json")
	@RequiresPermissions(value = "system:channel:view")
	@ResponseBody
	public ListResponseDto channelPage(
			@RequestParam(value = "SPSupplier", required = false) String SPSupplier,
			@RequestParam(value = "SPAccNo", required = true) String SPAccNo,
			@RequestParam(value = "channelType", required = true) String channelType,
			@RequestParam(value = "status", required = true) String status,
			@RequestParam(value = "page", required = true) int startPage,
			@RequestParam(value = "rows", required = true) int pageSize) {
		/** 组合查询条件 */
		Map<String, Object> condition = new HashMap<String, Object>();
		condition.put("SPSupplier", SPSupplier);
		condition.put("SPAccNo", SPAccNo);
		condition.put("channelType", channelType);
		condition.put("status", status);

		Page<Map<String, Object>> page = channelManageService.queryByCondition(
				condition, new PageQuery(startPage, pageSize));

		Map<String, String> businessType = BusinessTypeEnum.toMap();
		Map<String, String> channelManageStatus = BusinessStatusEnum
				.toMap();
		/** page的翻译 */
		for (Map<String, Object> m : page) {
			m.put("channelType", businessType.get(m.get("channelType")));
			m.put("channelStatus",
					channelManageStatus.get(m.get("channelStatus")));
			m.put("creTime",
					TimeUtil.format(TimeUtil.YMD_HMS, (Date) m.get("creTime")));
			if(m.get("modTime") != null){
			m.put("modTime",
					TimeUtil.format(TimeUtil.YMD_HMS, (Date) m.get("modTime")));
			}
		}

		return new ListResponseDto(page.getTotal(), page.getResult());
	}
	@RequestMapping("/system/channel/enable")
	@RequiresPermissions(value = "system:channel:enable")
	@ResponseBody
	@SysControllerLog(description="启用通道信息")
	public ResponseDto enableChannel(
			@RequestParam(value = "channelId", required = true) String channelId) {
		ResponseDto responseDto = new ResponseDto();
		
		try {
			channelManageService.enableChannel(channelId, "01", TimeUtil.getNow());
		}catch (Exception e) {
			responseDto.setSuccess(false);
			responseDto.setMsg(e.getMessage());
			return responseDto;
		}
		return responseDto;
	}

	@RequestMapping("/system/channel/disable")
	@RequiresPermissions(value = "system:channel:disable")
	@ResponseBody
	@SysControllerLog(description="停用通道信息")
	public ResponseDto disableChannel(
			@RequestParam(value = "channelId", required = true) String channelId) {
		ResponseDto responseDto = new ResponseDto();
		
		try {
			channelManageService.disableChannel(channelId, FormatHelperUtil.stringParse("01"), TimeUtil.getNow());
		}catch (Exception e) {
			responseDto.setSuccess(false);
			responseDto.setMsg(e.getMessage());
			return responseDto;
		}

		return responseDto;
	}
	
}
