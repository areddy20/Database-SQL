package com.example.frequentflier;

import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Spinner;
import android.widget.TableLayout;
import android.widget.TableRow;
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
import java.util.Arrays;
import java.util.List;

public class MainActivity5 extends AppCompatActivity implements AdapterView.OnItemSelectedListener {
    private Spinner awardSpinner;
    private TableLayout tableLayout;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main5);

        String pid = getIntent().getStringExtra("pid");

        awardSpinner = findViewById(R.id.awardSpinner);
        tableLayout = findViewById(R.id.tableLayout);

        awardSpinner.setOnItemSelectedListener(this);

        String awardIdsUrl = "http://10.0.2.2:8080/frequentflier/AwardIds.jsp?pid=" + pid;

        // Instantiate the RequestQueue.
        RequestQueue queue = Volley.newRequestQueue(this);

        // Request a string response from the provided URL to fetch award IDs.
        StringRequest awardIdsRequest = new StringRequest(Request.Method.GET, awardIdsUrl,
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {
                        // Split the response by comma to get individual award IDs
                        String[] awardIds = response.split(",");

                        List<String> awardList = new ArrayList<>(Arrays.asList(awardIds));

                        ArrayAdapter<String> adapter = new ArrayAdapter<>(MainActivity5.this,
                                android.R.layout.simple_spinner_item, awardList);
                        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
                        awardSpinner.setAdapter(adapter);
                    }
                }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                Toast.makeText(MainActivity5.this, "Error fetching awards: " + error.getMessage(), Toast.LENGTH_SHORT).show();
            }
        });

        // Add the request to the RequestQueue.
        queue.add(awardIdsRequest);
    }

    @Override
    public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
        String selectedAward = parent.getItemAtPosition(position).toString();
        String pid = getIntent().getStringExtra("pid");
        String redemptionDetailsUrl = "http://10.0.2.2:8080/frequentflier/RedemptionDetails.jsp?pid=" + pid + "&awardid=" + selectedAward;
        System.out.println("redemptionDetailsUrl" + redemptionDetailsUrl);
        // Instantiate the RequestQueue.
        RequestQueue queue = Volley.newRequestQueue(this);

        // Request a string response from the provided URL to fetch redemption details.
        StringRequest redemptionDetailsRequest = new StringRequest(Request.Method.GET, redemptionDetailsUrl,
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {
                        // Clear the existing rows from the table
                        tableLayout.removeAllViews();

                        // Split the response by newline to get individual rows
                        String[] rows = response.split("\n");

                        for (String row : rows) {
                            // Split each row by comma to get individual columns
                            String[] columns = row.split(",");

                            // Create a new table row
                            //TableRow tableRow = new TableRow(MainActivity5.this);

                            // Create and set TextViews for each column in the row
                            for (String column : columns) {
                                TableRow tableRow = new TableRow(MainActivity5.this);
                                TextView textView = new TextView(MainActivity5.this);
                                textView.setText(column + "  ");
                                tableRow.addView(textView);
                                tableLayout.addView(tableRow);
                            }

                            // Add the table row to the table layout
                           // tableLayout.addView(tableRow);
                        }
                    }
                }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                Toast.makeText(MainActivity5.this, "Error fetching redemption details: " + error.getMessage(), Toast.LENGTH_SHORT).show();
            }
        });

        // Add the request to the RequestQueue.
        queue.add(redemptionDetailsRequest);
    }

    @Override
    public void onNothingSelected(AdapterView<?> parent) {
        // Do nothing
    }
}
