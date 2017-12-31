select
  appl.NAME,
  c.TYPE,
  c.HTML_TYPE,
  item_loc.LANG_CD,
  i.CTRL_NAME,
  i.ITEM_NUM,
  l.ITEM_NUM + l.COLUMN_SPAN,
  case when i.ITEM_NUM = l.ITEM_NUM + l.COLUMN_SPAN then 'OK' else 'WARNING' end
from
  S_APPL_WTMPL_IT i
  left join S_APLT_WTI_INTL item_loc on item_loc.APPL_WTMPL_IT_ID = i.ROW_ID
  join S_REPOSITORY rep on rep.ROW_ID = i.REPOSITORY_ID
  join S_APPL_WEB_TMPL tmpl on tmpl.ROW_ID = i.APPL_WEB_TMPL_ID
  join S_APPLET appl on appl.ROW_ID = tmpl.APPLET_ID
  join S_CONTROL c on c.APPLET_ID = appl.ROW_ID and c.NAME = i.CTRL_NAME
  join S_APPL_WTMPL_IT l on l.APPL_WEB_TMPL_ID = i.APPL_WEB_TMPL_ID and l.CTRL_NAME = i.CTRL_NAME and l.GRID_PROPERTY = 'FormattedLabel'
where
  i.GRID_PROPERTY = 'FormattedHtml'
  and
  appl.NAME = 'Contact Form Applet'
  and
  (appl.INACTIVE_FLG = 'N' OR appl.INACTIVE_FLG IS NULL)
  and
  rep.NAME = 'Siebel Repository'
  and
  i.ITEM_NUM <> l.ITEM_NUM + l.COLUMN_SPAN
order by appl.NAME,i.CTRL_NAME
