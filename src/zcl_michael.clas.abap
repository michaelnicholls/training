CLASS zcl_michael DEFINITION
  PUBLIC

  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES: BEGIN OF ts_attribute,
             attribute TYPE string,
             value     TYPE string,
           END OF ts_attribute,
           tt_attributes TYPE STANDARD TABLE OF ts_attribute WITH  NON-UNIQUE KEY attribute.
    METHODS:

      constructor IMPORTING iv_name      TYPE string
                            iv_planetype TYPE saplane-planetype
                  RAISING   cx_s4d400_wrong_plane,

      get_attributes EXPORTING " returns an internal table
                       et_attributes TYPE tt_attributes,
      get_mv_name RETURNING VALUE(r_result) TYPE string,
      set_mv_name IMPORTING iv_mv_name TYPE string,
      get_mv_planetype RETURNING VALUE(r_result) TYPE saplane-planetype,
      set_mv_planetype IMPORTING iv_mv_planetype TYPE saplane-planetype."tt_attributes.
    CLASS-METHODS:
      class_constructor,
      get_n_o_airplanes RETURNING VALUE(ev_number) TYPE i.
  PROTECTED  SECTION.
    DATA: mv_name      TYPE string, "instance level
          mv_planetype TYPE saplane-planetype. " instance level
  PRIVATE SECTION.
    CLASS-DATA:
      gv_n_o_airplanes TYPE i,
      gt_planetypes    TYPE TABLE OF saplane. "class level

ENDCLASS.



CLASS zcl_michael IMPLEMENTATION.


  METHOD get_attributes.
    et_attributes = VALUE #(
      (  attribute = 'NAME' value = mv_name )
      (  attribute = 'PLANETYPE' value = mv_planetype )
   ).

  ENDMETHOD.

  METHOD get_n_o_airplanes.
    ev_number = gv_n_o_airplanes.

  ENDMETHOD.
  METHOD class_constructor.
    SELECT * FROM saplane INTO TABLE gt_planetypes.

  ENDMETHOD.

  METHOD constructor.
    IF NOT line_exists( gt_planetypes[  planetype = iv_planetype  ] ).
      RAISE EXCEPTION TYPE cx_s4d400_wrong_plane.
    ENDIF.
    mv_name = iv_name.
    mv_planetype    = iv_planetype.
    gv_n_o_airplanes = gv_n_o_airplanes + 1.
  ENDMETHOD.



  METHOD get_mv_name.
    r_result = me->mv_name.
  ENDMETHOD.

  METHOD set_mv_name.
    me->mv_name = iv_mv_name.
  ENDMETHOD.

  METHOD get_mv_planetype.
    r_result = me->mv_planetype.
  ENDMETHOD.

  METHOD set_mv_planetype.
    me->mv_planetype = iv_mv_planetype.
  ENDMETHOD.

ENDCLASS.
