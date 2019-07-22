package com.xyj.util;

import java.lang.reflect.Method;
import java.util.List;

import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

public class FmtPOI {

    public static Workbook exportExcel(List<?> dataList, List<String> propList, List<String> fieldName)
            throws Exception {
        XSSFWorkbook workbook = new XSSFWorkbook();
        XSSFSheet sheet = workbook.createSheet("list");
        XSSFRow row = sheet.createRow(0);
        for (int i = 0; i < fieldName.size(); i++) {
            row.createCell(i).setCellValue(fieldName.get(i));
        }
        
//        Class<? extends Object> c = dataList.get(0).getClass()       
//        for (int i = 0; i < dataList.size(); i++) {
//            Object obj = dataList.get(i);
//            row = sheet.createRow(i + 1);
//            for (int k = 0; k < propList.size(); k++) {
//                Field f = c.getDeclaredField(propList.get(k));
//                f.setAccessible(true);
//                row.createCell(k).setCellValue(f.get(obj).toString());
//            }
//        }
        
        if( !FmtEmpty.isEmpty(dataList) ) {       	
        	for (int i = 0; i < dataList.size(); i++) {
        		Object obj = dataList.get(i);
        		Class<? extends Object> clazz = obj.getClass();
        		row = sheet.createRow(i + 1);
        		for (int k = 0; k < propList.size(); k++) {
        			String prop = propList.get(k);
        			String tt = prop.substring(0, 1).toUpperCase();
        			tt += prop.substring(1);
        			Method code = clazz.getMethod("get" + tt);
        			Object val = code.invoke(obj);
        			row.createCell(k).setCellValue(val == null ? "" : val.toString());
        		}
        	}
        }
      
        return workbook;
    }

}
