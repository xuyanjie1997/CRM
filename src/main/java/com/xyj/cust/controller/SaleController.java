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

import com.xyj.base.model.DictionaryModel;
import com.xyj.base.service.DictionaryService;
import com.xyj.crm.model.UserModel;
import com.xyj.crm.service.UserService;
import com.xyj.cust.model.InfoModel;
import com.xyj.cust.model.MdseModel;
import com.xyj.cust.model.SaleModel;
import com.xyj.cust.service.InfoService;
import com.xyj.cust.service.MdseService;
import com.xyj.cust.service.SaleService;
import com.xyj.util.FmtEmpty;
import com.xyj.util.FmtPOI;

@Controller
@RequestMapping("/sale")
public class SaleController {

	@Autowired
	private SaleService<SaleModel> saleService;
	@Autowired
	private UserService<UserModel> userService;
	@Autowired
	private InfoService<InfoModel> infoService;
	@Autowired
	private MdseService<MdseModel> mdseService;
	@Autowired
	private DictionaryService<DictionaryModel> dictionaryService;
	
	@ResponseBody
	@RequestMapping(value="/selectList",produces="text/html;charset=UTF-8")
	public String selectList(SaleModel um){
		String usercode = "%" + um.getUserCode() + "%" ;
		String custcode = "%" + um.getCustCode() + "%" ;
		String mdsecode = "%" + um.getMdseCode() + "%" ;
		SaleModel model = new SaleModel();
		model.setUserCode(usercode);
		model.setMdseCode(mdsecode);
		model.setCustCode(custcode);
		model.setDeleted(0);
		model.setPageIndex(um.getPageIndex());
		model.setPageLimit(um.getPageLimit());
		model.setPageOn(true);
		model.setOrderby("user_code ASC , cust_code ASC");
		List<SaleModel> list = saleService.selectModel(model);	
		Map<String, Object> map = new HashMap<String, Object>();
	    map.put("data", list);
	    map.put("code", 0);
	    map.put("count", saleService.selectCount(model));
	    return new JSONObject(map).toString();
	}
	
	@RequestMapping("/addorupd")
	public String addorupd(String code , Model model) {
		if(!FmtEmpty.isEmpty(code)) {
			model.addAttribute("model", saleService.select(code));
		}
		model.addAttribute("saleUser", userService.selectAll(new UserModel()));
		model.addAttribute("saleCust", infoService.selectAll(new InfoModel()));
		model.addAttribute("saleMdse", mdseService.selectAll(new MdseModel()));
		model.addAttribute("state", dictionaryService.selectAll(new DictionaryModel()));
		return "web/page/cust/saleaddorupd";
	}
	
	@ResponseBody
	@RequestMapping("/save")
	public int save(SaleModel model , HttpSession session) {
		Integer id = model.getId();
		Object obj = session.getAttribute("user");
		UserModel um = (UserModel)obj;
		String username = um.getName();	
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String date = df.format(new Date());//	获取当前时间
		SaleModel m2 = new SaleModel();
		m2.setCustCode(model.getCustCode());
		m2.setUserCode(model.getUserCode());
		m2.setMdseCode(model.getMdseCode());
		SaleModel m3ByCodes = saleService.selectByCodes(m2);
		
		if(saleService.select(id) == null && m3ByCodes == null) {
			//	添加
			model.setUpdateBy(username);
			model.setUpdateTime(date);
			model.setCreateTime(date);
			return FmtEmpty.isEmpty(saleService.insert(model)) ? 1 : 0;//	添加成功 0  添加失败1
		}else if(saleService.select(id) == null && m3ByCodes != null) {
			Integer v = model.getVolume() + m3ByCodes.getVolume();
			model.setUpdateBy(username);
			model.setUpdateTime(date);
			model.setVolume(v);
			model.setId(m3ByCodes.getId());
			saleService.updateActive(model);
			return 3;//	在原有的基础上修改数量 3
		}else if(saleService.select(id) != null) {
			//	修改			
			model.setUpdateBy(username);
			model.setUpdateTime(date);
			return saleService.updateActive(model) + 1;//	修改成功2
		}else {
			return 4;//	操作失败
		}
	}

	@ResponseBody
	@RequestMapping(value="/selectDel",produces="text/html;charset=UTF-8")
	public String selectDel() {
		SaleModel model = new SaleModel();
		model.setDeleted(1);
		List<SaleModel> list = saleService.selectAll(model);
		Map<String, Object> map = new HashMap<String, Object>();
	    map.put("list", list);
	    return new JSONObject(map).toString();
	}
	
	@ResponseBody
	@RequestMapping("/toTrach")
	public int toTrach(String id) {
		SaleModel model = new SaleModel();
		Integer id2 = Integer.parseInt(id);
		model.setId(id2);
		model.setDeleted(1);
		return saleService.update(model);
	}
	
	@ResponseBody
	@RequestMapping("/back")
	public int back(String code) {
		SaleModel model = new SaleModel();
		Integer id2 = Integer.parseInt(code);
		model.setId(id2);
		model.setDeleted(0);
		return saleService.update(model);
	}
	
	@ResponseBody
	@RequestMapping("/delCompletely")
	public int delCompletely(String code) {
		return saleService.delete(code);
	}
	
	@ResponseBody
	@RequestMapping("/toTrachBatch")
	public int toTrachBatch(String ids) {
		ids = ids.substring(0, ids.length()-1);
		for(String id : ids.split(",")) {
			Integer id2 = Integer.parseInt(id);
			saleService.updateBatch(id2);
		}
		return 1;//	执行完成
	}
	
	@ResponseBody
	@RequestMapping(value="/selectVolume",produces="text/html;charset=UTF-8")
	public String selectVolume() {
		List<SaleModel> list = saleService.selectVolume();
		Map<String, Object> map = new HashMap<String, Object>();
	    map.put("list", list);
	    return new JSONObject(map).toString();
	}	
	
	@RequestMapping("/exportExcel")
	public void exportExcel(HttpServletResponse response ,  SaleModel model) throws Exception {		
		model.setPageLimit(1000);
		model.setDeleted(0);//	仅打印出未被删除的数据
		List<SaleModel> dataList = saleService.selectAll(model);
		List<String> propList = Arrays.asList("userName" , "custName" , "mdseCode" , "volume" , "createTime" , "updateBy" , "updateTime");
		List<String> fieldName = Arrays.asList("用户" , "客户" , "商品" , "销量" , "创建时间" , "操作人" , "操作时间");		
		Workbook wb = FmtPOI.exportExcel(dataList, propList, fieldName);				
		response.setContentType("multipart/form-data");		
		String fileName = "销售信息表.xlsx";
		response.setHeader("Content-Disposition", "attachment;filename="+new String(fileName.getBytes("UTF-8"),"ISO8859-1"));		
		OutputStream out = response.getOutputStream();
		wb.write(out);
		wb.close();
		out.close();
	}
	
}
