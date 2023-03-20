class ZCL_MICHAEL definition
  public
  create public .

public section.

  types:
    BEGIN OF ts_attribute,
             attribute TYPE string,
             value     TYPE string,
           END OF ts_attribute .
  types:
    tt_attributes TYPE STANDARD TABLE OF ts_attribute WITH  NON-UNIQUE KEY attribute .

  methods CONSTRUCTOR
    importing
      !IV_NAME type STRING
      !IV_PLANETYPE type SAPLANE-PLANETYPE
    raising
      CX_S4D400_WRONG_PLANE .
  methods GET_ATTRIBUTES
    exporting                  " returns an internal table
      !ET_ATTRIBUTES type TT_ATTRIBUTES .
  methods GET_MV_NAME
    returning
      value(R_RESULT) type STRING .
  methods SET_MV_NAME
    importing
      !IV_MV_NAME type STRING .
  methods GET_MV_PLANETYPE
    returning
      value(R_RESULT) type SAPLANE-PLANETYPE .
  methods SET_MV_PLANETYPE
    importing                                                           "tt_attributes.
      !IV_MV_PLANETYPE type SAPLANE-PLANETYPE .
  class-methods CLASS_CONSTRUCTOR .
  class-methods GET_N_O_AIRPLANES
    exporting
      value(EV_NUMBER) type I .
  PROTECTED  SECTION.
    DATA: mv_name      TYPE string, "instance level
          mv_planetype TYPE saplane-planetype. " instance level
  PRIVATE SECTION.
    CLASS-DATA:
      gv_n_o_airplanes TYPE i,
      gt_planetypes    TYPE TABLE OF saplane. "class level

ENDCLASS.



CLASS ZCL_MICHAEL IMPLEMENTATION.


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
