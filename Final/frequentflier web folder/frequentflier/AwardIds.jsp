<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    String pid = request.getParameter("pid");

    String query = "SELECT DISTINCT AwardID " +
                   "FROM Redeem_History " +
                   "WHERE PassID = ? order by 1 ";
    
    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        String dbUrl = "jdbc:oracle:thin:@artemis.vsnet.gmu.edu:1521/vse18c.vsnet.gmu.edu";
        String dbUsername = "areddy20";
        String dbPassword = "phimsuhi";
        Connection conn = DriverManager.getConnection(dbUrl, dbUsername, dbPassword);
        PreparedStatement stmt = conn.prepareStatement(query);
        stmt.setString(1, pid);
        ResultSet rs = stmt.executeQuery();
        String columnSeparator = ",";
        String rowSeparator = "#";

     
        
        StringBuilder responseBuilder = new StringBuilder();

        if (rs.next()) {
            do {
                int awardId = rs.getInt("AwardID");
                responseBuilder.append(awardId).append(columnSeparator);
            } while (rs.next());

            String response1 = responseBuilder.toString();
            response1 = response1.substring(0, response1.length() - columnSeparator.length()); // Remove trailing column separator

            out.println(response1.replace(",", columnSeparator).replace("#", rowSeparator));
        } else {
            out.println("<p>No award IDs found for the specified passenger ID.</p>");
        }

        rs.close();
        stmt.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    }
%>
