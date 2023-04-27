*&---------------------------------------------------------------------*
*&  Include           ZGNRE004SC01
*&---------------------------------------------------------------------*

* Parâmetros de seleção
*-----------------------------------------------------------------------
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-t01. "Critérios de seleção
SELECT-OPTIONS: s_credat FOR gs_screen_params-credat,                    "Data de criação da Guia
                s_nfcdat FOR gs_screen_params-nf_credat,                 "Data de criação da Nota Fiscal
                s_dtpgto FOR gs_screen_params-dtpgto,                    "Data de pagamento
                s_docnum FOR gs_screen_params-docnum,                    "Nº documento
                s_nfenum FOR gs_screen_params-nfenum,                    "Nº documento nove posições
                s_serie  FOR gs_screen_params-series,                    "Séries
                s_vbeln  FOR gs_screen_params-vbeln_va,                  "Ordem de venda
                s_bukrs  FOR gs_screen_params-bukrs OBLIGATORY
                                                    MEMORY ID buk,       "Empresa
                s_branc  FOR gs_screen_params-branch,                    "Local de negócios
                s_cgc    FOR gs_screen_params-cgc,                       "CNPJ da filial do destino
                s_regio  FOR gs_screen_params-regio,                     "Região
                s_step   FOR gs_screen_params-step,                      "Etapa GNRE
                s_hkont  FOR gs_screen_params-hkont,                     "Conta Contábil
                s_matnr  FOR gs_screen_params-matnr,                     "Material
                s_matkl  FOR gs_screen_params-matkl.                     "Grupo de Mercadorias
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-t02. "Tipo de operação
PARAMETERS: p_cfinal RADIOBUTTON GROUP rb1,             "Consumidor Final
            p_contri RADIOBUTTON GROUP rb1,             "Contribuinte
            p_todos  RADIOBUTTON GROUP rb1 DEFAULT 'X'. "Todos
SELECTION-SCREEN END OF BLOCK b2.

AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF screen-name = 'S_CREDAT-LOW' OR screen-name = 'S_NFCDAT-LOW' OR
       screen-name = 'S_DTPGTO-LOW' OR screen-name = 'S_DOCNUM-LOW'.
      screen-required = 2.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.
