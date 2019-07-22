package com.xyj.cust.controller;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;

import com.xyj.crm.model.UserModel;
import com.xyj.cust.model.CommModel;
import com.xyj.cust.model.InfoModel;
import com.xyj.cust.model.MdseModel;
import com.xyj.cust.service.CommService;
import com.xyj.cust.service.InfoService;
import com.xyj.util.FmtEmpty;
import com.xyj.util.FmtMail;
import com.xyj.util.FmtPOI;

@Controller
@RequestMapping("/info")
public class InfoController {

	@Autowired
	private InfoService<InfoModel> infoService;
	@Autowired
	private CommService<CommModel> commService;

	@ResponseBody
	@RequestMapping(value="/selectList",produces="text/html;charset=UTF-8")
	public String selectList(InfoModel um){
		//	根据Code,Name,Email的模糊查询
		String code = "%" + um.getCode() + "%" ;
		String name = "%" + um.getName() + "%" ;
		String email = "%" + um.getEmail() + "%" ;
		String updateBy = um.getUpdateBy() ;
		InfoModel model = new InfoModel();
		model.setCode(code);
		model.setName(name);
		model.setDeleted(0);
		model.setEmail(email);
		if (!FmtEmpty.isEmpty(updateBy)) {			
			model.setUpdateBy(updateBy);
		}
		model.setPageIndex(um.getPageIndex());
		model.setPageLimit(um.getPageLimit());
		model.setPageOn(true);
		//	根据条件查询
		List<InfoModel> list = infoService.selectModel(model);	
		Map<String, Object> map = new HashMap<String, Object>();
	    map.put("data", list);
	    //	LayUI表格状态码，默认0
	    map.put("code", 0);
	    map.put("count", infoService.selectCount(model));
	    return new JSONObject(map).toString();
	}
	
	/**
	 * @param email
	 * @param text
	 * @param self
	 * @param title
	 * @param code
	 * @param usercode
	 * @return 1 发送成功
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping("/email")
	public int email(String email , String text , String self , String title , String code , String usercode) throws Exception {
		 String[] to = { email };// 收件人
	     String from = self;// 发件人
	     String pass = "oncfnxbotjlyjbbh";//	授权码
	     String hostSend = "smtp.qq.com";
	     String portSend = "587";//	端口号(非SSL) qq-587或465
	     FmtMail ms = new FmtMail(to, from, pass, hostSend, portSend);
	     ms.send(title, text); 	   
		return addComm(code,title,usercode);
	}
	
	/**
	 * @param custcode
	 * @param title
	 * @param usercode
	 * @return
	 * 	向沟通记录表中插入本次邮件的信息(生成一条记录)
	 */
	private int addComm(String custcode , String title , String usercode) {
		//	当前时间
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String time = df.format(new Date());	
		CommModel cm = new CommModel();
		cm.setUserCode(usercode);
		cm.setCustCode(custcode);
		cm.setCreateTime(time);
		cm.setType(0); //	未指定Type
		cm.setDescr(title);
		commService.insert(cm);
		return 1;
	}

	@RequestMapping("/addorupd")
	public String addorupd(String code , Model model) {
		if(!FmtEmpty.isEmpty(code)) {
			model.addAttribute("model", infoService.select(code));
		}
		return "web/page/cust/infoaddorupd";
	}
	
	/**
	 * @param infomodel
	 * @param session
	 * @return 状态(0,1,3,9),int
	 */
	@ResponseBody
	@RequestMapping("/save")
	public int save(InfoModel imodel , HttpSession session) {
		//	获取Session中的用户名
		Object obj = session.getAttribute("user");
		UserModel um = (UserModel)obj;
		String username = um.getName();
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String date = df.format(new Date());		
		String code = imodel.getCode();

		if(infoService.select(code) == null) {
			//	添加
			imodel.setCreateBy(username);
			imodel.setCreateTime(date);
			imodel.setUpdateBy(username);			
			imodel.setUpdateTime(date);
			imodel.setState("1");
			imodel.setDeleted(0);
			return insertIfNotExist(imodel);
		}else if(infoService.select(code) != null) {
			//	修改
			imodel.setUpdateBy(username);	
			imodel.setUpdateTime(date);
			return infoService.updateActive(imodel) + 2;
		}else {
			//	返回操作失败
			return 9;
		}
	}
	private int insertIfNotExist(InfoModel imodel) {
		String code = imodel.getCode();
		if(infoService.select(code) == null) {
			return FmtEmpty.isEmpty(infoService.insert(imodel)) ? 4 : 0;
		}
		return 1;
	}
	
	/**
	 * @return Map集合
	 * 	查找被删除的数据(回收站)
	 */
	@ResponseBody
	@RequestMapping("/selectDel")
	public String selectDel() {
		InfoModel model = new InfoModel();
		model.setDeleted(1);
		List<InfoModel> list = infoService.selectAll(model);
		Map<String, Object> map = new HashMap<String, Object>();
	    map.put("list", list);
	    return new JSONObject(map).toString();
	}
	
	/**
	 * @param id
	 * @return 状态(1,0),int
	 */
	@ResponseBody
	@RequestMapping("/toTrach")
	public int toTrach(String id) {//	放入回收站
		InfoModel model = new InfoModel();
		model.setCode(id);
		model.setDeleted(1);
		return infoService.update(model);
	}
	
