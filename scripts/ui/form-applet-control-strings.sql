SELECT
  ctrl.NAME,
  ctrl.caption_ref,
  col.NAME,
  col.display_name_ref
FROM
  S_APPL_WTMPL_IT item
  JOIN S_APPL_WEB_TMPL templ ON templ.ROW_ID = item.APPL_WEB_TMPL_ID
  JOIN S_APPLET applet ON applet.ROW_ID = templ.APPLET_ID
  LEFT JOIN S_CONTROL ctrl ON ctrl.APPLET_ID = applet.ROW_ID AND ctrl.NAME = item.CTRL_NAME
  LEFT JOIN S_LIST lst ON lst.APPLET_ID = applet.ROW_ID
  LEFT JOIN S_LIST_COLUMN col ON col.LIST_ID = lst.ROW_ID AND col.NAME = item.CTRL_NAME
WHERE
  applet.NAME = 'Contact Form Applet'
  AND templ.NAME = 'Edit'
  
  
  
