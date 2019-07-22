package com.xyj.util;

import java.util.Collection;
import java.util.Map;

public class FmtEmpty {
	
	public static boolean isEmpty(String str) {
		if(str==null||str.trim().isEmpty()) {
			return true;
		}
		return false;
	}

	public static boolean isEmpty(Object obj) {
		if(obj==null||isEmpty(obj.toString())) {
			return true;
		}
		return false;
	}

	public static boolean isEmpty(Map<?,?> map) {
		if(map==null||map.isEmpty()) {
			return true;
		}
		return false;
	}

	public static boolean isEmpty(Collection<?> list) {
		if(list==null||list.isEmpty()) {
			return true;
		}
		return false;
	}

	public static boolean isEmpty(Object[] array) {
		if(array==null||array.length==0) {
			return true;
		}
		return false;
	}

}
