desc user_constraints;
/*
c = check, NOT NULL, p = primary key, u = unique, r = reference(foreign key)
*/
select constraint_name, CONSTRAINT_TYPE from user_constraints;

/*
2. 컬럼 단위 제약조건
테이블을 생성할 때 컬럼에 직접 제약조건을 명시하는 경우.
NOT NULL 제약조건은 컬럼 레벨에서만 정의할 수 있다.

3. 테이블 단위 제약조건
NOT NULL을 제외한 모든 제약조건을 명시할 수 있다.
*/
-- 아래 제약 조건은 모두 컬럼 단위 제약조건임.
-- constraint 테이블명_컬럼_제약조건이름 제약조건명시
create table colst(
bun number(3) constraint colst_bun_pk primary key,
name varchar2(10) constraint colst_name_nn not null,
age number(5) constraint colst_age_ck check(age >= 20 and age <= 30),
addr varchar2(50) default '서울시 마포구 신수동',
jumin varchar2(14) constraint colst_jumin_uq unique);

-- 제약조건 확인
select constraint_name, CONSTRAINT_TYPE from user_constraints where TABLE_NAME='COLST';

-- 테이블 단위 제약조건
create table talst(
bun number(3),
name varchar2(10) constraint talst_name_nn not null,
age number(3),
addr varchar2(30) default '서울시 마포구',
jumin varchar2(14) constraint talst_jumin_nn not null,
constraint talst_bun_pk primary key(bun),
constraint talst_age_ch check(age >= 20 and age <= 30),
constraint talst_uq unique(jumin));
-- 제약조건 확인
select constraint_name, CONSTRAINT_TYPE from user_constraints where TABLE_NAME='TALST';


create table lib(
bun number(3),
book varchar2(20),
l_date date default sysdate,
constraint lib_bun_fk foreign key(bun) references talst(bun) on delete cascade);

select owner, r_owner, table_name, constraint_type, constraint_name
from user_constraints
where table_name in('LIB', 'TALST');

insert into talst (bun, name, age, addr, jumin) values(10, '김길동', 30, '서울시 마포구', '111111-1234567');
insert into talst (bun, name, age, addr, jumin) values(20, '이춘자', 20, '서울시 마포구', '111111-2234567');
insert into talst (bun, name, age, addr, jumin) values(30, '임아영', 20, '인천시 남구', '111111-2111567');
-- insert into tals values(30, '임아영', 20, '인천시 남구', '111111-2111567');
select * from talst;

insert into lib (bun, book) values(10, '자바책');
insert into lib (bun, book) values(20, '오라클책');
select * from lib;
-- 테이블 설정 할 때 cascade한거 확인
delete from talst where bun=10;

-- 제약조건 삭제
alter table talst drop constraint talst_jumin_nn;

select owner, r_owner, table_name, constraint_type, constraint_name
from user_constraints
where table_name in ('LIB', 'TALST');

-- 실습테이블 삭제
select * from tab;
drop table talst CASCADE CONSTRAINTS;
drop table gogek;
drop table sawon_phone;
drop table sawon;
drop table dept;
drop table lib;
drop table colst;
purge recyclebin;

-- 코드로 생성해보기
create table dept(
deptno number(3),
dname varchar2(10),
loc varchar2(10));

create table sawon(
     sabun number(3), 
     saname varchar2(10), 
     deptno number(3), 
     sajob varchar2(10), 
     sapay number(10), 
     sahire date default sysdate, 
     sasex varchar2(6), 
     samgr number(3));
create table gogek(gobun number(3),
                  goname varchar2(10),
                  gotel varchar2(14),
                  gojumin varchar(14),
                  godam number(3));

-- 제약조건 생성
alter table dept add constraint dept_deptno_pk primary key(deptno);
alter table dept add constraint dept_dname_uq unique(dname);
alter table sawon add CONSTRAINT sawon_sabun_pk primary key(sabun);
alter table sawon add CONSTRAINT sawon_deptno_fk foreign key (deptno) references dept(deptno) on delete cascade;
alter table sawon add CONSTRAINT sawon_sasex_ck check(sasex='남자' or sasex='여자');
alter table sawon add CONSTRAINT sawon_samgr_fk foreign key (samgr) references sawon(sabun) on delete cascade;
alter table gogek add CONSTRAINT gogek_gobun_pk primary key(gobun);
alter table gogek add CONSTRAINT gogek_gojumin_uq unique(gojumin);
alter table gogek add CONSTRAINT gogek_godam_fk foreign key(godam) references sawon(sabun) on delete cascade;
-- 확인
select owner, r_owner, table_name, constraint_type, constraint_name
from user_constraints
where table_name in ('DEPT', 'SAWON', 'GOGEK');