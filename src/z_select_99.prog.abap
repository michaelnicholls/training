*&---------------------------------------------------------------------*
*& Report z_select_00
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_select_99.

cl_s4d_input=>get_flight(
  IMPORTING
    ev_airline   =  DATA(airline) " use LH
    ev_flight_no = DATA(flightno) " use 0400
    ev_date      =  DATA(fldate) " use 31.12.2022
).

SELECT SINGLE FROM sflight FIELDS carrid, connid, fldate, seatsmax, seatsocc
WHERE carrid = @airline
AND connid = @flightno
AND fldate = @fldate
INTO @DATA(gs_flight).

IF sy-subrc = 0.
  cl_s4d_output=>display_structure(  gs_flight ).
ELSE.
  cl_s4d_output=>display_string(  'No record found' ).
ENDIF.
