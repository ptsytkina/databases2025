drop database if exists cities;
create database cities;
use cities;
drop table if exists Kyiv;
drop table if exists Lviv;
drop table if exists Frankivsk;
drop table if exists Donetsk;
drop table if exists Chernivtsi;

create table Kyiv (
user_id int primary key auto_increment,
kyiv_card_holder_name varchar(100) not null,
number_of_rides_of_a_user int not null default 0
) ENGINE=InnoDB;

create table Lviv (
user_id int primary key auto_increment,
lviv_card_holder_name varchar(100) not null,
number_of_rides_of_a_user int not null default 0
) ENGINE=InnoDB;

create table Frankivsk  (
user_id int primary key auto_increment,
frankivsk_card_holder_name varchar(100) not null,
number_of_rides_of_a_user int not null default 0
) ENGINE=InnoDB;

create table Donetsk (
user_id int primary key auto_increment,
donetsk_card_holder_name varchar(100) not null,
number_of_rides_of_a_user int not null default 0
) ENGINE=InnoDB;

create table Chernivtsi (
user_id int primary key auto_increment,
chernivtsi_card_holder_name varchar(100) not null,
number_of_rides_of_a_user int not null default 0
) ENGINE=InnoDB;


-- імена та кількість поїздок згенерував чат джпт
insert into Kyiv (kyiv_card_holder_name, number_of_rides_of_a_user) values
('Олександр Іваненко', 25),
('Марія Петренко', 12),
('Ігор Сидорчук', 40),
('Наталія Шевченко', 5),
('Володимир Коваленко', 33),
('Світлана Лисенко', 18),
('Андрій Бондар', 7),
('Олена Гончарук', 29),
('Юрій Поліщук', 14),
('Тетяна Савчук', 22);

insert into Lviv (lviv_card_holder_name, number_of_rides_of_a_user) values
('Андрій Гнатюк', 17),
('Ольга Кравчук', 28),
('Тарас Білий', 6),
('Ірина Мельник', 22),
('Юрій Степанюк', 15),
('Марія Левицька', 11),
('Богдан Климчук', 35),
('Надія Федорук', 8),
('Петро Сеник', 26),
('Христина Дубовик', 19);

insert into Frankivsk (frankivsk_card_holder_name, number_of_rides_of_a_user) values
('Богдан Федорів', 19),
('Христина Савчук', 12),
('Олег Панчишин', 31),
('Руслана Гордійчук', 7),
('Дмитро Онуфрак', 24),
('Назар Блажко', 16),
('Мар’яна Тимчук', 27),
('Василь Юрків', 5),
('Іван Марчук', 38),
('Оксана Левчук', 14);

insert into Donetsk (donetsk_card_holder_name, number_of_rides_of_a_user) values
('Олексій Гончаренко', 10),
('Володимир Зеленський', 27),
('Максим Чернов', 45),
('Петро Порошенко', 14),
('Вітя Янукович', 32),
('Василь Стус', 9),
('Олександр Хоменко', 20),
('Юлія Тимошенко', 6),
('Аділь Абдураманов', 28),
('Дарина Гринько', 13);

insert into Chernivtsi (chernivtsi_card_holder_name, number_of_rides_of_a_user) values
('Василь Коцюбинський', 21),
('Леся Бондар', 9),
('Степан Мартинюк', 37),
('Олена Поліщук', 4),
('Михайло Андрусяк', 29),
('Галина Гаврилюк', 18),
('Ростислав Мельничук', 12),
('Іванна Лисак', 6),
('Тарас Мазур', 25),
('Оксана Чобанюк', 15);

with rides_union AS (
select user_id, kyiv_card_holder_name, number_of_rides_of_a_user as card_holder_name,  number_of_rides_of_a_user, 'Kyiv' as city
from Kyiv
UNION ALL
select user_id, lviv_card_holder_name, number_of_rides_of_a_user as card_holder_name,  number_of_rides_of_a_user, 'Lviv' as city
from Lviv
UNION ALL
select user_id, frankivsk_card_holder_name, number_of_rides_of_a_user as card_holder_name,  number_of_rides_of_a_user, 'Frankivsk' as city
from Frankivsk
UNION ALL
select user_id, donetsk_card_holder_name, number_of_rides_of_a_user as card_holder_name,  number_of_rides_of_a_user, 'Donetsk' as city
from Donetsk
UNION ALL
select user_id, chernivtsi_card_holder_name, number_of_rides_of_a_user as card_holder_name,  number_of_rides_of_a_user, 'Chernivtsi' as city
from Chernivtsi),

number_of_rides_per_person_where_more_than_ten (number_of_rides_of_a_user) as (
select number_of_rides_of_a_user 
from rides_union 
where number_of_rides_of_a_user >10
),

yanukovych as (
select card_holder_name
from rides_union
where card_holder_name = 'Вітя Янукович'
limit 1
),

bigger_than_22 as(
select card_holder_name from rides_union where number_of_rides_of_a_user > 22),

sum_rides as (
select city,  sum(number_of_rides_of_a_user) as rides_sum
from rides_union
group by city
having sum(number_of_rides_of_a_user) > 200),

rides_in_order as(
select user_id, card_holder_name,  number_of_rides_of_a_user from rides_union 
order by user_id desc),

rides_over_40 as(
select number_of_rides_of_a_user
from rides_union
where number_of_rides_of_a_user > 40
 limit 55
)
    
    
select * 
from rides_union;