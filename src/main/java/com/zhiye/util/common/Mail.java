package com.zhiye.util.common;

import java.util.Properties;

import javax.activation.DataHandler;
import javax.activation.FileDataSource;
import javax.mail.Address;
import javax.mail.BodyPart;
import javax.mail.Message;
import javax.mail.Multipart;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.mail.internet.MimeUtility;

public class Mail { 
	private String SMTP; 
	private String FROM;  
	private String USERNAME;   
	private String PASSWORD; 
	
	private MimeMessage mimeMsg; //MIME邮件对象 
	private Session session; //邮件会话对象 
	private Properties props; //系统属性 
	
	//smtp认证用户名和密码 
	private String username; 
	private String password; 
	private Multipart mp; //Multipart对象,邮件内容,标题,附件等内容均添加到其中后再生成MimeMessage对象 
	 
	 //构造初始化
	public Mail(String host,String from,String sendder,String pwd){
		SMTP = host;
		FROM = from;
		USERNAME = sendder;
		PASSWORD = pwd;
		setSmtpHost(host); 
		createMimeMessage(); 
	}
	
	/**
	 * 设置邮件发送服务器
	 * @param hostName String 
	 */
	public void setSmtpHost(String hostName) { 
		System.out.println("设置系统属性：mail.smtp.host = "+hostName); 
		if(props == null)
		   props = System.getProperties(); //获得系统属性对象 	
		props.put("mail.smtp.host",hostName); //设置SMTP主机 
	} 

	/**
	 * 创建MIME邮件对象  
	 * @return
	 */
	public boolean createMimeMessage() 
	{ 
		try { 
			System.out.println("准备获取邮件会话对象！"); 
			session = Session.getDefaultInstance(props,null); //获得邮件会话对象 
		} 
		catch(Exception e){ 
			System.err.println("获取邮件会话对象时发生错误！"+e); 
			return false; 
		} 
	
		System.out.println("准备创建MIME邮件对象！"); 
		try { 
			mimeMsg = new MimeMessage(session); //创建MIME邮件对象 
			mp = new MimeMultipart(); 
			return true; 
		} catch(Exception e){ 
			System.err.println("创建MIME邮件对象失败！"+e); 
			return false; 
		} 
	} 	
	
	/**
	 * 设置SMTP是否需要验证
	 * @param need
	 */
	public void setNeedAuth(boolean need) { 
		System.out.println("设置smtp身份认证：mail.smtp.auth = "+need); 
		if(props == null) props = System.getProperties(); 
		if(need){ 
			props.put("mail.smtp.auth","true"); 
		}else{ 
			props.put("mail.smtp.auth","false"); 
		} 
	} 

	/**
	 * 设置用户名和密码
	 * @param name
	 * @param pass
	 */
	public void setNamePass(String name,String pass) { 
		username = name; 
		password = pass; 
	} 

	/**
	 * 设置邮件主题
	 * @param mailSubject
	 * @return
	 */
	public boolean setSubject(String mailSubject) { 
		System.out.println("设置邮件主题！"); 
		try{ 
			mimeMsg.setSubject(MimeUtility.encodeText( mailSubject,"GB2312", "B")); 
			return true; 
		} 
		catch(Exception e) { 
			System.err.println("设置邮件主题发生错误！"); 
			return false; 
		} 
	}
	
	/** 
	 * 设置邮件正文
	 * @param mailBody String 
	 */ 
	public boolean setBody(String mailBody) { 
		try{ 
			BodyPart bp = new MimeBodyPart(); 
			bp.setContent(""+mailBody,"text/html;charset=GBK"); 
			mp.addBodyPart(bp); 
			return true; 
		} catch(Exception e){ 
			System.err.println("设置邮件正文时发生错误！"+e); 
			return false; 
		} 
	} 
	
	/** 
	 * 添加附件
	 * @param filename String 
	 */ 
	public boolean addFileAffix(String filename) { 
	
		System.out.println("增加邮件附件："+filename); 
		try{ 
			BodyPart bp = new MimeBodyPart(); 
			FileDataSource fileds = new FileDataSource(filename); 
			bp.setDataHandler(new DataHandler(fileds)); 
			bp.setFileName(fileds.getName()); 
			
			mp.addBodyPart(bp); 
			return true; 
		} catch(Exception e){ 
			System.err.println("增加邮件附件："+filename+"发生错误！"+e); 
			return false; 
		} 
	} 
	
