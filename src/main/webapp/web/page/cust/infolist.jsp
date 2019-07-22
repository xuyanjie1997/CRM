<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/web/header.jsp"%>
<title>客户详细信息</title>
</head>
<body>

<div class="layui-collapse">
  <div class="layui-colla-item">
    <h2 class="layui-colla-title">客户详细信息-查询条件</h2>
    <div class="layui-colla-content layui-show">
	<fieldset class="layui-elem-field layui-field-title" style="margin-top: 0px; padding: 5px">
		<legend>客户详细信息-查询条件</legend>
		<form class="layui-form">
			<div class="layui-form-item">
				<label class="layui-form-label">编号</label>
				<div class="layui-input-inline">
					<input type="text" name="code" placeholder="请输入客户编号" autocomplete="off" class="layui-input">
				</div>
				<label class="layui-form-label">姓名</label>
				<div class="layui-input-inline">
					<input type="text" name="name" placeholder="请输入客户姓名" autocomplete="off" class="layui-input">
				</div>
				<label class="layui-form-label">邮箱</label>
				<div class="layui-input-inline">
					<input type="text" name="email" placeholder="请输入邮箱" autocomplete="off" class="layui-input">
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
				<button type="button" class="layui-btn" onclick="deleted()">
					<i class="layui-icon">&#xe640;</i>回收站
				</button> 
				</span>
			</div>
			<div class="layui-form-item">
				<span> 
				<button type="button" class="layui-btn" onclick="exportExcel()">
					<i class="layui-icon">&#xe62d;</i>导出表格
				</button>
				<button type="button" class="layui-btn" onclick="exportTemp()" >
					<i class="layui-icon">&#xe663;</i>下载模板
				</button> 
				<button type="button" class="layui-btn" id="upl">
					<i class="layui-icon">&#xe67c;</i>上传文件
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

<script type="text/javascript" src="<%=path%>/layui/layui.js"></script>

<script type="text/html" id="toolbarDemo">
  <div class="layui-btn-container">
    <button class="layui-btn layui-btn-sm" lay-event="delBatch">删除选中条目</button>
  </div>
</script>

<script type="text/javascript">

refresh();
function refresh(){
	layui.use('table', function(){
		  var table = layui.table;
		  
		  table.render({
		    elem: '#test'
		    ,url:'/CRM/info/selectList'
		    ,toolbar: '#toolbarDemo'
		    ,title: '客户信息表'
		    ,where: {
			    name:$("input[name='name']").val() 
			    ,code: $("input[name='code']").val() 
			    ,email : $("input[name='email']").val() 
			    ,deleted:0 
			} 
		    ,request: {
		    	pageName: 'pageIndex' //	页码的参数名称，默认：page
		    	,limitName: 'pageLimit' //	每页数据量的参数名，默认：limit
		    } 
		    ,cols: [[
		      {type: 'checkbox', fixed: 'left'}
		      ,{type:'numbers', title:'序号', width:80, fixed: 'left', unresize: true}
		      ,{field:'code', title:'账号', width:100 , align: 'center'}
		      ,{field:'name', title:'姓名', width:100, sort: true , align: 'center'}
		      ,{field:'email', title:'邮箱', width:190}
		      ,{field:'createTime', title:'创建时间', width:190}
		      ,{field:'createBy', title:'创建人', width:100, sort: true}
		      ,{field:'updateTime', title:'更新时间', width:190, sort: true}
		      ,{field:'updateBy', title:'操作人', width:100, sort: true}
		      ,{fixed: 'right', title:'操作', toolbar: '#barDemo', width:220 , fixed: 'right'}
		    ]]
		    ,page: true
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

function openAdd(){
	openLayer('/info/addorupd',refresh)
}

function openUpd(code){
	openLayer('/info/addorupd?code='+code,refresh)
}

function openEmail(email,code){
	openLayer('/web/page/cust/email.jsp?email='+email+"&code="+code,refresh)
}

function del(code){
	openConfirm(function(index){
		ajax("/info/toTrach" , {id:code} , "text" , function(data){
			if(data == 1){
				layer.msg("数据已被删除，您可以在回收站找到它们！");
				refresh();
			}else{
				layer.msg("操作失败！")
			}
		})
	})
}

function exportExcel(){
	location.href="/CRM/info/exportExcel";
}

function exportTemp(){
	location.href="/CRM/info/exportTemp";
}

layui.use('upload', function(){
    var upload = layui.upload;

    upload.render({
    	elem:"#upl"
    	,url:"/CRM/info/uploadExcel"
    	,accept:"file"
    	,exts:"xls|xlsx"
    	,done:function(res){
    		layer.msg("上传成功！");
    		refresh();
    	}
    	,error:function(index){
    		layer.msg("上传失败，请按照模板正确上传！");
    	}
  	})
});

function deleted(){
	openLayer('/web/page/cust/deleted.jsp',refresh)
}

function delBatch(ids){
	openConfirm(function(index){
		ajax("/info/toTrachBatch" , {ids:ids} , "text" , function(data){
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
  <a class="layui-btn layui-btn-sm" href="javascript:openUpd('{{ d.code }}')"> 编辑</a>
  <a class="layui-btn layui-btn-danger layui-btn-sm" href="javascript:del('{{ d.code }}')"> <i class="layui-icon layui-icon-delete"></i> </a></a>
  <a class="layui-btn layui-btn-sm" href="javascript:openEmail('{{ d.email }}','{{ d.code }}')"> 联系客户</a>
</script>
	

</body>
</html>