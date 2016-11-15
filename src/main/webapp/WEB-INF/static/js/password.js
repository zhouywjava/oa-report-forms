var PGEdit_IE32_CLASSID="3A2C8BC3-5B68-4AE5-81D6-6DC378708F3E";
var PGEdit_IE32_CAB="PassGuardCtrl.cab#version=1,0,1,8";
var PGEdit_IE32_EXE="PassGuardSetupIE.exe";

var PGEdit_IE64_CLASSID="206F48A0-61BB-48C8-B54C-7700B7923CFD";
var PGEdit_IE64_CAB="PassGuardX64.cab#version=1,0,1,2";
var PGEdit_IE64_EXE="PassGuardSetupX64.exe";

var PGEdit_FF="PassGuardSetupFF.exe";
var PGEdit_FF_VERSION="3.0.0.7";


var PGEdit_Update="0";//非IE控件是否强制升级 1强制升级,0不强制升级

if(navigator.userAgent.indexOf("MSIE")<0){
	   navigator.plugins.refresh();
}

;(function($) {
	$.pge = function (options) {
		this.settings = $.extend(true, {}, $.pge.defaults, options);
		this.init();
	};

	$.extend($.pge, {
		defaults: {
			pgePath: "./ocx/",
			pgeId: "",
			pgeEdittype: 0,
			pgeEreg1: "",
			pgeEreg2: "",
			pgeMaxlength: 12,
			pgeTabindex: 2,
			pgeClass: "ocx_style",
			pgeInstallClass: "ocx_style",
			pgeOnkeydown:"",
			pgeFontName:"",
			pgeFontSize:"",
			tabCallback:"",
			pgeBackColor:"",
			pgeForeColor:""
		},

		prototype: {
			init: function() {				
			    this.pgeDownText="请点此安装控件";
			    this.osBrowser = this.checkOsBrowser();
				this.pgeVersion = this.getVersion();			    			
				this.isInstalled = this.checkInstall();
			},

			checkOsBrowser: function() {
				var userosbrowser;
				if((navigator.platform =="Win32") || (navigator.platform =="Windows")){
					if(navigator.userAgent.indexOf("MSIE")>0 || navigator.userAgent.indexOf("msie")>0 || navigator.userAgent.indexOf("Trident")>0 || navigator.userAgent.indexOf("trident")>0){
						if(navigator.userAgent.indexOf("ARM")>0){
							userosbrowser=9; //win8 RAM Touch
							this.pgeditIEExe="";
						}else{
							userosbrowser=1;//windows32ie32
							this.pgeditIEClassid=PGEdit_IE32_CLASSID;
							this.pgeditIECab=PGEdit_IE32_CAB;
							this.pgeditIEExe=PGEdit_IE32_EXE;
						}
					}else{
						userosbrowser=2; //windowsff
						this.pgeditFFExe=PGEdit_FF;
					}
				}else if((navigator.platform=="Win64")){
					if(navigator.userAgent.indexOf("Windows NT 6.2")>0 || navigator.userAgent.indexOf("windows nt 6.2")>0){		
						userosbrowser=1;//windows32ie32
						this.pgeditIEClassid=PGEdit_IE32_CLASSID;
						this.pgeditIECab=PGEdit_IE32_CAB;
						this.pgeditIEExe=PGEdit_IE32_EXE;						
					}else if(navigator.userAgent.indexOf("MSIE")>0 || navigator.userAgent.indexOf("msie")>0 || navigator.userAgent.indexOf("Trident")>0 || navigator.userAgent.indexOf("trident")>0){
						userosbrowser=3;//windows64ie64
						this.pgeditIEClassid=PGEdit_IE64_CLASSID;
						this.pgeditIECab=PGEdit_IE64_CAB;
						this.pgeditIEExe=PGEdit_IE64_EXE;			
					}else{
						userosbrowser=2;//windowsff
						this.pgeditFFExe=PGEdit_FF;
					}
				}
				return userosbrowser;
			},
			
			getpgeHtml: function() {
				if (this.osBrowser==1 || this.osBrowser==3) {

					var pgeOcx= '<span id="'+this.settings.pgeId+'_pge" style="display:none;"><OBJECT ID="' + this.settings.pgeId + '" CLASSID="CLSID:' + this.pgeditIEClassid + '" ' 
					         
					        +'codebase="'+this.settings.pgePath+ this.pgeditIECab+'" onkeydown="if(13==event.keyCode || 27==event.keyCode)'+this.settings.pgeOnkeydown+';" onfocus="' + this.settings.pgeOnfocus + '" tabindex="'+this.settings.pgeTabindex+'" class="' + this.settings.pgeClass + '">' 
					        
					        + '<param name="edittype" value="'+ this.settings.pgeEdittype + '"><param name="maxlength" value="' + this.settings.pgeMaxlength +'">' 

							+ '<param name="input2" value="'+ this.settings.pgeEreg1 + '"><param name="input3" value="'+ this.settings.pgeEreg2 + '">';
							
							if(this.settings.pgeFontName!=undefined && this.settings.pgeFontName!="") pgeOcx+= '<param name="FontName" value="'+ this.settings.pgeFontName + '">' 
					        
							if(this.settings.pgeFontSize!=undefined && this.settings.pgeFontSize!="") pgeOcx+= '<param name="FontSize" value="'+ this.settings.pgeFontSize + '">' 
					        
					        pgeOcx+= '</OBJECT></span>';
							
							pgeOcx+= '<div id="'+this.settings.pgeId+'_down" class="'+this.settings.pgeInstallClass+'" style="text-align:center;display:none;"><a href="'+this.settings.pgePath+this.pgeditIEExe+'">'+this.pgeDownText+'</a></div>';

							return pgeOcx;
							
				} else if (this.osBrowser==2) {
					
					var pgeOcx='<embed ID="' + this.settings.pgeId + '" input_10="false" maxlength="'+this.settings.pgeMaxlength+'" input_2="'+this.settings.pgeEreg1+'" input_3="'+this.settings.pgeEreg2+'" edittype="'+this.settings.pgeEdittype+'" type="application/x-pass-guard" tabindex="'+this.settings.pgeTabindex+'" class="' + this.settings.pgeClass + '" ';
					
					if(this.settings.pgeOnkeydown!=undefined && this.settings.pgeOnkeydown!="") pgeOcx+=' input_1013="'+this.settings.pgeOnkeydown+'"';
					
					if(this.settings.tabCallback!=undefined && this.settings.tabCallback!="") pgeOcx+=' input_1009="document.getElementById(\''+this.settings.tabCallback+'\').focus()"';
					
					if(this.settings.pgeFontName!=undefined && this.settings.pgeFontName!="") pgeOcx+=' FontName="'+this.settings.pgeFontName+'"';
					
					if(this.settings.pgeFontSize!=undefined && this.settings.pgeFontSize!="") pgeOcx+=' FontSize='+Number(this.settings.pgeFontSize)+'';	
							
					pgeOcx+=' >';
					
					return pgeOcx;

				} else {

					return '<div id="'+this.settings.pgeId+'_down" class="'+this.settings.pgeInstallClass+'" style="text-align:center;">暂不支持此浏览器</div>';

				}				
			},
			
			getDownHtml: function() {
				if (this.osBrowser==1 || this.osBrowser==3) {
					return '<div id="'+this.settings.pgeId+'_down" class="'+this.settings.pgeInstallClass+'" style="text-align:center;"><a href="'+this.settings.pgePath+this.pgeditIEExe+'">'+this.pgeDownText+'</a></div>';
				} else if (this.osBrowser==2) {

					return '<div id="'+this.settings.pgeId+'_down" class="'+this.settings.pgeInstallClass+'" style="text-align:center;"><a href="'+this.settings.pgePath+this.pgeditFFExe+'">'+this.pgeDownText+'</a></div>';
				
				} else {

					return '<div id="'+this.settings.pgeId+'_down" class="'+this.settings.pgeInstallClass+'" style="text-align:center;">暂不支持此浏览器</div>';

				}				
			},
			
			load: function() {				
				if (!this.checkInstall()) {
					return this.getDownHtml();
				}else{		
				   if(this.osBrowser==2){  
						if(this.pgeVersion!=PGEdit_FF_VERSION && PGEdit_Update==1){
							this.setDownText();
							return this.getDownHtml();	
						}				    
				   }				
					return this.getpgeHtml();
				}
			},
			
			generate: function() {

				   if(this.osBrowser==2){
					   if(this.isInstalled==false){
						   return document.write(this.getDownHtml());	 
					   }else if(this.pgeVersion!=PGEdit_FF_VERSION && PGEdit_Update==1){
							this.setDownText();
							return document.write(this.getDownHtml());	
						}
			       }
					return document.write(this.getpgeHtml());				
			},
			
			pwdclear: function() {
				if (this.checkInstall()) {
					var control = document.getElementById(this.settings.pgeId);
					control.value = "";
					try{
					control.ClearSeCtrl();
					}catch(err){}
				}				
			},
			pwdSetSk: function(s) {
				if (this.checkInstall()) {
					try {
						var control = document.getElementById(this.settings.pgeId);
						if (this.osBrowser==1 || this.osBrowser==3) {
							control.input1=s;
						} else if (this.osBrowser==2) {
							control.input(1,s);
						}					
					} catch (err) {
					}
				}				
			},
			
			pwdResultHash: function() {

				var code = '';

				if (!this.checkInstall()) {

					code = '';
				}
				else{	
					try {
						var control = document.getElementById(this.settings.pgeId);
						if (this.osBrowser==1 || this.osBrowser==3) {
							code = control.output;
						} else if (this.osBrowser==2) {
							//control.setinput(10, false);
							control.package=5;
							
							code = control.output(7);
						}				
					} catch (err) {
						code = '';
					}
				}
				return code;
			},
			
			pwdResult: function() {

				var code = '';

				if (!this.checkInstall()) {

					code = '';
				}
				else{	
					try {
						var control = document.getElementById(this.settings.pgeId);
						if (this.osBrowser==1 || this.osBrowser==3) {
							code = control.output1;
						} else if (this.osBrowser==2) {
							code = control.output(7);
						}				
					} catch (err) {
						code = '';
					}
				}
				return code;
			},
			
			machineNetwork: function() {
				var code = '';

				if (!this.checkInstall()) {

					code = '';
				}
				else{
					try {
						var control = document.getElementById(this.settings.pgeId);
						if (this.osBrowser==1 || this.osBrowser==3) {
							code = control.GetIPMacList();
						} else if (this.osBrowser==2) {
							control.package=0;
							code = control.output(9);
						}
					} catch (err) {

						code = '';

					}
				}
				return code;
			},
			machineDisk: function() {
				var code = '';

				if (!this.checkInstall()) {

					code = '';
				}
				else{
					try {
						var control = document.getElementById(this.settings.pgeId);
						if (this.osBrowser==1 || this.osBrowser==3) {
							code = control.GetNicPhAddr(1);
						} else if (this.osBrowser==2) {
							control.package=0;
							code = control.output(11);
						}
					} catch (err) {

						code = '';

					}
				}
				return code;
			},
			machineCPU: function() {
				var code = '';

				if (!this.checkInstall()) {

					code = '';
				}
				else{
					try {
						var control = document.getElementById(this.settings.pgeId);
						if (this.osBrowser==1 || this.osBrowser==3) {
							code = control.GetNicPhAddr(2);
						} else if (this.osBrowser==2) {
							control.package=0;
							code = control.output(10);
						}
					} catch (err) {
						code = '';
					}
				}
				return code;
			},
			pwdSimple: function() {
				var code = '';

				if (!this.checkInstall()) {

					code = '';
				}
				else{
					try {
						var control = document.getElementById(this.settings.pgeId);
						if (this.osBrowser==1 || this.osBrowser==3) {
							code = control.output44;
						} else if (this.osBrowser==2) {
							code = control.output(13);
						}
					} catch (err) {
						code = '';
					}
				}
				return code;
			},			
			pwdValid: function() {
				var code = '';

				if (!this.checkInstall()) {

					code = 1;
				}
				else{
					try {
						var control = document.getElementById(this.settings.pgeId);
						if (this.osBrowser==1 || this.osBrowser==3) {
							if(control.output1) code = control.output5;
						} else if (this.osBrowser==2) {
							code = control.output(5);
						}
					} catch (err) {

						code = 1;

					}
				}
				return code;
			},				
			pwdHash: function() {
				var code = '';

				if (!this.checkInstall()) {

					code = 0;
				}
				else{
					try {
						var control = document.getElementById(this.settings.pgeId);
						if (this.osBrowser==1 || this.osBrowser==3) {
							code = control.output2;
						} else if (this.osBrowser==2) {
							code = control.output(2);
						}
					} catch (err) {

						code = 0;

					}
				}
				return code;
			},			
			pwdLength: function() {
				var code = '';

				if (!this.checkInstall()) {

					code = 0;
				}
				else{
					try {
						var control = document.getElementById(this.settings.pgeId);
						if (this.osBrowser==1 || this.osBrowser==3) {
							code = control.output3;
						} else if (this.osBrowser==2) {
							code = control.output(3);
						}
					} catch (err) {

						code = 0;

					}
				}
				return code;
			},				
			pwdStrength: function() {
				var code = 0;

				if (!this.checkInstall()) {

					code = 0;

				}

				else{

					try {

						var control = document.getElementById(this.settings.pgeId);

						if (this.osBrowser==1 || this.osBrowser==3) {
							var l=control.output3;
							var n=control.output4;
						} else if (this.osBrowser==2) {
							var l=control.output(3);
							var n=control.output(4);
						}

						if(l==0){
							code = 0;
						}else if(n==1 || l<7){
							code = 1;//弱
						}else if(n==2 && l>=6){
							code = 2;//中
						}else if(n==3 && l>=6){
							code = 3;//强
						}

					} catch (err) {

						code = 0;

					}

				}		
				return code;
								
			},	
			checkInstall: function() {
				try {
					if (this.osBrowser==1) {

						var comActiveX = new ActiveXObject("PassGuardCtrl.PassGuard.1"); 
						
					} else if (this.osBrowser==2) {

					    var arr=new Array();
					    var pge_info=navigator.plugins['PassGuard'].description;
					    
						if(pge_info.indexOf(":")>0){
							arr=pge_info.split(":");
							var pge_version = arr[1];
						}else{
							var pge_version = "";
						}
						
					} else if (this.osBrowser==3) {
						var comActiveX = new ActiveXObject("PassGuardX64.PassGuard.1");
					}else{
					   return false;
					}
				}catch(e){
					return false;
				}
				return true;
			},
			getVersion: function() {
				try {
					if(this.osBrowser==1 || this.osBrowser==3){
						var control = document.getElementById(this.settings.pgeId);
						var pge_version = control.output35;
					}else{
						if(navigator.userAgent.indexOf("MSIE")<0){
							var arr=new Array();
							var pge_info=navigator.plugins['PassGuard'].description;
							if(pge_info.indexOf(":")>0){
								arr=pge_info.split(":");
								var pge_version = arr[1];
							}else{
								var pge_version = "";
							}
						}
					}
					return pge_version;
				}catch(e){
					return "";
				}					
			},
			setColor: function() {
				var code = '';

				if (!this.checkInstall()) {

					code = '';
				}
				else{
					try {
						var control = document.getElementById(this.settings.pgeId);
						if(this.settings.pgeBackColor!=undefined && this.settings.pgeBackColor!="") control.BackColor=this.settings.pgeBackColor;
						if(this.settings.pgeForeColor!=undefined && this.settings.pgeForeColor!="") control.ForeColor=this.settings.pgeForeColor;
					} catch (err) {

						code = '';

					}
				}
			},			
			setDownText:function(){
				if(this.pgeVersion!=undefined && this.pgeVersion!=""){
						this.pgeDownText="请点此升级控件";
				}
			},			
			pgInitialize:function(){
				if(this.checkInstall()){
					if(this.osBrowser==1 || this.osBrowser==3){ 
			            $('#'+this.settings.pgeId+'_pge').show(); 
					}
					
					var control = document.getElementById(this.settings.pgeId);
					
					if(this.settings.pgeBackColor!=undefined && this.settings.pgeBackColor!="") control.BackColor=this.settings.pgeBackColor;
					if(this.settings.pgeForeColor!=undefined && this.settings.pgeForeColor!="") control.ForeColor=this.settings.pgeForeColor;
					
				}else{
					if(this.osBrowser==1 || this.osBrowser==3){
						$('#'+this.settings.pgeId+'_down').show();
					}	
					
				}
				
			}
		}
	});	
	
})(jQuery);

