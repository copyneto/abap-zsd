CLASS lcl_cx_gnre_cockpit DEFINITION
  INHERITING FROM cx_static_check.

  PUBLIC SECTION.

    INTERFACES if_t100_message .

    TYPES:
      ty_t_errors TYPE TABLE OF REF TO lcl_cx_gnre_cockpit WITH DEFAULT KEY.

    CONSTANTS:
      BEGIN OF gc_gnre_cockpit,
        msgid TYPE symsgid VALUE 'ZSD_GNRE',
        msgno TYPE symsgno VALUE '000',
        attr1 TYPE scx_attrname VALUE 'GV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'GV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'GV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'GV_MSGV4',
      END OF gc_gnre_cockpit,

      BEGIN OF gc_data_not_found,
        msgid TYPE symsgid VALUE 'ZSD_GNRE',
        msgno TYPE symsgno VALUE '001',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF gc_data_not_found.

    METHODS constructor
      IMPORTING
        !iv_textid      LIKE if_t100_message=>t100key OPTIONAL
        !iv_previous    LIKE previous OPTIONAL
        !iv_msgv1       TYPE msgv1 OPTIONAL
        !iv_msgv2       TYPE msgv2 OPTIONAL
        !iv_msgv3       TYPE msgv3 OPTIONAL
        !iv_msgv4       TYPE msgv4 OPTIONAL
        !it_errors      TYPE ty_t_errors OPTIONAL
        !it_bapi_return TYPE bapiret2_t OPTIONAL.

    METHODS display.

    METHODS get_bapi_return
      RETURNING
        VALUE(rt_return) TYPE bapiret2_t.

  PROTECTED SECTION.

    DATA gv_msgv1 TYPE msgv1.
    DATA gv_msgv2 TYPE msgv2.
    DATA gv_msgv3 TYPE msgv3.
    DATA gv_msgv4 TYPE msgv4.
    DATA gt_errors TYPE ty_t_errors.
    DATA gt_bapi_return TYPE bapiret2_t.

  PRIVATE SECTION.
ENDCLASS.

