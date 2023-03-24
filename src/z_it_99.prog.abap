*&---------------------------------------------------------------------*
*& Report z_it_00
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_it_99.

DATA: gt_connections TYPE z99_t_connections,

      gt_percentage  TYPE d400_t_percentage.
TRY.
    gt_connections =  VALUE #( BASE gt_connections   ( carrid = 'LH' connid = '0400' ) ).
    gt_connections =  VALUE #(  BASE gt_connections (  carrid = 'LH' connid = '0401' ) ).


    cl_s4d400_flight_model=>get_flights_for_connections(
      EXPORTING
        it_connections = gt_connections
     IMPORTING
        et_flights     = DATA(gt_flights)
    ).
    gt_percentage = CORRESPONDING #( gt_flights ).
    LOOP AT gt_percentage INTO DATA(gs_percentage).
      gt_percentage[  sy-tabix ]-percentage = gs_percentage-seatsocc * 100 / gs_percentage-seatsmax.

    ENDLOOP.
    SORT gt_percentage BY percentage DESCENDING.
    cl_s4d_output=>display_table(  gt_percentage ).
  CATCH cx_s4d400_no_data.
    cl_s4d_output=>display_string(  |No flights found| ).

  CATCH cx_root INTO DATA(gs_err).

    cl_s4d_output=>display_string(  |Some other error: { gs_err->get_text(  ) }| ).
ENDTRY..
