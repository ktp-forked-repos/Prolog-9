%%%%%%%%%%%%%%%%%%% Project 2 %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%% Ex. 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


:-lib(ic).
:-lib(ic_global).
:-lib(lists).				
:-lib(branch_and_bound).
:-lib(ic_cumulative).
:-import maxlist/2 from ic_global.


%%% course(Course,Duration,Students)

course(c1,150,120).
course(c2,180,200).
course(c3,230,190).
course(c4,130,250).
course(c5,210,70).


/*Οι πληροφορίες για τα μαθήματα γράφτηκαν με τη μορφή γεγονότων,
οπότε χρησιμοποιώ το κατηγόρημα findall/3 για να συλλέξω στις
λίστες Courses,Durations,Students τις αντίστοιχες πληροφορίες*/


/*Αφού υπάρχουν N μαθήματα, θα δημιουργήσω Ν μεταβλητές έναρξης,
μία για κάθε μάθημα, με το κατηγόρημα lenght/2*/


/*Το StartsAt #:: 0..inf εξασφαλίζει ότι οι χρόνοι έναρξης εξέτασης
του κάθε μαθήματος θα είναι >= 0, αφού τη χρονική στιγμή 0 ξεκινά
η εξέταση του κάθε μαθήματος*/

/*Ο χρόνος εξέτασης όλων των μαθημάτων AllExamined είναι ο χρόνος
λήξης της εξέτασης του τελευταίου μαθήματος*/

/*Η αίθουσα είναι ο μόνος πόρος της άσκησης και έχει χωρητικότητα
400 φοιτητές. Η εξέταση του κάθε μαθήματος καταναλώνει μέρος της 
αίθουσας ανάλογα με το σύνολο των φοιτητών που εξετάζονται σε κάθε
μάθημα, επομένως μπορούμε να εξασφαλίσουμε ότι ο μέγιστος αριθμός 
φοιτητών στην αίθουσα θα είναι 400 με το cumulative*/



exams(StartsAt,AllExamined):-

	findall(C,course(C,_,_),Courses),
	findall(D,course(_,D,_),Durations),
	findall(S,course(_,_,S),Students),

	length(Courses,N),
	length(StartsAt,N),

	StartsAt #:: 0..inf,

	start_end_times(StartsAt,Durations,EndsAt),
	
	maxlist(EndsAt,AllExamined),
	cumulative(StartsAt,Durations,Students,400),
	

	bb_min(labeling(StartsAt),AllExamined, bb_options{timeout:60}).


/*Έχω τους χρόνους έναρξης στη λίστα StartsAt, οπότε μπορώ
να χρησιμοποιήσω αναδρομή για να βρω χρόνους έναρξης και λήξης
της εξέτασης του κάθε μαθήματος*/

/*Χρησιμοποιώ το αναδρομικό κατηγόρημα start_end_times(StartsAt,
Durations,EndsAt), όπου StartsAt οι χρόνοι έναρξης, Durations
μία λίστα με τις διάρκειες εξέτασης του κάθε μαθήματος και 
EndsAt μία λίστα με τους χρόνους λήξης κάθε εξέτασης*/


/*Για κάθε μάθημα υπάρχει ένας περιορισμός Start+Duration #= End
όπου Start ο χρόνος έναρξης της εξέτασης ενός μαθήματος και End ο 
χρόνος λήξης*/


start_end_times([],[],[]).

start_end_times([Start|StartsAt],[Dur|Durations], [End|EndsAt]):-
	Start + Dur #= End,
	start_end_times(StartsAt,Durations,EndsAt).

	
	
/*Παραδείγματα Εκτέλεσης*/
/*?- exams(StartsAt, AllExamined).
StartsAt = [0, 0, 150, 380, 180]
AllExamined = 510
Yes (60.00s cpu)*/

