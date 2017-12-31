SELECT
       bc.NAME,
       bcsctipt.NAME,
       GET_BUSCOMP_SCRIPT(bcsctipt.ROW_ID)
FROM
     S_BUSCOMP_SCRIPT bcsctipt
     JOIN S_REPOSITORY rep ON rep.ROW_ID = bcsctipt.REPOSITORY_ID
     JOIN S_BUSCOMP bc ON bc.ROW_ID = BUSCOMP_ID
WHERE
     rep.NAME = 'Siebel Repository'
     AND
     bc.NAME LIKE 'Opportunity%'
     AND
     GET_BUSCOMP_SCRIPT(bcsctipt.ROW_ID) LIKE '%Reject%'
