declare
begin
  execute immediate 'truncate table siebel.S_EAI_QUEUE_ITM';
  execute immediate 'truncate table siebel.S_EAI_QUEUE';
  execute immediate 'truncate table siebel.S_AUDIT_ITEM';
  execute immediate 'truncate table siebel.S_AUDIT_READ';
  execute immediate 'truncate table siebel.S_WFA_INST_LOG';
  execute immediate 'truncate table siebel.S_WFA_INSTP_LOG';
  execute immediate 'truncate table siebel.S_WFA_STPRP_LOG';
  execute immediate 'truncate table siebel.S_WFA_INSTANCE';
  execute immediate 'truncate table siebel.S_SRM_TASK_HIST';
  execute immediate 'truncate table siebel.S_ESCL_ACTN_REQ';
  execute immediate 'truncate table siebel.S_ESCL_LOG';
  execute immediate 'truncate table siebel.S_ESCL_STATE';
  execute immediate 'truncate table siebel.S_ESCL_REQ';
  execute immediate 'truncate table siebel.S_DOCK_STATUS';
  execute immediate 'truncate table siebel.S_DOCK_TXN_LOG';
  execute immediate 'truncate table siebel.S_DOCK_TXN_LOGT';
  execute immediate 'truncate table siebel.S_DOCK_TXN_SET';
  execute immediate 'truncate table siebel.S_DOCK_TXN_SETT';
  execute immediate 'truncate table siebel.S_COMM_REQ';
  execute immediate 'truncate table siebel.S_APSRVR_REQ';
  execute immediate 'truncate table siebel.S_VALDN_INST';
  execute immediate 'truncate table siebel.S_MERGE_LOG_OBJ';
  execute immediate 'truncate table siebel.S_MERGE_LOG_ATTR';
  execute immediate 'truncate table siebel.S_DIAG_DATA';
  execute immediate 'truncate table siebel.S_UCM_ORG_CHILD';
  execute immediate 'truncate table siebel.S_UCM_ORG_EXT';
  execute immediate 'truncate table siebel.S_UCM_CON_CHILD';
  execute immediate 'truncate table siebel.S_UCM_CONTACT';
  execute immediate 'delete from siebel.S_WFA_DPLOY_DEF where deploy_status_cd in (''INACTIVE'', ''OUTDATED'')';
  execute immediate 'delete from siebel.S_WFA_DATA t where t.deploy_def_id not in (select row_id from siebel.S_WFA_DPLOY_DEF)';
  execute immediate 'delete from siebel.S_SRM_REQUEST where status in (''OUTDATED'', ''SUCCESS'', ''ERROR'', ''CANCELED'', ''CREATING'', ''PRT_CANCELLED'')';
  execute immediate 'delete from siebel.S_SRM_DATA where par_id not in (select row_id from siebel.S_SRM_REQUEST)';
exception when others then
  commit;
  dbms_output.put_line(SQLERRM);
end;
