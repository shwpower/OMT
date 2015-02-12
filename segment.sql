REM  18-DEC-2011        V1.0    Wei     Creation

set line 200
set pages 30
set verify off
col segment_name for a30
col tablespace_name for a16

accept tablespace_name prompt 'Enter the tablespace Name: '

select segment_name,segment_type,round(sum(bytes)/(1024*1024),2) Size_M from dba_segments 
where tablespace_name= UPPER('&tablespace_name')
group by segment_name,segment_type
order by Size_M
/
