<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    String flightId = request.getParameter("flightid");

    String query = "SELECT f.dept_datetime, f.arrival_datetime, f.flight_miles, t.trip_id, t.trip_miles " +
                   "FROM Flights f " +
                   "JOIN Trips t ON f.flight_id = t.flight_id " +
                   "WHERE f.flight_id = ?";
    
    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        String dbUrl = "jdbc:oracle:thin:@artemis.vsnet.gmu.edu:1521/vse18c.vsnet.gmu.edu";
        String dbUsername = "areddy20";
        String dbPassword = "phimsuhi";
        Connection conn = DriverManager.getConnection(dbUrl, dbUsername, dbPassword);
        PreparedStatement stmt = conn.prepareStatement(query);
        stmt.setString(1, flightId);
        ResultSet rs = stmt.executeQuery();

     
        
        
        String responseString = ""; // String to hold the response data

        if (rs.next()) {
            // Iterate over the result set
            do {
                String departureTime = rs.getTimestamp("dept_datetime").toString();
                String arrivalTime = rs.getTimestamp("arrival_datetime").toString();
                int flightMiles = rs.getInt("flight_miles");
                int tripId = rs.getInt("trip_id");
                int tripMiles = rs.getInt("trip_miles");

                // Append the row data to the response string
                responseString += departureTime + "," + arrivalTime + "," + flightMiles + "," + tripId + "," + tripMiles + "#";
            } while (rs.next());

            // Remove the last '#' character from the response string
            responseString = responseString.substring(0, responseString.length() - 1);
        }

        if (!responseString.isEmpty()) {
            // Print the response string
            out.println(responseString);
        } else {
            out.println("<p>No flight details found for the specified flight ID.</p>");
        }
        
        rs.close();
        stmt.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    }
%>
