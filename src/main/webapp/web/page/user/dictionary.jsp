<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/web/header.jsp"%>
<title>字典表</title>
</head>
<body>
<table class="layui-hide" id="test" lay-filter="test"></table>
<script type="text/html" id="toolbarDemo">
  <div class="layui-btn-container">
	<button class="layui-btn layui-btn-sm" lay-event="delBatch">删除选中条目</button>
  </div>
</script>

<script type="text/javascript">

refresh();
function refresh(){
	layui.config({
	    base: '/CRM/web/common/js/'
	}).extend({
	    tableMerge: 'tableMerge'
	});
	
	layui.use(['table' , 'tableMerge'], function(){
		  var table = layui.table,
		  tableMerge = layui.tableMerge;
		  
		  table.render({
		    elem: '#test'
		    ,url:'/CRM/dic/selectList'
		    ,toolbar: '#toolbarDemo'
		    ,title: '字典表'
		    ,where: {} 
		    ,request: {
		    	pageName: 'pageIndex' //	页码的参数名称，默认：page
		    	,limitName: 'pageLimit' //	每页数据量的参数名，默认：limit
		    } 
		    ,cols: [[
		      {type: 'checkbox', fixed: 'left'}
		      ,{field:'id', title:'ID', width:80, fixed: 'left', unresize: true, sort: true}
		      ,{field:'code', title:'字典编号', width:100}
		      ,{field:'name', title:'字段名', width:160}
		      ,{field:'descr', title:'描述', width:120, sort: true}
		      ,{field:'parentCode', title:'上级', width:100, sort: true}
		    ]]
		    ,page: true
		    ,done: function () {
		        tableMerge.render(this)
		    }
		  });
		  
		  //	头工具栏事件
		  table.on('toolbar(test)', function(obj){
		    var checkStatus = table.checkStatus(obj.config.id);
		    switch(obj.event){
		      case 'getCheckData':
		        var data = checkStatus.data;
		        layer.alert(JSON.stringify(data));
		      break;
		      case 'getCheckLength':
		        var data = checkStatus.data;
		        layer.msg('选中了：'+ data.length + ' 个');
		      break;
		      case 'isAll':
		        layer.msg(checkStatus.isAll ? '全选': '未全选');
		      break;
		      case 'delBatch':
		    	  var data = checkStatus.data;
		    	  var ids = '';
		    	  $.each(data , function(i,dom){
			    	  ids += dom.id + ",";
			   })
			   delBatch(ids);
		    };
		  });
	});
}

</script>

</body>
</html>