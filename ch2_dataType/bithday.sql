#1.参考https://github.com/datacharmer/test_db 安装test_db和数据

#2.需求：根据某个用户的出生日期和当前日期，计算最近（后面）的生日。若闰月返回2月28日；若不是闰月，返回3月1日

#结果：
use employees;
SELECT name, birthday, IF(cur > today, cur, next) AS birth_day
FROM (SELECT name,
             birthday,
             today,
             DATE_ADD(cur, INTERVAL IF(DAY(birthday) = 29
                                           && DAY(cur) = 28, 1, 0) DAY)  AS cur,
             DATE_ADD(next, INTERVAL IF(DAY(birthday) = 29
                                            && DAY(cur) = 28, 1, 0) DAY) AS next
      FROM (select name,
                   birthday,
                   today,
                   DATE_ADD(birthday, INTERVAL diff YEAR)     AS cur,
                   DATE_ADD(birthday, INTERVAL diff + 1 YEAR) AS next
            FROM (SELECT CONCAT(last_name, ' ', first_name) AS Name,
                         birth_date                         As BirthDay,
                         YEAR(NOW()) - YEAR(birth_date)     AS diff,
                         NOW()                              as today
                  FROM employees.employees) AS a)
               AS b) As c;

#解析：
#a. 查询出生日期到今年的相差年份
SELECT CONCAT(last_name, ' ', first_name) AS Name,
       birth_date                         As BirthDay,
       YEAR(NOW()) - YEAR(birth_date)     AS diff,
       NOW()                              as today
FROM employees.employees;

#b.查询出生日期+相差年份，出生日期+相差年份+1。也就是今年生日，明年生日
select name,
       birthday,
       today,
       DATE_ADD(birthday, INTERVAL diff YEAR)     AS cur,
       DATE_ADD(birthday, INTERVAL diff + 1 YEAR) AS next
FROM (SELECT CONCAT(last_name, ' ', first_name) AS Name,
             birth_date                         As BirthDay,
             YEAR(NOW()) - YEAR(birth_date)     AS diff,
             NOW()                              as today
      FROM employees.employees) AS a;

#c.处理闰月
SELECT name,
       birthday,
       today,
       #处理闰月
       DATE_ADD(cur, INTERVAL IF(DAY(birthday) = 29
                                     && DAY(cur) = 28, 1, 0) DAY)  AS cur,
       DATE_ADD(next, INTERVAL IF(DAY(birthday) = 29
                                      && DAY(cur) = 28, 1, 0) DAY) AS next
FROM (select name,
             birthday,
             today,
             DATE_ADD(birthday, INTERVAL diff YEAR)     AS cur,
             DATE_ADD(birthday, INTERVAL diff + 1 YEAR) AS next
      FROM (SELECT CONCAT(last_name, ' ', first_name) AS Name,
                   birth_date                         As BirthDay,
                   YEAR(NOW()) - YEAR(birth_date)     AS diff,
                   NOW()                              as today
            FROM employees.employees) AS a)
         AS b;

#最终结果
#判断今年生日是否已过
SELECT name, birthday, IF(cur > today, cur, next) AS birth_day
FROM (SELECT name,
             birthday,
             today,
             DATE_ADD(cur, INTERVAL IF(DAY(birthday) = 29
                                           && DAY(cur) = 28, 1, 0) DAY)  AS cur,
             DATE_ADD(next, INTERVAL IF(DAY(birthday) = 29
                                            && DAY(cur) = 28, 1, 0) DAY) AS next
      FROM (select name,
                   birthday,
                   today,
                   DATE_ADD(birthday, INTERVAL diff YEAR)     AS cur,
                   DATE_ADD(birthday, INTERVAL diff + 1 YEAR) AS next
            FROM (SELECT CONCAT(last_name, ' ', first_name) AS Name,
                         birth_date                         As BirthDay,
                         YEAR(NOW()) - YEAR(birth_date)     AS diff,
                         NOW()                              as today
                  FROM employees.employees) AS a)
               AS b) As c;
