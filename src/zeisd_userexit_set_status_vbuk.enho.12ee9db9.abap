"Name: \PR:SAPLV45P\FO:USEREXIT_SET_STATUS_VBUK\SE:END\EI
ENHANCEMENT 0 ZEISD_USEREXIT_SET_STATUS_VBUK.

DATA lv_error_log TYPE xfeld.

FIELD-SYMBOLS <fs_vbfs> TYPE vbfs.

ASSIGN ('(SAPLV60A)XVBFS') TO <fs_vbfs>.
IF <fs_vbfs> IS ASSIGNED AND
   NOT <fs_vbfs>-msgid IS INITIAL AND
   NOT <fs_vbfs>-msgty IS INITIAL.
  "Importa a variável "lv_error_log" do report ZSDR_JOB_FATURAMENTO
  "para exibir a mensagem de erro do log de execução da VF01 (caso não tenha efetivado o faturamento)
  IMPORT lv_error_log TO lv_error_log FROM MEMORY ID 'ZSDR_JOB_FATURAMENTO'.
  IF NOT lv_error_log IS INITIAL.
     FREE MEMORY ID 'ZSDR_JOB_FATURAMENTO'.
    "Write error log to job log
    MESSAGE ID <fs_vbfs>-msgid TYPE <fs_vbfs>-msgty NUMBER <fs_vbfs>-msgno
      WITH <fs_vbfs>-msgv1 <fs_vbfs>-msgv2 <fs_vbfs>-msgv3 <fs_vbfs>-msgv4.
  ENDIF.
ENDIF.

ENDENHANCEMENT.
