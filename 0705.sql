desc user_constraints;
/*
c = check, NOT NULL, p = primary key, u = unique, r = reference(foreign key)
*/
select constraint_name, CONSTRAINT_TYPE from user_constraints;

/*
2. �÷� ���� ��������
���̺��� ������ �� �÷��� ���� ���������� ����ϴ� ���.
NOT NULL ���������� �÷� ���������� ������ �� �ִ�.

3. ���̺� ���� ��������
NOT NULL�� ������ ��� ���������� ����� �� �ִ�.
*/
-- �Ʒ� ���� ������ ��� �÷� ���� ����������.
-- constraint ���̺��_�÷�_���������̸� �������Ǹ��
create table colst(
bun number(3) constraint colst_bun_pk primary key,
name varchar2(10) constraint colst_name_nn not null,
age number(5) constraint colst_age_ck check(age >= 20 and age <= 30),
addr varchar2(50) default '����� ������ �ż���',
jumin varchar2(14) constraint colst_jumin_uq unique);

-- �������� Ȯ��
select constraint_name, CONSTRAINT_TYPE from user_constraints where TABLE_NAME='COLST';

-- ���̺� ���� ��������
create table talst(
bun number(3),
name varchar2(10) constraint talst_name_nn not null,
age number(3),
addr varchar2(30) default '����� ������',
jumin varchar2(14) constraint talst_jumin_nn not null,
constraint talst_bun_pk primary key(bun),
constraint talst_age_ch check(age >= 20 and age <= 30),
constraint talst_uq unique(jumin));
-- �������� Ȯ��
select constraint_name, CONSTRAINT_TYPE from user_constraints where TABLE_NAME='TALST';


create table lib(
bun number(3),
book varchar2(20),
l_date date default sysdate,
constraint lib_bun_fk foreign key(bun) references talst(bun) on delete cascade);

select owner, r_owner, table_name, constraint_type, constraint_name
from user_constraints
where table_name in('LIB', 'TALST');

insert into talst (bun, name, age, addr, jumin) values(10, '��浿', 30, '����� ������', '111111-1234567');
insert into talst (bun, name, age, addr, jumin) values(20, '������', 20, '����� ������', '111111-2234567');
insert into talst (bun, name, age, addr, jumin) values(30, '�Ӿƿ�', 20, '��õ�� ����', '111111-2111567');
-- insert into tals values(30, '�Ӿƿ�', 20, '��õ�� ����', '111111-2111567');
select * from talst;

insert into lib (bun, book) values(10, '�ڹ�å');
insert into lib (bun, book) values(20, '����Ŭå');
select * from lib;
-- ���̺� ���� �� �� cascade�Ѱ� Ȯ��
delete from talst where bun=10;

-- �������� ����
alter table talst drop constraint talst_jumin_nn;

select owner, r_owner, table_name, constraint_type, constraint_name
from user_constraints
where table_name in ('LIB', 'TALST');

-- �ǽ����̺� ����
select * from tab;
drop table talst CASCADE CONSTRAINTS;
drop table gogek;
drop table sawon_phone;
drop table sawon;
drop table dept;
drop table lib;
drop table colst;
purge recyclebin;

-- �ڵ�� �����غ���
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

-- �������� ����
alter table dept add constraint dept_deptno_pk primary key(deptno);
alter table dept add constraint dept_dname_uq unique(dname);
alter table sawon add CONSTRAINT sawon_sabun_pk primary key(sabun);
alter table sawon add CONSTRAINT sawon_deptno_fk foreign key (deptno) references dept(deptno) on delete cascade;
alter table sawon add CONSTRAINT sawon_sasex_ck check(sasex='����' or sasex='����');
alter table sawon add CONSTRAINT sawon_samgr_fk foreign key (samgr) references sawon(sabun) on delete cascade;
alter table gogek add CONSTRAINT gogek_gobun_pk primary key(gobun);
alter table gogek add CONSTRAINT gogek_gojumin_uq unique(gojumin);
alter table gogek add CONSTRAINT gogek_godam_fk foreign key(godam) references sawon(sabun) on delete cascade;
-- Ȯ��
select owner, r_owner, table_name, constraint_type, constraint_name
from user_constraints
where table_name in ('DEPT', 'SAWON', 'GOGEK');