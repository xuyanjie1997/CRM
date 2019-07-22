<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/web/header.jsp"%>
<script type="text/javascript" src="/CRM/web/page/user/module/tableMerge.js"></script>
<title>权限信息</title>
</head>
<body>
<div class="layui-collapse">
  <div class="layui-colla-item">
    <h2 class="layui-colla-title">权限详细信息-查询条件</h2>
    <div class="layui-colla-content layui-show">
	<fieldset class="layui-elem-field layui-field-title" style="margin-top: 0px; padding: 5px">
		<legend>权限详细信息-查询条件</legend>
		<form class="layui-form">
			<div class="layui-form-item">
				<label class="layui-form-label">角色编号</label>
				<div class="layui-input-inline">
					<input type="text" name="roleCode" placeholder="请输入角色编号" autocomplete="off" class="layui-input">
				</div>
				<label class="layui-form-label">菜单编号</label>
				<div class="layui-input-inline">
					<input type="text" name="menuCode" placeholder="请输入菜单编号" autocomplete="off" class="layui-input">
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
				<button type="button" class="layui-btn" value="添加" onclick="openAdd()">
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
<script type="text/javascript" src="/CRM/web/page/user/module/tableMerge.js"></script>

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
		    ,url:'/CRM/rel/selectList'
		    ,toolbar: '#toolbarDemo'
		    ,title: '职工信息表'
		    ,where: {roleCode:$("input[name='roleCode']").val() , menuCode: $("input[name='menuCode']").val()} 
		    ,request: {
		    	pageName: 'pageIndex' //	页码的参数名称，默认：page
		    	,limitName: 'pageLimit' //	每页数据量的参数名，默认：limit
		    } 
		    ,cols: [[
		      {type: 'checkbox', fixed: 'left'}
		      ,{type:'numbers', title:'序号', width:100, fixed: 'left', unresize: true}
		      ,{field:'roleCode', title:'角色编号', merge: 'roleCode', width:150, sort: true}
		      ,{field:'roleName', title:'角色名称', merge: 'roleCode',width:150, sort: true, templet:function(d){return d.roleModel.name} }
		      ,{field:'menuCode', title:'菜单编号', width:150,sort: true}
		      ,{field:'menuName', title:'菜单名称', width:150, sort: true,templet:"<div>{{ d.menuModel.name }}</div>"}
		      ,{fixed: 'right', title:'操作', toolbar: '#barDemo', width:250 , fixed: 'right'}
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
	openLayer('/rel/addorupd',refresh)
}

function openUpd(id){
	openLayer('/rel/addorupd?code='+id,refresh)
}

function del(id){
	openConfirm(function(index){
		ajax('/rel/del', {relId:id}, 'text', function(data){
	        if (data == 1) {
	            layer.msg('删除成功');
	            $("input[name='pageIndex']").val(1);
	            refresh();
	        } else{
	        	layer.msg('删除失败');
	        }
	    })
	})
}

</script>
 
<script type="text/html" id="barDemo">
  <a class="layui-btn layui-btn-sm" href="javascript:openUpd('{{ d.id }}')"> 编辑</a>
  <a class="layui-btn layui-btn-danger layui-btn-sm" href="javascript:del('{{ d.id }}')"> <i class="layui-icon layui-icon-delete"></i></a>
</script>

</body>
</html>