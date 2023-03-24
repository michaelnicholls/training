*&---------------------------------------------------------------------*
*& Report zstructure00
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zstructure99.
TYPES: BEGIN OF ts_complete,
         carrid    TYPE d400_struct_s1-carrid,
         connid    TYPE d400_struct_s1-connid,
         cityfrom  TYPE d400_struct_s1-cityfrom,
         cityto    TYPE d400_struct_s1-cityto,
         fldate   TYPE d400_s_flight-fldate,
         planetype TYPE d400_s_flight-planetype,
         seatsocc  TYPE d400_s_flight-seatsocc,
         seatsmax  TYPE d400_s_flight-seatsmax,
       END OF ts_complete.
DATA gs_conn TYPE z99_connection.
DATA: gs_complete TYPE ts_complete.


gs_conn = VALUE #(
carrid = 'LH'
connid = '0400'
cityfrom = 'FRANKFURT'
cityto  = 'NEW YORK'
 ).

TRY.
    cl_s4d400_flight_model=>get_next_flight(
       EXPORTING iv_carrid = gs_conn-carrid
               iv_connid = gs_conn-connid
               IMPORTING
               es_flight = DATA(gs_flight)
               ).
    gs_complete = CORRESPONDING #(  BASE (  gs_complete )  gs_conn ).
    gs_complete = CORRESPONDING #(  BASE (  gs_complete )  gs_flight ).
    cl_s4d_output=>display_structure(  iv_structure = gs_complete ).
  CATCH cx_s4d400_no_data.
    cl_s4d_output=>display_line(  text-nof ).
    catch cx_root.
    cl_s4d_output=>display_line(  text-oth ).

ENDTRY.
