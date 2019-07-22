package com.xyj.cust.controller;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
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
import com.xyj.cust.model.MdseModel;
import com.xyj.cust.service.MdseService;
import com.xyj.util.BaiKe;
import com.xyj.util.FmtEmpty;
import com.xyj.util.FmtPOI;

@Controller
@RequestMapping("/mdse")
public class MdseController {

	@Autowired
	private MdseService<MdseModel> mdseService;
	
	@ResponseBody
	@RequestMapping(value="/selectList",produces="text/html;charset=UTF-8")
	public String selectList(MdseModel um){
		String code = "%" + um.getCode() + "%" ;
		String name = "%" + um.getName() + "%" ;
		String updateBy = um.getUpdateBy() ;
		MdseModel model = new MdseModel();
		model.setCode(code);
		model.setName(name);
		model.setDeleted(0);
		if (!FmtEmpty.isEmpty(updateBy)) {			
			model.setUpdateBy(updateBy);
		}
		model.setPageIndex(um.getPageIndex());
		model.setPageLimit(um.getPageLimit());
		model.setPageOn(true);
		model.setOrderby("create_by");
		List<MdseModel> list = mdseService.selectModel(model);	
		Map<String, Object> map = new HashMap<String, Object>();
	    map.put("data", list);
	    map.put("code", 0);
	    map.put("count", mdseService.selectCount(model));
	    return new JSONObject(map).toString();
	}
	
	@RequestMapping("/addorupd")
	public String addorupd(String code , Model model) {
		if(!FmtEmpty.isEmpty(code)) {
			model.addAttribute("model", mdseService.select(code));
		}
		return "web/page/cust/mdseaddorupd";
	}
	
	@ResponseBody
	@RequestMapping("/save")
	public int save(MdseModel imodel , HttpSession session) {
		Object obj = session.getAttribute("user");
		UserModel um = (UserModel)obj;
		String username = um.getName();		
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String date = df.format(new Date());//	获取当前时间
		String code = imodel.getCode();

		if(mdseService.select(code) == null) {
			//	添加
			imodel.setCreateBy(username);
			imodel.setCreateTime(date);
			imodel.setUpdateBy(username);			
			imodel.setUpdateTime(date);
			imodel.setDeleted(0);
			return insertIfNotExist(imodel);
		}else if(mdseService.select(code) != null) {
			//	修改
			imodel.setUpdateBy(username);	
			imodel.setUpdateTime(date);
			return mdseService.updateActive(imodel) + 2;
		}else {
			//	返回操作失败
			return 9;
		}
	}
	private int insertIfNotExist(MdseModel imodel) {
		String code = imodel.getCode();
		if(mdseService.select(code) == null) {
			return FmtEmpty.isEmpty(mdseService.insert(imodel)) ? 4 : 0;
		}
		return 1;
	}
	
	@ResponseBody
	@RequestMapping("/selectDel")
	public String selectDel() {
		MdseModel model = new MdseModel();
		model.setDeleted(1);
		List<MdseModel> list = mdseService.selectAll(model);
		Map<String, Object> map = new HashMap<String, Object>();
	    map.put("list", list);
	    return new JSONObject(map).toString();
	}
	
	@ResponseBody
	@RequestMapping("/toTrach")
	public int toTrach(String id , HttpSession session) {
		Object obj = session.getAttribute("user");
		UserModel um = (UserModel)obj;
		String rolecode = um.getRoleCode();
		if(rolecode.equals("YG1")) {
			return 2 ;
		}else {			
			MdseModel model = new MdseModel();
			model.setCode(id);
			model.setDeleted(1);
			return mdseService.update(model);
		}
	}
	
	@ResponseBody
	@RequestMapping("/back")
	public int back(String code) {
		MdseModel model = new MdseModel();
		model.setCode(code);
		model.setDeleted(0);
		return mdseService.update(model);
	}
	
	@ResponseBody
	@RequestMapping("/delCompletely")
	public int delCompletely(String code ,  HttpSession session) {
		Object obj = session.getAttribute("user");
		UserModel um = (UserModel)obj;
		String rolecode = um.getRoleCode();
		if(rolecode.equals("YG1")) {
			return 2 ;
		}else {	
			return mdseService.delete(code);
		}
	}
	
	@ResponseBody
	@RequestMapping("/toTrachBatch")
	public int toTrachBatch(String ids , HttpSession session) {
		Object obj = session.getAttribute("user");
		UserModel um = (UserModel)obj;
		String rolecode = um.getRoleCode();
		if(rolecode.equals("YG1")) {
			return 2 ;
		}else {			
			ids = ids.substring(0, ids.length()-1);
			for(String id : ids.split(",")) {
				Integer id2 = Integer.parseInt(id);
				mdseService.updateBatch(id2);
			}
			return 1;//	执行完成
		}
	}
	
