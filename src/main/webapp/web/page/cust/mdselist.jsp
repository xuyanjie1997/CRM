<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/web/header.jsp"%>
<title>商品详细信息</title>
</head>
<body>

<div class="layui-collapse">
  <div class="layui-colla-item">
    <h2 class="layui-colla-title">商品详细信息-查询条件</h2>
    <div class="layui-colla-content layui-show">
	<fieldset class="layui-elem-field layui-field-title" style="margin-top: 0px; padding: 5px">
		<legend>商品详细信息-查询条件</legend>
		<form class="layui-form">
			<div class="layui-form-item">
				<label class="layui-form-label">编号</label>
				<div class="layui-input-inline">
					<input type="text" name="code" placeholder="请输入商品编号" autocomplete="off" class="layui-input">
				</div>
				<label class="layui-form-label">姓名</label>
				<div class="layui-input-inline">
					<input type="text" name="name" placeholder="请输入商品名" autocomplete="off" class="layui-input">
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
				<button type="button" class="layui-btn" onclick="stat()">
					<i class="layui-icon">&#xe60e;</i>库存统计
				</button>
				<button type="button" class="layui-btn" onclick="price()">
					<i class="layui-icon">&#xe65e;</i>价格一览
				</button>
				</span>
			</div>
			<div class="layui-form-item">
				<span> 
				<button type="button" class="layui-btn" onclick="find()">
					<i class="layui-icon">&#xe615;</i>检索商品
				</button>
				<button type="button" class="layui-btn" onclick="exportExcel()" >
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
		    ,url:'/CRM/mdse/selectList'
		    ,toolbar: '#toolbarDemo'
		    ,title: '客户信息表'
		    ,where: {name:$("input[name='name']").val() , code: $("input[name='code']").val() , deleted:0} 
		    ,request: {
		    	pageName: 'pageIndex' //	页码的参数名称，默认：page
		    	,limitName: 'pageLimit' //	每页数据量的参数名，默认：limit
		    } 
		    ,cols: [[
		      {type: 'checkbox', fixed: 'left'}
		      ,{type:'numbers', title:'序号', width:80, fixed: 'left', unresize: true}
		      ,{field:'code', title:'编号', width:100 ,sort: true}
		      ,{field:'name', title:'商品名', width:160}
		      ,{field:'cost', title:'价格', width:120, sort: true ,templet: function(d){
		    	  return tttt(d);
			    }}
		      ,{field:'num', title:'库存', width:80, sort: true}
		      ,{field:'createTime', title:'创建时间', width:190, sort: true}
		      ,{field:'createBy', title:'创建人', width:100, merge: 'createBy', sort: true}
		      ,{field:'updateTime', title:'更新时间', width:190, sort: true}
		      ,{field:'updateBy', title:'操作人', width:100, merge: 'updateBy',sort: true}
		      ,{fixed: 'right', title:'操作', toolbar: '#barDemo', width:160 , fixed: 'right'}
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
					if(data.length != 0){
						var ids = '';
						$.each(data , function(i,dom){
							ids += dom.id + ",";
						})
			   			delBatch(ids);
					}else{
						delNull();
					}
		     	 break;
		   	 };
		});
	});
}

function tttt (d){
		if (d.cost !== '' && d.cost != null)
			if(d.cost === 0)  //当为0时，不用处理
				return 0 ;
			else  
	   			return parseFloat(d.cost).toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, '$1,');
		 else 
		    return '';
   
}
function openAdd(){
	openLayer('/mdse/addorupd',refresh)
}

function openUpd(code){
	openLayer('/mdse/addorupd?code='+code,refresh)
}

function deleted(){
	openLayer('/web/page/cust/mdsedeleted.jsp',refresh)
}

function del(code){
	openConfirm(function(index){
		ajax("/mdse/toTrach" , {id:code} , "text" , function(data){
			if(data == 1){
				layer.msg("数据已被删除，您可以在回收站找到它们！");
				refresh();
			}if(data == 2){
				layer.msg("您无权删除！");
			}else{
				layer.msg("操作失败！");
			}
		})
	})
}

function delBatch(ids){
	openConfirm(function(index){
		ajax("/mdse/toTrachBatch" , {ids:ids} , "text" , function(data){
			if(data == 1){
				layer.msg("选中的数据已全部被删除，您可以在回收站找到它们！");
				refresh();
			}if(data == 2){
				layer.msg("您无权删除！");
			}else{
				layer.msg("操作失败！")
			}
		})
	})
}

function delNull(){
	layer.msg("您未选择任何数据");
}

layui.use('upload', function(){
    var upload = layui.upload;

    upload.render({
    	elem:"#upl"
    	,url:"/CRM/mdse/uploadExcel"
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

function exportExcel(){
	location.href="/CRM/mdse/exportExcel";
}

function exportTemp(){
	location.href="/CRM/mdse/exportTemp";
}

function stat(){
	openLayer('/mdse/stat',refresh)
}

function price(){
	openLayer('/mdse/price',refresh)
}
function find(){
	openLayer('/mdse/tofind',refresh)
}

</script>

<script type="text/html" id="barDemo">
  <a class="layui-btn layui-btn-sm" href="javascript:openUpd('{{ d.code }}')"> 编辑</a>
  <a class="layui-btn layui-btn-danger layui-btn-sm" href="javascript:del('{{ d.code }}')"> <i class="layui-icon layui-icon-delete"></i> </a>
</script>

</body>
</html>