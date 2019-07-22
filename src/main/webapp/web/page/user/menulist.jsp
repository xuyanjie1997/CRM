<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/web/header.jsp"%>
<title>菜单信息</title>
</head>
<body>

<div class="layui-collapse">
  <div class="layui-colla-item">
    <h2 class="layui-colla-title">菜单详细信息-查询条件</h2>
    <div class="layui-colla-content layui-show">
	<fieldset class="layui-elem-field layui-field-title" style="margin-top: 0px; padding: 5px">
		<legend>菜单详细信息-查询条件</legend>
		<form class="layui-form">
			<div class="layui-form-item">
				<label class="layui-form-label">编号</label>
				<div class="layui-input-inline">
					<input type="text" name="code" placeholder="请输入账号" autocomplete="off" class="layui-input">
				</div>
				<label class="layui-form-label">菜单名</label>
				<div class="layui-input-inline">
					<input type="text" name="name" placeholder="请输入菜单名" autocomplete="off" class="layui-input">
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
    <button class="layui-btn layui-btn-sm" lay-event="getCheckData">获取选中行数据</button>
    <button class="layui-btn layui-btn-sm" lay-event="getCheckLength">获取选中数目</button>
    <button class="layui-btn layui-btn-sm" lay-event="isAll">验证是否全选</button>
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
		    ,url:'/CRM/menu/selectList'
		    ,toolbar: '#toolbarDemo'
		    ,title: '菜单信息表'
		    ,where: {name:$("input[name='name']").val() , code: $("input[name='code']").val()} 
		    ,request: {
		    	pageName: 'pageIndex' //	页码的参数名称，默认：page
		    	,limitName: 'pageLimit' //	每页数据量的参数名，默认：limit
		    } 
		    ,cols: [[
		      {type: 'checkbox', fixed: 'left'}
		      ,{type:'numbers', title:'序号', width:100, fixed: 'left', unresize: true}
		      ,{field:'parentCode', title:'上级编号', width:100, merge: 'parentCode',sort: true}
		      ,{field:'parentName', title:'上级名', width:100, merge: 'parentName',sort: true}
		      ,{field:'code', title:'菜单编号', width:100}
		      ,{field:'name', title:'菜单名', width:180}
		      ,{field:'url', title:'路径', width:230, merge: 'url',sort: true}
		      ,{field:'level', title:'菜单级别', width:100, merge: 'level',sort: true}
		      ,{fixed: 'right', title:'操作', toolbar: '#barDemo', width:190 , fixed: 'right'}
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
		    };
		  });
	});
}

function openAdd(){
	openLayer('/menu/addorupd',refresh)
}

function openUpd(code){
	openLayer('/menu/addorupd?code='+code,refresh)
}

function del(code){
	openConfirm(function(index){
		ajax("/menu/del" , {code:code} , "text" , function(data){
			if(data == 1){
				layer.msg("删除成功！");
				refresh();
			}else if(data == 2){
				layer.msg("存在下级目录，无法删除！");
			}else{
				layer.msg("操作失败！")
			}
		})
	})
}

</script>
 
<script type="text/html" id="barDemo">
  <a class="layui-btn layui-btn-sm" lay-event="edit" href="javascript:openUpd('{{ d.code }}')"> 编辑</a>
  <a class="layui-btn layui-btn-danger layui-btn-sm" lay-event="del" href="javascript:del('{{ d.code }}')"> <i class="layui-icon layui-icon-delete"></i> </a></a>
</script>

</body>
</html>