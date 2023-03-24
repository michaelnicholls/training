*&---------------------------------------------------------------------*
*& Report z_calc00
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_calc99.


data gt_airplanes type table of ref  to zcl_michael.

gt_airplanes = value #( base gt_airplanes (
    new zcl_michael( iv_name = 'Plane1' iv_planetype = '747-400' ) ) ).
gt_airplanes = value #( base gt_airplanes
( new zcl_michael( iv_name = 'Plane2' iv_planetype = '747-400'  ) ) ).
gt_airplanes = value #( base gt_airplanes
( new zcl_michael( iv_name = 'Plane3' iv_planetype = '747-400'  ) ) ).




 zcl_michael=>get_n_o_airplanes( IMPORTING ev_number = data(nn)  ).

loop at gt_airplanes into data(gs_airplane).
    gs_airplane->get_attributes( IMPORTING et_attributes = data(gt_attributes) ).
    data gt_output like gt_attributes.
    gt_output = CORRESPONDING #( base ( gt_output ) gt_attributes ).
endloop.
cl_s4d_output=>display_table(  gt_output ).
DATA: gv_result TYPE p LENGTH 16 DECIMALS 2.
data(iv_num1) = nn.
data(iv_num2) = nn.
data(iv_op) = '+'.
*cl_s4d_input=>get_calc_input( IMPORTING ev_num1 = DATA(iv_num1)
*                    ev_num2 = DATA(iv_num2)
*                    ev_op = DATA(iv_op) )    .

CASE iv_op.
  WHEN '+'.
    gv_result = iv_num1 + iv_num2.
  WHEN '-'.
    gv_result = iv_num1 - iv_num2.
  WHEN '*'.
    gv_result = iv_num1 * iv_num2.
  WHEN '/'.
    IF iv_num2 = 0.
      DATA(gv_error) = | { TEXT-dbz } |.
    ELSE.

      gv_result = iv_num1 / iv_num2.
    ENDIF.
  WHEN '%'.
    CALL FUNCTION 'S4D400_CALCULATE_PERCENTAGE'
      EXPORTING
        iv_int1          = iv_num1
        iv_int2          = iv_num2

      IMPORTING
        ev_result        = gv_result
      EXCEPTIONS
        division_by_zero = 1
        today_is_monday = 2.
    IF sy-subrc > 0.
      gv_error = TEXT-poz.
    ENDIF.
  WHEN OTHERS.

    gv_error = |{  TEXT-bop } {  iv_op }|.
ENDCASE.
IF gv_error IS INITIAL.

  cl_s4d_output=>display_string( |{ TEXT-res } {  gv_result } |  ).
ELSE.
  cl_s4d_output=>display_string( gv_Error ).
ENDIF.

WRITE: gv_result.
