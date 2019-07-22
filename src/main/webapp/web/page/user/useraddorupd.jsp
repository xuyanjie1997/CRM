<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/web/header.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%> 
<title>员工信息维护</title>
</head>
<body>

<fieldset class="layui-elem-field" style="margin: 20px;padding:15px;">
   <legend>员工信息--维护信息</legend>
    
    <form class="layui-form" method="post">

        
        <div class="layui-form-item">
            <label class="layui-form-label">上级</label>
            <div class="layui-input-inline">
                <select name="parentCode">
                	<option value='' id="def"></option>
                 	<c:forEach items="${role}" var="item">
						<option value='${item.code}'>${item.name}</option>
					</c:forEach>
                </select>
            </div>
        </div>	
        
		<div class="layui-form-item">
			<span class="layui-form-label">员工编号</span>
			<div class="layui-input-inline">
 				<input type="text" name="code" lay-verify="required" placeholder="请输入编号" autocomplete="off"
                    class="layui-input">
			</div>
			 <div class="layui-form-mid layui-word-aux">员工默认密码：123456</div>
		</div>

		<div class="layui-form-item">
            <label class="layui-form-label">员工姓名</label>
            <div class="layui-input-inline">
                <input type="text" name="name" lay-verify="required" placeholder="请输入姓名" autocomplete="off"
                    class="layui-input">
            </div>
        </div>
       
        <div class="layui-form-item">
            <label class="layui-form-label">员工角色</label>
            <div class="layui-input-inline">
                <select name="roleCode">
                <option value=''></option>
                 	<c:forEach items="${role}" var="item">
						<option value='${item.code}'>${item.name}</option>
					</c:forEach>
                </select>
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
		$("select[name='parentCode']").val("${model.parentCode}");
		$("input[name='code']").val("${model.code}");
		$("input[name='code']").prop("readonly",true);
		$("input[name='name']").val("${model.name}");
		$("select[name='roleCode']").val("${model.roleCode}");
		if("${model.parentCode}" == "0"){
			$("select[name='parentCode']").prop("disabled",true);
			form.render()
		}
	}
}

form.render()

formSubmit('/user/save', 'submit(add)', 'text', function(data) {
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