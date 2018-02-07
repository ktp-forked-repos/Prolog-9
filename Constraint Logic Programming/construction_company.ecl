%%%%%%%%%%%%%%%%%%% Ex. 3 %%%%%%%%%%%%%%%%%%%%%%%%%%%
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
:-use_module(library(ic_edge_finder)).



%%% EXEC 3

builders(a1,days(12)).
builders(a2,days(5)).
builders(a3,days(10)).
builders(a4,days(5)).
builders(a5,days(5)).
builders(a6,days(10)).
builders(a7,days(5)).

electricians(a1,10,days(10)).
electricians(a2,5,days(30)).
electricians(a3,7,days(20)).
electricians(a4,3,days(25)).
electricians(a5,3,days(40)).
electricians(a6,2,days(15)).
electricians(a7,1,days(25)).

plumbers(a1,4,days(8)).
plumbers(a2,3,days(11)).
plumbers(a3,2,days(18)).
plumbers(a4,5,days(14)).
plumbers(a5,3,days(14)).
plumbers(a6,4,days(13)).
plumbers(a7,3,days(9)).

finishers(a1,3,days(10)).
finishers(a2,4,days(25)).
finishers(a3,4,days(23)).
finishers(a4,6,days(10)).
finishers(a5,5,days(9)).
finishers(a6,4,days(3)).
finishers(a7,4,days(13)).



construction_plan(SBa1,Duration,Electricians,Plumbers,Finishers):-

	/*Συλλογή δεδομένων για τις διάρκειες*/
	collect_durations(BDurations,EDurations,PDurations,FDurations),
	
	
	/*Ορισμός χρόνων έναρξης όλων των εργασιών/όροφο σε λίστες*/
	StartBuilding = [SBa1,SBa2,SBa3,SBa4,SBa5,SBa6,SBa7],
	StartElectrical = [SEa1,SEa2,SEa3,SEa4,SEa5,SEa6,SEa7],
	StartPlumbing = [SPa1,SPa2,SPa3,SPa4,SPa5,SPa6,SPa7],
	StartFinishing = [SFa1,SFa2,SFa3,SFa4,SFa5,SFa6,SFa7],


	/*Ορισμός διάρκειας όλων των εργασιών/όροφο σε λίστες*/
	EDurations = [EDa1,EDa2,EDa3,EDa4,EDa5,EDa6,EDa7],
	PDurations = [PDa1,PDa2,PDa3,PDa4,PDa5,PDa6,PDa7],


	/*Ορισμός χρόνων λήξης όλων των εργασιών/όροφο σε λίστες*/
	EndBuilding = [EBa1,EBa2,EBa3,EBa4,EBa5,EBa6,EBa7],
	EndElectrical = [EEa1,EEa2,EEa3,EEa4,EEa5,EEa6,EEa7],
	EndPlumbing = [EPa1,EPa2,EPa3,EPa4,EPa5,EPa6,EPa7],
	EndFinishing = [_EFa1,_EFa2,_EFa3,_EFa4,_EFa5,_EFa6,_EFa7],

	
	/* Περιορισμοί που αφορούν τις εργασίες */
	/*Ορισμός πεδίου τιμών για τους χρόνους έναρξης/εργασία*/
	StartBuilding #:: 0..140,
	StartElectrical #:: 0..140,
	StartPlumbing #:: 0..140,
	StartFinishing #:: 0..140,

	
	/* Περιορισμοί για την κατασκευή ορόφων */
	/* Περιορισμοί ώστε οι όροφοι να χτίζονται με τη σειρά */
	EBa1 #=< SBa2,				
	EBa2 #=< SBa3,				
	EBa3 #=< SBa4,				
	EBa4 #=< SBa5,				
	EBa5 #=< SBa6,				
	EBa6 #=< SBa7,				

	/* Η κατασκεύη ενός ορόφου ξεκινά μετά το πέρας κατασκευής του προηγούμενου*/
	disjunctive(StartBuilding,BDurations),
			

	/* Περιορισμοί για τις ηλ/κές εγκαταστάσεις/όροφο */
	/* Οι ηλ/κές εγκαταστάσεις γίνονται μετά την κατασκευή του κάθε ορόφου */
	EBa1 #=< SEa1,		
	EBa2 #=< SEa2,		
	EBa3 #=< SEa3,		
	EBa4 #=< SEa4,		
	EBa5 #=< SEa5,		
	EBa6 #=< SEa6,
	EBa7 #=< SEa7,
	
	
	/* Περιορισμοί για τις υδ/κές εγκαταστάσεις/όροφο */
	/* Οι υδ/κές εγκαταστάσεις γίνονται μετά την κατασκευή του κάθε ορόφου */
	EBa1 #=< SPa1,
	EBa2 #=< SPa2,
	EBa3 #=< SPa3,
	EBa4 #=< SPa4,
	EBa5 #=< SPa5,
	EBa6 #=< SPa6,
	EBa7 #=< SPa7,


	/*Περιορισμοί για τη μη επικάλυψη ηλ/κών και υδ/κών εργασιών/όροφο*/
	/*Σε έναν όροφο μπορούν να γίνονται είτε ηλ/κες εργασίες
	είτε υδ/κες,όχι όμως ταυτόχρονα και οι δύο */
	disjunctive([SEa1,SPa1],[EDa1,PDa1]),
	disjunctive([SEa2,SPa2],[EDa2,PDa2]),
	disjunctive([SEa3,SPa3],[EDa3,PDa3]),
	disjunctive([SEa4,SPa4],[EDa4,PDa4]),
	disjunctive([SEa5,SPa5],[EDa5,PDa5]),
	disjunctive([SEa6,SPa6],[EDa6,PDa6]),
	disjunctive([SEa7,SPa7],[EDa7,PDa7]),


	/* Περιορισμοί για τις λοιπές εργασίες/όροφο */
	/* Οι λοιπές εργασίες γίνονται μετά το πέρας των ηλ/κών εργασιών...*/
	EEa1 #=< SFa1,
	EEa2 #=< SFa2,
	EEa3 #=< SFa3,
	EEa4 #=< SFa4,
	EEa5 #=< SFa5,
	EEa6 #=< SFa6,
	EEa7 #=< SFa7,


	/* ...και μετά το πέρας των υδ/κών εργασιών του κάθε ορόφου*/
	EPa1 #=< SFa1,
	EPa2 #=< SFa2,
	EPa3 #=< SFa3,
	EPa4 #=< SFa4,
	EPa5 #=< SFa5,
	EPa6 #=< SFa6,
	EPa7 #=< SFa7,
	

	/*Εύρεση χρόνων έναρξης,λήξης και διάρκειας της κάθε εργασίας*/
	/*Χρησιμοποιείται το αναδρομικό κατηγόρημα start_end_times που*/
	/*Ορίστηκε στην άσκηση 1*/
	start_end_times(StartBuilding,BDurations,EndBuilding),			
	start_end_times(StartElectrical,EDurations,EndElectrical),
	start_end_times(StartPlumbing,PDurations,EndPlumbing),
	start_end_times(StartFinishing,FDurations,EndFinishing),


	
	/* Περιορισμοί που αφορούν τους εργάτες */

	/*Συλλογή δεδομένων για τους εργάτες*/	
	collect_workers(EWorkers,PWorkers,FWorkers),


	/*Εύρεση μέγιστου αριθμού εργατών που απαιτούνται/εργασία...*/
	find_max_workers(EWorkers,PWorkers,FWorkers,EWMax,PWMax,FWMax),


	/*...ώστε το πεδίο τιμών των εργατών να βρίσκεται ανάμεσα σε αυτόν τον*/
	/*αριθμό και τον μέγιστο αριθμό εργατών που μπορεί να προσλάβει η εταιρεία*/
	Electricians #:: EWMax..20,
	Plumbers #:: PWMax..20,
	Finishers #:: FWMax..20,

	
	/*Περιορισμοί του αριθμού εργατών ώστε να μην ξερπερνούν τη μέγιστη τιμή του*/
	/*πεδίου τιμών που ορίστηκε*/
	ic_cumulative:cumulative(StartElectrical,EDurations,EWorkers,Electricians),
	ic_cumulative:cumulative(StartPlumbing,PDurations,PWorkers,Plumbers),
	ic_cumulative:cumulative(StartFinishing,FDurations,FWorkers,Finishers),


	
	
	/*Τοποθέτηση όλων των τιμών που θέλουμε να ελαχιστοποιηθούν σε μία λίστα*/
	Start = [SBa1,SBa2,SBa3,SBa4,SBa5,SBa6,SBa7,SEa1,SEa2,SEa3,SEa4,SEa5,SEa6,SEa7,SPa1,SPa2,SPa3,SPa4,SPa5,SPa6,SPa7,SFa1,SFa2,SFa3,SFa4,SFa5,SFa6,SFa7,Electricians,Plumbers,Finishers],

	
	/*Εύρεση του χρόνου λήξης της τελευταίας εργασίας από τις λοιπές εργασίες*/
	maxlist(EndFinishing,MaxFinishing),

	
	/*Η συνολική διάρκεια των εργασιών είναι ο χρόνος λήξης της τελευταίας*/
	/*εργασίας - το χρόνο λήξης της πρώτης εργασίας(Κατασκευή 1ου ορόφου)*/
	MaxFinishing #= 140,
	Duration #= MaxFinishing - SBa1,
	

	/*Αναζήτηση λύσης...*/	
	bb_min(labeling(Start),Duration, bb_options{timeout:120}).


	
	
