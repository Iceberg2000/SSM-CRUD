<%--
  Created by IntelliJ IDEA.
  User: Nauhc
  Date: 2020/2/22
  Time: 14:27
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% pageContext.setAttribute("appPath",request.getContextPath()); %>
<!--
     不以/开始的相对路径，找资源，以当前资源的路径为基准，经常容易出问题
     以/开始的相对路径，找资源，以服务器的路径为标准(http://localhost:8080),需要加上项目名，不会出错
-->
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Title</title>
    <link href="${appPath}/static/css/bootstrap.min.css" rel="stylesheet">
    <script src="${appPath}/static/js/jquery-3.2.1.min.js"></script>
    <script src="${appPath}/static/js/bootstrap.min.js"></script>
</head>
<body>

    <!--页面展示 -->
    <div class="container">
        <!--标题 -->
        <div class="row">
            <h1>SSM-CRUD</h1>
        </div>
        <!--按钮 -->
        <div class="row">
            <div class="col-md-4 col-md-offset-8">
                <button class="btn btn-primary" type="button">新增</button>
                <button class="btn btn-danger" type="button">删除</button>
            </div>
        </div>
        <!--表格 -->
        <div class="row">
            <table class="table table-hover">
                <tr>
                    <th>#</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Gender</th>
                    <th>DepartName</th>
                    <th>Operation</th>
                </tr>
                <c:forEach items="${pageInfo.list}" var="emp">
                    <tr class="success">
                        <td>${emp.empId}</td>
                        <td>${emp.empName}</td>
                        <td>${emp.email}</td>
                        <td>${emp.gender=='m'?'男':'女'}</td>
                        <td>${emp.department.deptName}</td>
                        <td>
                            <button class="btn btn-info" type="button">
                                <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>编辑
                            </button>
                            <button class="btn btn-danger" type="button">
                                <span class="glyphicon glyphicon-trash" aria-hidden="true"></span>删除
                            </button>
                        </td>
                    </tr>
                </c:forEach>
            </table>
        </div>
        <!--分页信息 -->
        <div class="row">
            <div class="col-md-6">
                当前第<font color="red">${pageInfo.pageNum}</font>页，共<font color="red">${pageInfo.pages}</font>页，共<font color="red">${pageInfo.total}</font>条记录
            </div>
            <div class="col-md-6">
                <nav aria-label="Page navigation">
                    <ul class="pagination">
                        <li><a href="${appPath}/emps?pageNum=1">首页</a></li>
                        <c:if test="${pageInfo.hasPreviousPage}">
                            <li>
                                <a href="${appPath}/emps?pageNum=${pageInfo.pageNum-1}" aria-label="Previous">
                                    <span aria-hidden="true">&laquo;</span>
                                </a>
                            </li>
                        </c:if>
                        <c:forEach items="${pageInfo.navigatepageNums}" var="i">
                            <c:if test="${i==pageInfo.pageNum}">
                                <li class="active"><a href="${appPath}/emps?pageNum=${i}">${i}</a></li>
                            </c:if>
                            <c:if test="${i!=pageInfo.pageNum}">
                                <li><a href="${appPath}/emps?pageNum=${i}">${i}</a></li>
                            </c:if>
                        </c:forEach>
                        <c:if test="${pageInfo.hasNextPage}">
                            <li>
                                <a href="${appPath}/emps?pageNum=${pageInfo.pageNum+1}" aria-label="Next">
                                    <span aria-hidden="true">&raquo;</span>
                                </a>
                            </li>
                        </c:if>
                        <li><a href="${appPath}/emps?pageNum=${pageInfo.pages}">末页</a></li>
                    </ul>
                </nav>
            </div>
        </div>
    </div>





</body>
</html>
