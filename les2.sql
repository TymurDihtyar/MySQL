-- 1.Вибрати усіх клієнтів, чиє ім'я має менше ніж 6 символів.
select *
from client
where length(FirstName) < 6;

-- 2.Вибрати львівські відділення банку.
select *
from department
where DepartmentCity = 'lviv';

-- 3.Вибрати клієнтів з вищою освітою та посортувати по прізвищу.
select *
from client
where Education = 'high'
order by FirstName;

-- 4.Виконати сортування у зворотньому порядку над таблицею Заявка і вивести 5 останніх елементів.
select *
from application
order by idApplication desc
limit 5;

-- 5.Вивести усіх клієнтів, чиє прізвище закінчується на OV чи OVA.
select *
from client
where LastName like '%ov'
   or LastName like '%ova';

-- 6.Вивести клієнтів банку, які обслуговуються київськими відділеннями.
select client.*, City
from client
         join department d on d.idDepartment = client.Department_idDepartment
where DepartmentCity = 'kyiv';

-- 7.Знайти унікальні імена клієнтів.
select distinct FirstName
from client;

-- 8.Вивести дані про клієнтів, які мають кредит більше ніж на 5000 гривень.
select *
from client
         join application a on client.idClient = a.Client_idClient
where Currency = 'gryvnia'
  and Sum > 5000;

-- 9.Порахувати кількість клієнтів усіх відділень та лише львівських відділень.
    (select count(*) from client)
    union
    (select count(*)
     from client
              join department d on d.idDepartment = client.Department_idDepartment
     where DepartmentCity = 'lviv');

-- 10.Знайти кредити, які мають найбільшу суму для кожного клієнта окремо.
select Client_idClient, MAX(Sum)
from application
group by Client_idClient;

-- 11. Визначити кількість заявок на крдеит для кожного клієнта.
select Client_idClient, sum(idApplication)
from application
group by Client_idClient;

-- 12. Визначити найбільший та найменший кредити.
    (select * from application order by Sum desc limit 1)
    union
    (select * from application order by Sum limit 1);

-- 13. Порахувати кількість кредитів для клієнтів,які мають вищу освіту.
select count(*), Education
from client
         join application a on client.idClient = a.Client_idClient
where Education = 'high';

-- 14. Вивести дані про клієнта, в якого середня сума кредитів найвища.
select avg(Sum), Client_idClient
from application
group by Client_idClient;

-- 15. Вивести відділення, яке видало в кредити найбільше грошей
select sum(sum) as MaxSum, DepartmentCity
from department
         join client c on department.idDepartment = c.Department_idDepartment
         join application a on c.idClient = a.Client_idClient
group by DepartmentCity
limit 1;

-- 16. Вивести відділення, яке видало найбільший кредит.
select Max(sum) as MaxSum, DepartmentCity
from department
         join client c on department.idDepartment = c.Department_idDepartment
         join application a on c.idClient = a.Client_idClient
group by DepartmentCity
limit 1;

-- 17. Усім клієнтам, які мають вищу освіту, встановити усі їхні кредити у розмірі 6000 грн.
update application join client c on c.idClient = application.Client_idClient
set Sum=6000,
    Currency='Gryvnia'
where Education = 'high';

-- 18. Усіх клієнтів київських відділень пересилити до Києва.
update department join client c on department.idDepartment = c.Department_idDepartment
set City='kyiv'
where DepartmentCity = 'kyiv';

-- 19. Видалити усі кредити, які є повернені.
delete
from application
where CreditState = 'not returned';

-- 20. Видалити кредити клієнтів, в яких друга літера прізвища є голосною.
delete
from application
where Client_idClient in (select idClient from client where substring(LastName, 2, 1) in ('a', 'e', 'i', 'o', 'u'));

-- 21.Знайти львівські відділення, які видали кредитів на загальну суму більше ніж 5000
select *
from department
         join client c on department.idDepartment = c.Department_idDepartment
         join application a on c.idClient = a.Client_idClient
where DepartmentCity = 'lviv'
  and Sum > 5000;

-- 22.Знайти клієнтів, які повністю погасили кредити на суму більше ніж 5000
select *
from client
         join application a on client.idClient = a.Client_idClient
where CreditState = 'returned'
  and Sum > 5000;

-- 23.Знайти максимальний неповернений кредит.
select *
from application
where CreditState = 'not returned'
order by Sum desc
limit 1;

-- 24.Знайти клієнта, сума кредиту якого найменша
select *
from client
         join application a on client.idClient = a.Client_idClient
order by Sum
limit 1;

-- 25.Знайти кредити, сума яких більша за середнє значення усіх кредитів
select *
from application
where Sum > (select avg(sum) from application);

-- 26. Знайти клієнтів, які є з того самого міста, що і клієнт, який взяв найбільшу кількість кредитів
select *
from client
where City = (select City
              from application
                       join client c on c.idClient = application.Client_idClient
              group by Client_idClient
              order by count(sum) desc
              limit 1);

-- 27. Місто клієнта з найбільшою кількістю кредитів
select City
from client
where idClient = (select Client_idClient from application group by Client_idClient order by count(sum) desc limit 1);



