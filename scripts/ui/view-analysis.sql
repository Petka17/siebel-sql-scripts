SELECT
      v.NAME,
      vtmplitem.ITEM_NUM,
      vtmplitem.APPLET_NAME,
      vtmplitem.APPLET_MODE_CD
FROM
    S_VIEW v
    JOIN S_REPOSITORY rep ON rep.ROW_ID = v.REPOSITORY_ID
    JOIN S_VIEW_WEB_TMPL vtmpl ON vtmpl.VIEW_ID = v.ROW_ID AND vtmpl.INACTIVE_FLG = 'N'
    JOIN S_VIEW_WTMPL_IT vtmplitem ON vtmplitem.VIEW_WEB_TMPL_ID = vtmpl.ROW_ID
WHERE
     v.NAME IN ('Employee Monthly Calendar Detail View')
     AND
     rep.NAME = 'Siebel Repository'
     and
     vtmplitem.INACTIVE_FLG = 'N'
     and
     vtmpl.INACTIVE_FLG = 'N'
ORDER BY v.NAME, vtmplitem.ITEM_NUM
