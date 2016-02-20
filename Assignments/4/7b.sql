set serveroutput on
DECLARE
thisBranchName library_branch.branch_name%TYPE;
BEGIN
thisBranchName:='Pratt library';
BorrowedLast30Days(thisBranchName);
END;
.
RUN;
