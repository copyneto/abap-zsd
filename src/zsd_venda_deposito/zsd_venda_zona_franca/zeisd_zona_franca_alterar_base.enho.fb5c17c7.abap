"Name: \TY:CL_TAX_CALC_BR_SD\ME:CALC_SUBTRIB_START_VALUE\SE:END\EI
ENHANCEMENT 0 ZEISD_ZONA_FRANCA_ALTERAR_BASE.
DATA: lt_komv TYPE TABLE OF komv_index.
DATA: ls_komvds TYPE komv_index.
DATA: lv_base_zf TYPE mty_taxamount.
CONSTANTS: lc_kschl_bxzf TYPE komv-kschl VALUE 'BXZF'.
* Checar se o desenvolvimento existe na ZALACT
DO 1 TIMES.
* Relevante apenas para processos SD
 CHECK ms_komk-kappl = 'V'
   AND ms_tax_data-subtribsurtype = '1'
   AND ms_tax_control-usage <> mc_consum.
*  Ler tabela de valores
 CLEAR: lt_komv, ls_komvds, lv_base_zf.
*  Passar valores, não trabalhar com mt_komv
 MOVE mt_komv[] TO lt_komv[].
   SORT lt_komv[] BY kposn kschl.
   READ TABLE lt_komv INTO ls_komvds WITH KEY
    kposn = ms_komp-kposn
    kschl = lc_kschl_bxzf BINARY SEARCH.
*  Checar se o valor do ICMS desonerado foi encontrado
 CHECK sy-subrc IS INITIAL
   AND ls_komvds-kwert LT '0.00'.
*  Alterar a base de cálculo
 CHECK iv_val_incl_icms_ipi GT '0.000000'.
*  Subtrair base do icms desonerado
 lv_base_zf = iv_val_incl_icms_ipi + ls_komvds-kwert + ms_tax_data-subtribmod.
*  Testar se base menos desonerado é maior que zero
 IF lv_base_zf GT '0.000000'.
   ev_base = lv_base_zf.
 ENDIF.
ENDDO.
ENDENHANCEMENT.