//改数组用于存放ocx对象
var pgeditors =[];

// 将页面中的 input[type='password'] 的元素替换为 密码控件
function loadPasswordOCX(style){
	//获得随机码
	$.ajax({
        type: "GET",
        url: "/msgmgr/public/genCryptkey",
        cache:false,
        error: function(request) {
        	bootbox.alert("对不起，系统繁忙或维护中，请稍后再试。");
        	return;
        },
        success: function(data) {
        	data = ZhiyeCommon.toJson(data); 
           	if(data.success){
           		var randomCode = data.data.randomKey;          		
           		
           		// 密码初始化
           		if (pgeditors.length == 0) {
           			//将页面中的 input[type='password'] 的元素替换为 密码控件
           			var passwordElements = $("input[type='password']");
           			$.each(passwordElements,function(i,item){
           				var name = item.name;
           				//初始化密码控件
           				var pgeditor = new $.pge({ 
           					pgePath : "ocx/",//控件文件目录 
           					pgeId : name,//控件ID 
           					pgeEdittype : 0,//控件类型,0星号,1明文 
           					pgeEreg1 : "[a-zA-Z0-9_]*",//输入过程中字符类型限制 
           					pgeEreg2 : "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,20}$", //输入完毕后字符类型判断条件 
           					pgeMaxlength : 20,//允许最大输入长度
           					pgeTabindex : 2,//tab键顺序
           					pgeClass : style,//控件css样式
           					pgeInstallClass : "ocx_style",//针对安装或升级
           					pgeOnkeydown : null,//回车键响应函数
           					tabCallback : null
           					//非IE tab键焦点切换的ID
           				});
           				item.parentNode.innerHTML = pgeditor.load();
           				pgeditor.pgInitialize();
           				//设置随机数
           				pgeditor.pwdSetSk(randomCode);
           				pgeditors.push(pgeditor);
           			});
           		}else{
           			$.each(pgeditors, function(i, item) {
           				var name = item.settings.pgeId;
           				
           				if (name != null) {
           					//密码控件初始化
           					item.pgInitialize();
           					item.pwdSetSk(randomCode);
           					item.pwdclear();
           				}
           			});
           		}
           		
        	} else {
        		bootbox.alert(data.msg);   
        		return;
           	}
        }
    });	
}

