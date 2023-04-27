
* Parâmetros de seleção
*-----------------------------------------------------------------------
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-t01. "Critérios de seleção
SELECT-OPTIONS: s_credat FOR gs_screen_params-credat,                    "Data de criação da Guia
                s_nfcdat FOR gs_screen_params-nf_credat,                 "Data de criação da Nota Fiscal
                s_dtpgto FOR gs_screen_params-dtpgto,                    "Data de pagamento
                s_docnum FOR gs_screen_params-docnum,                    "Nº documento
                s_nfenum FOR gs_screen_params-nfenum,                    "Nº documento nove posições
                s_serie  FOR gs_screen_params-series,                    "Séries
                s_refke  FOR gs_screen_params-refkey,                    "Ref.doc.origem
                s_fkart  FOR gs_screen_params-fkart,                     "Tp.doc.faturamento
                s_auart  FOR gs_screen_params-auart,                     "Tipo doc.vendas
                s_bukrs  FOR gs_screen_params-bukrs OBLIGATORY
                                                    MEMORY ID buk,       "Empresa
                s_branc  FOR gs_screen_params-branch,                    "Local de negócios
*                s_parid  FOR gs_screen_params-parid,                     "ID parceiro
*                s_cgc    FOR gs_screen_params-cgc,                       "CNPJ da filial do destino
                s_regio  FOR gs_screen_params-regio,                     "Região
                s_nguia  FOR gs_screen_params-num_guia,                  "Nº de Guia
                s_step   FOR gs_screen_params-step.                      "Etapa GNRE

SELECTION-SCREEN END OF BLOCK b1.
SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-t02.
PARAMETERS: p_cfinal RADIOBUTTON GROUP rb1,             "Consumidor Final
            p_contri RADIOBUTTON GROUP rb1,             "Contribuinte
            p_todos  RADIOBUTTON GROUP rb1 DEFAULT 'X', "Todos
            p_guia   RADIOBUTTON GROUP rb1.
SELECTION-SCREEN END OF BLOCK b2.
SELECTION-SCREEN FUNCTION KEY 1.
SELECTION-SCREEN FUNCTION KEY 2.


AT SELECTION-SCREEN OUTPUT.



  LOOP AT SCREEN.
    IF screen-name = 'S_CREDAT-LOW' OR screen-name = 'S_NFCDAT-LOW' OR
       screen-name = 'S_DTPGTO-LOW' OR screen-name = 'S_DOCNUM-LOW'.
      screen-required = 2.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.
