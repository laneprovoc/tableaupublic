



#check distance to closest sites





#check number of sites within 20, 50, 100 mile radius











######
#OPIOD - RACE DATASET
######

	#	drop table Opioid_Visualization_Dataset;
CREATE TABLE Opioid_Visualization_Dataset
(
StateFP int,
CountyFP int,
Year int,
Indicator nvarchar(255),
Value float,
County nvarchar(255),
State nvarchar(55),
StateAbbreviation nvarchar(10),
Indicator_Flag nvarchar(55),
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
Hispanic_MultiRacial int,
Percentage_Black float,
Percentage_White float,
Percentage_Hispanic float,
Percentage_Native float,
Opioid_Treatment_Facilities_County int,
Opiod_Treatment_Facilities_Less_Than_30_Miles int,
Is_There_Treatment_Within_30_Miles int,
Opiod_Treatment_Facilities_Less_Than_60_Miles int,
Is_There_Treatment_Within_60_Miles int,
Opiod_Treatment_Facilities_Less_Than_90_Miles int,
Is_There_Treatment_Within_90_Miles int,
Closest_Treatment_Facility_Distance int
)
;








#INSERT RAW OPIOD DATASET W APPENDED POPULATION RACE COUNTS
TRUNCATE TABLE Opioid_Visualization_Dataset;
INSERT INTO Opioid_Visualization_Dataset
SELECT DISTINCT
		o.*,
		'' Indicator_Flag,
		TotalPopulation,
		NonHispanic,
		White_NonHispanic,
		Black_NonHispanic,
		NativeAmerican_NonHispanic,
		Asian_NonHispanic,
		PacificIslander_NonHispanic,
		Other_NonHispanic,
		MultiRacial_NonHispanic,
		Hispanic,
		Hispanic_White,
		Hispanic_Black,
		Hispanic_NativeAmerican,
		Hispanic_Asian,
		Hispanic_PacificIslander,
		Hispanic_Other,
		Hispanic_MultiRacial,
		Black_NonHispanic/TotalPopulation Percentage_Black,
		White_NonHispanic/TotalPopulation Percentage_White,
		Hispanic/TotalPopulation Percentage_Hispanic,
		NativeAmerican_NonHispanic/TotalPopulation Percentage_Native,
		coalesce(facilities_percounty, 0) Opioid_Treatment_Facilities_County,
		coalesce(clinic_30.clinic_count,0) Opiod_Treatment_Facilities_Less_Than_30_Miles,
		CASE when clinic_30.clinic_count is null then 0 else 1 end as Is_There_Treatment_Within_30_Miles,
		coalesce(clinic_60.clinic_count,0) Opiod_Treatment_Facilities_Less_Than_60_Miles,
		CASE when clinic_60.clinic_count is null then 0 else 1 end as Is_There_Treatment_Within_60_Miles,
		coalesce(clinic_90.clinic_count,0) Opiod_Treatment_Facilities_Less_Than_90_Miles,
		CASE when clinic_90.clinic_count is null then 0 else 1 end as Is_There_Treatment_Within_90_Miles,
		closest_clinic.closest_clinic_distance
FROM	opiod_county o
			left join county_race_2016_adjusted c
				on o.county = c.county
				and o.state = c.state
			left join
				(
				SELECT county,
						state,
					count(*) facilities_percounty
				FROM opioid_treatment_facilities
				GROUP BY County, state
				) t
				on o.county = t.county
				and o.stateabbreviation = t.state
			left join 
				(SELECT County,
						state,
						count(*) clinic_count
				FROM County_Treatment_Facility_Distances d
				WHERE Distance_to_Treatment < 30
				GROUP BY County,
						state) clinic_30
					on o.county = clinic_30.county
					and o.stateabbreviation = clinic_30.state
			left join 
				(SELECT County,
						state,
						count(*) clinic_count
				FROM County_Treatment_Facility_Distances d
				WHERE Distance_to_Treatment < 60
				GROUP BY County,
						state) clinic_60
					on o.county = clinic_60.county
					and o.stateabbreviation = clinic_60.state
			left join 
				(SELECT County,
						state,
						count(*) clinic_count
				FROM County_Treatment_Facility_Distances d
				WHERE Distance_to_Treatment < 90
				GROUP BY County,
						state) clinic_90
					on o.county = clinic_90.county
					and o.stateabbreviation = clinic_90.state
			left join
				(SELECT County,
						state,
						min(Distance_to_Treatment) closest_clinic_distance
				FROM County_Treatment_Facility_Distances
				GROUP BY County,
						state
				) closest_clinic
					on o.county = closest_clinic.county
					and o.stateabbreviation = closest_clinic.state
				
#where c.county is null
#order by o.county
;





#INSERT DEATHRATE + ESTIMATE SUPPLEMENT TO DATASET
	#	truncate table Opioid_Visualization_Dataset;
