*&---------------------------------------------------------------------*
*& Report z_class_00
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*


REPORT z_class_00.

CLASS lcl_passenger_plane DEFINITION INHERITING FROM zcl_michael.
  PUBLIC SECTION.
    METHODS get_attributes REDEFINITION.
    METHODS constructor IMPORTING iv_name TYPE string iv_planetype TYPE saplane-planetype iv_seats TYPE i
    RAISING cx_s4d400_wrong_plane.
    METHODS: get_mv_seats RETURNING value(r_result) TYPE i.

  PRIVATE SECTION.
    DATA: mv_seats TYPE i.

ENDCLASS.

CLASS lcl_passenger_plane IMPLEMENTATION.

  METHOD constructor.

    super->constructor( iv_name = iv_name iv_planetype = iv_planetype ).
    mv_seats = iv_seats.
  ENDMETHOD.

  METHOD get_attributes.
    super->get_attributes( IMPORTING et_attributes = et_attributes ).
    et_attributes = VALUE #( BASE et_attributes ( attribute = 'SEATS' value = mv_seats ) ).
  ENDMETHOD.



  METHOD get_mv_seats.
    r_result = me->mv_seats.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_cargo_plane DEFINITION INHERITING FROM zcl_michael.
  PUBLIC SECTION.
    METHODS get_attributes REDEFINITION.
    METHODS constructor IMPORTING iv_name TYPE string iv_planetype TYPE saplane-planetype iv_weight TYPE i
    RAISING cx_s4d400_wrong_plane.
    METHODS: get_mv_weight RETURNING value(r_result) TYPE i.


  PRIVATE SECTION.
    DATA: mv_weight TYPE i.
ENDCLASS.

CLASS lcl_cargo_plane IMPLEMENTATION.

  METHOD get_attributes.
    et_attributes = VALUE #(
      (  attribute = 'NAME' value = mv_name )
      (  attribute = 'PLANETYPE' value = mv_planetype )
      (  attribute = 'WEIGHT' value = mv_weight )
   ).
  ENDMETHOD.

  METHOD constructor.

    super->constructor( iv_name = iv_name iv_planetype = iv_planetype ).
    mv_weight = iv_weight.

  ENDMETHOD.



  METHOD get_mv_weight.
    r_result = me->mv_weight.
  ENDMETHOD.

ENDCLASS.
CLASS lcl_carrier DEFINITION.
  PUBLIC SECTION.
    TYPES: tt_planetab TYPE STANDARD TABLE OF REF TO zcl_michael WITH EMPTY KEY.
    METHODS: add_plane IMPORTING io_plane TYPE REF TO zcl_michael,
      get_planes RETURNING VALUE(rt_planes) TYPE tt_planetab,
      get_highest_cargo_weight returning value(rv_weight) type i.
  PRIVATE SECTION.
    DATA mt_planes TYPE tt_planetab.

ENDCLASS..
CLASS lcl_carrier IMPLEMENTATION.
  METHOD add_plane.
    mt_planes = VALUE #(  BASE mt_planes (  io_plane ) ).
  ENDMETHOD..
  METHOD get_planes.
    rt_planes = mt_planes.
  ENDMETHOD.

  METHOD get_highest_cargo_weight.
    data:      lo_cargo_plane type REF TO lcl_cargo_plane.
    loop at mt_planes into data(lo_plane).
        if lo_plane is INSTANCE OF lcl_cargo_plane.
            lo_cargo_plane = cast #( lo_plane ).
            if lo_cargo_plane->get_mv_weight( ) > rv_weight.
                rv_weight = lo_cargo_plane->get_mv_weight(  ).
            endif.
        endif.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.


START-OF-SELECTION.


  DATA(go_carrier) = NEW lcl_carrier(  ).

  TRY.
      go_carrier->add_plane(   NEW zcl_michael(  iv_name = 'Plane 1' iv_planetype = 'A320-200' ) ) .
    CATCH cx_s4d400_wrong_plane.
  ENDTRY.
  TRY.
      go_carrier->add_plane(   NEW zcl_michael(  iv_name = 'Plane 2' iv_planetype = '747' ) ) .
    CATCH cx_s4d400_wrong_plane.
  ENDTRY.

  TRY.
      go_carrier->add_plane(   NEW lcl_passenger_plane(  iv_name = 'Passenger 1' iv_planetype = 'A320-200' iv_seats = 500 ) ) .
    CATCH cx_s4d400_wrong_plane.
  ENDTRY.
  TRY.
      go_carrier->add_plane(   NEW lcl_cargo_plane(  iv_name = 'Cargo 1' iv_planetype = 'A320-200' iv_weight = 300 ) ) .
    CATCH cx_s4d400_wrong_plane.
  ENDTRY.
  TRY.
      go_carrier->add_plane(   NEW lcl_cargo_plane(  iv_name = 'Cargo 2' iv_planetype = 'A321-200' iv_weight = 200 ) ) .
    CATCH cx_s4d400_wrong_plane.
  ENDTRY.

*  TRY.
*      gt_airplanes = VALUE #( BASE gt_airplanes (  NEW zcl_michael( iv_name = 'Plane 1' iv_planetype = 'A320' ) ) ).
*    CATCH cx_s4d400_wrong_plane.
*  ENDTRY.
*  TRY.
*      gt_airplanes = VALUE #( BASE gt_airplanes (  NEW zcl_michael( iv_name = 'Plane 2' iv_planetype = 'A320-200' ) ) ).
*    CATCH cx_s4d400_wrong_plane.
*  ENDTRY.
*  TRY.
*      gt_airplanes = VALUE #( BASE gt_airplanes (  NEW zcl_michael( iv_name = 'Plane 3' iv_planetype = 'A380-800' ) ) ).
*    CATCH cx_s4d400_wrong_plane.
*  ENDTRY.
*  TRY.
*      gt_airplanes = VALUE #( BASE gt_airplanes (  NEW zcl_michael(  iv_name = 'Plane 4' iv_planetype = '747') ) ).
*    CATCH cx_s4d400_wrong_plane.
*  ENDTRY.
  DATA(gt_airplanes) = go_carrier->get_planes(  ).

  LOOP AT gt_airplanes INTO DATA(go_airplane).
    go_airplane->get_attributes(  IMPORTING et_attributes = DATA(gt_attributes) ).
    DATA gt_output LIKE gt_attributes.
    gt_output = CORRESPONDING #( BASE ( gt_output ) gt_attributes ).
  ENDLOOP.
  "cl_s4d_output=>display_string( |Highest cargo weight {  go_carrier->get_highest_cargo_weight(  ) }| ).
  gt_output = value #(  base gt_output  ( attribute = 'highest cargo weight' value = go_carrier->get_highest_cargo_weight(  ) ) ).
  cl_s4d_output=>display_table(  gt_output ).
