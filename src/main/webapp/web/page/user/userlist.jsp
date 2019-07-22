<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/web/header.jsp"%>
<title>员工信息</title>
</head>
<body>

<div class="layui-collapse">
  <div class="layui-colla-item">
    <h2 class="layui-colla-title">员工详细信息-查询条件</h2>
    <div class="layui-colla-content layui-show">
	<fieldset class="layui-elem-field layui-field-title" style="margin-top: 0px; padding: 5px">
		<legend>员工详细信息-查询条件</legend>
		<form class="layui-form">
			<div class="layui-form-item">
				<label class="layui-form-label">账号</label>
				<div class="layui-input-inline">
					<input type="text" name="code" placeholder="请输入员工账号" autocomplete="off" class="layui-input">
				</div>
				<label class="layui-form-label">姓名</label>
				<div class="layui-input-inline">
					<input type="text" name="name" placeholder="请输入员工姓名" autocomplete="off" class="layui-input">
				</div>
				<label class="layui-form-label">角色</label> 
				<div class="layui-input-inline">
					<select name="roleCode">

					</select>
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

init();
refresh();

//	取出查询条件中角色下拉框中的内容
function init(){
	ajax("/role/selectList",{code:'' , name:''},"json",function(data){
  	var html = "<option value=''></option>";
  	$.each(data.data,function(i,d){		
  		html += laytpl($('#opt1').html()).render(d); 
  	})
  	$("select[name='roleCode']").html(html);
  	form.render()
  })
}

//	执行一次查询，将结果显示再表格中
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
		    ,url:'/CRM/user/selectList'
		    ,toolbar: '#toolbarDemo'
		    ,title: '职工信息表'
		    ,where: {
				name:$("input[name='name']").val() 
				,code: $("input[name='code']").val()
				,roleCode: $("select[name='roleCode']").val()
			} 
		    ,request: {
		    	pageName: 'pageIndex' //	页码的参数名称，默认：page
		    	,limitName: 'pageLimit' //	每页数据量的参数名，默认：limit
		    } 
		    ,cols: [[
		      {type: 'checkbox', fixed: 'left'}
		      ,{type:'numbers', title:'序号', width:100, fixed: 'left', unresize: true}
		      ,{field:'code', title:'账号', width:150}
		      ,{field:'name', title:'姓名', width:150}
		      ,{field:'roleCode', title:'角色编号', width:100, merge: 'roleCode',sort: true}
		      ,{field:'roleName', title:'角色名', width:150, merge: 'roleCode',sort: true , templet:function(d){return d.roleModel.name}}
		      ,{field:'parentCode', title:'上级', width:100, merge: 'parentCode' , sort: true}
		      ,{field:'parentName', title:'上级', width:150, merge: 'parentCode' , sort: true}
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

//	添加
function openAdd(){
	openLayer('/user/addorupd',refresh)
}

//	修改
function openUpd(code){
	openLayer('/user/addorupd?code='+code,refresh)
}

//	删除
function del(code){
	openConfirm(function(index){
		ajax('/user/del', {code:code}, 'text', function(data){
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

//	修改密码
function openPass(code){
	openLayer('/web/page/user/updpass.jsp?code='+code,refresh)
}

</script>
 
<script type="text/html" id="barDemo">
  <a class="layui-btn layui-btn-sm" href="javascript:openUpd('{{ d.code }}')"> 编辑</a>
  <a class="layui-btn layui-btn-danger layui-btn-sm" href="javascript:del('{{ d.code }}')"> <i class="layui-icon layui-icon-delete"></i> </a></a>
  <a class="layui-btn layui-btn-sm" href="javascript:openPass('{{ d.code }}')"> 修改密码</a>
</script>
<script type="text/html" id="opt1" >
  <option value='{{d.code}}'>{{d.name}}</option>
</script>
</body>
</html>