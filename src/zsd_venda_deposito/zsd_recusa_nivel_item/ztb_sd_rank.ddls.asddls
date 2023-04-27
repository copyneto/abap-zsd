@EndUserText.label: 'Ultima modificação - usuário'
define table function ZTB_SD_RANK
  //  with parameters
  //    @Environment.systemField: #CLIENT
  //    p_clnt : abap.clnt
returns
{
  mandant  : mandt;
  objectid : cdobjectv;
  username : cdusername;
  udate    : udate;
  utime    : utime;

}
implemented by method
  zclsd_rank=>get_udate;
