package com.xyj.crm.mapper;

import com.xyj.base.mapper.BaseMapper;
import com.xyj.crm.model.RelationModel;

public interface RelationMapper<T> extends BaseMapper<T>{

	RelationModel selectByCodes(RelationModel model);

}
