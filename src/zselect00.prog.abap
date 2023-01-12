*&---------------------------------------------------------------------*
*& Report zselect00
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zselect00.
data(searchname) = 'Michael'.

select  single from zmichael fields  firstname, lastname  where lastname = @searchname       into  @data(mi). "structure
" check sy-subrc now!

data(status1) = sy-subrc.

select  from zmichael fields  firstname, lastname where lastname = @searchname order by lastname into  @data(mi2). " structure
  " do something for each record read using mi2-xxx

  " check if accessing this record  is allowed!


endselect.
" check sy-subrc now!
data(status2) = sy-subrc.

select   from zmichael fields  firstname, lastname where lastname = @searchname order by lastname into table  @data(mi3). "internal table
" check sy-subrc now!
data(status3) = sy-subrc.

loop at mi3 into data(mi3_row).

" do something for each row of the internal table using mi3_row-xxx

" need to check security here...

endloop.


write: status1, status2, status3.
