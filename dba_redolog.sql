REM  18-DEC-2011        V1.0    Wei     Creation
REM  24-Feb-2015        V1.1    Wei     ADD standby redo log

set line 200
set pages 30
set verify off
col member for a55
col sizec for a10
col group# for 99
col thread# for 99
col type for a8

select l.status,l.group#,l.thread#,l.archived,round(l.bytes/(1024*1024))||'M' sizec,l.first_time,f.type,f.member
from v$log l, v$logfile f where l.group#=f.group#
union all
select l.status,l.group#,l.thread#,l.archived,round(l.bytes/(1024*1024))||'M' sizec,l.first_time,f.type,f.member
from v$standby_log l, v$logfile f where l.group#=f.group#
order by 2,3
/
