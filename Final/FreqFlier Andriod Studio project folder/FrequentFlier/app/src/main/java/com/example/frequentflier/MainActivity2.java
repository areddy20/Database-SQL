package com.example.frequentflier;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;

import com.squareup.picasso.Picasso;
import android.widget.ImageView;

public class MainActivity2 extends AppCompatActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main2);

        String pid = getIntent().getStringExtra("data");

        final TextView passengerName = findViewById(R.id.passengername);
        final TextView rewardpoints = findViewById(R.id.rewardpoints);

        final ImageView profileImage = findViewById(R.id.profileImage);
        String imageUrl = "http://10.0.2.2:8080/frequentflier/images/" + pid + ".jpg";



        // Instantiate the RequestQueue.
        RequestQueue queue = Volley.newRequestQueue(this);
        String url ="http://10.0.2.2:8080/frequentflier/Info.jsp?pid=" + pid;

        // Request a string response from the provided URL.
        StringRequest stringRequest = new StringRequest(Request.Method.GET, url,
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {
                        // split the response by '#'
                        String[] rows = response.split("#");
                        for (String row : rows) {
                            // split each row by ','
                            String[] columns = row.split(",");
                            if (columns.length > 0) {
                                passengerName.setText(columns[0]); // Set the passenger's name
                                rewardpoints.setText(columns[1]);
                                Picasso.get().load(imageUrl).into(profileImage);
                                break; // Stop after the first row
                            }
                        }
                    }
                }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                Toast.makeText(MainActivity2.this,"That didn't work!", Toast.LENGTH_SHORT).show();
            }
        });

        // Add the request to the RequestQueue.
        queue.add(stringRequest);

        // Find the buttons by their id
        Button button1 = findViewById(R.id.button1);
        Button button2 = findViewById(R.id.button2);
        Button button3 = findViewById(R.id.button3);
        Button button4 = findViewById(R.id.button4);
        Button button5 = findViewById(R.id.button5);

        // Set the onClickListener for button1
        button1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                // Code to execute when button1 is clicked
                Toast.makeText(MainActivity2.this, "Flight Details clicked", Toast.LENGTH_SHORT).show();
                Intent intent = new Intent(MainActivity2.this, MainActivity4.class);
                intent.putExtra("pid", pid); // Add pid to the intent
                startActivity(intent);
            }
        });

        // Set the onClickListener for button2
        button2.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                // Code to execute when button2 is clicked
                //Toast.makeText(MainActivity2.this, "All Flights clicked", Toast.LENGTH_SHORT).show();
                Intent intent = new Intent(MainActivity2.this, MainActivity3.class);
                intent.putExtra("pid", pid); // Add pid to the intent
                startActivity(intent);
            }
        });

        // Set the onClickListener for button3
        button3.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                // Code to execute when button3 is clicked
                //Toast.makeText(MainActivity2.this, "Redemption Info clicked", Toast.LENGTH_SHORT).show();

                Toast.makeText(MainActivity2.this, "Redemption Info clicked", Toast.LENGTH_SHORT).show();
                Intent intent = new Intent(MainActivity2.this, MainActivity5.class);
                intent.putExtra("pid", pid); // Add pid to the intent
                startActivity(intent);

            }
        });

        // Set the onClickListener for button4
        button4.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                // Code to execute when button4 is clicked
                Toast.makeText(MainActivity2.this, "Transfer Points clicked", Toast.LENGTH_SHORT).show();

                Intent intent = new Intent(MainActivity2.this, MainActivity6.class);
                intent.putExtra("pid", pid); // Add pid to the intent
                startActivity(intent);
            }
        });

        // Set the onClickListener for button5
        button5.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                // Code to execute when button5 is clicked
                Toast.makeText(MainActivity2.this, "Exit clicked", Toast.LENGTH_SHORT).show();
                finish();
            }
        });
    }
}
