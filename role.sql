REM  18-DEC-2011        V1.0    Wei     Creation
REM  05-OCT-2013	v1.1	Wei	Add grantee & admin option & default role

SET TERMOUT OFF;
COLUMN current_instance NEW_VALUE current_instance NOPRINT;
SELECT rpad(instance_name, 17) current_instance FROM v$instance;
SET TERMOUT ON;

PROMPT 
PROMPT +------------------------------------------------------------------------+
PROMPT | Report   : Security - All Roles                                        |
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

COLUMN role             FORMAT a30    HEAD 'Role Name'
COLUMN grantee          FORMAT a30    HEAD 'Grantee'
COLUMN grantee          FORMAT a20    HEAD 'Password Required'
COLUMN admin_option     FORMAT a15    HEAD 'Admin Option?'
COLUMN default_role     FORMAT a15    HEAD 'Default Role?'

BREAK ON role SKIP 2

SELECT
    b.role
  , b.password_required
  , a.grantee
  , a.admin_option
  , a.default_role
FROM
    dba_role_privs  a
  , dba_roles       b
WHERE
    granted_role(+) = b.role
ORDER BY
    b.role
  , a.grantee
/