	/**
	 * @param code
	 * @return 状态(1,0),int
	 */
	@ResponseBody
	@RequestMapping("/back")
	public int back(String code) {//	还原
		InfoModel model = new InfoModel();
		model.setCode(code);
		model.setDeleted(0);
		return infoService.update(model);
	}
	
	/**
	 * @param code
	 * @return 状态(1,0),int
	 * 	彻底删除
	 */
	@ResponseBody
	@RequestMapping("/delCompletely")
	public int delCompletely(String code) {
		return infoService.delete(code);
	}
	
	/**
	 * @param ids
	 * @return 状态(1,0),int
	 *	批量放入回收站
	 */
	@ResponseBody
	@RequestMapping("/toTrachBatch")
	public int toTrachBatch(String ids) {	
		ids = ids.substring(0, ids.length()-1);
		for(String id : ids.split(",")) {
			Integer id2 = Integer.parseInt(id);
			infoService.updateBatch(id2);
		}
		return 1;//	执行完成
	}
	
	/**
	 * @param response
	 * @param model
	 * @throws Exception
	 * 	导出Excel表格
	 */
	@RequestMapping("/exportExcel")
	public void exportExcel(HttpServletResponse response ,  InfoModel model) throws Exception {		
		model.setPageLimit(1000);
		model.setDeleted(0);
		List<InfoModel> dataList = infoService.selectAll(model);
		List<String> propList = Arrays.asList("code" , "name" , "email" , "createBy" , "createTime" );
		List<String> fieldName = Arrays.asList("编号" , "姓名"  , "邮箱" , "创建人" , "创建时间" );		
		Workbook wb = FmtPOI.exportExcel(dataList, propList, fieldName);				
		response.setContentType("multipart/form-data");		
		String fileName = "客户信息表.xlsx";
		response.setHeader("Content-Disposition", "attachment;filename="+new String(fileName.getBytes("UTF-8"),"ISO8859-1"));		
		OutputStream out = response.getOutputStream();
		wb.write(out);
		wb.close();
		out.close();
	}
	
	/**
	 * @param response
	 * @param model
	 * @throws Exception
	 * 	导出模板
	 */
	@RequestMapping("/exportTemp")
	public void exportTemp(HttpServletResponse response ,  MdseModel model) throws Exception {		
		List<String> fieldName = Arrays.asList("编号" , "名称" , "邮箱" , "创建人" , "创建时间");		
		Workbook wb = FmtPOI.exportExcel(null, null, fieldName);
		//	将模板的第一个Sheet工作表名称设置为‘info’
		wb.setSheetName(0, "info");	
		String fileName = "客户信息表_模板.xls";
		response.setHeader("Content-Disposition", "attachment;filename="+new String(fileName.getBytes("UTF-8"),"ISO8859-1"));		
		OutputStream out = response.getOutputStream();
		wb.write(out);
		wb.close();
		out.close();
	}
	
	/**
	 * @param multipartResolver
	 * @param request
	 * @return 
	 * @throws IOException
	 * 	上传文件
	 */
	@ResponseBody
	@RequestMapping("/uploadExcel")
	public String uploadExcel(CommonsMultipartResolver multipartResolver , HttpServletRequest request) throws IOException {
		Map<String , Object> result = new HashMap<>();
		result.put("code", 0);
		if(multipartResolver.isMultipart(request)) {
			MultipartHttpServletRequest multiRequest = (MultipartHttpServletRequest)request;
			Iterator<String> iter = multiRequest.getFileNames();
			//	迭代
			while (iter.hasNext()) {
				MultipartFile file = multiRequest.getFile(iter.next().toString());
				result.put("data", parse(file.getInputStream()));
			}
		}
		return new JSONObject(result).toString();
	}

	/**
	 * @param fis
	 * @return Map集合
	 * @throws IOException
	 * 得到Excel中的Sheet，得到值后存入数据库
	 */
	private List<InfoModel> parse(InputStream fis) throws IOException{
		//	由输入流得到工作簿
		XSSFWorkbook workbook = new XSSFWorkbook(fis);
		//	得到工作表
		XSSFSheet sheet = workbook.getSheet("info");
		List<InfoModel> list = new ArrayList<>();
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String date = df.format(new Date());
		//	遍历工作簿
		for(Row row : sheet) {
			if(0 == row.getRowNum()) {
				continue;
			}
			InfoModel model = new InfoModel();
			model.setCode(getValue(row.getCell(0)));
			model.setName(getValue(row.getCell(1)));
			model.setEmail(getValue(row.getCell(2)));
			model.setCreateBy(getValue(row.getCell(3)));
			model.setCreateTime(date);
			model.setUpdateTime(date);
			model.setUpdateBy(getValue(row.getCell(3)));
			list.add(model);
			insertIfNotExist(model);
		}
		workbook.close();
		fis.close();
		return list;
	}

	/**
	 * @param cell
	 * @return 单元格中的值,String,Number
	 * 	获取每个单元格中的值
	 */
	private String getValue(Cell cell) {
		CellType type = cell.getCellTypeEnum();
		if(CellType.STRING.equals(type)) {
			//	得到字符串类型的值
			return cell.getStringCellValue();
		}else if(CellType.NUMERIC.equals(type)) {
			//	得到数字类型的值
			return String.valueOf(cell.getNumericCellValue());
		}
		return null;
	}

}
