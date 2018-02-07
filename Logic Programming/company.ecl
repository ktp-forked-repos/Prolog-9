%%% Project 1
%%% Ex.1 (The Company)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Company Data 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

employee(name(john),occupation([programmer,analyst]),wage(40000)).
employee(name(alice),occupation([programmer,tester]),wage(35000)).
employee(name(peter),occupation([uxdesigner,web,databases]),wage(25000)).
employee(name(nick),occupation([accountant]),wage(60000)).
employee(name(helen),occupation([ceo,programmer,project_leader]),wage(140000)).
employee(name(bob),occupation([programmer]),wage(15000)).
employee(name(mathiew),occupation([project_namager,analyst]),wage(50000)).
employee(name(donald),occupation([public_relations,boss]),wage(100000)).
employee(name(igor),occupation([server_admin,security]),wage(20000)).


data(john,status(married,children(2))).
data(alice,status(single,children(0))).
data(peter,status(married,children(1))).
data(nick,status(married,children(3))).
data(helen,status(single,children(2))).
data(bob,status(single,children(0))).
data(mathiew,status(married,children(1))).
data(donald,status(single,children(1))).
data(igor,status(married,children(1))).

 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Q. a
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% wage/2
%%% wage(Empl,Wage)
%%% Succeeds if Empl is an employee of the Company
%%% with annual salary Wage


wage(Empl,Wage):-
	employee(name(Empl),_,wage(Wage)).




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Q. b
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% single_with_children/2
%%% single_with_children(Empl,N)
%%% Succeds if the employee Empl is single and has
%%% N kids (N>0)


single_with_children(Empl,N):-
	data(Empl,status(single,children(N))),
	N>0.


single_no_children(Empl,N):-
	data(Empl,status(single,children(N))),
	N is 0.

married_with_children(Empl,N):-
	data(Empl,status(married,children(N))),
	N>=0.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Q. c
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% same_status/2
%%% same_status(X,Y)
%%% Succeeds if the employees X and Y have the same 
%%% status (married/single).


same_status(X,Y):-
	data(X,status(Status,_)),
	data(Y,status(Status,_)),
	X \= Y.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Q. d
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% benefit/3
%%% benefit(Name,Wage,Benefit)
%%% Succeeds if the employee Name, with annual salary
%%% Wage, gets a benefit Benefit, accoring to the 
%%% following criteria:

%%% Single employee with no children: Benefit 0
%%% Single employee with N children (N>0): Benefit 1000 + 500*N
%%% Married employee with children N (N>=0): Benefit 500 + 600*N


benefit(Name,Wage,Benefit):-
	wage(Name,Wage),
	single_with_children(Name,N),
	Benefit is 1000+500*N.

benefit(Name,Wage,Benefit):-
	wage(Name,Wage),
	married_with_children(Name,N),
	Benefit is 500+600*N.

benefit(Name,Wage,Benefit):-
	wage(Name,Wage),
	single_no_children(Name,_),
	Benefit is 0.


