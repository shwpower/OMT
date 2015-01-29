REM  14-AUG-2011	V1.0	Wei	Creation
REM  06-OCT-2013	v1.1	Wei	Add title & Temp tablespace & sum/avg  and remove the %
REM					Refer: www.idevelopment.info

SET TERMOUT OFF;
COLUMN current_instance NEW_VALUE current_instance NOPRINT;
SELECT rpad(instance_name, 17) current_instance FROM v$instance;
SET TERMOUT ON;

PROMPT 
PROMPT +------------------------------------------------------------------------+
PROMPT | Report   : Tablespaces                                                 |
PROMPT | Instance : &current_instance                                           |
PROMPT +------------------------------------------------------------------------+

SET ECHO        OFF
SET FEEDBACK    6
SET HEADING     ON
SET LINESIZE    180
SET PAGESIZE    50000
SET TERMOUT     ON
SET TIMING      OFF
SET TRIMOUT     ON
SET TRIMSPOOL   ON
SET VERIFY      OFF

CLEAR COLUMNS
CLEAR BREAKS
CLEAR COMPUTES

COLUMN status      FORMAT a9                 HEADING 'Status'
COLUMN name        FORMAT a25                HEADING 'Tablespace Name'
COLUMN type        FORMAT a15                HEADING 'TS Type'
COLUMN extent_mgt  FORMAT a10                HEADING 'Ext. Mgt.'
COLUMN segment_mgt FORMAT a10                HEADING 'Seg. Mgt.'
COLUMN ts_size     FORMAT 9,999,999,999,999  HEADING 'Tablespace Size'
COLUMN used        FORMAT 9,999,999,999,999  HEADING 'Used (in bytes)'
COLUMN free        FORMAT 9,999,999,999,999  HEADING 'Free (in bytes)'
COLUMN pct_used    FORMAT 999                HEADING 'Pct. Used'
--COLUMN pct_used    FORMAT a10                HEADING 'Pct. Used'

BREAK ON report

COMPUTE sum OF ts_size  ON report
COMPUTE sum OF used     ON report
COMPUTE sum OF free     ON report
COMPUTE avg OF pct_used ON report

accept content_type prompt 'Enter type of content ( eg Name/Type/TS_Size/Used/Pct_used ) : '

SELECT
    d.status                                            status
  , d.tablespace_name                                   name
  , d.contents                                          type
  , d.extent_management                                 extent_mgt
  , d.segment_space_management                          segment_mgt
  , NVL(a.bytes, 0)                                     ts_size
  , NVL(a.bytes - NVL(f.bytes, 0), 0)                   used
  -- , NVL(f.bytes, 0)                                     free
  --, to_char(NVL((a.bytes - NVL(f.bytes, 0)) / a.bytes * 100, 0),'99.99')||'%' pct_used
  , NVL((a.bytes - NVL(f.bytes, 0)) / a.bytes * 100, 0) pct_used
FROM 
    sys.dba_tablespaces d
  , ( select tablespace_name, sum(bytes) bytes
      from dba_data_files
      group by tablespace_name
    ) a
  , ( select tablespace_name, sum(bytes) bytes
      from dba_free_space
      group by tablespace_name
    ) f
WHERE
      d.tablespace_name = a.tablespace_name(+)
  AND d.tablespace_name = f.tablespace_name(+)
  AND NOT (
    d.extent_management like 'LOCAL'
    AND
    d.contents like 'TEMPORARY'
  )
UNION ALL 
SELECT
    d.status                         status
  , d.tablespace_name                name
  , d.contents                       type
  , d.extent_management              extent_mgt
  , d.segment_space_management       segment_mgt
  , NVL(a.bytes, 0)                  ts_size
  , NVL(t.bytes, 0)                  used
  -- , NVL(a.bytes - NVL(t.bytes,0), 0) free
  --, to_char(NVL(t.bytes / a.bytes * 100, 0),'99.99')||'%'  pct_used
  , NVL(t.bytes / a.bytes * 100, 0)  pct_used
FROM
    sys.dba_tablespaces d
  , ( select tablespace_name, sum(bytes) bytes
      from dba_temp_files
      group by tablespace_name
    ) a
  , ( select tablespace_name, sum(bytes_cached) bytes
      from v$temp_extent_pool
      group by tablespace_name
    ) t
WHERE
      d.tablespace_name = a.tablespace_name(+)
  AND d.tablespace_name = t.tablespace_name(+)
  AND d.extent_management like 'LOCAL'
  AND d.contents like 'TEMPORARY'
ORDER BY 
  &content_type
/
