CLASS zclsd_envio_xml DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS:

      execute
        IMPORTING
          is_header   TYPE j_1bnfdoc
          it_partner  TYPE j_1b_tt_nfnad
          it_itens    TYPE j_1bnflin_tab
          it_vbrp     TYPE vbrp_tab OPTIONAL
        EXPORTING
          et_add_info TYPE j_1bnfadd_info_tab.


  PROTECTED SECTION.
  PRIVATE SECTION.

    CONSTANTS: BEGIN OF gc_values,
                 btd_tco          TYPE /scmtms/d_tordrf-btd_tco  VALUE '73',
                 tor_cat          TYPE /scmtms/d_torrot-tor_cat  VALUE 'TO',
                 transporta_email TYPE string VALUE 'TRANSPORTA_EMAIL',
                 remessa          TYPE string VALUE 'REMESSA',
                 plano            TYPE string VALUE 'PLANO',
                 sp               TYPE j_1bparvw  VALUE 'SP',
                 vl2              TYPE j_1bdirect VALUE '2',
                 mailnfe          TYPE ad_remark2 VALUE 'MAILNFE',
                 bi               TYPE j_1breftyp  VALUE 'BI',
                 v1               TYPE i VALUE 1,
                 v2               TYPE i VALUE 2,
                 v3               TYPE i VALUE 3,
                 v4               TYPE i VALUE 4,
                 v5               TYPE i VALUE 5,
                 v6               TYPE i VALUE 6,
                 v7               TYPE i VALUE 7,
                 v8               TYPE i VALUE 8,
                 v9               TYPE i VALUE 9,
               END OF gc_values.

ENDCLASS.



CLASS zclsd_envio_xml IMPLEMENTATION.


  METHOD execute.

    DATA lv_cont TYPE n LENGTH 2.


    IF is_header-direct = gc_values-vl2
    AND line_exists( it_partner[ docnum = is_header-docnum parvw = gc_values-sp ] ).

      DATA(ls_partner)  = VALUE #( it_partner[ docnum = is_header-docnum parvw = gc_values-sp ] OPTIONAL ).

      IF ls_partner IS NOT INITIAL.

        IF VALUE #( it_itens[ gc_values-v1 ]-reftyp OPTIONAL ) = gc_values-bi.

          " Obter o número de remessa
          DATA(lv_vgbel) = VALUE /scmtms/btd_id( it_vbrp[ gc_values-v1 ]-vgbel OPTIONAL ).

          IF lv_vgbel IS NOT INITIAL.

            UNPACK lv_vgbel TO lv_vgbel.

            " Obter o número da ordem de frete
            SELECT SINGLE _torid~tor_id
                INTO @DATA(lv_tor_id)
                FROM /scmtms/d_tordrf       AS _tordrf
                INNER JOIN /scmtms/d_torrot AS _torid
                 ON _tordrf~parent_key EQ _torid~db_key
                WHERE _tordrf~btd_id     EQ @lv_vgbel
                  AND _tordrf~btd_tco    EQ @gc_values-btd_tco
                  AND _torid~tor_cat     EQ @gc_values-tor_cat .

          ENDIF.

        ENDIF.

        " Obter email de NF-e da transportadora
        SELECT emailaddress FROM c_bpemailaddress
        INTO TABLE @DATA(lt_email)
        WHERE businesspartner                 = @ls_partner-parid
          AND addresscommunicationremarktext  = @gc_values-mailnfe.

        IF lt_email IS NOT INITIAL.

          DO gc_values-v3 TIMES.

* LSCHEPP - Ajuste - 14.10.2022 Início
            IF sy-index EQ gc_values-v3 AND
              lv_tor_id EQ space.
              EXIT.
            ENDIF.
* LSCHEPP - Ajuste - 14.10.2022 Fim

            et_add_info = VALUE #( BASE et_add_info (
                docnum    = is_header-docnum
                inf_usage = gc_values-v1
                xcampo    = COND #( WHEN sy-index EQ gc_values-v1 THEN gc_values-transporta_email
                                    WHEN sy-index EQ gc_values-v2 THEN gc_values-remessa
                                    ELSE gc_values-plano )
                xtexto    = COND #( WHEN sy-index EQ gc_values-v1 THEN VALUE #( lt_email[ gc_values-v1 ]-emailaddress OPTIONAL )
                                    WHEN sy-index EQ gc_values-v2 THEN lv_vgbel
                                    ELSE lv_tor_id )
* LSCHEPP - Ajuste - 14.10.2022 Início
*                xtexto2 = COND #( WHEN sy-index EQ gc_values-v1 THEN VALUE #( lt_email[ gc_values-v2 ]-emailaddress OPTIONAL ) )
*                xtexto3 = COND #( WHEN sy-index EQ gc_values-v1 THEN VALUE #( lt_email[ gc_values-v3 ]-emailaddress OPTIONAL ) )
*                xtexto4 = COND #( WHEN sy-index EQ gc_values-v1 THEN VALUE #( lt_email[ gc_values-v4 ]-emailaddress OPTIONAL ) )
*                xtexto5 = COND #( WHEN sy-index EQ gc_values-v1 THEN VALUE #( lt_email[ gc_values-v5 ]-emailaddress OPTIONAL ) )
*                xtexto6 = COND #( WHEN sy-index EQ gc_values-v1 THEN VALUE #( lt_email[ gc_values-v6 ]-emailaddress OPTIONAL ) )
*                xtexto7 = COND #( WHEN sy-index EQ gc_values-v1 THEN VALUE #( lt_email[ gc_values-v7 ]-emailaddress OPTIONAL ) )
*                xtexto8 = COND #( WHEN sy-index EQ gc_values-v1 THEN VALUE #( lt_email[ gc_values-v8 ]-emailaddress OPTIONAL ) )
*                xtexto9 = COND #( WHEN sy-index EQ gc_values-v1 THEN VALUE #( lt_email[ gc_values-v9 ]-emailaddress OPTIONAL ) )
* LSCHEPP - Ajuste - 14.10.2022 Fim
             ) ).

          ENDDO.

* LSCHEPP - Ajuste - 14.10.2022 Início
          IF lines( lt_email ) > 1.
            DELETE et_add_info WHERE xcampo = gc_values-transporta_email.
            LOOP AT lt_email ASSIGNING FIELD-SYMBOL(<fs_email>).
              ADD 1 TO lv_cont.
              APPEND VALUE #( inf_usage = gc_values-v1
                              xcampo    = |{ gc_values-transporta_email }{ lv_cont }|
                              xtexto    = <fs_email>-emailaddress
                            ) TO et_add_info.
            ENDLOOP.
          ENDIF.
* LSCHEPP - Ajuste - 14.10.2022 Fim

        ENDIF.

      ENDIF.

    ENDIF.

    SORT et_add_info.
    DELETE ADJACENT DUPLICATES FROM et_add_info COMPARING ALL FIELDS.
    DELETE et_add_info WHERE xcampo IS NOT INITIAL AND xtexto IS INITIAL.

  ENDMETHOD.
ENDCLASS.
