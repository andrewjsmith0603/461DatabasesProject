create database if not exists proj1;
use proj1;

create table Folk
	(folk_ID		int(16),
	 f_name  		varchar(20),
     l_name     	varchar(20),
	 nickname		varchar(20),
	 pri_phone		int(10),
	 sec_phone		int(10),
	 birthday		date,
	 primary key (folk_ID)
	);
    
create table place
	(X_coord  		int(20),
	 Y_coord     	int(20),
	 st_num 		int(10),
	 st_name		varchar(20),
	 city			varchar(20),
	 state			varchar(20),
	 zipcode		int(10),
	 primary key (X_coord, Y_coord)
	);

create table Residence
	(X_coord  		int(20),
	 Y_coord     	int(20),
	 primary key (X_coord, Y_coord),
     foreign key (X_coord, Y_coord) references Place(X_coord, Y_coord) ON DELETE CASCADE
	);

create table Voting_Center
	(X_coord  		int(20),
	 Y_coord     	int(20),
	 voting_ac 		char(4),
	 primary key (X_coord, Y_coord),
     foreign key (X_coord, Y_coord) references Place(X_coord, Y_coord) ON DELETE CASCADE,
	 unique (voting_ac)
	);
    
create table Email
	(folk_ID		int(16),
	 email_add 		varchar(30),
	 primary key (folk_ID, email_add),
	 foreign key (folk_ID) references Folk(folk_ID) ON DELETE CASCADE
	);
    
create table Resides
	(folk_ID		int(16),
	 X_coord  		int(20),
     Y_coord     	int(20),
	 primary key (folk_ID, X_coord, Y_coord),
	 foreign key (folk_ID) references Folk(folk_ID) ON DELETE CASCADE,
	 foreign key (X_coord, Y_coord) references Residence(X_coord, Y_coord) ON DELETE CASCADE
	);

create table Election_Staff
	(folk_ID		int(16),
	 primary key (folk_ID),
	 foreign key (folk_ID) references Folk(folk_ID) ON DELETE CASCADE
	);

create table Clerk
	(clerk_ID		int(16),
	 primary key (clerk_ID),
	 foreign key (clerk_ID) references Election_Staff(folk_ID) ON DELETE CASCADE
	);

create table Monitor
	(mon_ID		int(16),
	 primary key (mon_ID),
	 foreign key (mon_ID) references Election_Staff(folk_ID) ON DELETE CASCADE
	);
    
create table Works_At
	(folk_ID		int(16),
	 voting_ac 		varchar(10),
	 startDT 		datetime,
     endDT			datetime,
	 primary key (folk_ID, voting_ac, startDT, endDT),
	 foreign key (folk_ID) references Election_Staff(folk_ID) ON DELETE CASCADE,
     foreign key (voting_ac) references Voting_Center(voting_ac) ON DELETE CASCADE
	);
    
create table Operates
	(voting_ac 		char(4),
     startDT		datetime,
	 endDT 			datetime,
	 primary key (voting_ac, startDT, endDT),
     foreign key (voting_ac) references Voting_Center(voting_ac) ON DELETE CASCADE
	);
    
create table Ballot
	(bal_ID 		char(4),
     clerk_ID		int(16),
	 question 		varchar(100),
     startDT		datetime,
	 endDT 			datetime,
	 primary key (bal_ID),
     foreign key (clerk_ID) references Clerk(clerk_ID)
	);

create table Answer_Choice
	(bal_ID 		char(4),
     answer			varchar(10),
	 primary key (bal_ID, answer),
     foreign key (bal_ID) references Ballot(bal_ID) ON DELETE CASCADE
	);
    
create table Registered
	(folk_ID 		int(16),
     bal_ID			char(4),
     voting_ac		char(4),
     reg_date		date,
	 primary key (folk_ID, bal_ID, voting_ac, reg_date),
     foreign key (folk_ID) references Folk(folk_ID) ON DELETE CASCADE,
     foreign key (bal_ID) references Ballot(bal_ID) ON DELETE CASCADE,
     foreign key (voting_ac) references Voting_Center(voting_ac) ON DELETE CASCADE
	);
    
create table cast
    (folk_ID 		int(16),
     bal_ID			char(4),
     voting_ac		char(4),
     vote_date		date,
     vote_time      time,
     mon_ID			int(16),
     bal_answer		varchar(10),
	 primary key (folk_ID, bal_ID),
     foreign key (folk_ID) references Folk(folk_ID),
     foreign key (voting_ac) references Voting_Center(voting_ac),
     foreign key (mon_ID) references Monitor(mon_ID),
	 foreign key (bal_ID, bal_answer) references Answer_Choice(bal_ID, answer)
	);
    
    
