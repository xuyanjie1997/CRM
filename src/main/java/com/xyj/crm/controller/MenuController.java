package com.xyj.crm.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.xyj.crm.model.MenuModel;
import com.xyj.crm.service.MenuService;
import com.xyj.util.FmtEmpty;

@Controller
@RequestMapping("/menu")
public class MenuController {

	@Autowired
	private MenuService<MenuModel> menuService;
	
	@ResponseBody
	@RequestMapping(value="/selectList" , produces="text/html;charset=UTF-8")
	public String selectList(MenuModel mm) {
		String code = "%" + mm.getCode() + "%" ;
		String name = "%" + mm.getName() + "%" ;
		MenuModel model = new MenuModel();
		model.setCode(code);
		model.setName(name);
		model.setPageIndex(mm.getPageIndex());
		model.setPageLimit(mm.getPageLimit());
		model.setPageOn(true);
		model.setOrderby("parent_code");
		List<MenuModel> list = menuService.selectModel(model);
		Map<String, Object> map = new HashMap<String, Object>();
	    map.put("data", list);
	    map.put("code", 0);
	    map.put("count", menuService.selectCount(model));
	    return new JSONObject(map).toString();
	}
	
	@RequestMapping("/addorupd")
	public String addorupd(Model model , String code) {
		if(!FmtEmpty.isEmpty(code)) {
			model.addAttribute("model",menuService.select(code));
		}
		model.addAttribute("upMenu", menuService.selectUpMenu());
		return "web/page/user/menuaddorupd";		
	}
	
	@ResponseBody
	@RequestMapping("/save")
	public int save(MenuModel mm) {
		String code=  mm.getCode();
		String parentCode = mm.getParentCode();
		if(menuService.select(code) == null) {
			//	添加
			if(parentCode.equals("00")) {
				mm.setType(1);
			}else if(parentCode.equals("zz")) {
				mm.setType(0);
			}else {
				mm.setType(2);
			}
			return insertIfNotExist(mm);
		}else if(menuService.select(code) != null) {
			return menuService.updateActive(mm) + 2;
		}else {			
			return 9;
		}
	}

	private int insertIfNotExist(MenuModel model) {
		String code = model.getCode();
		if(menuService.select(code) == null) {
			return FmtEmpty.isEmpty(menuService.insert(model)) ? 4 : 0;
		}
		return 1;
	}
	
	@ResponseBody
	@RequestMapping("/del")
	public int del(MenuModel model) {
		String code = model.getCode();
		MenuModel mm = new MenuModel();
		mm.setParentCode(code);
		int count = menuService.selectCount(mm);
		if(count != 0) {
			return 2;
		}else {			
			return menuService.delete(model.getCode());
		}
	}
	
}
