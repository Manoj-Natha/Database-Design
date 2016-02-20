create or replace procedure BorrowedLast30Days(bname IN VARCHAR) AS
thisBookLoan Book_loans%ROWTYPE;
thisBookName BOOK.TITLE%TYPE;
thisBorrowerName borrower.name%TYPE;
thisBorrowerPno borrower.phone%TYPE;	
z number;
CURSOR AllBookloans IS
SELECT * FROM Book_loans
where Return_date is null AND Branch_id IN 
(SELECT Branch_id FROM Library_branch where branch_name=bname);
BEGIN
dbms_output.put_line('bname:= '|| bname);
OPEN AllBookloans;
LOOP
FETCH AllBookloans INTO thisBookloan;
EXIT WHEN (AllBookloans%NOTFOUND);
    dbms_output.put_line('Z:= ');
    Z:=FLOOR(SYSDATE-thisBookloan.date_out);
    dbms_output.put_line('Z:= '|| Z);
   IF Z<31 THEN
    select title into thisBookName from book where BOOK_ID=thisBookloan.book_id;
    select name into thisBorrowerName from borrower where card_no=thisBookloan.card_no;
    select phone into thisBorrowerPno from borrower where card_no=thisBookloan.card_no;    
	dbms_output.put_line(' ');
	dbms_output.put_line('Book Name : '|| thisBookName);
    dbms_output.put_line('Borrower Name : '|| thisBorrowerName);     
	dbms_output.put_line('Borrower Phone Number : '|| thisBorrowerPno);     
   END IF;
END LOOP;
CLOSE AllBookloans;
END;
