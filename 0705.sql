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

-- like문, order by절 사용: 검색된 데이터의 번호의 최신순으로 정렬
select sabun, saname, deptno, sapay, sahire from sawon order by 1 desc;

-- 번호를 primary key로 증가시킬 경우 자동으로 생성하도록 구현할 수 있다.
-- start with 번호: 지정번호부터 시작
-- increment by: 지정번호대로 증가
create sequence sawon_seq increment by 1 start with 25;
-- nextVal: 시퀀수 함수를 증가
insert into sawon values(sawon_seq.nextVal, '박점심', 20, '과장', 5000, sysdate, '남자', 10);
commit;
select sabun, saname, deptno, sapay, sahire from sawon order by 1 desc;

list;


-- 합성연산자: 문자열 연결 연산자 ||
-- as alias
select saname ||'의 사번은 ' || sabun || '입니다.' from sawon;
select saname ||'의 사번은 ' || sabun || '입니다.' as 내용 from sawon;
select saname ||'의 사번은 ' || sabun || '입니다.' 내용 from sawon; -- as는 생략가능
select saname ||'의 사번은 ' || sabun || '입니다.' "sawon Contents" from sawon; -- 되지만 비추
select saname ||'의 사번은 ' || sabun || '입니다.' "sawon_contents" from sawon;
select saname ||'의 사번은 ' || sabun || '입니다.' "sawonContents" from sawon;

-- 문제) 김길동의 급여는 10000이다. 이번달 보너스는 급여의 50%이다.
select saname || '의 급여는' || sapay || '입니다.' Message,
'이번달 보너스는' || sapay/2 || '입니다.' Bonus from sawon;

-- 문제) 부서번호 20 김길동의 급여는 3000이다. 2000 ~ 3000 사이의 급여를 받는 20번 부서사원의 정보를 출력하되
-- 컬럼은 deptno, message로 출력하시오.
select '부서번호 ' || deptno "deptno", saname || '의 급여는' || sapay || '이다.' "Message"
from sawon where sapay >= 2000 and sapay <= 3000 and deptno=20;
select '부서번호 ' || deptno "deptno", saname || '의 급여는' || sapay || '이다.' "Message"
from sawon where sapay between 2000 and 3000 and deptno=20;

-- or 연산자, in() 연산자, not in()
-- in 연산자를 사용하면 반복문 코드를 짤 때 or을 쓰는 것 보다 훨씬 쉽다.
select saname, deptno, sapay from sawon where deptno = 10 or deptno = 20 order by 2 asc;
select saname, deptno, sapay from sawon where deptno in(10, 20) order by 2 asc;

-- like 문자열 연산자
-- % 어떤 여러 문자열
-- _ 어떤 한 문자열
select saname from sawon where saname like '%길%';
select saname from sawon where saname like '__동';

-- dual 테이블
-- 한 행으로 결과를 출력하기 위한 테이블.
-- 산술연산, 가상 컬럼등의 값을 한 번에 출력하기 위한 목적
select 100 * 2 result from dual;
select sysdate today from dual;
select * from dual; -- 아무의미없는 row의 값이 존재.

-- 숫자함수
select -10, abs(-10) from dual;
select sin(10), cos(10), tan(10), log(10, 2) from dual;
-- -2는 위에서 두 자리를 의미
select round(888.8888), round(888.8888, 0), round(888.8888, 2), round(888.8888, -2) from dual;
-- 지정한 자리수 버림
select trunc(888.8888), trunc(888.8888, 0), trunc(888.8888, 2), trunc(888.8888, -2) from dual;
-- 올림, 내림
select ceil(10.001), floor(10.99) from dual;

-- 사원명, 급여, 월급(급여/12), 세금(급여의 3.3%)를 출력하시오.
-- 단, 월급은 십 단위로 반올림하고, 세금은 원 단위로 절삭하시오.
select saname, sapay, round(sapay/12, -1) "earn/month", floor(sapay*0.033) "vat" from sawon;
select saname, sapay, round(sapay/12, -1) "earn/month", trunc(sapay*0.033, -1) "vat" from sawon;

-- lower: 문자열 전체를 소문자로 변환
-- upper: 문자열 전체를 대문자로 변환
-- initcap: 문자열의 첫 번째 문자만 대문자로 변환
-- length: 문자열 길이를 구하는 함수
-- lengthb: 지정된 포맷에 의한 문자열의 바이트 수를 반환
select lower('kOstal88 OraclE'), upper('kOstal99 OraclE'), initcap('kOstal99 OraclE') from dual;
select length('Kostal88 Oracle') from dual;
select lengthb('Kostal88'), lengthb('오라클') from dual;
select * from nls_database_parameters where parameter like '%CHARACTERSET%';
-- AL32UTF8: 한글 정렬 기능을 지원, 3바이트 공간을 차지.
-- KO16KSC5601(한글완성형),
-- KO16KSC5601, MSWIN949 -> 2바이트
-- UTF8 -> 3바이트

