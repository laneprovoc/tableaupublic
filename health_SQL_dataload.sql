






#OPIOD DATA - COUNTY
CREATE TABLE Opiod_County
(
STATEFP	int,
COUNTYFP int,
YEAR int,
INDICATOR nvarchar(55),
VALUE float,
COUNTY nvarchar(155),
STATE nvarchar(100),
STATEABBREVIATION nvarchar(10)
)
;




#load flat file into sql
truncate Opiod_County;
load data local infile '/users/lanetrisko/documents/work/ad hoc data projects/iron viz 2018/opiod_countydata.csv' into table Opiod_County 
	fields terminated by ','
	enclosed by '"'
  	lines terminated by '\r\n'
  	IGNORE 1 LINES 
;  select * from Opiod_County


	# ALTER TABLE Opiod_County DROP INDEX Opiod_County
CREATE INDEX Opiod_county
on Opiod_County(County, state)
;




#UPDATE COUNTY NAMES, REMOVE TRAILING INDICATORS (i.e. 'County', 'Parish' etc)
UPDATE Opiod_County
SET County = REPLACE(
					REPLACE(	
						REPLACE(
							REPLACE
								(REPLACE(
										REPLACE(County, ' County',''),
								' Municipio',''),
							' Borough',''),
						' Census Area',''),
					' Parish',''),
				' Municipality','') 




#UPDATE COUNTY NAMES, CHANGE 'ST.' to 'Saint' IN LA
UPDATE Opiod_County
SET County = REPLACE(County,'St. ', 'Saint ')
WHERE Stateabbreviation = 'LA'




#UPDATE COUNTY NAMES, AK UPDATES
UPDATE Opiod_County
SET County = REPLACE(REPLACE (County, '-', ' '),' City and', '')
WHERE Stateabbreviation = 'AK'




#RANDOM SAINTS
UPDATE Opiod_County
SET County = REPLACE(County, 'St. ', 'Saint ')
#select distinct county, state from opiod_county
WHERE Stateabbreviation in ('mn','ar', 'il', 'fl', 'al','in','mi','mo','ny','wi')
		and county like 'st. %'




#UPDATE HARDCODES
UPDATE Opiod_county a
	JOIN Opioid_County_County_Adjustments b
		on a.county = b.county
		and a.stateabbreviation = b.state
SET a.County = b.County_Adjusted




#HARDCODED COUNTY NAMES - MANUALLY ADDED
CREATE TABLE Opioid_County_County_Adjustments
(
County nvarchar (155),
state nvarchar(10),
County_adjusted nvarchar(155)
)




TRUNCATE TABLE Opioid_County_County_Adjustments;
INsERt INTO Opioid_County_County_Adjustments
VALUEs
('Saint Clair','CO','Adams'),
('Obrian','IA','Obrien'),
('St. Joseph','IN','St Joseph'),
('Salem city','VA','Salem'),

('Hoonah Angoon','AK','Skagway Hoonah Angoon'),
('Petersburg','AK','Wrangell Petersburg'),
('Prince of Wales Hyder','AK','Prince Wales Ketchikan'),
('Skagway','AK','Skagway Hoonah Angoon'),
('Wrangell','AK','Wrangell Petersburg'),
('DeKalb','AL','De Kalb'),
('Broomfield','CO','Saint Clair'),
('DeSoto','FL','De Soto'),
('O''Brien','IA','Obrian'),
('De Witt','IL','Dewitt'),
('DeKalb','IL','De Kalb'),
('DuPage','IL','Du Page'),
('LaSalle','IL','La salle'),
('DeKalb','IN','De Kalb'),
('LaPorte','IN','La Porte'),
('Saint Joseph','IN','St Joseph'),
('LaSalle','LA','La salle'),
('Saint John the Baptist','LA','St John The Baptist'),
('Prince George''s','MD','Prince Georges'),
('Queen Anne''s','MD','Queen Annes'),
('St. Mary''s','MD','Saint Marys'),
('Ste. Genevieve','MO','Sainte Genevieve'),
('DeSoto','MS','De Soto'),
('Oglala Lakota','SD','Shannon'),
('DeWitt','TX','De Witt'),
('Bristol city','VA','Bristol'),
('Radford city','VA','Radford'),
('Hoonah Angoon','AK','Skagway Hoonah Angoon'),
('Prince of Wales Hyder','AK','Prince Wales Ketchikan'),
('Wrangell','AK','Wrangell Petersburg'),
('Obrian','IA','Obrien'),
('Saint Mary''s','MD','Saint Marys')




