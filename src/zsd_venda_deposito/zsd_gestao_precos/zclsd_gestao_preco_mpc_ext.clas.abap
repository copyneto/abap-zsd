class ZCLSD_GESTAO_PRECO_MPC_EXT definition
  public
  inheriting from ZCLSD_GESTAO_PRECO_MPC
  create public .

public section.

    METHODS define REDEFINITION.

protected section.
private section.
ENDCLASS.



CLASS ZCLSD_GESTAO_PRECO_MPC_EXT IMPLEMENTATION.

  METHOD define.

    super->define( ).

    DATA:
      lo_entity   TYPE REF TO /iwbep/if_mgw_odata_entity_typ,
      lo_property TYPE REF TO /iwbep/if_mgw_odata_property.

    lo_entity = model->get_entity_type( iv_entity_name = 'uploadPrice' ).

    IF lo_entity IS BOUND.
      lo_property = lo_entity->get_property( iv_property_name = 'Tablename' ) ##NO_TEXT.
      lo_property->set_as_content_type( ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