	/** 
	 * 设置发信人
	 * @param from String 
	 */ 
	public boolean setFrom(String from) { 
		System.out.println("设置发信人！"); 
		try{ 
			mimeMsg.setFrom(new InternetAddress(from)); //设置发信人 
			return true; 
		} catch(Exception e) { 
			return false; 
		} 
	} 
	/** 
	 * 设置收信人
	 * @param to String 
	 */ 
	public boolean setTo(String to){ 
		if(to == null)return false; 
		try{ 
			mimeMsg.setRecipients(Message.RecipientType.TO,InternetAddress.parse(to)); 
			return true; 
		} catch(Exception e) { 
			return false; 
		} 	
	} 
	
	/** 
	 * 设置抄送人
	 * @param copyto String  
	 */ 
	public boolean setCopyTo(String copyto) 
	{ 
		if(copyto == null)return false; 
		try{ 
		mimeMsg.setRecipients(Message.RecipientType.CC,(Address[])InternetAddress.parse(copyto)); 
		return true; 
		} 
		catch(Exception e) 
		{ return false; } 
	} 
	
	/** 
	 * 发送邮件
	 */ 
	public boolean sendOut() 
	{ 
		try{ 
			mimeMsg.setContent(mp); 
			mimeMsg.saveChanges(); 
			System.out.println("正在发送邮件...."); 
			
			Session mailSession = Session.getInstance(props,null); 
			Transport transport = mailSession.getTransport("smtp"); 
			transport.connect((String)props.get("mail.smtp.host"),username,password); 
			transport.sendMessage(mimeMsg,mimeMsg.getRecipients(Message.RecipientType.TO)); 
			//transport.sendMessage(mimeMsg,mimeMsg.getRecipients(Message.RecipientType.CC)); 
			//transport.send(mimeMsg); 
			
			System.out.println("发送邮件成功！"); 
			transport.close(); 
			
			return true; 
		} catch(Exception e) { 
			System.err.println("邮件发送失败！"+e); 
			return false; 
		} 
	} 

	public boolean send(String to,String subject,String content) {
		setNeedAuth(true); //需要验证
		
		if(!setSubject(subject)) return false;
		if(!setBody(content)) return false;
		if(!setTo(to)) return false;
		if(!setFrom(getFROM())) return false;
		setNamePass(getUSERNAME(),getPASSWORD());
		
		if(!sendOut()) return false;
		return true;
	}
	
	public static void main(String[] args) {
	    String to = "lh-xyzf@xiangyu.cn";  
	    String subject = "象屿支付风控系统操作员登陆密码";
	    StringBuffer strBuf = new StringBuffer();
		strBuf.append("亲爱的象屿支付用户：").append("</br>");
		strBuf.append("您好!").append("</br>");
		strBuf.append("这是象屿支付给您发送的密码邮件，查看邮件后登录象屿支付风控系统；").append("</br>");
		strBuf.append("请先确认此邮箱 xyrisk@sina.com是您要绑定象屿支付账户的登录邮箱，象屿支付将通过此邮箱来验证您的用户身份；").append("</br>");
		strBuf.append("操作员的登陆密码为：QKP0JUX8 ").append("</br>");
		strBuf.append("操作员的授权密码为：QKP0JUX8 ").append("</br>");
		strBuf.append("重新登录后修改您的密码！ 请牢记您的象屿支付账户和密码，这是您使用象屿支付服务所必须拥有的。").append("</br>");
		strBuf.append("如您没有申请过注册象屿支付，请忽略本邮件。给您带来的不便敬请谅解！").append("</br>");
		strBuf.append("本邮件由象屿支付系统自动发出，请勿直接回复！");
//	    Mail.send(to, subject, strBuf.toString());
	}
	
	public String getSMTP() {
		return SMTP;
	}
	public void setSMTP(String sMTP) {
		SMTP = sMTP;
	}
	public String getFROM() {
		return FROM;
	}
	public void setFROM(String fROM) {
		FROM = fROM;
	}
	public String getUSERNAME() {
		return USERNAME;
	}
	public void setUSERNAME(String uSERNAME) {
		USERNAME = uSERNAME;
	}
	public String getPASSWORD() {
		return PASSWORD;
	}
	public void setPASSWORD(String pASSWORD) {
		PASSWORD = pASSWORD;
	}
} 