//// 取加密随机数
//function getMcrypt_key(){
//	$.ajax({
//        type: "GET",
//        url: "/enterprise/public/genCryptkey",
//        cache:false,
//        error: function(request) {
//        	bootbox.alert("对不起，系统繁忙或维护中，请稍后再试。");
//        	return "";
//        },
//        success: function(data) {
//           	if(data.success){
//           		alert(data.data.randomKey);
//           		return data.data.randomKey;
//        	} else {
//        		bootbox.alert(data.msg);   
//        		return "";
//           	}
//        }
//    });	
//}

function get_time(){
	return new Date().getTime();
}
function _$(v){
	return document.getElementById(v);
}
//判断密码强度
function SetPWDStrength(n){

    _$("passwd_level_1").style.background="url(./pics/bg.gif)";
    _$("passwd_level_2").style.background="url(./pics/bg.gif)";
    _$("passwd_level_3").style.background="url(./pics/bg.gif)";
    if(n==2){
		_$("passwd_level_1").style.background="url(./pics/bg1.gif)";
	}
	if(n==3){
	   _$("passwd_level_1").style.background="url(./pics/bg1.gif)";
	   _$("passwd_level_2").style.background="url(./pics/bg1.gif)";
	}
	if(n==4){
	   _$("passwd_level_1").style.background="url(./pics/bg1.gif)";
	   _$("passwd_level_2").style.background="url(./pics/bg1.gif)";
	   _$("passwd_level_3").style.background="url(./pics/bg1.gif)";
	}

}

