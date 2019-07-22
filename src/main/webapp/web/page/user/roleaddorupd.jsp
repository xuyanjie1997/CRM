<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/web/header.jsp"%>
<title>角色信息</title>
</head>
<body>

<fieldset class="layui-elem-field" style="margin: 20px;padding:15px;">
   <legend>角色信息--维护信息</legend>
    
    <form class="layui-form" method="post">	
        
		<div class="layui-form-item">
			<span class="layui-form-label">角色编号</span>
			<div class="layui-input-inline">
 				<input type="text" name="code" required placeholder="请输入编号" autocomplete="off"
                    class="layui-input">
			</div>
		</div>

		<div class="layui-form-item">
            <label class="layui-form-label">角色姓名</label>
            <div class="layui-input-inline">
                <input type="text" name="name" required placeholder="请输入姓名" autocomplete="off"
                    class="layui-input">
            </div>
        </div>		
        
        <div class="layui-form-item">
            <label class="layui-form-label"></label>
            <div class="layui-input-inline">
                <input type="button" class="layui-btn" lay-submit lay-filter="add" value="确定" />
                <input type="button" class="layui-btn" onclick="closeThis()" value="取消" />
            </div>
        </div>
        <input type="hidden" name="ccc" value="${model.code}"  />
    </form>
</fieldset>

<script type="text/javascript">

init();
function  init() {
	var code = $("input[name='ccc']").val();
	if(code != ''){
		$("input[name='code']").val("${model.code}");
		$("input[name='code']").prop("readonly",true);
		$("input[name='name']").val("${model.name}");
		form.render()

	}
}

form.render()

formSubmit('/role/save', 'submit(add)', 'text', function(data) {
	if (data == 0) {
        layer.msg('添加成功');
        closeThis(3000);
    } else if (data == 1) {
        layer.msg('用户已存在');
    } else if(data == 2){
        layer.msg('修改失败');
    }else if(data == 3){
    	layer.msg('修改成功');
    	closeThis(3000);
    }else if(data == 4){
    	layer.msg('添加失败');
    }else{
    	layer.msg('操作出现异常');
    }
});

</script>

</body>
</html>