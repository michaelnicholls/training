*&---------------------------------------------------------------------*
*& Report z_selectm_00
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_selectm_00.
TRY.
    cl_s4d_input=>get_connection(
      IMPORTING
        ev_airline   =  DATA(airline) " use LH
        ev_flight_no = DATA(flightno) " use 0400
    ""    ev_date      =  DATA(fldate) " use 31.12.2022
    ).

    SELECT  FROM sflight FIELDS carrid, connid, planetype, fldate, seatsmax, seatsocc
    WHERE carrid = @airline
    AND connid = @flightno
    AND fldate GE @sy-datum
    INTO TABLE @DATA(gt_flights).

    IF sy-subrc = 0.
      cl_s4d_output=>display_structure(  gt_flights ).
    ELSE.
      cl_s4d_output=>display_string(  'No records found - please check your selection criteria' ).
    ENDIF.
  CATCH cx_s4d_no_structure .
    cl_s4d_output=>display_string( | not a structure  - sack the developer - they should have found this!| ).

  CATCH cx_root INTO DATA(error_details).

  data: include_name type SYREPID, program_name type syrepid, line_num type i.
        error_details->get_source_position( IMPORTING include_name = include_name  program_name = program_name source_line = line_num ).

    cl_s4d_output=>display_string( |Error: { program_name } { include_name } {  line_num } - please contact the help desk| ).
ENDTRY.