#checks


#CHECK OPIOID DATASET POST UPDATE
SELECT o.*
FROM 
(
SELECT DISTINCT
		o.county, o.stateabbreviation state
FROM Opiod_County o
ORDER BY stateabbreviation, county
) o
		left join zipcode_city_county_state z
			on o.county = z.county
			and o.state = z.state
WHERE z.county is null




#ZIPCODE COUNTY
SELECT DISTINCT county, state
FROM Zipcode_City_county_State
WHERE STATE = 'VA'# and county like '%city'
ORDER BY state, county













#COUNTY RACE 2016
CREATE TABLE County_Race_2016
(
GEOid nvarchar(55),
GEOid2 int,
County nvarchar(255),
HD01_VD01 int,
HD02_VD01 nvarchar(55),
HD01_VD02 int,
HD02_VD02 int,
HD01_VD03 int,
HD02_VD03 int,
HD01_VD04 int,
HD02_VD04 int,
HD01_VD05 int,
HD02_VD05 int,
HD01_VD06 int,
HD02_VD06 int,
HD01_VD07 int,
HD02_VD07 int,
HD01_VD08 int,
HD02_VD08 int,
HD01_VD09 int,
HD02_VD09 int,
HD01_VD10 int,
HD02_VD10 int,
HD01_VD11 int,
HD02_VD11 int,
HD01_VD12 int,
HD02_VD12 int,
HD01_VD13 int,
HD02_VD13 int,
HD01_VD14 int,
HD02_VD14 int,
HD01_VD15 int,
HD02_VD15 int,
HD01_VD16 int,
HD02_VD16 int,
HD01_VD17 int,
HD02_VD17 int,
HD01_VD18 int,
HD02_VD18 int,
HD01_VD19 int,
HD02_VD19 int,
HD01_VD20 int,
HD02_VD20 int,
HD01_VD21 int,
HD02_VD21 int
)
;






#load flat file into sql
truncate County_Race_2016;
load data local infile '/users/lanetrisko/documents/work/ad hoc data projects/iron viz 2018/race-county-2016.csv' into table County_Race_2016 
	fields terminated by ','
	enclosed by '"'
  	lines terminated by '\r\n'
  	IGNORE 2 LINES 
;  select * from County_Race_2016 where county like '%miami%'








#county race with seperate state and counties
	#	drop table County_Race_2016_adjusted;
CREATE TABLE County_Race_2016_adjusted
(
GEOid nvarchar(55),
GEOid2 int,
County nvarchar(255),
State nvarchar(55),
TotalPopulation int,
NonHispanic int,
White_NonHispanic int,
Black_NonHispanic int,
NativeAmerican_NonHispanic int,
Asian_NonHispanic int,
PacificIslander_NonHispanic int,
Other_NonHispanic int,
MultiRacial_NonHispanic int,
Hispanic int,
Hispanic_White int,
Hispanic_Black int,
Hispanic_NativeAmerican int,
Hispanic_Asian int,
Hispanic_PacificIslander int,
Hispanic_Other int,
Hispanic_MultiRacial int
)
;



CREATE INDEX County_Race_2016_adjusted
on County_Race_2016_adjusted(County, State)


#INSERT ADJUSTED COUNTY NAMES
	#	truncate County_Race_2016_adjusted;
TRUNCATE TABLE County_Race_2016_adjusted;
INSERT INTO County_Race_2016_adjusted
SELECT 	GEOid,
		GEOid2,
		trim(replace(replace(replace(replace(replace(replace(replace(replace(substring_index(County,',',1),'County',''),'Parish', ''),'Municipio',''),'Borough',''),'St.', 'Saint'),'Ste.','Sainte'),'Census Area',''),'Municipality','')) as County,
		trim(substring_index(substring_index(County,',',-1),'-',1)) State,
		HD01_VD01,
		HD01_VD02,
		HD01_VD03,
		HD01_VD04,
		HD01_VD05,
		HD01_VD06,
		HD01_VD07,
		HD01_VD08,
		HD01_VD09,
		HD01_VD12,
		HD01_VD13,
		HD01_VD14,
		HD01_VD15,
		HD01_VD16,
		HD01_VD17,
		HD01_VD18,
		HD01_VD19
FROM 	county_race_2016
;




#Update county names based on adjustments from opioid dataset		
UPDATE county_race_2016_adjusted a
		join (select c.*
			from county_race_2016_adjusted c
				left join opiod_county o
					on c.county = o.county
					and c.state = o.state	
					where o.county is null) b
				on a.county = b.county
				and a.state = b.state
			join opioid_county_county_adjustments c
			on a.county = c.county