CLASS lcl_gnre_cockpit DEFINITION
                       FINAL
                       CREATE PRIVATE.

  PUBLIC SECTION.

    TYPES: ty_t_outtab_top            TYPE TABLE OF zssd_gnree001 WITH DEFAULT KEY,
           ty_t_outtab_bottom         TYPE TABLE OF zssd_gnree002 WITH DEFAULT KEY,
           ty_t_outtab_manual_payment TYPE TABLE OF zssd_gnree004 WITH DEFAULT KEY,
           ty_t_outtab_manual_guide   TYPE TABLE OF zssd_gnree005 WITH DEFAULT KEY,
           ty_t_outtab_guia_compl     TYPE TABLE OF zssd_gnree006 WITH DEFAULT KEY,
           ty_t_outtab_popup          TYPE TABLE OF zssd_gnree011 WITH DEFAULT KEY,
           ty_t_ucomm                 TYPE TABLE OF sy-ucomm WITH DEFAULT KEY.

    TYPES:
      BEGIN OF ty_s_result_select1,
        docnum      TYPE ztsd_gnret001-docnum,
        docguia     TYPE ztsd_gnret001-docguia,
        tpguia      TYPE ztsd_gnret001-tpguia,
        step        TYPE ztsd_gnret001-step,
        tpprocess   TYPE ztsd_gnret001-tpprocess,
        consumo     TYPE ztsd_gnret001-consumo,
        zsub        TYPE ztsd_gnret001-zsub,
        guiacompl   TYPE ztsd_gnret001-guiacompl,
        credat      TYPE ztsd_gnret001-credat,
        cretim      TYPE ztsd_gnret001-cretim,
        crenam      TYPE ztsd_gnret001-crenam,
        chadat      TYPE ztsd_gnret001-chadat,
        chatim      TYPE ztsd_gnret001-chatim,
        chanam      TYPE ztsd_gnret001-chanam,
        bukrs       TYPE ztsd_gnret001-bukrs,
        branch      TYPE ztsd_gnret001-branch,
        lifnr       TYPE ztsd_gnret001-lifnr,
        num_guia    TYPE ztsd_gnret001-num_guia,
        prot_guia   TYPE ztsd_gnret001-prot_guia,
        bukrs_doc   TYPE ztsd_gnret001-bukrs_doc,
        branch_doc  TYPE ztsd_gnret001-branch_doc,
        belnr       TYPE ztsd_gnret001-belnr,
        gjahr       TYPE ztsd_gnret001-gjahr,
        augbl       TYPE ztsd_gnret001-augbl,
        auggj       TYPE ztsd_gnret001-auggj,
        dtpgto      TYPE ztsd_gnret001-dtpgto,
        faedt       TYPE ztsd_gnret001-faedt,
        brcde_guia  TYPE ztsd_gnret001-brcde_guia,
        ldig_guia   TYPE ztsd_gnret001-ldig_guia,
        codaut_guia TYPE ztsd_gnret001-codaut_guia,
        vlrtot      TYPE ztsd_gnret001-vlrtot,
        vlrpago     TYPE ztsd_gnret001-vlrpago,
        laufd       TYPE ztsd_gnret001-laufd,
        laufi       TYPE ztsd_gnret001-laufi,
        nf_docdat   TYPE j_1bnfdoc-docdat,
        nf_crenam   TYPE j_1bnfdoc-crenam,
        nf_credat   TYPE j_1bnfdoc-credat,
        nf_cretim   TYPE j_1bnfdoc-cretim,
        series      TYPE j_1bnfdoc-series,
        nfenum      TYPE j_1bnfdoc-nfenum,
        regio       TYPE j_1bnfdoc-regio,
        parvw       TYPE j_1bnfdoc-parvw,
        parid       TYPE j_1bnfdoc-parid,
        parxcpdk    TYPE j_1bnfdoc-parxcpdk,
        name1       TYPE j_1bnfdoc-name1,
        code        TYPE j_1bnfe_active-code,
      END OF ty_s_result_select1,

      ty_t_result_select1 TYPE TABLE OF ty_s_result_select1 WITH DEFAULT KEY.

    TYPES:
      BEGIN OF ty_s_result_select2,
        docnum      TYPE ztsd_gnret002-docnum,
        docguia     TYPE ztsd_gnret002-docguia,
        itemguia    TYPE ztsd_gnret002-itemguia,
        taxtyp      TYPE ztsd_gnret002-taxtyp,
        hkont       TYPE ztsd_gnret002-hkont,
        taxval      TYPE ztsd_gnret002-taxval,
        subdivision TYPE j_1baj-subdivision,
      END OF ty_s_result_select2,

      ty_t_result_select2 TYPE TABLE OF ty_s_result_select2 WITH DEFAULT KEY.

    TYPES:
      BEGIN OF ty_s_result_select3,
        docnum TYPE j_1bnflin-docnum,
        refkey TYPE j_1bnflin-refkey,
        fkart  TYPE vbrk-fkart,
        tknum  TYPE vttk-tknum,
      END OF ty_s_result_select3,

      ty_t_result_select3 TYPE TABLE OF ty_s_result_select3 WITH DEFAULT KEY.

    TYPES:
      BEGIN OF ty_s_result_select4,
        docnum TYPE j_1bnflin-docnum,
        refkey TYPE j_1bnflin-refkey,
        vbeln  TYPE vbak-vbeln,
        auart  TYPE vbak-auart,
      END OF ty_s_result_select4,

      ty_t_result_select4 TYPE TABLE OF ty_s_result_select4 WITH DEFAULT KEY.

    TYPES:
      BEGIN OF ty_s_j_1bnfcpd,
        docnum TYPE j_1bnfcpd-docnum,
        parvw  TYPE j_1bnfcpd-parvw,
        regio  TYPE j_1bnfcpd-regio,
        name1  TYPE j_1bnfcpd-name1,
      END OF ty_s_j_1bnfcpd,

      ty_t_j_1bnfcpd TYPE TABLE OF ty_s_j_1bnfcpd WITH DEFAULT KEY.

    TYPES:
      BEGIN OF ty_s_vbrk,
        vbeln TYPE vbrk-vbeln,
        fkart TYPE vbrk-fkart,
      END OF ty_s_vbrk.

    CLASS-METHODS create_instance
      RETURNING
        VALUE(rt_instance) TYPE REF TO lcl_gnre_cockpit.
    CLASS-METHODS get_instance
      RETURNING
        VALUE(rt_instance) TYPE REF TO lcl_gnre_cockpit.
    CLASS-METHODS check_auth_buttons_9000
      RETURNING
        VALUE(rt_excluding) TYPE ty_t_ucomm.

    METHODS main.
    METHODS add_guia_compl.
    METHODS popup_confirm.
    METHODS preenche_alv.
    METHODS set_data_9000.
    METHODS set_data_9010.
    METHODS user_command_9000
      IMPORTING
        iv_ucomm TYPE sy-ucomm.
    METHODS set_data_9001.
    METHODS user_command_9001
      IMPORTING
        iv_ucomm TYPE sy-ucomm.
    METHODS set_data_9002.
    METHODS user_command_9002
      IMPORTING
        iv_ucomm TYPE sy-ucomm.
    METHODS set_data_9003.
    METHODS user_command_9003
      IMPORTING
        iv_ucomm TYPE sy-ucomm.
    METHODS user_command_9004
      IMPORTING
        iv_ucomm TYPE sy-ucomm.
    METHODS user_command_9005
      IMPORTING
        iv_ucomm TYPE sy-ucomm.
    METHODS user_command_9006
      IMPORTING
        iv_ucomm TYPE sy-ucomm.
    METHODS user_command_9007
      IMPORTING
        iv_ucomm TYPE sy-ucomm.
    METHODS user_command_9008
      IMPORTING
        iv_ucomm TYPE sy-ucomm.
    METHODS user_command_9009
      IMPORTING
        iv_ucomm TYPE sy-ucomm.
    METHODS user_command_9010
      IMPORTING
        iv_ucomm TYPE sy-ucomm.

  PRIVATE SECTION.

    CLASS-DATA: go_instance TYPE REF TO lcl_gnre_cockpit.

    DATA: go_main_container           TYPE REF TO cl_gui_custom_container,
          go_manual_guide_container   TYPE REF TO cl_gui_custom_container,
          go_manual_payment_container TYPE REF TO cl_gui_custom_container,
          go_manual_popup             TYPE REF TO cl_gui_custom_container,
          go_splitter_container       TYPE REF TO cl_gui_splitter_container,
          go_container_top            TYPE REF TO cl_gui_container,
          go_container_bottom         TYPE REF TO cl_gui_container,
          go_container_guia_compl     TYPE REF TO cl_gui_custom_container,
          go_container_popup          TYPE REF TO cl_gui_custom_container,
          go_alv_grid_top             TYPE REF TO cl_gui_alv_grid,
          go_alv_grid_manual_guide    TYPE REF TO cl_gui_alv_grid,
          go_alv_grid_manual_payment  TYPE REF TO cl_gui_alv_grid,
          go_alv_grid_popup           TYPE REF TO cl_gui_alv_grid,
          go_alv_grid_bottom          TYPE REF TO cl_gui_alv_grid,
          go_alv_grid_guia_compl      TYPE REF TO cl_gui_alv_grid,
          gt_outtab_top               TYPE ty_t_outtab_top,
          gt_outtab_manual_guide      TYPE ty_t_outtab_manual_guide,
          gt_outtab_manual_payment    TYPE ty_t_outtab_manual_payment,
          gt_outtab_bottom            TYPE ty_t_outtab_bottom,
          gt_outtab_guia_compl        TYPE ty_t_outtab_guia_compl,
          gt_outtab_popup             TYPE ty_t_outtab_popup,
          gt_result_select1           TYPE ty_t_result_select1,
          gt_result_select2           TYPE ty_t_result_select2,
          gt_result_select3           TYPE ty_t_result_select3,
          gt_result_select4           TYPE ty_t_result_select4,
          gt_ztsd_gnret003            TYPE TABLE OF ztsd_gnret003,
          gt_gnret009                 TYPE TABLE OF ztsd_gnret009,
          gt_j_1bnfcpd                TYPE ty_t_j_1bnfcpd,
          gv_alv_top_displayed        TYPE abap_bool,
          gv_alv_bottom_displayed     TYPE abap_bool.

    METHODS select_data
      RAISING
        lcl_cx_gnre_cockpit.
    METHODS process_data
      RAISING
        lcl_cx_gnre_cockpit.
    METHODS call_screen.
    METHODS init_objects.
    METHODS display_alv.
    METHODS display_alv_top.
    METHODS display_alv_bottom.
    METHODS generate_fieldcat
      IMPORTING
        it_table       TYPE ANY TABLE
      RETURNING
        VALUE(rt_fcat) TYPE lvc_t_fcat.
    METHODS change_fieldcat_top
      CHANGING
        ct_fieldcat TYPE lvc_t_fcat.
    METHODS display_log_for_docguia
      IMPORTING
        is_outtab_top TYPE zssd_gnree001.
    METHODS call_screen_manual_guide.
    METHODS call_screen_manual_payment.
    METHODS init_objects_9001.
    METHODS display_alv_9001.
    METHODS init_objects_9002.
    METHODS display_alv_9002.
    METHODS change_fieldcat_manual_guide
      CHANGING
        ct_fieldcat TYPE lvc_t_fcat.
    METHODS change_fieldcat_manual_payment
      CHANGING
        ct_fieldcat TYPE lvc_t_fcat.
    METHODS refresh.
    METHODS reprocess.
    METHODS show_popup_manual_guide.
    METHODS free_control_manual_guide.
    METHODS manual_guide.
    METHODS show_popup_manual_payment.
    METHODS free_control_manual_payment.
    METHODS manual_payment.
    METHODS print.
    METHODS init_objects_9003.
    METHODS display_alv_9003.
    METHODS init_objects_9010.
    METHODS display_alv_9010.
    METHODS process_guia_compl
      RAISING
        zcxsd_gnre_automacao.
    METHODS disable_guia.

    METHODS handle_hotspot_click_alv_top FOR EVENT hotspot_click OF cl_gui_alv_grid
      IMPORTING
        e_row_id
        e_column_id.

ENDCLASS.