	@RequestMapping("/exportExcel")
	public void exportExcel(HttpServletResponse response ,  MdseModel model) throws Exception {		
		model.setPageLimit(1000);
		model.setDeleted(0);
		List<MdseModel> dataList = mdseService.selectAll(model);
		List<String> propList = Arrays.asList("code" , "name" , "cost" , "num" , "createBy" , "createTime");
		List<String> fieldName = Arrays.asList("编号" , "名称" , "价格" , "库存" , "创建人" , "创建时间");		
		Workbook wb = FmtPOI.exportExcel(dataList, propList, fieldName);				
		response.setContentType("multipart/form-data");		
		String fileName = "商品信息表.xlsx";
		response.setHeader("Content-Disposition", "attachment;filename="+new String(fileName.getBytes("UTF-8"),"ISO8859-1"));		
		OutputStream out = response.getOutputStream();
		wb.write(out);
		wb.close();
		out.close();
	}
	
	@RequestMapping("/exportTemp")
	public void exportTemp(HttpServletResponse response ,  MdseModel model) throws Exception {		
		List<String> fieldName = Arrays.asList("编号" , "名称" , "价格" , "库存" , "创建人" , "创建时间");		
		Workbook wb = FmtPOI.exportExcel(null, null, fieldName);
		wb.setSheetName(0, "mdse");
		response.setContentType("multipart/form-data");		
		String fileName = "商品信息表_模板.xlsx";
		response.setHeader("Content-Disposition", "attachment;filename="+new String(fileName.getBytes("UTF-8"),"ISO8859-1"));		
		OutputStream out = response.getOutputStream();
		wb.write(out);
		wb.close();
		out.close();
	}
	
	@ResponseBody
	@RequestMapping("/uploadExcel")
	public String uploadExcel(CommonsMultipartResolver multipartResolver , HttpServletRequest request) throws IOException {
		Map<String , Object> result = new HashMap<>();
		result.put("code", 0);
		if(multipartResolver.isMultipart(request)) {
			MultipartHttpServletRequest multiRequest = (MultipartHttpServletRequest)request;
			Iterator<String> iter = multiRequest.getFileNames();
			while (iter.hasNext()) {
				MultipartFile file = multiRequest.getFile(iter.next().toString());
				result.put("data", parse(file.getInputStream()));
			}
		}
		return new JSONObject(result).toString();
	}

	private List<MdseModel> parse(InputStream fis) throws IOException{
		//	由输入流得到工作簿
		XSSFWorkbook workbook = new XSSFWorkbook(fis);
		//	得到工作表
		XSSFSheet sheet = workbook.getSheet("mdse");
		List<MdseModel> list = new ArrayList<>();
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String date = df.format(new Date());
		for(Row row : sheet) {
			if(0 == row.getRowNum()) {
				continue;
			}
			MdseModel model = new MdseModel();
			model.setCode(getValue(row.getCell(0)));
			model.setName(getValue(row.getCell(1)));
			model.setCost(getValue(row.getCell(3)));
			model.setNum(Integer.parseInt(getValue(row.getCell(4))));
			model.setCreateBy(getValue(row.getCell(5)));
			model.setCreateTime(date);
			model.setUpdateTime(date);
			model.setUpdateBy(getValue(row.getCell(5)));
			list.add(model);
			insertIfNotExist(model);
		}
		workbook.close();
		fis.close();
		return list;
	}

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
	
	@RequestMapping("/stat")
	public String statnum() {
		return "web/page/cust/mdsestat";		
	}
	
	@RequestMapping("/price")
	public String statprice() {
		return "web/page/cust/mdseprice";		
	}
	
	@RequestMapping("/tofind")
	public String tofind() {
		return "web/page/cust/mdsebaike";		
	}
	
	@ResponseBody
	@RequestMapping(value = "/find" , produces = "text/html;charset=UTF-8")
	public String find(String item) throws UnsupportedEncodingException {
		if(!FmtEmpty.isEmpty(item)) {	
			String baseUrl = "https://baike.baidu.com/item/";
			BaiKe bk = new BaiKe();
			//	URLEncoder.encode(String,"UTF-8")	将中文字符编码
			 Map<String, Object> map = bk.getContent2(baseUrl + URLEncoder.encode(item,"UTF-8"));
			Object contentText =  map.get("contentText");
			Object picUrl = map.get("picUrl");
			map.put("contentText", contentText);
			map.put("picUrl", picUrl);
			return new JSONObject(map).toString();	
		}else {
			return "";
		}
	}
	
}
