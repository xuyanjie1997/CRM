<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/web/header.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%> 
<title>菜单信息维护</title>
</head>
<body>
<fieldset class="layui-elem-field" style="margin: 20px;padding:15px;">
   <legend>菜单信息--维护信息</legend>
    
    <form class="layui-form" method="post">

			<div class="layui-form-item">
				<span class="layui-form-label">上级编号</span>
				<div class="layui-input-inline">
 					<select name="parentCode">
 						<c:forEach items="${upMenu}" var="item">
							<option value='${item.code}'>${item.name}</option>
						</c:forEach>
 					</select>
				</div>
			</div>

			<div class="layui-form-item">
            <label class="layui-form-label">菜单编号</label>
            <div class="layui-input-inline">
                <input type="text" name="code" lay-verify="required" placeholder="请输入编号" autocomplete="off"
                    class="layui-input">
            </div>
        </div>
       
        <div class="layui-form-item">
            <label class="layui-form-label">菜单名</label>
            <div class="layui-input-inline">
                <input type="text" name="name" placeholder="请输入菜单名" autocomplete="off"
                    class="layui-input">
            </div>
        </div>		
        	
       <div class="layui-form-item">
            <label class="layui-form-label">路径</label>
            <div class="layui-input-inline">
                <input type="text" name="url" placeholder="请输入访问路径" autocomplete="off"
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
		$("input[name='url']").val("${model.url}");
		$("select[name='parentCode']").val("${model.parentCode}");
		if("${model.parentCode}" == "00" || "${model.parentCode}" == "zz"){
			$("select[name='parentCode']").prop("disabled",true);
			$("input[name='url']").val("此级别菜单不存在路径");
			$("input[name='url']").prop("readonly",true);
		}
	}
}

form.render()

formSubmit('/menu/save', 'submit(add)', 'text', function(data) {
	if (data == 0) {
        layer.msg('添加成功');
        closeThis(3000);
    } else if (data == 1) {
        layer.msg('客户已存在');
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