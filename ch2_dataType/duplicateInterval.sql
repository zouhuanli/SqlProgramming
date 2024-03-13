#需求:查询会话重叠数据
#建表
use employees;
CREATE TABLE sessions
(
    id        INT         NOT NULL AUTO_INCREMENT,
    app       VARCHAR(10) NOT NULL,
    usr       VARCHAR(10) NOT NULL,
    starttime TIME        NOT NULL,
    endtime   TIME        NOT NULL,
    PRIMARY KEY (id)
);

#模拟数据
INSERT INTO sessions(app, usr, starttime, endtime)
VALUES ('app1', 'user1', '08:30', '10:30');
INSERT INTO sessions(app, usr, starttime, endtime)
VALUES ('app1', 'user2', '08:30', '08:45');
INSERT INTO sessions(app, usr, starttime, endtime)
VALUES ('app1', 'user1', '09:00', '09:30');
INSERT INTO sessions(app, usr, starttime, endtime)
VALUES ('app1', 'user2', '09:15', '10:30');
INSERT INTO sessions(app, usr, starttime, endtime)
VALUES ('app1', 'user1', '09:15', '09:30');
INSERT INTO sessions(app, usr, starttime, endtime)
VALUES ('app1', 'user2', '10:30', '14:30');
INSERT INTO sessions(app, usr, starttime, endtime)
VALUES ('app1', 'user1', '10:45', '11:30');
INSERT INTO sessions(app, usr, starttime, endtime)
VALUES ('app1', 'user2', '11:00', '12:30');
INSERT INTO sessions(app, usr, starttime, endtime)
VALUES ('app2', 'user1', '08:30', '08:45');
INSERT INTO sessions(app, usr, starttime, endtime)
VALUES ('app2', 'user2', '09:00', '09:30');
INSERT INTO sessions(app, usr, starttime, endtime)
VALUES ('app2', 'user1', '11:45', '12:00');
INSERT INTO sessions(app, usr, starttime, endtime)
VALUES ('app2', 'user2', '12:30', '14:00');
INSERT INTO sessions(app, usr, starttime, endtime)
VALUES ('app2', 'user1', '12:45', '13:30');
INSERT INTO sessions(app, usr, starttime, endtime)
VALUES ('app2', 'user2', '13:00', '14:00');
INSERT INTO sessions(app, usr, starttime, endtime)
VALUES ('app2', 'user1', '14:00', '16:30');
INSERT INTO sessions(app, usr, starttime, endtime)
VALUES ('app2', 'user2', '15:30', '17:00');

CREATE UNIQUE INDEX idx_app_usr_s_e_key
    ON sessions (app, usr, starttime, endtime, id);
CREATE INDEX idx_app_s_e ON sessions (app, starttime, endtime);


select *
from sessions
where app = 'app1'
  and usr = 'user1';

#1.问题1：标示重叠，
#例如app1，user1的一个会话[start,end]，找出其他所有在区间内的会话。因为一条记录end>=start，所以
#以a为基准，b.end<a.start,b.start>a.end都没有重合区间

SELECT a.app, a.usr, a.starttime, a.endtime, b.starttime, b.endtime
from sessions a,
     sessions b
where (b.endtime >= a.starttime and b.starttime <= a.endtime);


#2.问题2：分组重叠。
#例如app1，user1的一个会话[start,end]，则app1,user1所有在这个区间内部的都算在一个。要按时间区间去重。
