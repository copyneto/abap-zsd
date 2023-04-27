class ZCLSD_QUALITY_VE definition
  public
  final
  create public .

public section.

  interfaces IF_SADL_EXIT .
  interfaces IF_SADL_EXIT_CALC_ELEMENT_READ .
protected section.
private section.
ENDCLASS.



CLASS ZCLSD_QUALITY_VE IMPLEMENTATION.


  method if_sadl_exit_calc_element_read~calculate.

    data: lt_data    type standard table of zi_sd_quality_ve with default key,
          lt_lines   type standard table of tline,
          lv_tdspras type thead-tdspras,
          lv_name    type thead-tdname.

    lt_data  = corresponding #( it_original_data ).


    loop at lt_data assigning field-symbol(<fs_data>).

      try.

          <fs_data>-quality = 'aa'.

          lv_tdspras = 'EN'.
          lv_name = |{ <fs_data>-salesorder(10) }{ <fs_data>-salesorderitem(6) }|.


          call function 'READ_TEXT'  "#EC CI_SEL_NESTED
            exporting
              client                  = sy-mandt    " Client
              id                      = '0001'      " Text ID of text to be read
              language                = lv_tdspras  " Language of text to be read
              name                    = lv_name     " Name of text to be read
              object                  = 'VBBP'      " Object of text to be read
            tables
              lines                   = lt_lines
            exceptions
              id                      = 1       " Text ID invalid
              language                = 2       " Invalid language
              name                    = 3       " Invalid text name
              not_found               = 4       " Text not found
              object                  = 5       " Invalid text object
              reference_check         = 6       " Reference chain interrupted
              wrong_access_to_archive = 7       " Archive handle invalid for access
              others                  = 8.

          if sy-subrc is initial.

            IF lt_lines[] IS NOT INITIAL.
              <fs_data>-quality = lt_lines[ 1 ]-tdline.
            ENDIF.

          else.
            <fs_data>-quality = 'not found'.

          endif.

        catch cx_sy_itab_line_not_found.

      endtry.

    endloop.

    ct_calculated_data = corresponding #( lt_data ).
  endmethod.


  method IF_SADL_EXIT_CALC_ELEMENT_READ~GET_CALCULATION_INFO.

    check 1 = 1.

  endmethod.
ENDCLASS.
