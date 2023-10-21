# SQL Murdery Mystery

The SQL Murder Mystery is a web-based SQL challenge designed by two MIT students, Joon Park and Cathy He. It can be found on [mystery.knightlab.com](https://mystery.knightlab.com/).

The following SQL Concepts were used to solve the mystery:
* LIKE and Wildcards (%)
* IN
* GROUP BY
* ORDER BY
* JOINS
* LIMIT

## The Challenge
A crime has taken place and the detective needs your help. The detective gave you the crime scene report, but you somehow lost it. You vaguely remember that the crime was a ​murder​ that occurred sometime on ​Jan.15, 2018​ and that it took place in ​SQL City​. Start by retrieving the corresponding crime scene report from the police department’s database.

## The Schema
<span class="image main"><img src="https://mystery.knightlab.com/schema.png" alt="" /></span>


## The Result

When first looking for the initial crime report that happened on January 15, 2018 in SQL City, I found the following description: 
> Security footage shows that there were 2 witnesses. The first witness lives at the last house on "Northwestern Dr". The second witness, named Annabel, lives somewhere on "Franklin Ave".

According to the first witness, Morty Schapiro, they reported:
> I heard a gunshot and then saw a man run out. He had a "Get Fit Now Gym" bag. The membership number on the bag started with "48Z". Only gold members have those bags. The man got into a car with a plate that included "H42W".

According to the second witness, Annabel Miller, they reported: 
> I saw the murder happen, and I recognized the killer from my gym when I was working out last week on January the 9th.

Thus, I was able to determine and verify that Jeremy Bowers was the killer based on the following criteria:
* The suspect is a man.
* The suspect is a member of "Get Fit Now Gym" with an ID that starts with "48Z."
* The suspect is a "gold" member.
* The suspect was in the gym on January 9th (2018).
* The suspect drives a car with a license plate containging "H42W"

After hearing Jeremy Bowers's interview, I was looking to find the mastermind who fit the following criteria:
* The mastermind is a woman with red hair.
* The woman's height is between 5'5" (65") or 5'7" (67").
* The woman drives a Tesla Model S.
* The woman attended the SQL Symphony 3 times in Decemeber 2017.

* Finally, the mastermind who was behind the murder was determiend to be Miranda Priestly as she fit all the criteria described by the killer.