function EntertoTab(){
	document.getElementById("input2").focus();
}

function FormSubmit(){  
	$.ajax({
		url: "./srand_num.jsp?"+get_time(),
		type: "GET",
		async: false,
		success: function(srand_num){
		    pgeditor.pwdSetSk(srand_num);
		}
	 });
	var PwdResult=pgeditor.pwdResult();
	var machineNetwork=pgeditor.machineNetwork();
	var machineDisk=pgeditor.machineDisk();
	var machineCPU=pgeditor.machineCPU();	


	if(pgeditor.pwdLength()==0){
	     alert("密码不能为空");
		 _$("_ocx_password").focus();
		 return false;
	}

	if(pgeditor.pwdValid()==1){
		alert("密码不符合要求");
		 _$("_ocx_password").focus();
		 return false;
	} 
	//var l=_$("_ocx_password").get_output3();
	//var n=_$("_ocx_password").get_output4();
	//alert(l+"--"+n);
	
	_$("password").value=PwdResult;//获得密码密文,赋值给表单
	_$("local_network").value=machineNetwork;//获得网卡和MAC信息,赋值给表单
	_$("local_disk").value=machineDisk;//获得硬盘信息,赋值给表单
	_$("local_nic").value=machineCPU;//获得CPU信息,赋值给表单

	document.form1.submit();

}

