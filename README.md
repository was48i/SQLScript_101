# SQLScript_101
A Multi-Target Application (MTA) demo for SQLScript. After building and deploying, you can check the results in the Database Explorer. And you can use `useful_codes` to call the function in the procedure.

![](https://raw.githubusercontent.com/ICHIGOI7E/mdpics/master/SQLScript/2.jpg)
## Install SAP Web IDE for HANA
You can install Web IDE refer this [URL](https://developers.sap.com/sea/topics/sap-hana-express.html).

![](https://raw.githubusercontent.com/ICHIGOI7E/mdpics/master/SQLScript/1.jpg)
## Import Schema
You can import schema refer this [URL](https://blogs.sap.com/2018/12/18/howto-import-sflight-sample-data-into-sap-hana-from-a-local-computer/), and the prepared data is `sflight_hana.tar.gz`.
Technical users are not authorized to import or create DB objects in a container. They should only be created by the HDI deploy process, so you should import required schema in a tenant database first.
### Issues
**Error: Error executing: GRANT "SFLIGHT_CONTAINER_ACCESS" TO "OPENSAPHANA_OPENSAPHANA_HDI_CONTAINER_1#OO"**

You need to import into a regular DB connection and the same tenant that you are creating your containers in. And if you need to find the ports of each tenant, then run this query in the SQL Console of the SYSTEMDB:
```
SELECT DATABASE_NAME, SERVICE_NAME, PORT, SQL_PORT
FROM SYS_DATABASES.M_SERVICES;
```
**Error: authentication failed grantor service: "ServiceName_1", type: "sql", user: "CUPS_SFLIGHT"**

You need to create the SFLIGHT technical user and role in the pointed tenant database:
```
-- create user
CREATE USER CUPS_SFLIGHT PASSWORD "********" SET PARAMETER CLIENT = '001';
ALTER USER CUPS_SFLIGHT DISABLE PASSWORD LIFETIME;
GRANT SELECT ON SCHEMA SFLIGHT TO CUPS_SFLIGHT WITH GRANT OPTION;
GRANT SELECT METADATA ON SCHEMA SFLIGHT to CUPS_SFLIGHT WITH GRANT OPTION;
-- create role
CREATE ROLE SFLIGHT_CONTAINER_ACCESS;
GRANT SELECT, SELECT METADATA ON SCHEMA SFLIGHT TO SFLIGHT_CONTAINER_ACCESS WITH GRANT OPTION;
GRANT SFLIGHT_CONTAINER_ACCESS TO CUPS_SFLIGHT WITH ADMIN OPTION;
```
