*Macro to read in all data sets and forms;
%macro ReadData (Form); 
data Student&Form (keep = ID ans qnumber Form) Key&Form (keep = ID ans qnumber Form);
	infile "/home/paxonfischer1/Homework/SAS 224/Midterm Files/Form &Form.1.csv" delimiter = "," missover;
	input ID $ (q1-q150) ($);
	Form = "&Form";
	array q{150} $ q1-q150;
	do qnumber = 1 to 150;
		ans = q{qnumber};
		if ID = "&Form.&Form.&Form.&Form.&.KEY" then output Key&Form;
		else output Student&Form;
	end;
run;

data Domains&Form;
	infile "/home/paxonfischer1/Homework/SAS 224/Midterm Files/Domains Form &Form..csv" delimiter = "," firstobs = 2;
	input ItemId $ domain :$33. dnumber qnumber;
run;

data key&Form;
set key&Form;
rename ans = correct;
run;

proc sql noprint;
	create table Scores&Form as
	select Student&Form..ID, Student&Form..qnumber, ans, correct, Student&Form..Form,
		case when ans=correct then 1 else 0 end as Score
	from Student&Form, Key&Form
	where Student&Form..qnumber = Key&Form..qnumber
	;
quit;

proc sort data=Scores&Form;
by qnumber;
run;
proc sort data=Domains&Form;
by qnumber;
run;
data ScoresDomains&Form (drop = correct ans);
	merge Domains&Form Scores&Form;
	by qnumber;
run;

%Mend ReadData;
%ReadData(A);
%ReadData(B);
%ReadData(C);
%ReadData(D);

*Concatonate all forms into one data set;
data report;
set ScoresDomainsA ScoresDomainsB ScoresDomainsC ScoresDomainsD;
run;

*Means statments;
proc sort data=report;
by ID;
run;

proc means data = report mean sum noprint;
var Score;
by ID Form;
class dnumber;
output out=calculation mean=Mean sum=Sum;
run;

proc sort data = calculation;
by ID;
where ID ^= " ";
run;

data AC1;
retain Form op os ds1-ds5 dp1-dp5;
array scr{*} op os dp1 ds1 dp2 ds2 dp3 ds3 dp4 ds4 dp5 ds5;
set calculation;
by ID;
if first.ID then ind=0;
ind+1;
scr[ind]=Mean;
ind+1;
scr[ind]=Sum;
if last.ID then output;
run;

data AC1new;
set AC1 (rename=(ID=old));
ID = input(old,4.0);
format op dp1-dp5 percent7.0;
keep ID Form os op ds1-ds5 dp1-dp5;
run;

proc sort data=AC1new
	out=studentreport1;
	by ID;
run;

proc sql;
	create table OverallPercentages as
	select mean(dp1) as dp1 format percent7.0, 
	mean(dp2) as dp2 format percent7.0,
	mean(dp3) as dp3 format percent7.0,
	mean(dp4) as dp4 format percent7.0,
	mean(dp5) as dp5 format percent7.0,
	mean(op) as op format percent7.0 from studentreport1;
quit;

*Create Student Report;
ods pdf file = "/home/paxonfischer1/Homework/SAS 224/Midterm Files/Final Report.pdf";
options orientation=landscape;
title "Student Exam Grading Report";
*Section 1;
proc print data = studentreport1 noobs label;
	var ID Form ds1 dp1 ds2 dp2 ds3 dp3 ds4 dp4 ds5 dp5 os op;
	label ID = "Student ID" Form = "Exam Form" 
	os = "Overall Score" op = "Overall Percentage"
	ds1 = "Domain Score 1" ds2 = "Domain Score 2" 
	ds3 = "Domain Score 3" ds4 = "Domain Score 4" 
	ds5 = "Domain Score 5" dp1 = "Domain Percentage 1"
	dp2 = "Domain Percentage 2" dp3 = "Domain Percentage 3" 
	dp4 = "Domain Percentage 4" dp5 = "Domain Percentage 5";   
	title2 "Student Scores";
run;
*Section 2;
proc report data = OverallPercentages;
	define dp1 / display "Assessment of Performance Needs";
	define dp2 / display "Program Design and Development";
	define dp3 / display "Athlete Education and Training";
	define dp4 / display "Athlete Testing and Evaluation";
	define dp5 / display "Organizational and Administrative Responsibilities";
	define op / display "Overal Percentage";
	title2 "Average Scores by Domain";
run;
ods pdf close;