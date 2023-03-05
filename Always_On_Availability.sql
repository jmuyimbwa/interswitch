-- Create the availability group
CREATE AVAILABILITY GROUP interswitch_ag
WITH 
  (DB_FAILOVER = ON, CLUSTER_TYPE = NONE)
FOR 
  REPLICA ON 
    ('Node1' WITH 
      (
        ENDPOINT_URL = 'TCP://Node1:5022',
        AVAILABILITY_MODE = SYNCHRONOUS_COMMIT,
        FAILOVER_MODE = AUTOMATIC
      ),
     'Node2' WITH 
      (
        ENDPOINT_URL = 'TCP://Node2:5022',
        AVAILABILITY_MODE = SYNCHRONOUS_COMMIT,
        FAILOVER_MODE = AUTOMATIC
      )
    );

-- Add the interswitch database to the availability group
ALTER AVAILABILITY GROUP interswitch_ag 
ADD DATABASE interswitch;

-- Join the secondary replica to the availability group
ALTER AVAILABILITY GROUP interswitch_ag 
JOIN WITH (CLUSTER_TYPE = NONE);

-- Create a full backup of the primary database
BACKUP DATABASE interswitch 
TO DISK = 'C:\SQLBackup\interswitch.bak';

-- Restore the backup on the secondary replica with NORECOVERY option
RESTORE DATABASE interswitch 
FROM DISK = 'C:\SQLBackup\interswitch.bak' 
WITH NORECOVERY;

-- Manually fail over to the secondary replica for testing purposes
ALTER AVAILABILITY GROUP interswitch_ag 
FAILOVER;

-- Manually fail back to the primary replica after testing
ALTER AVAILABILITY GROUP interswitch_ag 
FAILOVER;
