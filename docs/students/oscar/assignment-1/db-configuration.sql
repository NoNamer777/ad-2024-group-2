-- Memory Configuration
EXEC sp_configure 'max server memory', 8192; -- 8GB
EXEC sp_configure 'min server memory', 2048; -- 2GB
RECONFIGURE;

-- CPU Configuration
EXEC sp_configure 'max degree of parallelism', 4; -- Use 4 CPUs
EXEC sp_configure 'affinity mask', 15; -- Use CPUs 0-3
RECONFIGURE;

-- TempDB Optimization
ALTER DATABASE tempdb ADD FILE (NAME = tempdev2, FILENAME = 'C:\tempdb2.ndf', SIZE = 1024MB);

-- Disk I/O Optimization
EXEC sp_configure 'instant file initialization', 1;
RECONFIGURE;

ALTER SERVER CONFIGURATION SET BUFFER POOL EXTENSION ON (FILENAME = 'D:\BufferPoolExtension.bpe', SIZE = 20GB);

-- Network Configuration
EXEC sp_configure 'network packet size', 8192; -- 8KB
RECONFIGURE;

-- Query Optimization
EXEC sp_configure 'optimize for ad hoc workloads', 1;
EXEC sp_configure 'cost threshold for parallelism', 50; -- Set to 50
RECONFIGURE;