function FormSubmit1(){  
	$.ajax({
		url: "./srand_num.jsp?"+get_time(),
		type: "GET",
		async: false,
		success: function(srand_num){
			pgeditorcvn.pwdSetSk(srand_num);
		}
	 });
	var PwdResult=pgeditorcvn.pwdResult();
	var machineNetwork=pgeditorcvn.machineNetwork();
	var machineDisk=pgeditorcvn.machineDisk();
	var machineCPU=pgeditorcvn.machineCPU();
	if(pgeditorcvn.pwdLength()==0){
	     alert("密码不能为空");
		 _$("_ocx_password").focus();
		 return false;
	}
	if(pgeditorcvn.pwdValid()==1){
		alert("密码不符合要求");
		 _$("_ocx_password").focus();
		 return false;
	} 

	_$("password").value=PwdResult;//获得密码密文,赋值给表单
	_$("local_network").value=machineNetwork;//获得网卡和MAC信息,赋值给表单
	_$("local_disk").value=machineDisk;//获得硬盘信息,赋值给表单
	_$("local_nic").value=machineCPU;//获得CPU信息,赋值给表单

	document.form1.submit();	
}

function FormSubmit2(){  
	$.ajax({
		url: "./srand_num.jsp?"+get_time(),
		type: "GET",
		async: false,
		success: function(srand_num){
		   pgeditoratm.pwdSetSk(srand_num);
		}
	 });
	var PwdResult=pgeditoratm.pwdResult();
	var machineNetwork=pgeditoratm.machineNetwork();
	var machineDisk=pgeditoratm.machineDisk();
	var machineCPU=pgeditoratm.machineCPU();
	if(pgeditoratm.pwdLength()==0){
	     alert("密码不能为空");
		 _$("_ocx_password2").focus();
		 return false;
	}
	if(pgeditoratm.pwdValid()==1){
		alert("密码不符合要求");
		 _$("_ocx_password2").focus();
		 return false;
	} 

	_$("password").value=PwdResult;//获得密码密文,赋值给表单
	_$("local_network").value=machineNetwork;//获得网卡和MAC信息,赋值给表单
	_$("local_disk").value=machineDisk;//获得硬盘信息,赋值给表单
	_$("local_nic").value=machineCPU;//获得CPU信息,赋值给表单

	document.form1.submit();	
}
//清除密码强度  
function ClearLevel(){
    _$("passwd_level_1").style.background="url(./pics/bg.gif)";
    _$("passwd_level_2").style.background="url(./pics/bg.gif)";
    _$("passwd_level_3").style.background="url(./pics/bg.gif)";
}
//获取密码强度
function GetLevel(){
  var n=pgeditor.pwdStrength();
  if(n>1){
  	  SetPWDStrength(n);
  }else{
       ClearLevel();
  }
}






