-- trim: 좌우 공백을 제거
-- ltrim, rtrim: 각각 제거
select trim(' kostal88 '), ltrim(' kostal88 '), rtrim(' kostal88 ') from dual;
-- 문자열의 길이로 비교
select length(trim(' kostal88 ')), length(ltrim(' kostal88 ')), length(rtrim(' kostal88 ')) from dual;
-- 특정 문자열 찾아서 삭제
select trim('ㄱ' from 'ㄱkostan ㄱㄱㄱㄱㄱ') from dual;

-- instr 함수: 문자열 중에서 지정한 특정 문자가 포함된 위치를 반환하는 함수.
-- instr(문자열, 찾을 문자열, 검색시작, n번째)
select instr('kosta_kosta', 'k', 1, 2) from dual;
select instr('kosta_kosta', 'k', 1, 1) from dual;
select instr('kosta_kosta', 'k', -1, 1) from dual;
select instr('kosta_kosta', 'k', -1, 2) from dual;
select instr('kosta_kosta', 'a') from dual;

-- substr(문자열, n부터 n개)
-- 오라클 인덱스는 1부터 시작이 됨!
select substr('Welcome to Oracle', 5, 3) from dual;
select substr('Welcome to Oracle', -3, 3) from dual;

-- 연습문제를 위한 실습 테이블
create table memphone(
    num number(3) constraint memphone_num_pk primary key,
    name varchar2(20),
    pnum varchar2(25));
create sequence memphone_seq increment by 1 start with 1;

insert into memphone values(memphone_seq.nextVal,'김길동','02)567-1267');
insert into memphone values(memphone_seq.nextVal,'노래하','032)567-1267');
insert into memphone values(memphone_seq.nextVal,'송유섭','032)567-1267');
insert into memphone values(memphone_seq.nextVal,'김경호','051)567-1267');
insert into memphone values(memphone_seq.nextVal,'오진아','02)567-1267');
insert into memphone values(memphone_seq.nextVal,'박수정','02)567-1267');
insert into memphone values(memphone_seq.nextVal,'정수미','062)567-1267');

-- 문제) memphone 테이블에서 사용자의 전화번호 중에 사용자, 국번, 전화번호 형태로 출력
select
    name as "사용자",
    substr(pnum, 1, instr(pnum, ')', 1, 1)-1) "국번",
    substr(pnum, instr(pnum, ')', 1 , 1)+1) "전화번호"
    from memphone;
    
-- 바이트 수로 자르기 (항목, 시작 바이트, 바이트 크기)
select substrb('김길동입니다.', 1, 3) from dual;
select substrb('김길동입니다.', 4, 3) from dual;
select substrb('김길동입니다.', 7, 3) from dual;
select substrb('김길동입니다.', 4, 6) from dual;

-- 문자 채우기 함수
select rpad(saname, 8, 'x'), lpad(saname, 8, 'x') from sawon;

-- 문제) 고객테이블에서 주민번호 뒷자리를 *로 보안처리해서 출력하시오.
select rpad(substr(gojumin, 1, 8), 14, '*') from gogek;

-- decode: 오라클에서만 제공하는 SQL함수
-- decode(기준값, 조건1, 결과1, 조건2, 결과2, ..., 그외의 결과) 컬럼명 
-- case 함수 : decode 기능을 확장한 함수
-- case [기준값] when 조건1 then 결과1
-- when 조건2 then 결과2
-- else 그외결과
-- end "컬럼명"
-- 차이) decode 함수는 기준값을 비교하는 컬럼값이 "=" 비교를 통해서만 조건과 일치하는 경우에
-- 다른 값으로 대치 하지만 case 함수는 이외에도 산술,논리,관계 연산과 같은 다양한 비교가 가능하다.
-- [] 은 생략이 되면 when절에서 비교할 수 있다.
select saname, deptno,
decode (deptno, 10, '총괄부', 20, '관리부', 30, '총무부', 50, '전산부', '개발부')
"임시부서명" from sawon order by 2 asc;

select saname, deptno,
case deptno when 10 then '영업부'
when 20 then '관리부'
else '전산부' end "임시부서명" from sawon order by 2 asc;

