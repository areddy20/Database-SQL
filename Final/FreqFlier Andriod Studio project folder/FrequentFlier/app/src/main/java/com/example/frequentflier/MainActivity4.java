package com.example.frequentflier;

import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;

import java.util.ArrayList;
import java.util.List;

public class MainActivity4 extends AppCompatActivity {

    private Spinner spinnerFlightIds;
    private RequestQueue requestQueue;
    private String pid;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main4);

        spinnerFlightIds = findViewById(R.id.spinnerFlightIds);

        // Initialize the RequestQueue
        requestQueue = Volley.newRequestQueue(this);

        // Retrieve pid from the intent
        pid = getIntent().getStringExtra("pid");

        // Make a request to fetch flight data
        String url = "http://10.0.2.2:8080/frequentflier/Flights.jsp?pid=" + pid;
        fetchFlightData(url);

        spinnerFlightIds.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                String selectedFlightId = parent.getItemAtPosition(position).toString();

                // Call a method to fetch and display flight details based on the selected flight ID
                fetchAndDisplayFlightDetails(selectedFlightId);
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {
                // Handle the case when no flight is selected
            }
        });
    }

    private void fetchFlightData(String url) {
        StringRequest request = new StringRequest(Request.Method.GET, url,
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {
                        // Split the response by '#' to get individual flight IDs
                        String[] flightIdsArray = response.split("#");
                        List<String> flightIds = new ArrayList<>();
                        for (String flightId : flightIdsArray) {
                            String[] flightIdArray = flightId.split(",");
                            flightIds.add(flightIdArray[0]);
                        }

                        // Create an ArrayAdapter and set it as the adapter for the Spinner
                        ArrayAdapter<String> spinnerAdapter = new ArrayAdapter<>(MainActivity4.this,
                                android.R.layout.simple_spinner_item, flightIds);
                        spinnerAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
                        spinnerFlightIds.setAdapter(spinnerAdapter);
                    }
                },
                new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error) {
                        error.printStackTrace();
                        Toast.makeText(MainActivity4.this, error.toString(), Toast.LENGTH_SHORT).show();
                    }
                });

        // Add the request to the RequestQueue
        requestQueue.add(request);
    }

    private void fetchAndDisplayFlightDetails(String flightId) {
        String url = "http://10.0.2.2:8080/frequentflier/FlightDetails.jsp?flightid=" + flightId;
        StringRequest request = new StringRequest(Request.Method.GET, url,
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {
                        // Display the flight details in your desired way
                        // Replace the following code with your implementation
                        //System.out.println(response);
                        //Toast.makeText(MainActivity4.this, "Flight Details: " + url + response, Toast.LENGTH_SHORT).show();
                        TextView textViewFlightDetails = findViewById(R.id.textViewFlightDetails);

                        String[] columns = response.split(",");

                        textViewFlightDetails.setText("Flight Details: " +  "Departure:" + columns[0] + "\n" + "Arrival:" + columns[1] +"\n" + "Miles" + columns[2]);
                    }
                },
                new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error) {
                        error.printStackTrace();
                        Toast.makeText(MainActivity4.this, error.toString(), Toast.LENGTH_SHORT).show();
                    }
                });

        // Add the request to the RequestQueue
        requestQueue.add(request);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();

        // Cancel any pending requests when the activity is destroyed
        if (requestQueue != null) {
            requestQueue.cancelAll(this);
        }
    }
}
