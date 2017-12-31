SELECT DISTINCT
      evt.OBJ_NAME,
      evt.EVT_NAME,
      evt.EVT_SUB_NAME,
      actset.NAME,
      act.SVC_NAME,
      act.SVC_METHOD_NAME,
      act.SVC_CONTEXT
FROM
    S_CT_EVENT evt
    JOIN S_CT_ACTION_SET actset ON actset.ROW_ID = evt.CT_ACTN_SET_ID
    JOIN S_CT_ACTION act ON act.CT_ACTN_SET_ID = actset.ROW_ID
WHERE
--     evt.EVT_SUB_NAME = 'EventMethodNBSMCheck'
     act.SVC_CONTEXT LIKE '%Workflow Name%'
ORDER BY evt.OBJ_NAME, act.SEQ_NUM
