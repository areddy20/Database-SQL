<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    String pid = request.getParameter("pid");

    String query = "SELECT p.pname, pa.total_points FROM Passengers p JOIN Point_Accounts pa ON p.passid = pa.passid WHERE p.passid = ?";
    
    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        String dbUrl = "jdbc:oracle:thin:@artemis.vsnet.gmu.edu:1521/vse18c.vsnet.gmu.edu";
        String dbUsername = "areddy20";
        String dbPassword = "phimsuhi";
        Connection conn = DriverManager.getConnection(dbUrl, dbUsername, dbPassword);
        PreparedStatement stmt = conn.prepareStatement(query);
        stmt.setString(1, pid);
        ResultSet rs = stmt.executeQuery();

     
      
        StringBuilder sb = new StringBuilder();

        while (rs.next()) {
            String name = rs.getString("pname");
            int points = rs.getInt("total_points");
             

            sb.append(name).append(",");
            sb.append(points).append(",");
            
        }

        if (sb.length() > 0) {
            // Remove the last '#' character
            sb.setLength(sb.length() - 1);
        }

        out.print(sb.toString());

        rs.close();
        stmt.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    }
%>