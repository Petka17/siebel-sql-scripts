SELECT
      aptmplitem.ITEM_NUM,
      aptmplitem.CTRL_NAME ITEM_NAME,
      aptmplitem.REPOS_TYPE,
      ctrl.NAME CTRL_NAME,
      lstcol.NAME COLUMN_NAME,
      lstcol.FIELD_NAME
FROM
    S_APPLET ap
    JOIN S_REPOSITORY rep ON rep.ROW_ID = ap.REPOSITORY_ID
    JOIN S_APPL_WEB_TMPL aptmpl ON aptmpl.APPLET_ID = ap.ROW_ID
    JOIN S_APPL_WTMPL_IT aptmplitem ON aptmplitem.APPL_WEB_TMPL_ID = aptmpl.ROW_ID
    LEFT JOIN S_CONTROL ctrl ON ctrl.NAME = aptmplitem.CTRL_NAME AND ctrl.APPLET_ID = ap.ROW_ID AND aptmplitem.REPOS_TYPE = 'Control'
    LEFT JOIN S_LIST lst ON lst.APPLET_ID = ap.ROW_ID
    LEFT JOIN S_LIST_COLUMN lstcol ON lstcol.LIST_ID = lst.ROW_ID AND lstcol.NAME = aptmplitem.CTRL_NAME AND aptmplitem.REPOS_TYPE = 'List Item'
WHERE
     ap.NAME IN ('Applet Name')
     AND
     rep.NAME = 'Siebel Repository'
     AND
     aptmpl.TYPE = 'Edit List'
ORDER BY ITEM_NUM
