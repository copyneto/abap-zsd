class ZCLSD_AGENDAMT_CLIENTE definition
  public
  final
  create public .

public section.

  methods MONTA_HORARIOS
    importing
      !IV_KUNNR type KUNNR
    exporting
      !EV_SEGUNDA type STRING
      !EV_TERCA type STRING
      !EV_QUARTA type STRING
      !EV_QUINTA type STRING
      !EV_SEXTA type STRING
      !EV_NTFOUND type CHAR1 .
protected section.
private section.

  constants GC_ABLAD type KNVA-ABLAD value 'PONTO' ##NO_TEXT.

  methods GET_DIA
    importing
      !IV_AB1 type TIMS optional
      !IV_BI1 type TIMS optional
      !IV_AB2 type TIMS optional
      !IV_BI2 type TIMS optional
    changing
      !CV_DIA type STRING .
ENDCLASS.



CLASS ZCLSD_AGENDAMT_CLIENTE IMPLEMENTATION.


  METHOD get_dia.

    DATA: lv_ab1 TYPE char8,
          lv_bi1 TYPE char8,
          lv_ab2 TYPE char8,
          lv_bi2 TYPE char8.

    IF iv_ab1 IS NOT INITIAL.
      lv_ab1 = |{ iv_ab1(2) }{ ':' }{ iv_ab1+2(2) }{ ':' }{ iv_ab1+4(2) }|.
    ENDIF.

    IF iv_bi1 IS NOT INITIAL.
      lv_bi1 = |{ iv_bi1(2) }{ ':' }{ iv_bi1+2(2) }{ ':' }{ iv_bi1+4(2) }|.
    ENDIF.

    IF iv_ab2 IS NOT INITIAL.
      lv_ab2 = |{ iv_ab2(2) }{ ':' }{ iv_ab2+2(2) }{ ':' }{ iv_ab2+4(2) }|.
    ENDIF.

    IF iv_bi2 IS NOT INITIAL.
      lv_bi2 = |{ iv_bi2(2) }{ ':' }{ iv_bi2+2(2) }{ ':' }{ iv_bi2+4(2) }|.
    ENDIF.

    cv_dia = |{ cv_dia } { lv_ab1 }|.

    IF iv_bi1 IS NOT INITIAL.
      cv_dia = |{ cv_dia } { '-' } { lv_bi1 }|.
      IF iv_ab2 IS NOT INITIAL.
        cv_dia = |{ cv_dia } { 'e' } { lv_ab2 } { '-' } { lv_bi2 }|.
      ENDIF.
    ELSE.
      IF iv_bi2 IS NOT INITIAL.
        cv_dia = |{ cv_dia } { 'a' } { lv_bi2 }|.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD monta_horarios.

    DATA: lv_semn TYPE char3.

    IF iv_kunnr IS NOT INITIAL.

      SELECT SINGLE kunnr,
                    ablad,
                    moab1,
                    mobi1,
                    moab2,
                    mobi2,
                    diab1,
                    dibi1,
                    diab2,
                    dibi2,
                    miab1,
                    mibi1,
                    miab2,
                    mibi2,
                    doab1,
                    dobi1,
                    doab2,
                    dobi2,
                    frab1,
                    frbi1,
                    frab2,
                    frbi2
        FROM knva
       WHERE kunnr = @iv_kunnr
         AND ablad = @gc_ablad
        INTO @DATA(ls_knva).

      IF sy-subrc IS INITIAL.

        " Segunda-feira
        IF ls_knva-moab1 IS NOT INITIAL.

          lv_semn = TEXT-001.
          ev_segunda = |{ lv_semn }|.

          me->get_dia( EXPORTING iv_ab1 = ls_knva-moab1
                                 iv_bi1 = ls_knva-mobi1
                                 iv_ab2 = ls_knva-moab2
                                 iv_bi2 = ls_knva-mobi2
                        CHANGING cv_dia = ev_segunda ).
        ENDIF.

        " Terça-feira
        IF ls_knva-diab1 IS NOT INITIAL.

          lv_semn = TEXT-002.
          ev_terca = |{ lv_semn }|.

          me->get_dia( EXPORTING iv_ab1 = ls_knva-diab1
                                 iv_bi1 = ls_knva-dibi1
                                 iv_ab2 = ls_knva-diab2
                                 iv_bi2 = ls_knva-dibi2
                        CHANGING cv_dia = ev_terca ).
        ENDIF.

        " Quarta-feira
        IF ls_knva-miab1 IS NOT INITIAL.

          lv_semn = TEXT-003.
          ev_quarta = |{ lv_semn }|.

          me->get_dia( EXPORTING iv_ab1 = ls_knva-miab1
                                 iv_bi1 = ls_knva-mibi1
                                 iv_ab2 = ls_knva-miab2
                                 iv_bi2 = ls_knva-mibi2
                        CHANGING cv_dia = ev_quarta ).
        ENDIF.

        " Quinta-feira
        IF ls_knva-doab1 IS NOT INITIAL.

          lv_semn = TEXT-004.
          ev_quinta = |{ lv_semn }|.

          me->get_dia( EXPORTING iv_ab1 = ls_knva-doab1
                                 iv_bi1 = ls_knva-dobi1
                                 iv_ab2 = ls_knva-doab2
                                 iv_bi2 = ls_knva-dobi2
                        CHANGING cv_dia = ev_quinta ).
        ENDIF.

        " Sexta-feira
        IF ls_knva-frab1 IS NOT INITIAL.

          lv_semn = TEXT-005.
          ev_sexta = |{ lv_semn }|.

          me->get_dia( EXPORTING iv_ab1 = ls_knva-frab1
                                 iv_bi1 = ls_knva-frbi1
                                 iv_ab2 = ls_knva-frab2
                                 iv_bi2 = ls_knva-frbi2
                        CHANGING cv_dia = ev_sexta ).
        ENDIF.
      ELSE.
        ev_ntfound = abap_true.
      ENDIF.
    ELSE.
      ev_ntfound = abap_true.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
