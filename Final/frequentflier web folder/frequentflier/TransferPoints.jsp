<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    String sourcePid = request.getParameter("spid");
    String destinationPid = request.getParameter("dpid");
    int pointsToTransfer = Integer.parseInt(request.getParameter("npoints"));

    String deductionQuery = "UPDATE Point_Accounts SET total_points = total_points - ? WHERE passid = ?";
    String additionQuery = "UPDATE Point_Accounts SET total_points = total_points + ? WHERE passid = ?";
    
    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        String dbUrl = "jdbc:oracle:thin:@artemis.vsnet.gmu.edu:1521/vse18c.vsnet.gmu.edu";
        String dbUsername = "areddy20";
        String dbPassword = "phimsuhi";
        Connection conn = DriverManager.getConnection(dbUrl, dbUsername, dbPassword);
        
        // Deduct points from the source passenger's account
        PreparedStatement deductionStmt = conn.prepareStatement(deductionQuery);
        deductionStmt.setInt(1, pointsToTransfer);
        deductionStmt.setString(2, sourcePid);
        int deductionResult = deductionStmt.executeUpdate();
        deductionStmt.close();
        
        // Add points to the destination passenger's account
        PreparedStatement additionStmt = conn.prepareStatement(additionQuery);
        additionStmt.setInt(1, pointsToTransfer);
        additionStmt.setString(2, destinationPid);
        int additionResult = additionStmt.executeUpdate();
        additionStmt.close();

        out.println("<html>");
        out.println("<head>");
        out.println("<title>Transfer Points</title>");
        out.println("</head>");
        out.println("<body>");
        out.println("<h1>Transfer Points</h1>");

        if (deductionResult > 0 && additionResult > 0) {
            out.println("<p>Points transfer successful.</p>");
        } else {
            out.println("<p>Points transfer failed.</p>");
        }

        out.println("</body>");
        out.println("</html>");

        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    }
%>
