<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/web/header.jsp"%>
<title>修改密码</title>
</head>
<body>

<fieldset class="layui-elem-field" style="margin: 20px;padding:15px;">
        <legend>用户维护--修改密码</legend>
    
    <form class="layui-form" method="post">
        <div class="layui-form-item">
            <label class="layui-form-label">账号</label>
            <div class="layui-input-inline">
                <input type="text" name="code" readonly required placeholder="请输入账号" autocomplete="off"
                    class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">密码</label>
            <div class="layui-input-inline">
                <input type="password" name="password" required placeholder="请输入新密码" autocomplete="off"
                    class="layui-input">
            </div>
        </div>
                <div class="layui-form-item">
            <label class="layui-form-label">确认密码</label>
            <div class="layui-input-inline">
                <input type="password" name="repassword" required placeholder="请输入再次新密码" autocomplete="off"
                    class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label"></label>
            <div class="layui-input-inline">
                <input type="button" class="layui-btn" lay-submit lay-filter="pasUser" value="确定" />
                <input type="button" class="layui-btn" onclick="closeThis()" value="取消" />
                <input type="hidden" name="yonghu" value="${user.code}">
            </div>
        </div>
    </form>
 </fieldset>

 <script type="text/javascript">
    
  $("input[name='code']").val('<%=request.getParameter("code")%>');
  var thiscode =  $("input[name='code']").val();
  var yonghucode = $("input[name='yonghu']").val();
    formSubmit('/user/updpass', 'submit(pasUser)', 'text', function(data) {
    	if (data == 1) {
            layer.msg('修改成功');
            if(yonghucode == thiscode){
            	closeThis();
            	layer.msg('当前用户密码已修改，请重新登录！');
            	parent.parent.location.href="/CRM/web/login.jsp"
                //	top.location.href    parent.location.href
            }else{
            	closeThis(3000);
            }
        }else if(data == 2){
        	layer.msg('两次输入的密码必须一致');
        }else{
        	layer.msg('修改失败');
        }
   });
    
 </script>

</body>
</html>