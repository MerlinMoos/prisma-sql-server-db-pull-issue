# prisma-sql-server-db-pull-issue

## Prisma SQL Server DB Pull Issue
This repository demonstrates an issue with Prisma's `db pull` command when used with a SQL Server database. The issue arises when the database contains multiple schemas. The default `dbo` schema is getting ignored when other schemas are written in uppercase e.g. `SEC` is not working, but `sec` is working. The `db pull` command fails to generate the correct Prisma schema for this table.


### Steps to Reproduce
run the following commands
```bash 
docker-compose up test_mssql
```



```bash
npm install
``` 

```bash
npx prisma db pull
```