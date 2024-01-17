CREATE TABLE Promotions (
  Prom_ID NUMBER PRIMARY KEY,
  Prom_Action VARCHAR2(50),
  Prom_Period DATE,
  P_Description VARCHAR2(100)
);

CREATE TABLE Passengers (
  passid NUMBER,
  pname VARCHAR2(50),
  ssn VARCHAR2(11),
  gender CHAR(1),
  is_member NUMBER(1) DEFAULT 0,
  email VARCHAR2(100),
  occupation VARCHAR2(50),
  dob DATE,
  PRIMARY KEY (passid)
);


CREATE TABLE Flights (
  flight_id NUMBER PRIMARY KEY,
  flight_miles NUMBER,
  source VARCHAR2(50),
  destination VARCHAR2(50),
  arrival_datetime TIMESTAMP,
  dept_datetime TIMESTAMP
);

CREATE TABLE Awards (
  award_id NUMBER PRIMARY KEY,
  points_required NUMBER,
  a_description VARCHAR2(100)
);

CREATE TABLE Passengers_address (
  address_id NUMBER,
  passid NUMBER,
  home_num VARCHAR2(10),
  street VARCHAR2(100),
  city VARCHAR2(50),
  state VARCHAR2(50),
  zip VARCHAR2(10),
  PRIMARY KEY (address_id),
  FOREIGN KEY (passid) REFERENCES Passengers(passid)
);

CREATE TABLE Passengers_phone (
  passid NUMBER,
  phone_number VARCHAR2(20),
  FOREIGN KEY (passid) REFERENCES Passengers(passid)
);

CREATE TABLE ExchngCenters (
  center_id NUMBER PRIMARY KEY,
  center_name VARCHAR2(100),
  c_location VARCHAR2(100)
);

CREATE TABLE Login (
  username VARCHAR2(50) PRIMARY KEY,
  password VARCHAR2(50),
  passid NUMBER,
  FOREIGN KEY (passid) REFERENCES Passengers(passid)
);

CREATE TABLE Cards (
  card_id NUMBER PRIMARY KEY,
  expiry_date DATE,
  is_valid NUMBER(1),
  passid NUMBER,
  FOREIGN KEY (passid) REFERENCES Passengers(passid)
);

CREATE TABLE Empl_incentives (
  passenger_id NUMBER,
  incentive_id NUMBER PRIMARY KEY,
  flight_id NUMBER,
  FOREIGN KEY (passenger_id) REFERENCES Passengers(passid),
  FOREIGN KEY (flight_id) REFERENCES Flights(flight_id)
);

CREATE TABLE Empl_Referrals (
  referral_id NUMBER PRIMARY KEY,
  passenger_id NUMBER,
  flight_id NUMBER,
  FOREIGN KEY (passenger_id) REFERENCES Passengers(passid),
  FOREIGN KEY (flight_id) REFERENCES Flights(flight_id)
);

CREATE TABLE Trips (
  trip_id NUMBER PRIMARY KEY,
  trip_miles NUMBER,
  source VARCHAR2(50),
  destination VARCHAR2(50),
  dept_datetime TIMESTAMP,
  arrival_datetime TIMESTAMP,
  card_id NUMBER,
  flight_id NUMBER,
  FOREIGN KEY (card_id) REFERENCES Cards(card_id),
  FOREIGN KEY (flight_id) REFERENCES Flights(flight_id)
);

CREATE TABLE Point_Accounts (
  point_account_id NUMBER PRIMARY KEY,
  total_points NUMBER,
  passid NUMBER,
  FOREIGN KEY (passid) REFERENCES Passengers(passid)
);

CREATE TABLE Promotions_Flights (
  promotion_id NUMBER,
  flight_id NUMBER,
  FOREIGN KEY (promotion_id) REFERENCES Promotions(prom_id),
  FOREIGN KEY (flight_id) REFERENCES Flights(flight_id)
);


CREATE TABLE Passenger_Flights (
  passenger_id NUMBER,
  flight_id NUMBER,
  FOREIGN KEY (passenger_id) REFERENCES Passengers(passid),
  FOREIGN KEY (flight_id) REFERENCES Flights(flight_id)
);

CREATE TABLE Redeem_History (
  RedeemID NUMBER PRIMARY KEY,
  redemption_date DATE,
  quantity NUMBER,
  PassID NUMBER,
  AwardID NUMBER,
  CenterID NUMBER,
  FOREIGN KEY (PassID) REFERENCES Passengers(PassID),
  FOREIGN KEY (AwardID) REFERENCES Awards(Award_ID),
  FOREIGN KEY (CenterID) REFERENCES ExchngCenters(Center_ID)
);