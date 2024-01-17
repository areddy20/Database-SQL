package com.example.frequentflier;

import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;

import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;

public class MainActivity6 extends AppCompatActivity {

    private Spinner spinner;
    private List<String> passengerIds;
    private ArrayAdapter<String> adapter;
    private String pid;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity6_main);

        pid = getIntent().getStringExtra("pid");

        spinner = findViewById(R.id.spinner);
        passengerIds = new ArrayList<>();
        adapter = new ArrayAdapter<>(this, android.R.layout.simple_spinner_item, passengerIds);
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinner.setAdapter(adapter);

        RequestQueue queue = Volley.newRequestQueue(this);
        String url = "http://10.0.2.2:8080/frequentflier/GetPassengerids.jsp?pid=" + pid;

        StringRequest stringRequest = new StringRequest(Request.Method.GET, url,
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {
                        String[] ids = response.split("#");
                        for (String id : ids) {
                            passengerIds.add(id.trim());
                        }
                        adapter.notifyDataSetChanged();
                    }
                },
                new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error) {
                        Toast.makeText(MainActivity6.this, "Error retrieving passenger IDs", Toast.LENGTH_SHORT).show();
                    }
                });

        queue.add(stringRequest);

        spinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                String selectedPassengerId = (String) parent.getItemAtPosition(position);
                Toast.makeText(MainActivity6.this, "Selected Passenger ID: " + selectedPassengerId, Toast.LENGTH_SHORT).show();
                // Perform further actions with the selected passenger ID
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {
                // Do nothing
            }
        });

        Button transferButton = findViewById(R.id.transferButton);
        transferButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String selectedPassengerId = spinner.getSelectedItem().toString();
                EditText pointsEditText = findViewById(R.id.pointsEditText);
                String points = pointsEditText.getText().toString();

                if (selectedPassengerId.isEmpty() || points.isEmpty()) {
                    Toast.makeText(MainActivity6.this, "Please fill in all fields", Toast.LENGTH_SHORT).show();
                } else {
                    transferPoints(pid, selectedPassengerId, points);
                }
            }
        });
    }

    private void transferPoints(String pid, String passengerId, String points) {
        try {
            String encodedPid = URLEncoder.encode(pid, "UTF-8");
            String encodedPassengerId = URLEncoder.encode(passengerId, "UTF-8");
            String encodedPoints = URLEncoder.encode(points, "UTF-8");

            String url = "http://10.0.2.2:8080/frequentflier/TransferPoints.jsp" +
                    "?spid=" + encodedPid +
                    "&dpid=" + encodedPassengerId +
                    "&npoints=" + encodedPoints;

            RequestQueue queue = Volley.newRequestQueue(this);
            StringRequest stringRequest = new StringRequest(Request.Method.GET, url,
                    new Response.Listener<String>() {
                        @Override
                        public void onResponse(String response) {
                            // Handle the response here
                            Toast.makeText(MainActivity6.this, encodedPoints + " Points Transferred Succesfully" , Toast.LENGTH_SHORT).show();
                        }
                    },
                    new Response.ErrorListener() {
                        @Override
                        public void onErrorResponse(VolleyError error) {
                            Toast.makeText(MainActivity6.this, "Error transferring points", Toast.LENGTH_SHORT).show();
                        }
                    });

            queue.add(stringRequest);

        } catch (Exception e) {
            e.printStackTrace();
            Toast.makeText(MainActivity6.this, "Error transferring points", Toast.LENGTH_SHORT).show();
        }
    }
}