SET a.county = c.county_adjusted
			
			
			

#UPDATE COUNTY NAMES, AK UPDATES
UPDATE county_race_2016_adjusted
SET County = REPLACE(REPLACE (County, '-', ' '),' City and', '')
WHERE State = 'Alaska'




SELECT a.county, a.state, a.totalpopulation, b.county, b.state
FROM
(
select c.*
from county_race_2016_adjusted c
		left join opiod_county o
			on c.county = o.county
			and c.state = o.state	
where o.county is null
) a
	left join opioid_county_county_adjustments b
		on a.county = b.county




select distinct county from zipcode_city_county_state where state = 'md' order by county


#zip county city state db
CREATE TABLE zipcode_city_county_state
(
zipcode	nvarchar(15),
latitude float,
longitude float,
city nvarchar(155),
state nvarchar(10),
county nvarchar(165)
)


#load flat file into sql
truncate zipcode_city_county_state;
load data local infile '/users/lanetrisko/documents/work/ad hoc data projects/iron viz 2018/zip_codes_states.csv' into table zipcode_city_county_state 
	fields terminated by ','
	enclosed by '"'
  	lines terminated by '\r\n'
  	IGNORE 1 LINES 
;  select * from zipcode_city_county_state 








#treatment facilities
	# drop table opioid_treatment_facilities;
CREATE TABLE opioid_treatment_facilities
(
ProgramName nvarchar(255),
DBA nvarchar(255),
Street nvarchar(255),
City nvarchar(155),
State nvarchar(10),
Zipcode nvarchar(20),
Phone nvarchar(55),
County nvarchar(155)
)
;


select * from zipcode_county_mapping


#load flat file into sql
truncate opioid_treatment_facilities;
load data local infile '/users/lanetrisko/documents/work/ad hoc data projects/iron viz 2018/opioid_treatment_facilities.csv' into table opioid_treatment_facilities 
	fields terminated by ','
	enclosed by '"'
  	lines terminated by '\r\n'
  	IGNORE 1 LINES 
;  select * from opioid_treatment_facilities 




SELECT o.*, z.county
FROM opioid_treatment_facilities o
		left join zipcode_city_county_state z
			on z.zipcode = o.zipcode
where z.zipcode is null
ORDER BY State, z.county		







#CREATE ZIP CODE TRANSLATION FOR INCORRECT ZIP CODES IN TREATMENT TABLE
CREATE TABLE opioid_treatment_facilities_adjusted_zipcodes
(
Street nvarchar(255),
City nvarchar(100),
State nvarchar(10),
Zipcode nvarchar(20),
Zipcode_adjusted nvarchar(20)
)


INSERT INTO opioid_treatment_facilities_adjusted_zipcodes
VALUES
('4301 West Markham St., Slot #835','Little Rock','AR','72250','72205'),
('7490 South Camino De Oeste','Tucson','AZ','85757','85746'),
('218 East Commonwealth Ave.','Fullerton','CA','92632','92832'),
('1628 Broadway Suite A and B','Vallejo','CA','95489','94590'),
('218 East Commonwealth Ave.','Fullerton','CA','92632','92832'),
('931 S. West Street','Bainbridge','GA','39819','39817'),
('3535 Mayflower Blvd.','Springfield','IL','62711','62704'),
('2172 North Salem Street','Apex','NC','27523','27502'),
('100 Deputy Dean Miera Dr. S.W.','Albuquerque','NM','87151','87121'),
('3376 So. Eastern Ave. #148','Las Vegas','NV','89169','89104'),
('2201 Hempstead Turnpike','East Meadow','NY','11534','11554'),
('10701 East Blvd.','Cleveland','OH','44016','44106'),
('3710 SW US Veteran''s Hospital Road','Portland','OR','97239','97201'),
('223 Eagle School Road','Martinsburg','WV','25404','25401')






#UPDATE ZIP CODES ON TREATMENT TABLE
UPDATE opioid_treatment_facilities a # SELECT * FROM opioid_treatment_facilities a
	JOIN opioid_treatment_facilities_adjusted_zipcodes b
		on a.street = b.street
		and a.city = b.city
		and a.state = b.state
		and a.zipcode = b.zipcode
SET a.zipcode = b.zipcode_Adjusted


