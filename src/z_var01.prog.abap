*&---------------------------------------------------------------------*
*& Report z_var01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_var01.

data: my_variable type string value 'hello',
      my_num type i value 12,
      i type i.

do my_num times.
   i = sy-index + 4.
enddo.

cl_demo_input=>request(  CHANGING field = my_variable ).
*cl_s4d_input=>get_text( importing ev_text = my_variable  ).

cl_s4d_output=>display_string( | welcome { my_variable  } | ).
