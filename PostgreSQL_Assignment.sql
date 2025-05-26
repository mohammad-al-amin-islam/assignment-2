
CREATE TABLE ranger (
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    region VARCHAR(255) NOT NULL
);

CREATE TABLE species ( 
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(255) NOT NULL,
    scientific_name VARCHAR(255) NOT NULL, 
    discovery_date DATE NOT NULL,
    conservation_status VARCHAR(255) NOT NULL
);

CREATE TABLE sighting (
    sighting_id SERIAL PRIMARY KEY,
    species_id INT NOT NULL,
    ranger_id INT NOT NULL,
    sighting_time TIMESTAMP NOT NULL,
    location VARCHAR(255) NOT NULL,
    note TEXT,
    FOREIGN KEY (ranger_id) REFERENCES ranger(ranger_id),
    FOREIGN KEY (species_id) REFERENCES species(species_id)
);

insert into ranger (name, region) values 
('Alice Green', 'Northern Hills'),
('Bob White', 'River Delta'),
('Carol King', 'Mountain Range');

insert into species (common_name, scientific_name, discovery_date, conservation_status) values 
('Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
('Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
('Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
('Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered');

insert into sighting (species_id, ranger_id, sighting_time, location, note) values 
(1, 1, '2024-05-10 07:45:00', 'Peak Ridge', 'Camera trap image captured'),
(2, 2, '2024-05-12 16:20:00', 'Bankwood Area', 'Juvenile seen'),
(3, 3, '2024-05-15 09:10:00', 'Bamboo Grove East', 'Feeding observed'),
(1, 2, '2024-05-18 18:30:00', 'Snowfall Pass', 'NULL');



-- 1. Register a new ranger with provided data with name = 'Derek Fox' and region = 'Coastal Plains'
insert into ranger (name, region) values 
('Derek Fox', 'Coastal Plains');


-- 2. Count unique species ever sighted.
select count(distinct species_id) as unique_species_count
from sighting;

-- 3. Find all sightings where the location includes "Pass".
select * from sighting
where location LIKE '%Pass%';

-- 4.  List each ranger's name and their total number of sightings.
select ranger.name, count(sighting.sighting_id) as total_sightings
from ranger
join sighting on ranger.ranger_id = sighting.ranger_id
group by ranger.name;


-- 5. List species that have never been sighted.
select species.common_name
from species
left join sighting on species.species_id = sighting.species_id
where sighting.species_id is null;

-- 6. Show the most recent 2 sightings.
select species.common_name, sighting.sighting_time, ranger.name
from species
join sighting on species.species_id = sighting.species_id
join ranger on sighting.ranger_id = ranger.ranger_id
order by sighting.sighting_time desc
limit 2;


-- 7. Update all species discovered before year 1800 to have status 'Historic'.
update species
set conservation_status = 'Historic'
where discovery_date < '1800-01-01';

-- 8. Label each sighting's time of day as 'Morning', 'Afternoon', or 'Evening'.
select species.common_name, sighting.sighting_time,
case
when extract(hour from sighting.sighting_time) >= 6 and extract(hour from sighting.sighting_time) < 12 then 'Morning'
when extract(hour from sighting.sighting_time) >= 12 and extract(hour from sighting.sighting_time) < 18 then 'Afternoon'
when extract(hour from sighting.sighting_time) >= 18 and extract(hour from sighting.sighting_time) < 24 then 'Evening'
end as time_of_day
from species
join sighting on species.species_id = sighting.species_id;


-- 9. Delete rangers who have never sighted any species
delete from ranger
where ranger_id not in (select ranger_id from sighting);