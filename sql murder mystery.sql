-- https://mystery.knightlab.com/

-- table structures
crime_scene_report(
    date integer,
    type text,
    description text,
    city text
)

drivers_license(
    id integer PRIMARY KEY,
    age integer,
    height integer,
    eye_color text,
    hair_color text,
    gender text,
    plate_number text,
    car_make text,
    car_model text
)

facebook_event_checkin(
    person_id integer,
    event_id integer,
    event_name text,
    date integer,
    FOREIGN KEY (person_id) REFERENCES person(id) 
)

interview(
    person_id integer,
    transcript text,
    FOREIGN KEY (person_id) REFERENCES person(id) 
)

get_fit_now_member(
    id text PRIMARY KEY,
    person_id integer,
    name text,
    membership_start_date integer,
    membership_status text,
    FOREIGN KEY (person_id) REFERENCES person(id)
)

get_fit_now_check_in(
    membership_id text,
    check_in_date integer,
    check_in_time integer,
    check_out_time integer,
    FOREIGN KEY (membership_id) REFERENCES get_fit_now_member(id)
)

solution(
    user integer,
    value text
)

income(
    ssn CHAR PRIMARY KEY,
    annual_income integer

)

person (
    id integer PRIMARY KEY,
    name text,
    license_id integer,
    address_number integer,
    address_street_name text,
    ssn CHAR REFERENCES income (ssn),
    FOREIGN KEY (license_id) REFERENCES drivers_license (id)
)

-- Challenge 1

/*
What we know:
- Crime occured on Jan 15, 2018
- Took place in SQL City
- Crime type is Murder
*/

select *
from crime_scene_report
where date is 20180115 and city is "SQL City" and type is "Murder"

/*
Security footage shows that there were 2 witnesses.
The first witness lives at the last house on "Northwestern Dr".
The second witness, named Annabel, lives somewhere on "Franklin Ave".
*/

-- Query for Witness 1
select *
from person
where address_street_name is "Northwestern Dr"
order by address_number desc
limit 1

/*
id	    name	        license_id	address_number	address_street_name	    ssn
14887	Morty Schapiro	118009  	4919	        Northwestern Dr	        111564949
*/

-- Query for Witness 2
select *
from person
where name like "Annabel %" and address_street_name is "Franklin Ave" 

/*
id	    name	        license_id	address_number  address_street_name ssn
16371	Annabel Miller	490173	    103	            Franklin Ave	    318771143
*/

-- Query for Witness Reports
select person.id, person.name, interview.transcript
from person join interview on person.id = interview.person_id
where id in (14887, 16371)
/*
id	name	transcript
14887	Morty Schapiro	I heard a gunshot and then saw a man run out. He had a "Get Fit Now Gym" bag. The membership number on the bag started with "48Z". Only gold members have those bags. The man got into a car with a plate that included "H42W".
16371	Annabel Miller	I saw the murder happen, and I recognized the killer from my gym when I was working out last week on January the 9th.
*/

/* Key Info:
- man
- gym membership id starts with "48Z"
- gym membership status is "gold"
- car license plate contains: "H42W"
- was in the gym on Jan 9th (check in date)
*/

/* Original Queries
select *
from get_fit_now_check_in
where check_in_date is 20180109 and membership_id like "48Z%"

membership_id	check_in_date	check_in_time	check_out_time
48Z7A	        20180109	    1600	        1730
48Z55	        20180109	    1530	        1700

select *
from get_fit_now_member
where id in ("48Z7A", "48Z55")

id	    person_id	name	        membership_start_date	membership_status
48Z55	67318	    Jeremy Bowers	20160101            	gold
48Z7A	28819	    Joe Germuska	20160305            	gold

select id, name, license_id
from person
where id in (67318, 28819)

id     	name	        license_id
28819	Joe Germuska	173289
67318	Jeremy Bowers	423327
*/

-- Queries using join:
-- Query to find potential suspects:
select get_fit_now_check_in.membership_id, get_fit_now_check_in.check_in_date, get_fit_now_member.person_id, get_fit_now_member.name, get_fit_now_member.membership_status
from get_fit_now_check_in join get_fit_now_member on get_fit_now_check_in.membership_id = get_fit_now_member.id
where check_in_date is 20180109 and membership_id like "48Z%" -- check-in date and membership id would be enough to narrow down the suspects

/*
membership_id	check_in_date	person_id	name	        membership_status
48Z7A	        20180109	    28819	    Joe Germuska	gold
48Z55	        20180109	    67318	    Jeremy Bowers	gold
*/

-- Query to find matching license plate among suspects:

select person.id, person.name, person.license_id, drivers_license.plate_number
from person join drivers_license on person.license_id = drivers_license.id
where plate_number like "%H42W%" and person.id in (28819, 67318)

/*
id	    name	        license_id	plate_number
67318	Jeremy Bowers	423327	    0H42W2
*/

-- Checking answer:
INSERT INTO solution VALUES (1, 'Jeremy Bowers');
        
        SELECT value FROM solution;

/*
Congrats, you found the murderer! But wait, there's more...
If you think you're up for a challenge, try querying the interview
transcript of the murderer to find the real villain behind this crime.
If you feel especially confident in your SQL skills, try to complete this final step with no more than 2 queries.
Use this same INSERT statement with your new suspect to check your answer.
*/

-- Challenge 2

select *
from interview
where person_id is 67318

/* I was hired by a woman with a lot of money.
I don't know her name but I know she's around 5'5" (65") or 5'7" (67").
She has red hair and she drives a Tesla Model S.
I know that she attended the SQL Symphony Concert 3 times in December 2017.
*/

-- Query to find potential suspects
select person.id, person.name, person.license_id, person.ssn,
	drivers_license.height, drivers_license.hair_color, drivers_license.car_make, drivers_license.car_model
from person join drivers_license on person.license_id = drivers_license.id
where gender is "female"
	and hair_color is "red"
	and car_make is "Tesla"
	and car_model is "Model S"
	and height >= 65
	and height <= 67
/*
id	name	license_id	ssn	height	hair_color	car_make	car_model
78881	Red Korb	918773	961388910	65	red	Tesla	Model S
90700	Regina George	291182	337169072	66	red	Tesla	Model S
99716	Miranda Priestly	202298	987756388	66	red	Tesla	Model S
*/

-- Query to find the suspect that attended the event
select facebook_event_checkin.person_id, person.name, facebook_event_checkin.event_name, facebook_event_checkin.date
from facebook_event_checkin join person on facebook_event_checkin.person_id = person.id
where event_name is "SQL Symphony Concert"
	and date like "201712%"
	and person_id in (78881, 90700, 99716)

/*
person_id	name	event_name	date
99716	Miranda Priestly	SQL Symphony Concert	20171206
99716	Miranda Priestly	SQL Symphony Concert	20171212
99716	Miranda Priestly	SQL Symphony Concert	20171229
*/

-- Checking answer:
INSERT INTO solution VALUES (1, 'Miranda Priestly');
        
        SELECT value FROM solution;

/*
Congrats, you found the brains behind the murder!
Everyone in SQL City hails you as the greatest SQL detective of all time.
Time to break out the champagne!
*/