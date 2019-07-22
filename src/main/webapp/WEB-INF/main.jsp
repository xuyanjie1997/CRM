<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/web/header.jsp"%>
<title>主页</title>
</head>
<body class="layui-layout-body">
	<div class="layui-layout layui-layout-admin">
		<div class="layui-header">
			<div class="layui-logo">企业管理系统</div>
			<ul class="layui-nav layui-layout-left"></ul>
			<ul class="layui-nav layui-layout-right">
				<li class="layui-nav-item">
				    <a href="javascript:;"> 
				        <img src="<%=path%>/img/timg.jpg"
				        class="layui-nav-img"/>用户[${user.name}]
				    </a>
					<dl class="layui-nav-child">
						<dd>
							<a href="javascript:openUser('${user.code}')">我的资料</a>
						</dd>
						<dd>
							<a href="javascript:openPass('${user.code}')">修改密码</a>
						</dd>
					</dl>
				</li>
				<li class="layui-nav-item">
				    <a href="javascript:logout()">注销</a>
				</li>
			</ul>
		</div>

		<div class="layui-side layui-bg-black">
			<div class="layui-side-scroll">
				<!-- 左侧导航区域（可配合layui已有的垂直导航） -->

				<ul class="layui-nav layui-nav-tree" >
					<li class="layui-nav-item ">
					    <a href="javascript:;">导航</a>
						<dl class="layui-nav-child">
							<dd>
								<a href="javascript:;" data-url=""
								class="site-demo-active">子导航一</a>				
							</dd>
							<dd>
								<a href="javascript:;" data-url="/web/page/user/dictionary.jsp"
								class="site-demo-active">字典表</a>				
							</dd>
						</dl>
					</li>
					
					<c:forEach items="${menus}" var = "l">
						<li class="layui-nav-item layui-nav-itemed">
					    <a href="javascript:;">${l.name}</a>
						<dl class="layui-nav-child">
							<c:forEach items="${l.child}" var = "l2">
								<dd>
									<a href="javascript:;" data-url="${l2.url}"
									class="site-demo-active">${l2.name}</a>				
								</dd>
							</c:forEach>
						</dl>
					</li>
					</c:forEach>
					
				</ul>
			</div>
		</div>
		<div class="layui-body"><!-- 内容主体区域 -->
			<iframe name="rightframe" width="99%" height="98%" src=""></iframe>
		</div>
		<div class="layui-footer">© 鲁ICP证110507号 鲁ICP备10046444号 鲁公网安备11010802020134号 鲁网文[2019]0059-0009号</div>
	</div>
<script type="text/javascript" src="<%=path%>/layui/layui.all.js"></script>
<script>

	refresh();
	function refresh() {
		$('.site-demo-active').click(function() {
			window.open(con.app + $(this).data('url'), "rightframe");
		});
	}

	function openURL(url) {
		window.open(con.app + url, "rightframe");
	}

	function openPass(code) {
		openLayer('/web/page/user/updpass.jsp?code=' + code , refresh)
	}

	function openUser(code) {
		openLayer('/web/page/user/userdetail.jsp?code=' + code , refresh)
	}
	
	function logout() {
		openConfirm(function(index) {
			layer.close(index);
			toJsp("/user/logout");
		}, '注销当前用户?');
	}
</script>
</body>
</html>