#UPDATE LINGERING ZIP
UPDATE opioid_treatment_Facilities
SET zipcode = '31717'
WHERE street = '931 S. West Street'
	and city = 'Bainbridge'
	and state = 'ga'


select * from zipcode_city_county_state
where county = 'Decatur' and state = 'ga'



#UPDATE COUNTIES IN TREATMENT FILE

UPDATE opioid_treatment_facilities o
		join zipcode_city_county_state z
			on o.zipcode = z.zipcode
SET o.county = z.county



#ADD COUNTIES WITHOUT TREATMENT CENTERS
INSERT INTO opioid_treatment_facilities
SELECT DISTINCT 
		o.programname,
		o.dba,
		o.street,
		o.city,
		z.state,
		o.zipcode,
		o.phone,
		z.county
FROM	zipcode_city_county_state z
			left join opioid_treatment_facilities o
				on z.county = o.county
				and z.state = o.state
WHERE o.programname is null







#COUNTY W AVERAGE LAT/LON
CREATE TABLE County_Lat_Lon
(
County nvarchar(155),
State nvarchar(10),
Latitude_County float,
Longitude_County float
)
;



TRUNCATE TABLE County_Lat_Lon;
INSERT INTO County_Lat_Lon
select county, 
		state, 
		avg(latitude) latitude, 
		avg(longitude) longitude
from zipcode_city_county_state
group by county, state

select * from County_Lat_Lon order by state


select distinct county from zipcode_city_county_state where state = 'la' order by county







#TREATMENT FACILITIES W LAT_LONG
	# drop table opiot_treatment_facilities_lat_lon;
CREATE TABLE opiot_treatment_facilities_lat_lon
(
Zipcode nvarchar(15),
Latitude float,
Longitude float
)



	#	truncate table opiot_treatment_facilities_lat_lon;
INSERT INTO opiot_treatment_facilities_lat_lon
select distinct
	o.zipcode,
	z.latitude,
	z.longitude
from opioid_treatment_facilities o
		join zipcode_city_county_state z
			on o.zipcode = z.zipcode



select * from zipcode_city_county_state




#COUNTYS W DISTANCES TO ALL TREATMENT CLINICS
	#	drop table County_Treatment_Facility_Distances;
CREATE TABLE County_Treatment_Facility_Distances
(
County nvarchar(155),
State nvarchar(10),
Zipcode nvarchar(15),
Distance_to_Treatment float
)

CREATE INDEX County_Treatment_Facility_Distances
on County_Treatment_Facility_Distances(County, State)





#Distince between county and closest sites
truncate table County_Treatment_Facility_Distances;
INSERT INTO County_Treatment_Facility_Distances
select  a.county, 
		a.state,
		b.zipcode, 
		69 *
    		DEGREES(ACOS(COS(RADIANS(Latitude_County))
      		* COS(RADIANS(b.Latitude))
         	* COS(RADIANS(Longitude_County - b.Longitude))
         	+ SIN(RADIANS(Latitude_County))
         	* SIN(RADIANS(b.Latitude)))) AS distance_in
from County_Lat_Lon a
		join opiot_treatment_facilities_lat_lon b
			on 1=1



select distinct county
from County_Treatment_Facility_Distances
where state = 'mn'







#checks

select a.*, b.*
from County_Lat_Lon a
join 
(	
	Select distinct a.county, a.stateabbreviation state from Opioid_Visualization_Dataset a
	join
		(
		select county, state,count(*)
		from opioid_visualization_dataset
		where closest_treatment_facility_distance is null
		group by county, state
		) b
		on a.county = b.county
		and a.state = b.state
) b
 on (a.county like concat('%',b.county,'%') and a.state = b.state)
 or (replace(a.county, 'Saint ','St. ') = b.county and a.state = b.state)












#OPIOD DATASET COUNTY
SELECT *
FROM 
(
SELECT DISTINCT REPLACE(
					REPLACE(	
						REPLACE(
							REPLACE
								(REPLACE(
										REPLACE(County, ' County',''),
								' Municipio',''),
							' Borough',''),
						' Census Area',''),
					' Parish',''),
				' Municipality','') county_a, county, State
FROM Opiod_County
ORDER BY State, County
) a
WHERE county not like '%county'
	and county not like '%municipio'
	and county not like '%borough'
	and county not like '%census area'
	and county not like '%parish'
	and county not like '%Municipality'
	and county not like '%city'








#TREATMENT DATASET COUNTY
SELECT DISTINCT County, State
FROM Opioid_Treatment_Facilities
ORDER BY State, County









