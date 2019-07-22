package com.xyj.cust.controller;

import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.poi.ss.usermodel.Workbook;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.xyj.crm.model.UserModel;
import com.xyj.crm.service.UserService;
import com.xyj.cust.model.CommModel;
import com.xyj.cust.model.InfoModel;
import com.xyj.cust.service.CommService;
import com.xyj.cust.service.InfoService;
import com.xyj.util.FmtEmpty;
import com.xyj.util.FmtPOI;

@Controller
@RequestMapping("/comm")
public class CommController {

	@Autowired
	private CommService<CommModel> commService;
	@Autowired
	private InfoService<InfoModel> infoService;
	@Autowired
	private UserService<UserModel> userService;
	
	@ResponseBody
	@RequestMapping(value="/selectList",produces="text/html;charset=UTF-8")
	public String selectList(CommModel cm){
		String code = "%" + cm.getCode() + "%" ;
		String name = "%" + cm.getName() + "%" ;
		String updateBy = cm.getUpdateBy() ;
		CommModel model = new CommModel();
		model.setCode(code);
		model.setName(name);
		model.setDeleted(0);
		if (!FmtEmpty.isEmpty(updateBy)) {			
			model.setUpdateBy(updateBy);
		}
		model.setPageIndex(cm.getPageIndex());
		model.setPageLimit(cm.getPageLimit());
		model.setPageOn(true);
		model.setOrderby("cust_code");
		List<CommModel> list = commService.selectModel(model);	
		Map<String, Object> map = new HashMap<String, Object>();
	    map.put("data", list);
	    map.put("code", 0);
	    map.put("count", commService.selectCount(model));
	    return new JSONObject(map).toString();
	}
	
	@RequestMapping("/addorupd")
	public String addorupd(String code , Model model) {
		if(!FmtEmpty.isEmpty(code)) {
			model.addAttribute("model", commService.select(code));
		}
		model.addAttribute("saleCust", infoService.selectAll(new InfoModel()));
		model.addAttribute("saleUser", userService.selectAll(new UserModel()));
		return "web/page/cust/commaddorupd";
	}
	
	@ResponseBody
	@RequestMapping("/save")
	public int save(CommModel model , HttpSession session) {
		Integer id = model.getId();
		String custCode = model.getCustCode();
		String descr = model.getDescr();
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String date = df.format(new Date());
		
		if(commService.select(id) == null) {
			//	添加
			model.setCreateTime(date);
			return FmtEmpty.isEmpty(commService.insert(model)) ? 1 : 0;//	添加成功 0  添加失败1
		}else if(commService.select(id) != null ) {
			//	修改
			model.setCustCode(custCode);
			model.setDescr(descr);
			return commService.updateActive(model) + 2;
		}else {
			return 4;//	操作失败
		}
	}
	
	@ResponseBody
	@RequestMapping("/selectDel")
	public String selectDel() {
		CommModel model = new CommModel();
		model.setDeleted(1);
		Map<String, Object> map = new HashMap<String, Object>();
	    map.put("list", commService.selectAll(model));
	    return new JSONObject(map).toString();
	}
	
	@ResponseBody
	@RequestMapping("/toTrach")
	public int toTrach(Integer id) {
		CommModel model = new CommModel();
		model.setId(id);
		model.setDeleted(1);
		return commService.update(model);
	}
	
	@ResponseBody
	@RequestMapping("/back")
	public int back(String id) {
		CommModel model = new CommModel();
		int id2 = Integer.parseInt(id);
		model.setId(id2);
		model.setDeleted(0);
		return commService.update(model);
	}
	
	@ResponseBody
	@RequestMapping("/delCompletely")
	public int delCompletely(Integer id) {
		CommModel model = new CommModel();
		model.setId(id);
		return commService.delete(model);
	}
	
	@ResponseBody
	@RequestMapping("/toTrachBatch")
	public int toTrachBatch(String ids) {
		ids = ids.substring(0, ids.length()-1);
		for(String id : ids.split(",")) {
			Integer id2 = Integer.parseInt(id);
			commService.updateBatch(id2);
		}
		return 1;//	执行完成
	}

	@RequestMapping("/exportExcel")
	public void exportExcel(HttpServletResponse response ,  CommModel model) throws Exception {		
		model.setPageLimit(1000);
		model.setDeleted(0);//	仅打印出未被删除的数据
		List<CommModel> dataList = commService.selectAll(model);
		List<String> propList = Arrays.asList("userName" , "custName" ,  "createTime" , "descr");
		List<String> fieldName = Arrays.asList("用户" , "客户" , "创建时间" , "内容" );		
		Workbook wb = FmtPOI.exportExcel(dataList, propList, fieldName);				
		response.setContentType("multipart/form-data");		
		String fileName = "沟通信息表.xlsx";
		response.setHeader("Content-Disposition", "attachment;filename="+new String(fileName.getBytes("UTF-8"),"ISO8859-1"));		
		OutputStream out = response.getOutputStream();
		wb.write(out);
		wb.close();
		out.close();
	}
	
}
