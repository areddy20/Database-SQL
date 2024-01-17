<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    String pid = request.getParameter("pid");

    String query = "SELECT f.flight_id, f.flight_miles, f.destination " +
                   "FROM Flights f " +
                   "JOIN Passenger_Flights pf ON f.flight_id = pf.flight_id " +
                   "JOIN Passengers p ON pf.passenger_id = p.passid " +
                   "WHERE p.passid = ?" +
                   "order by 1";
    
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
            String flightId = rs.getString("flight_id");
            int flightMiles = rs.getInt("flight_miles");
            String destination = rs.getString("destination");

            sb.append(flightId).append(",")
              .append(flightMiles).append(",")
              .append(destination).append("#");
        }

        if (sb.length() > 0) {
            // Remove the last '#' character
            sb.setLength(sb.length() - 1);
        }

        out.println(sb.toString());
       
        

        rs.close();
        stmt.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    }
%>
