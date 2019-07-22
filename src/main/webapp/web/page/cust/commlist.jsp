<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/web/header.jsp"%>
<title>沟通信息</title>
</head>
<body>

<div class="layui-collapse">
  <div class="layui-colla-item">
    <h2 class="layui-colla-title">沟通详细信息-查询条件</h2>
    <div class="layui-colla-content layui-show">
	<fieldset class="layui-elem-field layui-field-title" style="margin-top: 0px; padding: 5px">
		<legend>沟通详细信息-查询条件</legend>
		<form class="layui-form">
			<div class="layui-form-item">
				<label class="layui-form-label">员工账号</label>
				<div class="layui-input-inline">
					<input type="text" name="userCode" placeholder="请输入员工账号" autocomplete="off" class="layui-input">
				</div>
				<label class="layui-form-label">顾客编号</label>
				<div class="layui-input-inline">
					<input type="text" name="custCode" placeholder="请输入顾客编号" autocomplete="off" class="layui-input">
				</div>
			</div>
			
			<div class="layui-form-item">
				<span> 
				<button type="button" class="layui-btn" onclick="refresh()">
					<i class="layui-icon">&#xe615;</i>查询
				</button>				
				<button type="reset" class="layui-btn">
					<i class="layui-icon">&#xe669;</i>重置
				</button>
				<button type="button" class="layui-btn" onclick="openAdd()">
					<i class="layui-icon">&#xe608;</i>添加
				</button>
				<button type="button" class="layui-btn" onclick="exportExcel()" >
					<i class="layui-icon">&#xe62d;</i>导出表格
				</button>   
				<button type="button" class="layui-btn" onclick="deleted()">
					<i class="layui-icon">&#xe640;</i>回收站
				</button>  
				</span>
			</div>
			
				<input type="hidden" name="pageIndex" value="1" />
				<input type="hidden" name="pageLimit" value="10" />
			</form>
		</fieldset>
		</div>
	</div>
</div>

<table class="layui-hide" id="test" lay-filter="test"></table> 

<script type="text/javascript" src="<%=path%>/layui/layui.all.js"></script>

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
		    ,url:'/CRM/comm/selectList'
		    ,toolbar: '#toolbarDemo'
		    ,title: '客户信息表'
		    ,where: {name:$("input[name='name']").val() , code: $("input[name='code']").val() , deleted:0} 
		    ,request: {
		    	pageName: 'pageIndex' //	页码的参数名称，默认：page
		    	,limitName: 'pageLimit' //	每页数据量的参数名，默认：limit
		    } 
		    ,cols: [[
		      {type: 'checkbox', fixed: 'left'}
		      ,{type:'numbers', title:'序号', width:80 , fixed: 'left', unresize: true}
		      ,{field:'userCode', title:'员工编号', width:100 }
		      ,{field:'userName', title:'员工姓名', width:120 }
		      ,{field:'custCode', title:'顾客编号',merge: 'custCode', width:100 }
		      ,{field:'custName', title:'顾客姓名',merge: 'custName', width:120 }
		      ,{field:'createTime', title:'创建时间', width:200, sort: true}
		      ,{field:'descr', title:'沟通内容', width:300, sort: true}
		      ,{fixed: 'right', title:'操作', toolbar: '#barDemo', width:150 , fixed: 'right'}
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
		      break;
		    };
		  });
	});
}

function del(id){
	openConfirm(function(index){
		ajax("/comm/toTrach" , {id:id} , "text" , function(data){
			if(data == 1){
				layer.msg("数据已被删除，您可以在回收站找到它们！");
				refresh();
			}else{
				layer.msg("操作失败！")
			}
		})
	})
}

//添加
function openAdd(){
	openLayer('/comm/addorupd',refresh)
}

//	修改
function openUpd(id){
	openLayer('/comm/addorupd?code='+id,refresh)
}

function exportExcel(){
	location.href="/CRM/comm/exportExcel";
}


function deleted(){
	openLayer('/web/page/cust/commdeleted.jsp',refresh)
}

function delBatch(ids){
	openConfirm(function(index){
		ajax("/comm/toTrachBatch" , {ids:ids} , "text" , function(data){
			if(data == 1){
				layer.msg("选中的数据已全部被删除，您可以在回收站找到它们！");
				refresh();
			}else{
				layer.msg("操作失败！")
			}
		})
	})
}

</script>

<script type="text/html" id="barDemo">
	<a class="layui-btn layui-btn-sm" href="javascript:openUpd('{{ d.id }}')"> 编辑</a>
  <a class="layui-btn layui-btn-sm layui-btn-radius layui-btn-danger" href="javascript:del('{{ d.id }}')"> 删除</a>
</script>

</body>
</html>