INSERT INTO Opioid_Visualization_Dataset
SELECT DISTINCT
	est.StateFP,
	est.CountyFP,
	est.Year,
	'Death Rate-Combined' as Indicator,
	coalesce(det.value, est.value),
	est.County,
	est.State,
	est.StateAbbreviation,
	case when det.value is null then 'Estimate' else 'Actual' end as Indicator_Flag,
	TotalPopulation,
	NonHispanic,
	White_NonHispanic,
	Black_NonHispanic,
	NativeAmerican_NonHispanic,
	Asian_NonHispanic,
	PacificIslander_NonHispanic,
	Other_NonHispanic,
	MultiRacial_NonHispanic,
	Hispanic,
	Hispanic_White,
	Hispanic_Black,
	Hispanic_NativeAmerican,
	Hispanic_Asian,
	Hispanic_PacificIslander,
	Hispanic_Other,
	Hispanic_MultiRacial,
	Black_NonHispanic/TotalPopulation Percentage_Black,
	White_NonHispanic/TotalPopulation Percentage_White,
	Hispanic/TotalPopulation Percentage_Hispanic,
	NativeAmerican_NonHispanic/TotalPopulation Percentage_Native,
		coalesce(facilities_percounty, 0) Opioid_Treatment_Facilities_County,
		coalesce(clinic_30.clinic_count,0) Opiod_Treatment_Facilities_Less_Than_30_Miles,
		CASE when clinic_30.clinic_count is null then 0 else 1 end as Is_There_Treatment_Within_30_Miles,
		coalesce(clinic_60.clinic_count,0) Opiod_Treatment_Facilities_Less_Than_60_Miles,
		CASE when clinic_60.clinic_count is null then 0 else 1 end as Is_There_Treatment_Within_60_Miles,
		coalesce(clinic_90.clinic_count,0) Opiod_Treatment_Facilities_Less_Than_90_Miles,
		CASE when clinic_90.clinic_count is null then 0 else 1 end as Is_There_Treatment_Within_90_Miles,
		closest_clinic.closest_clinic_distance
FROM
	(
	select distinct *
	from opiod_county
	where indicator = 'drugdeathrate_est'
	) est 
 	left join
	(
	select *
	from opiod_county
	where indicator = 'drugdeathrate'
	) det
		on est.year = det.year
		and est.county = det.county
		and est.state = det.state
	left join county_race_2016_adjusted c
		on est.county = c.county
		and est.state = c.state
			left join
				(
				SELECT county,
						state,
					count(*) facilities_percounty
				FROM opioid_treatment_facilities
				GROUP BY County, state
				) t
				on est.county = t.county
				and est.stateabbreviation = t.state
			left join 
				(SELECT County,
						state,
						count(*) clinic_count
				FROM County_Treatment_Facility_Distances d
				WHERE Distance_to_Treatment < 30
				GROUP BY County, state) clinic_30
					on est.county = clinic_30.county
					and est.stateabbreviation = clinic_30.state
			left join 
				(SELECT County,
						state,
						count(*) clinic_count
				FROM County_Treatment_Facility_Distances d
				WHERE Distance_to_Treatment < 60
				GROUP BY County, state) clinic_60
					on est.county = clinic_60.county
					and est.stateabbreviation = clinic_60.state
			left join 
				(SELECT County,
						state,
						count(*) clinic_count
				FROM County_Treatment_Facility_Distances d
				WHERE Distance_to_Treatment < 90
				GROUP BY County, state) clinic_90
					on est.county = clinic_90.county
					and est.stateabbreviation = clinic_90.state
			left join
				(SELECT County,
						state,
						min(Distance_to_Treatment) closest_clinic_distance
				FROM County_Treatment_Facility_Distances
				GROUP BY County, state) closest_clinic
					on est.county = closest_clinic.county
					and est.stateabbreviation = closest_clinic.state
;




select * from Opioid_Visualization_Dataset
where Indicator ='Death Rate-Combined'


Select distinct a.county, a.state
from Opioid_Visualization_Dataset a
join
(
select county, state,count(*)
from opioid_visualization_dataset
where closest_treatment_facility_distance is null
group by county, state
) b
on a.county = b.county
and a.state = b.state
#where a.state = 'alaska'
order by state, county


select distinct t.county, t.state, o.county, o.state
from County_Treatment_Facility_Distances t
		left join Opioid_Visualization_Dataset o
			on t.county = o.county
			and t.state = o.stateabbreviation
order by t.state, t.county


SELECT t.county, t.state, o.county, stateabbreviation
FROM 
(
select distinct county, state
from County_Treatment_Facility_Distances t
order by t.state, t.county
) t 
	left join
(select distinct county, stateabbreviation
from Opioid_Visualization_Dataset
order by state, county
) o
		on t.county = o.county
		and t.state = o.stateabbreviation
order by t.state, t.county
	

select * from County_Treatment_Facility_Distances where county = 'st. louis county' and state = 'mn' order by distance_to_treatment

select * from opioid_treatment_facilities order by state, county
