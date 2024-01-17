<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    String awardId = request.getParameter("awardid");
    String pid = request.getParameter("pid");

    String query = "SELECT a.a_description, a.points_required, r.redemption_date, e.center_name " +
                   "FROM Awards a " +
                   "JOIN Redeem_History r ON a.award_id = r.awardid " +
                   "JOIN ExchngCenters e ON r.centerid = e.center_id " +
                   "WHERE a.award_id = ? AND r.passid = ?";
    
    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        String dbUrl = "jdbc:oracle:thin:@artemis.vsnet.gmu.edu:1521/vse18c.vsnet.gmu.edu";
        String dbUsername = "areddy20";
        String dbPassword = "phimsuhi";
        Connection conn = DriverManager.getConnection(dbUrl, dbUsername, dbPassword);
        PreparedStatement stmt = conn.prepareStatement(query);
        stmt.setString(1, awardId);
        stmt.setString(2, pid);
        ResultSet rs = stmt.executeQuery();

     
        
        if (rs.next()) {
            String awardDescription = rs.getString("a_description");
            int pointsRequired = rs.getInt("points_required");
            String redemptionDate = rs.getDate("redemption_date").toString();
            String exchangeCenter = rs.getString("center_name");

            // Concatenate the column values with commas
            String rowData = awardDescription + "," + pointsRequired + "," + redemptionDate + "," + exchangeCenter;
            out.println(rowData);
        } else {
            out.println("No redemption details found for the specified award ID and passenger ID.");
        }

        rs.close();
        stmt.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    }
%>
