*&---------------------------------------------------------------------*
*& Include          ZSDI_AUTOMACAO_GNRE
*&---------------------------------------------------------------------*
  IF i_active-code = '100'.

***LOOP INFINITO, para debugar JOB em background,
***atraves da transacao SM50.
***Para sair do Loop alterar variavel 'num' para 1.
    DATA: lv_debug TYPE tvarv_val,
          lv_name  TYPE rvari_vnam VALUE 'ZSDF_RETORNO_SEFAZ'.

    SELECT SINGLE low
      INTO lv_debug
      FROM tvarvc
     WHERE name EQ lv_name
       AND low  EQ 'X'.
    IF sy-subrc IS INITIAL.
      DO.
        SELECT SINGLE low
          INTO lv_debug
          FROM tvarvc
         WHERE name EQ lv_name
           AND low  EQ 'X'.
        IF sy-subrc IS  NOT INITIAL.
          EXIT.
        ENDIF.
      ENDDO.
    ENDIF.
***LOOP INFINITO*************************************

    "Adiciona a nota no processo de GNRE
    TRY.
        DATA(lr_gnre_automacao) = NEW zclsd_gnre_automacao( iv_docnum          = i_active-docnum
                                                            iv_new             = abap_true
                                                            is_j_1bnfe_active  = i_active ).
*                                                            is_header = is_header ).

        lr_gnre_automacao->persist( ).
        lr_gnre_automacao->free( ).

      CATCH zcxsd_gnre_automacao INTO DATA(lr_cx_gnre_automacao).
    ENDTRY.

  ELSEIF i_active-code = '101' OR
         i_active-code = '102' OR
         i_active-code = '151'.

    "Verifica se a nota existe no monitor
    SELECT COUNT(*)
      FROM ztsd_gnret001
      WHERE docnum = i_active-docnum.
    IF sy-subrc IS INITIAL.

      "Seta a Nota como cancelada no monitor de GNRE
      TRY.
          lr_gnre_automacao = NEW zclsd_gnre_automacao( iv_docnum = i_active-docnum ).

          lr_gnre_automacao->set_cancel( ).
          lr_gnre_automacao->persist( ).
          lr_gnre_automacao->free( ).

        CATCH zcxsd_gnre_automacao INTO lr_cx_gnre_automacao.

          zclsd_gnre_automacao=>enqueue_docnum_cancel( i_active-docnum ).

      ENDTRY.

    ENDIF.

  ENDIF.
