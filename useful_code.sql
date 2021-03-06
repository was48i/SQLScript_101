## SQLScript
PROCEDURE "get_header_data" (
    OUT EX_TOP_3_EMP_COMBINED_CNT TABLE (
        FULLNAME NVARCHAR(256),
        CREATE_CNT INTEGER,
        CHANGE_CNT INTEGER,
        COMBINED_CNT INTEGER
    )
)
LANGUAGE SQLSCRIPT
SQL SECURITY INVOKER
READS SQL DATA AS

BEGIN
    CREATE_CNT = SELECT COUNT(*) AS CREATE_CNT, "HISTORY.CREATEDBY.EMPLOYEEID" AS EID
                 FROM "PO.Header"
                 WHERE PURCHASEORDERID IN (
                     SELECT PURCHASEORDERID FROM "PO.Item"
                     WHERE "PRODUCT.PRODUCTID" IS NOT NULL
                 )
                 GROUP BY "HISTORY.CREATEDBY.EMPLOYEEID";

    CHANGE_CNT = SELECT COUNT(*) AS CHANGE_CNT, "HISTORY.CHANGEDBY.EMPLOYEEID" AS EID
                 FROM "PO.Header"
                 WHERE PURCHASEORDERID IN (
                     SELECT PURCHASEORDERID  FROM "PO.Item"
                     WHERE "PRODUCT.PRODUCTID" IS NOT NULL
                 )
                 GROUP BY "HISTORY.CHANGEDBY.EMPLOYEEID";

    EX_TOP_3_EMP_COMBINED_CNT = SELECT "get_full_name"("NAME.FIRST", "NAME.MIDDLE", "NAME.LAST") AS FULLNAME,
                                       crcnt.CREATE_CNT,
                                       chcnt.CHANGE_CNT,
                                       crcnt.CREATE_CNT + chcnt.CHANGE_CNT AS COMBINED_CNT
                                FROM "MD.Employees" AS emp
                                LEFT OUTER JOIN :CREATE_CNT AS crcnt ON emp.EMPLOYEEID = crcnt.EID
                                LEFT OUTER JOIN :CHANGE_CNT AS chcnt ON emp.EMPLOYEEID = chcnt.EID
                                ORDER BY COMBINED_CNT DESC LIMIT 3;
END;


## Fellowship
-- the issue
SELECT *
FROM "_SYS_BIC"."sap.is.ddf.ddf/ProdHierNodeInheritAttrOverrideByNodeByDate" (
    PLACEHOLDER."$$p_SAPClient$$" => '910',
    PLACEHOLDER."$$p_prod_hr_id$$" => '0000000002',
    PLACEHOLDER."$$p_valid_from$$" => '20170101',
    PLACEHOLDER."$$p_valid_to$$" => '20170101'
);
-- close cejoin
ALTER SYSTEM ALTER CONFIGURATION ('indexserver.ini', 'SYSTEM')
SET ('calcengine', 'cejoin_active') = '0' WITH RECONFIGURE;
-- open cejoin
ALTER SYSTEM ALTER CONFIGURATION ('indexserver.ini', 'SYSTEM')
SET ('calcengine', 'cejoin_active') = '1' WITH RECONFIGURE;
-- workaround
SELECT *
FROM "_SYS_BIC"."sap.is.ddf.ddf/ProdHierNodeInheritAttrOverrideByNodeByDate" (
    'placeholder' = ('ce_settings', '{"cejoin_active": "0"}'),
    'placeholder' = ('$$p_SAPClient$$', '910'),
    'placeholder' = ('$$p_prod_hr_id$$', '0000000002'),
    'placeholder' = ('$$p_valid_from$$', '20170101'),
    'placeholder' = ('$$p_valid_to$$', '20170101')
);
