*&---------------------------------------------------------------------*
*& Report z_program00
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_program00.

" this is a comment

data: number_of_people type i,  a_floating type f,  my_string type string,
      char10 TYPE c length 10.

cl_s4d_output=>display_hello( ).
"cl_s4d_output=>display_string(  EXPORTING iv_text = |Hello| ).
