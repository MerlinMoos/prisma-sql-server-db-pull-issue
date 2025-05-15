#!/bin/bash -x
/opt/mssql-tools18/bin/sqlcmd -C -S localhost -U sa -P $SA_PASSWORD  -d master -Q "exec sp_configure 'contained database authentication', 1"
/opt/mssql-tools18/bin/sqlcmd -C -S localhost -U sa -P $SA_PASSWORD  -d master -Q "GO"
/opt/mssql-tools18/bin/sqlcmd -C -S localhost -U sa -P $SA_PASSWORD  -d master -Q "RECONFIGURE"
/opt/mssql-tools18/bin/sqlcmd -C -S localhost -U sa -P $SA_PASSWORD  -d master -Q "GO"
/opt/mssql-tools18/bin/sqlcmd -C -S localhost -U sa -P $SA_PASSWORD  -d master -Q "create database test_db"
/opt/mssql-tools18/bin/sqlcmd -C -S localhost -U sa -P $SA_PASSWORD  -d master -Q "GO"


schemas=(SEC dbo)

for schema in "${schemas[@]}"; do
  echo "Creating schema: $schema"
  /opt/mssql-tools18/bin/sqlcmd -C -S localhost -U sa -P "$SA_PASSWORD" -d test_db -Q "
    IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = '$schema')
    BEGIN
      EXEC('CREATE SCHEMA [$schema]')
    END
  "

  for i in {1..6}; do
    table_name="table_"$schema"_"$i
    echo "Creating table: $schema.$table_name"

    /opt/mssql-tools18/bin/sqlcmd -C -S localhost -U sa -P "$SA_PASSWORD" -d test_db -Q "
      IF NOT EXISTS (
        SELECT * FROM INFORMATION_SCHEMA.TABLES
        WHERE TABLE_SCHEMA = '$schema' AND TABLE_NAME = '$table_name'
      )
      BEGIN
        CREATE TABLE [$schema].[$table_name] (
          id INT IDENTITY(1,1) PRIMARY KEY,
          name NVARCHAR(100),
          created_at DATETIME DEFAULT GETDATE()
        )
      END
    "
  done
done
