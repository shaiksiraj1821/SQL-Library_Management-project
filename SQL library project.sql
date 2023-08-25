create database library;
use library;

create table tbl_publisher (
publisher_PublisherName varchar(50) primary key,
publisher_PublisherAddress varchar(50),
publisher_PublisherPhone varchar(25));

create table tbl_borrower (
borrower_CardNo int primary key auto_increment,
borrower_BorrowerName varchar(50) not null,
borrower_BorrowerAddress varchar(50) not null,
borrower_BorrowerPhone varchar(25) ); 

create table tbl_book (
book_BookID int primary key auto_increment,
book_Title varchar(50) not null,
book_PublisherName varchar(50) not null,
foreign key (book_PublisherName)
references tbl_publisher(publisher_PublisherName));

create table tbl_book_authors (
book_authors_AuthorID int primary key auto_increment,
book_authors_BookID int,
book_suthors_AuthorName varchar(50) not null,
foreign key (book_authors_BookID)
references tbl_book(book_BookID));

create table tbl_library_branch (
library_branch_BranchID int primary key auto_increment,
library_branch_BranchName varchar(50),
library_branch_BranchAddress varchar(50)); 

create table tbl_book_loans (
book_loans_LoansID int primary key auto_increment,
book_loans_BookID int,
book_loans_BranchID int,
book_loans_CardNo int,
book_loans_DateOut Date,
book_loans_DueDate date,
foreign key (book_loans_BookID)
references tbl_book(book_BookID)on update cascade,
foreign key (book_loans_BranchID)
references tbl_library_branch(library_branch_BranchID) on update cascade,
foreign key (book_loans_CardNo)
references tbl_borrower(borrower_CardNo)on update cascade );

create table tbl_book_copies (
book_copies_CopiesID int primary key auto_increment,
book_copies_BookID int,
book_copies_BranchID int,
book_copies_No_Of_Copies int,
 foreign key (book_copies_BookID) 
 references tbl_book(book_BookID) on update cascade,
 foreign key (book_copies_BranchID)
 references tbl_library_branch(library_branch_BranchID)on update cascade );

select * from tbl_publisher;
select * from tbl_borrower;
select * from tbl_book;
select * from tbl_book_authors;
select * from tbl_library_branch;
select * from tbl_book_loans;
select * from tbl_book_copies;

# 1. How many copies of the book titled "The Lost Tribe" are owned by the library
# branch whose name is "Sharpstown"?

SELECT bc.book_copies_No_Of_Copies
FROM tbl_book_copies bc
JOIN tbl_book b ON bc.book_copies_BookID = b.book_BookID
JOIN tbl_library_branch lb ON bc.book_copies_BranchID = lb.library_branch_BranchID
WHERE b.book_Title = 'The Lost Tribe' AND lb.library_branch_BranchName = 'Sharpstown';

# 2. How many copies of the book titled "The Lost Tribe" are owned by each library
# branch?

SELECT lb.library_branch_BranchName, bc.book_copies_No_Of_Copies
FROM tbl_book_copies bc
JOIN tbl_book b ON bc.book_copies_BookID = b.book_BookID
JOIN tbl_library_branch lb ON bc.book_copies_BranchID = lb.library_branch_BranchID
WHERE b.book_Title = 'The Lost Tribe';

# 3. Retrieve the names of all borrowers who do not have any books checked out.
SELECT borrower_BorrowerName
FROM tbl_borrower
WHERE borrower_CardNo NOT IN (SELECT book_loans_CardNo FROM tbl_book_loans);

# 4. For each book that is loaned out from the "Sharpstown" branch and whose
# DueDate is 2/3/18, retrieve the book title, the borrower's name, and the
# borrower's address

SELECT b.book_Title, br.borrower_BorrowerName, br.borrower_BorrowerAddress
FROM tbl_book_loans bl
JOIN tbl_book b ON bl.book_loans_BookID = b.book_BookID
JOIN tbl_borrower br ON bl.book_loans_CardNo = br.borrower_CardNo
JOIN tbl_library_branch lb ON bl.book_loans_BranchID = lb.library_branch_BranchID
WHERE lb.library_branch_BranchName = 'Sharpstown' AND DATE(bl.book_loans_DueDate) = '2018-02-03';

# 5. For each library branch, retrieve the branch name and the total number of books
# loaned out from that branch.

SELECT lb.library_branch_BranchName, COUNT(bl.book_loans_BookID) AS TotalBooksLoaned
FROM tbl_library_branch lb
LEFT JOIN tbl_book_loans bl ON lb.library_branch_BranchID = bl.book_loans_BranchID
GROUP BY lb.library_branch_BranchName;

# 6. Retrieve the names, addresses, and number of books checked out for all
# borrowers who have more than five books checked out.
SELECT br.borrower_BorrowerName, br.borrower_BorrowerAddress, COUNT(bl.book_loans_BookID) AS NumBooksCheckedOut
FROM tbl_borrower br
JOIN tbl_book_loans bl ON br.borrower_CardNo = bl.book_loans_CardNo
GROUP BY br.borrower_BorrowerName, br.borrower_BorrowerAddress
HAVING NumBooksCheckedOut > 5;

# 7. For each book authored by "Stephen King", retrieve the title and the number of
# copies owned by the library branch whose name is "Central".
SELECT b.book_Title, bc.book_copies_No_Of_Copies
FROM tbl_book b
JOIN tbl_book_authors ba ON b.book_BookID = ba.book_authors_BookID
JOIN tbl_book_copies bc ON b.book_BookID = bc.book_copies_BookID
JOIN tbl_library_branch lb ON bc.book_copies_BranchID = lb.library_branch_BranchID
WHERE ba.book_suthors_AuthorName = 'Stephen King' AND lb.library_branch_BranchName = 'Central';



















