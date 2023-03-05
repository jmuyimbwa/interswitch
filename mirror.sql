-- Create the endpoints for the principal and mirror servers
CREATE ENDPOINT Mirroring 
STATE = STARTED 
AS TCP (LISTENER_PORT = 5022) 
FOR DATABASE_MIRRORING 
(AUTHENTICATION = WINDOWS NEGOTIATE, ENCRYPTION = REQUIRED ALGORITHM AES);

-- Backup the principal database and restore it on the mirror server with NORECOVERY option
BACKUP DATABASE interswitch TO DISK = 'C:\SQLBackup\interswitch.bak';
RESTORE DATABASE interswitch WITH NORECOVERY 
FROM DISK = 'C:\SQLBackup\interswitch.bak' 
WITH 
  MOVE 'interswitch' TO 'C:\SQLData\interswitch.mdf',
  MOVE 'interswitch_log' TO 'C:\SQLLog\interswitch_log.ldf';

-- Set up the mirroring session between the principal and mirror servers
ALTER DATABASE interswitch SET PARTNER = 'TCP://MirrorServer:5022';
ALTER DATABASE interswitch SET SAFETY OFF;
ALTER DATABASE interswitch SET PARTNER SAFETY OFF;

-- Manually fail over to the mirror database for testing purposes
ALTER DATABASE interswitch SET PARTNER FAILOVER;

-- Manually fail back to the principal database after testing
ALTER DATABASE interswitch SET PARTNER FORCE_SERVICE_ALLOW_DATA_LOSS;
