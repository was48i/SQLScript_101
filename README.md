# SQLScript-101
A SQLScript demonstration based on _Multi-Target Application_.

After building and deploying, we can check the results in Database Explorer and use `useful_code.sql` to call the function in a procedure.

## Installation
Install Web IDE for SAP HANA:
![](https://raw.githubusercontent.com/umarellyh/mPOST/master/SQLScript-101/00.png)

## Usage
We can import schema refer this [URL](https://blogs.sap.com/2018/12/18/howto-import-sflight-sample-data-into-sap-hana-from-a-local-computer/), and the prepared data is `sflight_hana.tar.gz`.
Technical users are not authorized to import or create DB objects in a container. They should only be created by the HDI deploy process, so we should **import required schema in a tenant database first**.

### Issues
> Error: Error executing: GRANT "SFLIGHT_CONTAINER_ACCESS" TO "OPENSAPHANA_OPENSAPHANA_HDI_CONTAINER_1#OO"

We need to import into a regular database connection and the same tenant that we are creating the containers in. Besides, if we want to find the ports of each tenant, then run this query in the SQL Console of the SYSTEMDB:
```sql
SELECT DATABASE_NAME, SERVICE_NAME, PORT, SQL_PORT
FROM SYS_DATABASES.M_SERVICES;
```

> Error: authentication failed grantor service: "ServiceName_1", type: "sql", user: "CUPS_SFLIGHT"

We need to create the SFLIGHT technical user and role in the pointed tenant database:
```sql
-- create user
CREATE USER CUPS_SFLIGHT PASSWORD "********" SET PARAMETER CLIENT = '001';
ALTER USER CUPS_SFLIGHT DISABLE PASSWORD LIFETIME;
GRANT SELECT ON SCHEMA SFLIGHT TO CUPS_SFLIGHT WITH GRANT OPTION;
GRANT SELECT METADATA ON SCHEMA SFLIGHT TO CUPS_SFLIGHT WITH GRANT OPTION;

-- create role
CREATE ROLE SFLIGHT_CONTAINER_ACCESS;
GRANT SELECT, SELECT METADATA ON SCHEMA SFLIGHT TO SFLIGHT_CONTAINER_ACCESS WITH GRANT OPTION;
GRANT SFLIGHT_CONTAINER_ACCESS TO CUPS_SFLIGHT WITH ADMIN OPTION;
```

## Contributing
We love contributions! Before submitting a Pull Request, it's always good to start with a new issue first.

## License
This repository is licensed under Apache 2.0. Full license text is available in [LICENSE](https://github.com/umarellyh/SQLScript-101/blob/master/LICENSE).