select saname, deptno,
case when deptno = 10 then '영업부'
when deptno = 20 then '관리부'
else '전산부' end "임시부서명" from sawon order by 2 asc;

-- 문제1) 고객테이블에서 고객명, 주민번호, 성별을 출력
select goname, gojumin,
decode (substr(gojumin, 8, 1), 1, '남자', 2, '여자', 3, '남자', 4, '여자')
"성별" from gogek;

-- 문제2) 사원명, 급여, 보너스 출력
-- 단, 보너스는 급여가 1000 미만 -> 급여의 10%
--                  1000 ~ 2000 -> 급여의 15%
--                  2000 초과 -> 급여의 20%
--                  null -> 0
select saname "사원명", sapay "연봉",
case when sapay < 1000 then sapay * 0.1
when sapay >= 1000 and sapay < 2000 then sapay * 0.15
when sapay >= 2000 then sapay * 0.2
else 0 end "보너스" from sawon;

-- yyyy 년도 표기, cc 세기 표현
select sysdate, to_char(sysdate,'yyyy'), to_char(sysdate,'CC') from dual;
select sysdate, to_char(sysdate,'YEAR') from dual; -- 영문표기
select sysdate, to_char(sysdate,'yy') from dual; -- 년도 2자리
select sysdate, to_char(sysdate,'month'), to_char(sysdate,'mon') from dual; -- 월 
select sysdate, to_char(sysdate,'q') from dual; -- 분기 
select sysdate, to_char(sysdate,'d') from dual; -- 요일 (1~7요일 ,1 : 일요일)
select sysdate, to_char(sysdate,'dy') from dual; -- 요일 한글
select sysdate, to_char(sysdate,'day') from dual;
select sysdate, to_char(sysdate,'dd') from dual; -- 일
select sysdate, to_char(sysdate,'ddd') from dual; -- 365일
select sysdate, to_char(sysdate,'hh'),to_char(sysdate,'hh24') from dual; -- 시간
select sysdate, to_char(sysdate,'mi') from dual;
select sysdate, to_char(sysdate,'ss') from dual;

select sysdate, to_char(sysdate, 'yyyy') || '년 ' || to_char(sysdate, 'mm') || '월 ' || to_char(sysdate, 'dd') || '일 '
|| to_char(sysdate, 'day') || '이며 ' || to_char(sysdate, 'q') || '분기, 앞으로 1년 중에' || to_char(sysdate, 'ddd') || '일 남았습니다.'
"SS" from dual;

select sysdate, to_char(sysdate, 'yyyy"년" mm"월" d"일" day"이며') "ss" from dual;

-- 문제3) 사원명, 입사일, 근무기간([xx년 xx개월])로 출력하시오.
select saname, sahire, trunc(months_between(sysdate, sahire)/12, 0) || '년'
|| trunc(mod(months_between(sysdate, sahire), 12), 0) || '개월' 근무기간
from sawon;

-- 처음으로 맞이하는 다음 월요일 날짜
-- : 해당 날짜로부터 시작해서 명시된 요일을 만나면 해당 되는 날짜를 반환하는 함수
-- : 오늘을 기준으로 가장 가까운 다음 월요일은 언제인지 반환함.
select next_day(sysdate, '월') from dual;
-- 지정한 년/월의 마지막 날짜 (이달의 마지막 날짜는..)
select last_day(sysdate) from dual;
-- add_months: 특정 개월 수를 더한 날짜를 구해주는 함수
select saname, sahire, add_months(sahire, 5) from sawon;

-- 날짜에 연산되는 round/trunc 함수
-- 기준으로 월에서 반올림
select saname, sahire, round(sahire, 'yyyy') from sawon;
-- 그 외의 연산함수 ['년-개월']
select sysdate + to_yminterval('01-00') from dual; -- 1년 0개월 더함
-- ['일 시:분:초']
select sysdate + to_dsinterval('100 00:00:00') from dual; -- 100일 0시0분0초 더함

-- 입사한 달의 근무일 수를 계산하여 부서번호, 이름, 근무일 수를 출력
select deptno, saname, sahire, sysdate, trunc(to_char(sysdate - sahire + 1), 0) from sawon;

-- 모든 사원의 60일이 지난 후의 월요일은 몇 년, 몇 월, 몇 일 인가를 구한 후, 이름, 입사일, 월요일 날짜를 출력하시오.
select saname, sahire, next_day(sahire+60, '월') from sawon;
select deptno, saname, sahire, sysdate, (trunc(to_char(sysdate - sahire + 1), 0)) as worked from sawon;