REM  18-DEC-2011        V1.0    Wei     Creation

set line 200
set pages 30
set verify off
col member for a55
col sizec for a10
col group# for 99
col thread# for 99

set echo off
alter session set nls_date_format='yyyy-mm-dd hh24:mi:ss';

select l.status,l.group#,l.thread#,l.archived,round(l.bytes/(1024*1024))||'M' sizec,l.first_time,f.member
from v$log l, v$logfile f where l.group#=f.group#
order by 2,3
/
