*&---------------------------------------------------------------------*
*& Report zold
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zold.

"parameters: pa_int1 type i.

            data: aaa type string.

  data mytable type STANDARD TABLE OF string.

            write: 'Helo world'.

            data: a type i, b type i.

                  move b to a.

                  a = b.

            data: struc1 type sflight, struc2 type sflight.

                  struc1 = value #( carrid = 'rr' connid = '1234' ).

                  struc2 = value #( connid = '3333' ).

                  struc2 = value #( carrid = 'xx' ).

                  struc2 = value #( base struc2 connid = '7777' ).
        MOVE-CORRESPONDING struc2 to struc1.

                  uline.
