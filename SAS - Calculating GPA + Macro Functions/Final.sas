*Provides a format for class, relating to GPA weight, and Standing which will be calculated by total number of credits;
proc format;
	value $gpa
	"A" = 4.0
	"A-" = 3.7
	"B+" = 3.4
	"B" = 3.0
	"B-" = 2.7
	"C+" = 2.4
	"C" = 2.0
	"C-" = 1.7
	"D+" = 1.4
	"D" = 1.0
	"D-" = .7
	"E" = 0
	"UW" = 0
	"IE" = 0
	"WE" = 0
	other = .
	;
	value standing
	0 - 29.9 = "Freshman"
	30 - 59.9 = "Sophomore"
	60 - 89.9 = "Junior"
	90 - HIGH = "Senior"
	;
run;

*Data used for Report 1, 2, and part of Report 3;
data grades;
infile "/home/paxonfischer1/Homework/SAS 224/Final Files/*.txt" delimiter="@";
input id $ semester $ class $10. credits grade $;
letterGPA = put(grade, $gpa.)*credits;
 *To distinguish Earned and Graded Credit;
 if substr(grade, 1, 1) in ("A" "B" "C" "D" "P") then EarnedCredit = 1; else EarnedCredit = 0;
 if letterGPA = . then GradedCredit = 0; else GradedCredit = 1;
 
 *Number of letter grades;
 if substr(grade, 1, 1) = "A" then A = 1; else A = 0;
 if substr(grade, 1, 1) = "B" then B = 1; else B = 0;
 if substr(grade, 1, 1) = "C" then C = 1; else C = 0;
 if substr(grade, 1, 1) = "D" then D = 1; else D = 0;
 if substr(grade, 1, 1) = "W" then W = 1; else W = 0;
 if substr(grade, 1, 2) in ("E" "UW" "WE" "IE") then E = 1; else E = 0;
 if substr(grade, 1, 2) in ("NS" "I" "T") then S = 1; else S = 0;
run;

*Subset of data used for finding repeats;
proc sort data = grades;
	by id class;
run;

data grades2 grades2junk; 
	set grades;
	by id class;
	if last.class then output grades2;
	else output grades2junk; 
run;

proc sql noprint;
	create table repeats as
	select id, count(distinct class) as repeats
	from grades2junk 
	group by id
;
quit;

*Used for Report 2 and 4 - Math and Stat classes with Repeats;
data math_stat;
set grades;
where substr(class, 1, 4) = "STAT" or substr(class, 1, 4) = "MATH";
run;

proc sort data = math_stat;
	by id class;
run;

data math_stat2 math_stat2junk;
	set math_stat;
	by id class;
	if last.class then output math_stat2;
	else output math_stat2junk;
run;

proc sql noprint;
	create table repeats2 as
	select id, count(distinct class) as repeats
	from math_stat2junk
	group by id
;
quit;

*Macro will run two different data sets. One for all classes and students, and the second for Math and Stat Classes;
%Macro Report(name);

proc sql; 
	create table creditsGPA as
	select *, sum(GradedCredit*credits) as GradedCreds
	from &name
	group by semester, id
	;
quit;

proc sort data = &name;
by semester id;
run;

proc sort data = creditsGPA;
by semester id;
run;

data combined;
merge &name creditsGPA;
by semester id;
run;

*Starts to calculate semester gpa, as well as weights per semester to get Earned and Graded Credits;
proc sql;
	create table SemesterGPA as
	select *, sum(letterGPA)/GradedCreds as semesterGPA, sum(letterGPA) as weight, sum(EarnedCredit*credits) as EarnedCreds
	from combined
	group by semester, id 
	;
quit;
*Calculates the number of letter grades per student;
proc sql; 
	create table SemesterGPA2 as
	select *, sum(A) as SumA, sum(B) as SumB, sum(C) as SumC, sum(D) as SumD, sum(W) as SumW, 
	sum(E) as SumE, sum(S) as SumS
	from SemesterGPA
	group by id
	;
quit;

proc sort data = SemesterGPA2;
	by semester id;
run;

*Condenses our table to output each Semester for the students;
data condensed;
	set SemesterGPA2 (keep = id semester semesterGPA weight EarnedCreds GradedCreds SumA SumB SumC SumD SumW SumE SumS);
	by semester id;
	if first.semester or first.id then output; 
run;

proc sort data = condensed;
by id;
run;

*Condenses the data even further to calculate Cumulative GPAs for each semester, as well as the cumulative graded and earned credits;
data condensed2; 
	set condensed;
	by id;
	if first.id then cumGPA = 0;
	cumGPA + weight;
	if first.id then cumGraded = 0;
	cumGraded + GradedCreds;
	if first.id then cumEarned = 0;
	cumEarned + EarnedCreds;
run;

proc sort data = condensed2;
 	by semester id;
run;

*Throws in Standing per semester and lastly calculates cummulative GPA per semester;
data ultimate;
	set condensed2;
	standing = put(cumEarned, standing.);
	by semester id;
	cumulativeGPA = cumGPA/cumGraded;
run;

proc sort data = ultimate;
	by id semester;
run; 

