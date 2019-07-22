package com.xyj.base.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.xyj.base.model.DictionaryModel;
import com.xyj.base.service.DictionaryService;

@Controller
@RequestMapping("/dic")
public class DictionaryController {

	@Autowired
	private DictionaryService<DictionaryModel> dictionaryService;
	
	@ResponseBody
	@RequestMapping(value="/selectList",produces="text/html;charset=UTF-8")
	public String selectList(DictionaryModel um){
		DictionaryModel model = new DictionaryModel();
		model.setDeleted(0);
		model.setPageIndex(um.getPageIndex());
		model.setPageLimit(um.getPageLimit());
		model.setPageOn(true);
		model.setOrderby("code");
		List<DictionaryModel> list = dictionaryService.selectModel(model);	
		Map<String, Object> map = new HashMap<String, Object>();
	    map.put("data", list);
	    map.put("code", 0);
	    map.put("count", dictionaryService.selectCount(model));
	    return new JSONObject(map).toString();
	}
	
}
