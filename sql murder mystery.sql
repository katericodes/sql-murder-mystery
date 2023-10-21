-- https://mystery.knightlab.com/

-- challenge 1

-- find the report for the crime

select *
from crime_scene_report
where date is 20180115 and city is "SQL City" and type is "Murder"

-- find witness 1
select *
from person
where address_street_name is "Northwestern Dr"
order by address_number desc
limit 1

-- find witness 2
select *
from person
where name like "Annabel %" and address_street_name is "Franklin Ave" 

-- find interviews of both witnesses
select person.id, person.name, interview.transcript
from person join interview on person.id = interview.person_id
where id in (14887, 16371)

/* Key Info for Suspect:
- man
- gym membership id starts with "48Z"
- gym membership status is "gold"
- car license plate contains: "H42W"
- was in the gym on Jan 9th (check in date)
*/

-- query to find potential suspects:
select get_fit_now_check_in.membership_id, get_fit_now_check_in.check_in_date, get_fit_now_member.person_id, get_fit_now_member.name, get_fit_now_member.membership_status
from get_fit_now_check_in join get_fit_now_member on get_fit_now_check_in.membership_id = get_fit_now_member.id
where check_in_date is 20180109 and membership_id like "48Z%"
-- check-in date and membership id was enough to *narrow* down the suspects

-- query to find matching license plate among suspects:
select person.id, person.name, person.license_id, drivers_license.plate_number
from person join drivers_license on person.license_id = drivers_license.id
where plate_number like "%H42W%" and person.id in (28819, 67318)

-- verifying answer:
INSERT INTO solution VALUES (1, 'Jeremy Bowers');
        
        SELECT value FROM solution;

-- challenge 2

select *
from interview
where person_id is 67318

/* Key Info for Suspect:
- woman
- had red hair
- height is between 5'5" (65") or 5'7" (67")
- drives a testla model s
- attended SQL Symphony Concert 3 times in December 2017
*/

-- first query based on personal description to narrow suspects
select person.id, person.name, person.license_id, person.ssn,
	drivers_license.height, drivers_license.hair_color, drivers_license.car_make, drivers_license.car_model
from person join drivers_license on person.license_id = drivers_license.id
where gender is "female"
	and hair_color is "red"
	and car_make is "Tesla"
	and car_model is "Model S"
	and height >= 65
	and height <= 67

-- second query based on event attendance to find suspect
select facebook_event_checkin.person_id, person.name, facebook_event_checkin.event_name, facebook_event_checkin.date
from facebook_event_checkin join person on facebook_event_checkin.person_id = person.id
where event_name is "SQL Symphony Concert"
	and date like "201712%"
	and person_id in (78881, 90700, 99716)

-- verifying answer:
INSERT INTO solution VALUES (1, 'Miranda Priestly');
        
        SELECT value FROM solution;