*Extra step for finding overall portions of the reports;
data ultimate3 (keep = id overallEarned overallGraded overallGPA);
	set ultimate;
	by id;
	if last.id then output;
	rename cumulativeGPA = overallGPA;
	rename cumEarned = overallEarned;
	rename cumGraded = overallGraded;
run;

proc sort data = ultimate;
by id;
run;
proc sort data = ultimate3;
by id;
run;

%Mend;

*Load in grades2 to Macro - Used for Report 1 and 3, and part of Report 2;
%Report(grades2);

*Report 1 dataset;
data report1;
	merge ultimate ultimate3 repeats;
	by id;
	if repeats = . then repeats = 0;
run;

*This dataset renames variables to be combined into Report 2 for Math Stat Classes later;
data overall_report1 (keep = id overallGPA2 repeats2 overallGraded2 overallEarned2 sumA2 sumB2 sumC2 sumD2 sumE2 sumW2);
set report1;
by id;
if last.id then output;
rename overallGPA = overallGPA2;
rename repeats = repeats2;
rename overallGraded = overallGraded2;
rename overallEarned = overallEarned2;
rename sumA = sumA2;
rename sumB = sumB2;
rename sumC = sumC2;
rename sumD = sumD2;
rename sumE = sumE2;
rename sumW = sumW2;
run;

*Taking our last data output to later be used for Report 3: 90th percentile;
data part3;
	set ultimate3;
	where overallEarned > 60 and overallEarned < 130;
run;

proc sort data = part3;
	by descending overallGPA;
run;

*Finds the 90th percentile after a certain number of sorted students by GPA;
proc sql noprint;
	select round(count(id)*.1) into: mymac
	from part3
	;
quit;

%put &mymac;


*HTML beginning to get all reports into one file;
ods html file = "/home/paxonfischer1/Homework/SAS 224/Final Reports.html";
options orientation=landscape;
*Takes data set of id's by semester for Report 1;
proc report data = report1;
columns id semester semesterGPA cumulativeGPA EarnedCreds GradedCreds standing overallEarned overallGraded 
overallGPA SumA SumB SumC SumD SumE SumW repeats;
title "Report 1: Semester Progress and Overall GPA and Classes";
define id / display "Student ID";
define semester / display "Semester";
define semesterGPA / display format = 4.2 "Semester GPA";
define cumulativeGPA / display format = 4.2 "Cummulative GPA";
define EarnedCreds / display "Earned Credits";
define GradedCreds / display "Graded Credits";
define standing / display "Class Standing";
define overallEarned / display "Overall Earned Credits";
define overallGraded / display "Overall Graded Credits";
define overallGPA / display format = 4.2 "Overall GPA";
define SumA / display "A's";
define SumB / display "B's";
define SumC / display "C's";
define SumD / display "D's";
define SumW / display "W's";
define SumE / display "E's";
define repeats / display "Repeated Classes";
run;

*Uses Data set substted above;
%Report(math_stat2);

*This dataset will be merged with our report 1 to show differences of Total and Major classes;
data math (keep = id overallGPA overallEarned overallGraded repeats sumA sumB sumC sumD sumE sumW);
	merge ultimate ultimate3 repeats2;
	by id;
	if last.id then output;
	if repeats = . then repeats = 0;
run;

*Merging for report2;
data report2;
	merge overall_report1 math;
	by id;
run;

*Print Report 2 which compares Total info and Major info for each student;
proc report data = report2;
columns id overallEarned2 overallGraded2 overallGPA2 sumA2 sumB2 sumC2 sumD2 sumE2 sumW2 repeats2 
overallEarned overallGraded overallGPA SumA SumB SumC SumD SumE SumW repeats;
title "Report 2: Math and Stat Classes";
define id / display "Student ID";
define overallEarned2 / display "Earned Credits";
define overallGraded2 / display "Graded Credits";
define overallGPA2 / display format = 4.2 "Overall GPA";
define SumA2 / display "A's";
define SumB2 / display "B's";
define SumC2 / display "C's";
define SumD2 / display "D's";
define SumW2 / display "W's";
define SumE2 / display "E's";
define repeats2 / display "Repeated Classes";
define overallEarned / display "Earned Credits in Major";
define overallGraded / display "Graded Credits in Major";
define overallGPA / display format = 4.2 "Overall GPA in Major";
define SumA / display "A's in Major";
define SumB / display "B's in Major";
define SumC / display "C's in Major";
define SumD / display "D's in Major";
define SumW / display "W's in Major";
define SumE / display "E's in Major";
define repeats / display "Repeated Classes in Major";
run;

*Used for Report 4 and finding 90th percentile of people with 20 or more credits in Math-Stat Major;
data part4;
	set ultimate3;
	where overallGraded > 20;
run;

proc sort data = part4;
	by descending overallGPA;
run;

proc sql noprint;
	select round(count(id)*.1) into: mymac2
	from part4
	;
quit;

%put &mymac2;

*Part 3;
title "Report 3: 90th Percentile of all Classes";
proc print data = part3 (obs = &mymac) label noobs; 
var id overallGPA;
label id = "ID" overallGPA = "Overall GPA";
run;

*Part 4;
title "Report 4: 90th Percentile of Stat and Math Classes";
proc print data = part4 (obs = &mymac2) label noobs; 
var id overallGPA;
label id = "ID" overallGPA = "Overall GPA";
run;
ods html close;