$.fn.passwordStrength = function(options){
	return this.each(function(){
		var that = this;that.opts = {};
		that.opts = $.extend({}, $.fn.passwordStrength.defaults, options);
		
		that.div = $(that.opts.targetDiv);
		that.defaultClass = that.div.attr('class');
		
		that.percents = (that.opts.classes.length) ? 100 / that.opts.classes.length : 100;
		 v = $(this).keyup(function(){
			if( typeof el == "undefined" )
				this.el = $(this);
			var s = getPasswordStrength (this.value);
			var p = this.percents;
			var t = Math.floor( s / p );			
			if( 100 <= s ) t = this.opts.classes.length - 1;	
			this.div.removeAttr('class').addClass( this.defaultClass ).addClass( this.opts.classes[ t ]);	
		})		
	});
	//获取密码强度
	function getPasswordStrength(H){
		var D=(H.length);
		if(D>5){
			D=5
		}
		var F=H.replace(/[0-9]/g,"");
		var G=(H.length-F.length);
		if(G>3){G=3}
		var A=H.replace(/\W/g,"");
		var C=(H.length-A.length);
		if(C>3){C=3}
		var B=H.replace(/[A-Z]/g,"");
		var I=(H.length-B.length);
		if(I>3){I=3}
		var E=((D*10)-20)+(G*10)+(C*15)+(I*10);
		if(E<0){E=0}
		if(E>100){E=100}
		return E
	}

};
	
$.fn.passwordStrength.defaults = {
	classes : Array('is10','is20','is30','is40','is50','is60','is70','is80','is90','is100'),
	targetDiv : 'input[type=password]',
	cache : {}
}
$.passwordStrength = {};
$.passwordStrength.getRandomPassword = function(size){
		var chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
		var size = size || 8;
		var i = 1;
		var ret = ""
		while ( i <= size ) {
			$max = chars.length-1;
			$num = Math.floor(Math.random()*$max);
			$temp = chars.substr($num, 1);
			ret += $temp;
			i++;
		}
		return ret;			
}