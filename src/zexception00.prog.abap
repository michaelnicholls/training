*&---------------------------------------------------------------------*
*& Report zexception00
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zexception00.

cl_s4d_input=>get_division_input(
    IMPORTING ev_num1 = DATA(iv_num1)
        ev_num2 = DATA(iv_num2)
        ).

        do 10 times.
        "sy-index.
        enddo.
TRY .
    cl_s4d400_calculator=>divide(  EXPORTING iv_int1 = iv_num1
           iv_int2 = iv_num2
           IMPORTING ev_result = DATA(xx_result) ).
    cl_s4d_output=>display_string(  |The result of dividing {  iv_num1 } by {  iv_num2 } is {  xx_result }| ).
  CATCH cx_s4d400_zerodivide.
    cl_s4d_output=>display_string(  |No division by zero allowed | ).
    catch cx_root.
        cl_s4d_output=>display_string(  |Some other error | ).
ENDTRY.
