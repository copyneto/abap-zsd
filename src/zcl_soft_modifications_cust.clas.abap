class ZCL_SOFT_MODIFICATIONS_CUST definition
  public
  final
  create public .

*"* public components of class ZCL_SOFT_MODIFICATIONS_CUST
*"* do not include other source files here!!!
public section.

  interfaces IF_JBR_SOFT_MODIFICATIONS .
protected section.
*"* protected components of class ZCL_SOFT_MODIFICATIONS_CUST
*"* do not include other source files here!!!
private section.
*"* private components of class ZCL_SOFT_MODIFICATIONS_CUST
*"* do not include other source files here!!!

  aliases CON_X_ACTIVE
    for IF_JBR_SOFT_MODIFICATIONS~CON_X_ACTIVE .
  aliases CON_X_INACTIVE
    for IF_JBR_SOFT_MODIFICATIONS~CON_X_INACTIVE .

  methods GET_ATTR_FOR_NOTE_4712
    importing
      !I_ATTRIBUTES type JBR_STR_SOFT_MOD_4712_IN
    exporting
      !E_ATTRIBUTES type JBR_STR_SOFT_MOD_4712_OUT .
ENDCLASS.



CLASS ZCL_SOFT_MODIFICATIONS_CUST IMPLEMENTATION.


METHOD GET_ATTR_FOR_NOTE_4712.

* --- Attribute.Demo:
*     Load attributes for special note: 4712
*     (the structures are determined by each individual note)


  CASE i_attributes-company_code.

    WHEN '0001'.

      CASE i_attributes-product_type.

        WHEN '33A'
          OR '33B'.                " general loans

          e_attributes-x_active = con_x_active.

        WHEN OTHERS.

          e_attributes-x_active = con_x_inactive.

      ENDCASE.

    WHEN OTHERS.

      e_attributes-x_active = con_x_inactive.

  ENDCASE.

ENDMETHOD.


METHOD IF_JBR_SOFT_MODIFICATIONS~GET_ATTRIBUTES.

* --- load attributes for each note (if note offers usage of attributes)

*     Next to the plain activation a note has the possibility
*     to offer special attributes to control the modification, so that
*     complexer control is possible.
*     Any combination of I_, E_, and C_ATTRIBUTES is imaginable.
*     The used structures differ for each note and are described there.
*     (One may access structures using assigning-technique or use own
*      methods with the requested structures in the interface like
*      shown below.)

  CASE i_note_id.

    WHEN 4712.                   " Demo

*     example: attribute-control for note 4712

      CALL METHOD get_attr_for_note_4712
        EXPORTING
          i_attributes = i_attributes
        IMPORTING
          e_attributes = e_attributes.

*--- add further notes here...
*    WHEN ... .
*
*      CALL METHOD get_attr_for_note_...
*        ...



    WHEN OTHERS.

*     do nothing (only plain activation supported)

  ENDCASE.


ENDMETHOD.


METHOD IF_JBR_SOFT_MODIFICATIONS~IS_ACTIVE.

* --- activate the soft modifications for each note-id
*     over this simple case-list:

  CASE i_note_id.

    WHEN 4711.                       " Demo

      r_x_active = con_x_active.

    WHEN 4712.                       " Demo

      r_x_active = con_x_active.

*--- add further notes here...
*    WHEN ... .
*
*      r_x_active = con_x_active.


    WHEN OTHERS.

      r_x_active = con_x_inactive.   " default: not active

  ENDCASE.


ENDMETHOD.
ENDCLASS.
