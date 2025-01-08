-- connect as sysdba
CONNECT sys/confluent123 AS SYSDBA
-- Enable archive log
shutdown immediate
startup mount
alter database archivelog;
alter database open;
ALTER SESSION SET CONTAINER=cdb$root;
ALTER DATABASE ADD SUPPLEMENTAL LOG DATA (ALL) COLUMNS;
ALTER SESSION SET CONTAINER=FREEPDB1;
ALTER DATABASE ADD SUPPLEMENTAL LOG DATA (ALL) COLUMNS;
exit;