/*Βοηθητικά Κατηγορήματα*/

/*Συλλογή της διάρκειας των εργασιών*/
collect_durations(BDurations,EDurations,PDurations,FDurations):-
	findall(BDur,builders(_floors,days(BDur)),BDurations),
	findall(EDur,electricians(_floors,_workers,days(EDur)),EDurations),
	findall(PDur,plumbers(_floors,_workers,days(PDur)),PDurations),
	findall(FDur,finishers(_floors,_workers,days(FDur)),FDurations).

/*Συλλογή αριθμού απαιτούμενων εργατών*/	
collect_workers(EWorkers,PWorkers,FWorkers):-
	findall(EW,electricians(_floors,EW,_days),EWorkers),
	findall(PW,plumbers(_floors,PW,_days),PWorkers),
	findall(FW,finishers(_floors,FW,_days),FWorkers).

/*Εύρεση μέγιστου αριθμού εργατών που απαιτούνται/εργασία για ορισμό πεδίου τιμών*/
find_max_workers(EWorkers,PWorkers,FWorkers,EWMax,PWMax,FWMax):-
	maxlist(EWorkers,EWMax),
	maxlist(PWorkers,PWMax),
	maxlist(FWorkers,FWMax).


start_end_times([],[],[]).

start_end_times([Start|StartsAt],[Dur|Durations], [End|EndsAt]):-
	Start + Dur #= End,
	start_end_times(StartsAt,Durations,EndsAt).


/*Παραδείγματα Εκτέλεσης*/
/*?- construction_plan(Start, Duration, Electricians, Plumbers, Finishers).
Start = 40
Duration = 100
Electricians = 18
Plumbers = 11
Finishers = 18
Yes (0.09s cpu)


?- construction_plan(Start, Duration, 10, 10, 10).
Start = 30
Duration = 110
Yes (119.94s cpu)*/
