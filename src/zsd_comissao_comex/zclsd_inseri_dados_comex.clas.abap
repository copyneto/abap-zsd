class ZCLSD_INSERI_DADOS_COMEX definition
  public
  final
  create public .

public section.

  methods MAIN
    importing
      !IS_HEADER type J_1BNFDOC .
protected section.
private section.

  types:
    tt_comiss_cmx TYPE TABLE OF ztsd_comiss_cmx .

  data GT_I_COMISSAO_CMX type TT_COMISS_CMX .
  data GT_M_COMISSAO_CMX type TT_COMISS_CMX .
ENDCLASS.



CLASS ZCLSD_INSERI_DADOS_COMEX IMPLEMENTATION.


  METHOD main.

***********************************************************************
***                         © 3corações                             ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: Inseri dados COMEX                                     *
*** AUTOR : Mikaelly A Saraiva - Dongkuk                              *
*** FUNCIONAL: Fabiana Camargo                                        *
*** DATA : 20/04/2022                                                 *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA | AUTOR | DESCRIÇÃO                                          *
***-------------------------------------------------------------------*
*** 20.04.2022 | MAS | GAP 517 - RICEFW – BD9-517E01                  *
***********************************************************************

    DATA: lr_valid_code TYPE RANGE OF j_1bnfdoc-code.

    DATA: lt_param_v TYPE RANGE OF fkart,
          lt_param_d TYPE RANGE OF fkart.

    DATA: ls_comex TYPE ztsd_comiss_cmx.

    DATA(lo_param) = zclca_tabela_parametros=>get_instance( ).    " CHANGE - JWSILVA - 22.07.2023

    CONSTANTS: BEGIN OF lc_param,
                 modulo TYPE ztca_param_par-modulo VALUE 'SD',
                 chave1 TYPE ztca_param_par-chave1 VALUE 'COMEX',
                 chave2 TYPE ztca_param_par-chave2 VALUE 'FKART',
                 chave3 TYPE ztca_param_par-chave3 VALUE 'VENDA',
                 chave4 TYPE ztca_param_par-chave3 VALUE 'DEVOL',
               END OF lc_param,

               lc_parvw    TYPE j_1bnfnad-parvw     VALUE 'ZX',
               lc_kschl    TYPE prcd_elements-kschl VALUE 'ZCOR',
               lc_cancel   TYPE c LENGTH 3          VALUE '101',
               lc_positivo TYPE c VALUE '1',
               lc_negativo TYPE c VALUE '0'.

    lr_valid_code = VALUE #( sign = 'I' option = 'EQ'
                            ( low = '100' )
                            ( low = '101' ) ).

    " Verifica status de aprovação da Nota
    IF is_header-code IN lr_valid_code.

      TRY.

          lo_param->m_get_range(
                EXPORTING
                  iv_modulo = lc_param-modulo
                  iv_chave1 = lc_param-chave1
                  iv_chave2 = lc_param-chave2
                  iv_chave3 = lc_param-chave3
                IMPORTING
                  et_range = lt_param_v ).

          lo_param->m_get_range(
                EXPORTING
                  iv_modulo = lc_param-modulo
                  iv_chave1 = lc_param-chave1
                  iv_chave2 = lc_param-chave2
                  iv_chave3 = lc_param-chave4
                IMPORTING
                  et_range = lt_param_d ).

        CATCH zcxca_tabela_parametros.

      ENDTRY.

      SELECT SINGLE docnum, parvw, partyp, parid, name1
        FROM j_1bnfnad
        INTO @DATA(ls_j_1bnfnad)
        WHERE docnum EQ @is_header-docnum
          AND parvw  EQ @lc_parvw.

      IF sy-subrc IS INITIAL.

        SELECT j_1bnflin~docnum, itmnum, werks, refkey, matnr, netwrt, xped
          FROM j_1bnflin
          INTO TABLE @DATA(lt_j_1bnflin)
          WHERE j_1bnflin~docnum EQ @is_header-docnum.

        IF sy-subrc IS INITIAL.

          SORT lt_j_1bnflin BY docnum.

          DATA(lt_j_1bnflin_aux) = lt_j_1bnflin[].

          DELETE ADJACENT DUPLICATES FROM lt_j_1bnflin_aux COMPARING refkey.

          SELECT vbeln, posnr, matnr, aubel, kondm
            FROM vbrp
            INTO TABLE @DATA(lt_vbrp)
            FOR ALL ENTRIES IN @lt_j_1bnflin
            WHERE vbeln EQ @lt_j_1bnflin-refkey(10)
              AND matnr EQ @lt_j_1bnflin-matnr.

          IF sy-subrc IS INITIAL.

            SORT lt_vbrp BY vbeln matnr.

          ENDIF.

          SELECT vbeln, knumv, fkart
            FROM vbrk
            INTO TABLE @DATA(lt_vbrk)
            FOR ALL ENTRIES IN @lt_j_1bnflin_aux
            WHERE vbeln EQ @lt_j_1bnflin_aux-refkey(10).

          IF sy-subrc IS INITIAL.

            SORT lt_vbrk BY vbeln.

            SELECT knumv, kwert
              FROM prcd_elements
              INTO TABLE @DATA(lt_prcd_elements)
              FOR ALL ENTRIES IN @lt_vbrk
              WHERE knumv EQ @lt_vbrk-knumv
                AND kschl EQ @lc_kschl.

            IF sy-subrc IS INITIAL.

              SORT lt_prcd_elements BY knumv.

            ENDIF.

            LOOP AT lt_j_1bnflin ASSIGNING FIELD-SYMBOL(<fs_j_1bnflin>).

              READ TABLE lt_vbrk ASSIGNING FIELD-SYMBOL(<fs_vbrk>) WITH KEY vbeln = <fs_j_1bnflin>-refkey(10) BINARY SEARCH.
              IF sy-subrc IS INITIAL.

                IF ( lt_param_d IS NOT INITIAL AND <fs_vbrk>-fkart IN lt_param_d ) "Devolucao
                    OR ( lt_param_v IS NOT INITIAL AND <fs_vbrk>-fkart IN lt_param_v ). "Venda

                  ls_comex-docdat = is_header-docdat.
                  ls_comex-nfenum = is_header-nfenum.
                  ls_comex-parid  = is_header-parid.
                  ls_comex-name1  = is_header-name1.
                  ls_comex-regio  = is_header-regio.
                  ls_comex-ntgew  = is_header-ntgew.
                  ls_comex-gewei  = is_header-gewei.

                  ls_comex-werks  = <fs_j_1bnflin>-werks.
                  ls_comex-itmnum = <fs_j_1bnflin>-itmnum.
                  ls_comex-matnr  = <fs_j_1bnflin>-matnr.
                  ls_comex-refkey = <fs_j_1bnflin>-refkey.
                  ls_comex-netwrt = <fs_j_1bnflin>-netwrt.
                  ls_comex-netwrt_cur = is_header-waerk.
                  ls_comex-xped   = <fs_j_1bnflin>-xped.

                  ls_comex-zparid = ls_j_1bnfnad-parid.
                  ls_comex-zname1 = ls_j_1bnfnad-name1.

                  READ TABLE lt_prcd_elements ASSIGNING FIELD-SYMBOL(<fs_prcd_elements>) WITH KEY knumv = <fs_vbrk>-knumv BINARY SEARCH.
                  IF sy-subrc IS INITIAL.
                    ls_comex-kwert = <fs_prcd_elements>-kwert.
                  ENDIF.

                  READ TABLE lt_vbrp ASSIGNING FIELD-SYMBOL(<fs_vbrp>) WITH KEY vbeln = <fs_j_1bnflin>-refkey
                                                                                matnr = <fs_j_1bnflin>-matnr BINARY SEARCH.
                  IF sy-subrc IS INITIAL.
                    ls_comex-aubel = <fs_vbrp>-aubel.
                    ls_comex-kondm = <fs_vbrp>-kondm.
                  ENDIF.

                  "Devolução e Cancelamento
                  IF ( lt_param_d IS NOT INITIAL AND <fs_vbrk>-fkart IN lt_param_d ) OR is_header-code EQ lc_cancel.

                    ls_comex-posneg = lc_negativo.
                    ls_comex-netwrt = <fs_j_1bnflin>-netwrt * -1.

*                    ls_comex-kwert = <fs_prcd_elements>-kwert * -1.

                    APPEND ls_comex TO gt_i_comissao_cmx.

                  ELSE.

                    ls_comex-posneg = lc_positivo.
                    APPEND ls_comex TO gt_m_comissao_cmx.

                  ENDIF.

                ENDIF.

              ENDIF.

            ENDLOOP.

            IF gt_i_comissao_cmx[] IS NOT INITIAL.

              INSERT ztsd_comiss_cmx FROM TABLE gt_i_comissao_cmx.

            ENDIF.

            IF gt_m_comissao_cmx[] IS NOT INITIAL.

              MODIFY ztsd_comiss_cmx FROM TABLE gt_m_comissao_cmx.

            ENDIF.

          ENDIF.

        ENDIF.

      ENDIF.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
