*&---------------------------------------------------------------------*
*& Include          ZSDI_ZXM06U44_PROCE_INDUS
*&---------------------------------------------------------------------*
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     VALUE(I_EKKO) LIKE  EKKO STRUCTURE  EKKO
*"     VALUE(I_EKKO_OLD) LIKE  EKKO STRUCTURE  EKKO
*"     VALUE(I_LOGSY) LIKE  EKKO-LOGSY OPTIONAL
*"     VALUE(I_VORGA) LIKE  T160-VORGA OPTIONAL
*"  TABLES
*"      XEKET STRUCTURE  UEKET
*"      XEKKN STRUCTURE  UEKKN
*"      XEKPO STRUCTURE  UEKPO
*"      XKOMV STRUCTURE  KOMV
*"      YEKET STRUCTURE  UEKET
*"      YEKKN STRUCTURE  UEKKN
*"      YEKPO STRUCTURE  UEKPO
*"      YKOMVI STRUCTURE  KOMV
*"      XEKBES STRUCTURE  EKBES
*"      XEKES STRUCTURE  UEKES OPTIONAL
*"      XEKEH STRUCTURE  IEKEH OPTIONAL
*"      XEKEK STRUCTURE  UEKEK OPTIONAL
*"      XEINA STRUCTURE  EINAU OPTIONAL
*"      XEINE STRUCTURE  EINEU OPTIONAL
*"      YEINA STRUCTURE  EINA OPTIONAL
*"      YEINE STRUCTURE  EINE OPTIONAL
*"      YEKES STRUCTURE  UEKES OPTIONAL
*"      YEKEH STRUCTURE  IEKEH OPTIONAL
*"      YEKEK STRUCTURE  UEKEK OPTIONAL
*"      XBATU STRUCTURE  FEBAN OPTIONAL
*"      XEKPA STRUCTURE  UEKPA OPTIONAL
*"      YEKPA STRUCTURE  UEKPA OPTIONAL
*"      XEKPV STRUCTURE  EKPV OPTIONAL
*"----------------------------------------------------------------------

*new zclsd_processo_indust( )->exit_criacao_ordem_venda(
*  EXPORTING
*    is_ekko     = I_EKKO
*    iv_vorga    = i_vorga
*    is_ekko_old = i_ekko_old
*    it_ekpo     = XEKPO[] ).
