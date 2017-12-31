SELECT
      fs.VALUE,
      ts.VALUE,
      tr.PUBLIC_FLG,
      ts.DESC_TEXT
FROM
    siebel.S_SM_TRANSITION tr
    JOIN siebel.S_STATE_MODEL m ON m.ROW_ID = tr.STATE_MODEL_ID
    JOIN siebel.S_SM_STATE fs ON fs.ROW_ID = tr.FROM_STATE_ID
    JOIN siebel.S_SM_STATE ts ON ts.ROW_ID = tr.TO_STATE_ID
WHERE
     m.NAME = 'Opportunity Sales Stage'
ORDER BY
      ts.DESC_TEXT,
      fs.VALUE,
      ts.VALUE
