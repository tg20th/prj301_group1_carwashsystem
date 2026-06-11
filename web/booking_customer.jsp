<%-- 
    Document   : booking_customer
    Created on : Jun 11, 2026, 2:41:21 PM
    Author     : PC
--%>
<%@page import="dto.Account"%>
<%
    Account acc = (Account) request.getSession().getAttribute("ACCOUNT");
    if (acc == null) {
        response.sendRedirect("MainController");
    } else {
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Booking Service</title>
    </head>
    <body>
        <div>
            <h1>Booking Car Wash</h1>
            <small>Please enter all information below</small>
            <form>
                <select>

                </select>
            </form>
        </div>
    </body>
</html>
<%
    }
%>
