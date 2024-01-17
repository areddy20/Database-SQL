<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    String currentPid = request.getParameter("pid");

    String query = "SELECT passid FROM Passengers WHERE passid <> ? order by 1";
    
    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        String dbUrl = "jdbc:oracle:thin:@artemis.vsnet.gmu.edu:1521/vse18c.vsnet.gmu.edu";
        String dbUsername = "areddy20";
        String dbPassword = "phimsuhi";
        Connection conn = DriverManager.getConnection(dbUrl, dbUsername, dbPassword);
        PreparedStatement stmt = conn.prepareStatement(query);
        stmt.setString(1, currentPid);
        ResultSet rs = stmt.executeQuery();

     
        
        StringBuilder responseBuilder = new StringBuilder();

        while (rs.next()) {
            int passengerId = rs.getInt("passid");
            responseBuilder.append(passengerId).append("#");
        }

        if (responseBuilder.length() > 0) {
            // Remove the last '#' character
            responseBuilder.setLength(responseBuilder.length() - 1);
        }

        out.print(responseBuilder.toString());
        
        rs.close();
        stmt.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    }
%>
