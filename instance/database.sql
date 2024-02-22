--
-- File generated with SQLiteStudio v3.4.4 on Wed Feb 21 20:59:05 2024
--
-- Text encoding used: System
--
PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

-- Table: assignment
CREATE TABLE IF NOT EXISTS assignment (
	id INTEGER NOT NULL, 
	start_date DATETIME, 
	end_date DATETIME, 
	formatted_start_date VARCHAR(100), 
	formatted_end_time VARCHAR(100), 
	event_id INTEGER NOT NULL, 
	trainer_id INTEGER NOT NULL, 
	trainer_status VARCHAR(50), 
	"isLead" BOOLEAN, 
	PRIMARY KEY (id), 
	FOREIGN KEY(event_id) REFERENCES event (id), 
	FOREIGN KEY(trainer_id) REFERENCES trainer (id)
);
INSERT INTO assignment (id, start_date, end_date, formatted_start_date, formatted_end_time, event_id, trainer_id, trainer_status, isLead) VALUES (1, '2024-01-30 12:00:00.000000', '2024-01-30 15:00:00.000000', '01/30/2024 12:00 PM', '03:00 PM', 1, 2, 'Team Lead', 1);
INSERT INTO assignment (id, start_date, end_date, formatted_start_date, formatted_end_time, event_id, trainer_id, trainer_status, isLead) VALUES (2, '2024-01-30 12:00:00.000000', '2024-01-30 15:00:00.000000', '01/30/2024 12:00 PM', '03:00 PM', 1, 3, 'Team Lead', 0);
INSERT INTO assignment (id, start_date, end_date, formatted_start_date, formatted_end_time, event_id, trainer_id, trainer_status, isLead) VALUES (3, '2024-01-30 12:00:00.000000', '2024-01-30 15:00:00.000000', '01/30/2024 12:00 PM', '03:00 PM', 1, 5, 'Basic Trainer', 0);
INSERT INTO assignment (id, start_date, end_date, formatted_start_date, formatted_end_time, event_id, trainer_id, trainer_status, isLead) VALUES (4, '2024-01-30 12:00:00.000000', '2024-01-30 15:00:00.000000', '01/30/2024 12:00 PM', '03:00 PM', 1, 6, 'Team Lead', 0);
INSERT INTO assignment (id, start_date, end_date, formatted_start_date, formatted_end_time, event_id, trainer_id, trainer_status, isLead) VALUES (5, '2024-01-30 12:00:00.000000', '2024-01-30 15:00:00.000000', '01/30/2024 12:00 PM', '03:00 PM', 1, 9, 'New', 0);
INSERT INTO assignment (id, start_date, end_date, formatted_start_date, formatted_end_time, event_id, trainer_id, trainer_status, isLead) VALUES (6, '2024-01-30 12:00:00.000000', '2024-01-30 14:00:00.000000', '01/30/2024 12:00 PM', '02:00 PM', 3, 3, 'Team Lead', 1);
INSERT INTO assignment (id, start_date, end_date, formatted_start_date, formatted_end_time, event_id, trainer_id, trainer_status, isLead) VALUES (7, '2024-01-30 12:00:00.000000', '2024-01-30 14:00:00.000000', '01/30/2024 12:00 PM', '02:00 PM', 3, 2, 'Team Lead', 0);
INSERT INTO assignment (id, start_date, end_date, formatted_start_date, formatted_end_time, event_id, trainer_id, trainer_status, isLead) VALUES (8, '2024-01-30 12:00:00.000000', '2024-01-30 14:00:00.000000', '01/30/2024 12:00 PM', '02:00 PM', 3, 6, 'Team Lead', 0);
INSERT INTO assignment (id, start_date, end_date, formatted_start_date, formatted_end_time, event_id, trainer_id, trainer_status, isLead) VALUES (9, '2024-01-30 12:00:00.000000', '2024-01-30 14:00:00.000000', '01/30/2024 12:00 PM', '02:00 PM', 3, 7, 'New', 0);
INSERT INTO assignment (id, start_date, end_date, formatted_start_date, formatted_end_time, event_id, trainer_id, trainer_status, isLead) VALUES (10, '2024-01-30 12:00:00.000000', '2024-01-30 14:00:00.000000', '01/30/2024 12:00 PM', '02:00 PM', 3, 9, 'New', 0);
INSERT INTO assignment (id, start_date, end_date, formatted_start_date, formatted_end_time, event_id, trainer_id, trainer_status, isLead) VALUES (11, '2024-01-30 12:00:00.000000', '2024-01-30 14:00:00.000000', '01/30/2024 12:00 PM', '02:00 PM', 3, 11, 'New', 0);

-- Table: event
CREATE TABLE IF NOT EXISTS event (
	id INTEGER NOT NULL, 
	name VARCHAR(50), 
	email VARCHAR(50), 
	phone VARCHAR(16), 
	title VARCHAR(50), 
	training_types VARCHAR(500), 
	mission VARCHAR(500), 
	num_learners INTEGER, 
	learners VARCHAR(500), 
	place VARCHAR(500), 
	chairs_tables VARCHAR(300), 
	cultural VARCHAR(500), 
	content_concerns VARCHAR(500), 
	music VARCHAR(300), 
	photos VARCHAR(200), 
	other_info VARCHAR(1500), 
	status VARCHAR(100), 
	admin_notes VARCHAR(500), 
	PRIMARY KEY (id)
);
INSERT INTO event (id, name, email, phone, title, training_types, mission, num_learners, learners, place, chairs_tables, cultural, content_concerns, music, photos, other_info, status, admin_notes) VALUES (1, 'Fake name', 'fake1@fakeemail.com', '1234134134', 'Fake Organization 1', 'Hands-only Adult CPR/AED - Classroom setting, Heartsaver CPR/AED/FA', 'Fake mission', 20, '12-24, no', 'Fake location and parking', 'Yes', 'No', 'No', 'No', 'Yes', 'No', 'Scheduled', 'Changed again');
INSERT INTO event (id, name, email, phone, title, training_types, mission, num_learners, learners, place, chairs_tables, cultural, content_concerns, music, photos, other_info, status, admin_notes) VALUES (2, 'Fake name 2', 'fake2@email.com', '134132413', 'Fake Organization 2', 'Hands-only Adult CPR/AED - Classroom setting, Child/Infant CPR, Narcan', 'Fake mission', 50, '12-20', 'Fake location and parking', 'Yes', 'No', 'No', 'No', 'No', '', 'New', 'None');
INSERT INTO event (id, name, email, phone, title, training_types, mission, num_learners, learners, place, chairs_tables, cultural, content_concerns, music, photos, other_info, status, admin_notes) VALUES (3, 'Fake name 3', 'fake3@fakeemail.com', '23421341324', 'Fake Organization 3', 'Hands-only Adult CPR/AED - Classroom setting, Heartsaver CPR/AED/FA, Child/Infant CPR', 'Fake mission', 30, '132413', 'Fake location and parking', 'Yes', '', '', '', '', '', 'Tentative', 'None');
INSERT INTO event (id, name, email, phone, title, training_types, mission, num_learners, learners, place, chairs_tables, cultural, content_concerns, music, photos, other_info, status, admin_notes) VALUES (4, 'Donald Duck', 'donaldduck@fake.com', '1234134134', 'Disney', 'Hands-only Adult CPR/AED - Street/Health Fair', 'Fake mission', 10, '8-40', 'Disneyland, parking info', 'Yes', '', '', '', '', '', 'New', 'None');
INSERT INTO event (id, name, email, phone, title, training_types, mission, num_learners, learners, place, chairs_tables, cultural, content_concerns, music, photos, other_info, status, admin_notes) VALUES (5, 'Elmo', 'elmo@fakeemail.com', '13413241', 'Sesame Street', 'Hands-only Adult CPR/AED - Street/Health Fair', 'asdfadsf', 20, '4-12, no medical backgrounds', 'Sesame street', 'Yes', '', '', '', '', '', 'New', 'None');

-- Table: event_date
CREATE TABLE IF NOT EXISTS event_date (
	id INTEGER NOT NULL, 
	start_date DATETIME, 
	end_date DATETIME, 
	formatted_start_date VARCHAR(100), 
	formatted_end_time VARCHAR(100), 
	iso_formatted_start_date VARCHAR(100), 
	iso_formatted_end_date VARCHAR(100), 
	PRIMARY KEY (id)
);
INSERT INTO event_date (id, start_date, end_date, formatted_start_date, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date) VALUES (1, '2024-01-30 12:00:00.000000', '2024-01-30 15:00:00.000000', '01/30/2024 12:00 PM', '03:00 PM', '2024-01-30T12:00:00', '2024-01-30T15:00:00');
INSERT INTO event_date (id, start_date, end_date, formatted_start_date, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date) VALUES (2, '2024-02-04 12:00:00.000000', '2024-02-04 15:00:00.000000', '02/04/2024 12:00 PM', '03:00 PM', '2024-02-04T12:00:00', '2024-02-04T15:00:00');
INSERT INTO event_date (id, start_date, end_date, formatted_start_date, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date) VALUES (3, '2024-02-06 12:00:00.000000', '2024-02-06 15:00:00.000000', '02/06/2024 12:00 PM', '03:00 PM', '2024-02-06T12:00:00', '2024-02-06T15:00:00');
INSERT INTO event_date (id, start_date, end_date, formatted_start_date, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date) VALUES (4, '2024-01-31 13:00:00.000000', '2024-01-31 14:00:00.000000', '01/31/2024 01:00 PM', '02:00 PM', '2024-01-31T13:00:00', '2024-01-31T14:00:00');
INSERT INTO event_date (id, start_date, end_date, formatted_start_date, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date) VALUES (5, '2024-02-07 13:00:00.000000', '2024-02-07 14:00:00.000000', '02/07/2024 01:00 PM', '02:00 PM', '2024-02-07T13:00:00', '2024-02-07T14:00:00');
INSERT INTO event_date (id, start_date, end_date, formatted_start_date, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date) VALUES (6, '2024-01-30 12:00:00.000000', '2024-01-30 15:00:00.000000', '01/30/2024 12:00 PM', '03:00 PM', '2024-01-30T12:00:00', '2024-01-30T15:00:00');
INSERT INTO event_date (id, start_date, end_date, formatted_start_date, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date) VALUES (7, '2024-02-07 12:00:00.000000', '2024-02-07 15:00:00.000000', '02/07/2024 12:00 PM', '03:00 PM', '2024-02-07T12:00:00', '2024-02-07T15:00:00');
INSERT INTO event_date (id, start_date, end_date, formatted_start_date, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date) VALUES (8, '2024-02-09 12:00:00.000000', '2024-02-09 15:00:00.000000', '02/09/2024 12:00 PM', '03:00 PM', '2024-02-09T12:00:00', '2024-02-09T15:00:00');
INSERT INTO event_date (id, start_date, end_date, formatted_start_date, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date) VALUES (9, '2024-02-06 10:00:00.000000', '2024-02-06 12:00:00.000000', '02/06/2024 10:00 AM', '12:00 PM', '2024-02-06T10:00:00', '2024-02-06T12:00:00');
INSERT INTO event_date (id, start_date, end_date, formatted_start_date, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date) VALUES (10, '2024-02-13 16:30:00.000000', '2024-02-13 18:30:00.000000', '02/13/2024 04:30 PM', '06:30 PM', '2024-02-13T16:30:00', '2024-02-13T18:30:00');

-- Table: event_date_association
CREATE TABLE IF NOT EXISTS event_date_association (
	event_id INTEGER, 
	event_date_id INTEGER, 
	FOREIGN KEY(event_id) REFERENCES event (id), 
	FOREIGN KEY(event_date_id) REFERENCES event_date (id)
);
INSERT INTO event_date_association (event_id, event_date_id) VALUES (1, 2);
INSERT INTO event_date_association (event_id, event_date_id) VALUES (1, 3);
INSERT INTO event_date_association (event_id, event_date_id) VALUES (2, 5);
INSERT INTO event_date_association (event_id, event_date_id) VALUES (3, 7);
INSERT INTO event_date_association (event_id, event_date_id) VALUES (3, 8);

-- Table: preferred_event_date_association
CREATE TABLE IF NOT EXISTS preferred_event_date_association (
	event_id INTEGER, 
	event_date_id INTEGER, 
	FOREIGN KEY(event_id) REFERENCES event (id), 
	FOREIGN KEY(event_date_id) REFERENCES event_date (id)
);
INSERT INTO preferred_event_date_association (event_id, event_date_id) VALUES (1, 1);
INSERT INTO preferred_event_date_association (event_id, event_date_id) VALUES (2, 4);
INSERT INTO preferred_event_date_association (event_id, event_date_id) VALUES (3, 6);
INSERT INTO preferred_event_date_association (event_id, event_date_id) VALUES (4, 9);
INSERT INTO preferred_event_date_association (event_id, event_date_id) VALUES (5, 10);

-- Table: trainer
CREATE TABLE IF NOT EXISTS trainer (
	id INTEGER NOT NULL, 
	name VARCHAR(50), 
	nickname VARCHAR(50), 
	date_of_birth DATE, 
	pronouns VARCHAR(50), 
	race_ethnicity VARCHAR(100), 
	how_did_you_hear VARCHAR(200), 
	phone VARCHAR(16), 
	text_or_call VARCHAR(16), 
	email VARCHAR(50), 
	education VARCHAR(100), 
	lifesaver_skills VARCHAR(500), 
	relevant_exp VARCHAR(500), 
	heartsaver_interest VARCHAR(4), 
	gen_avail VARCHAR(500), 
	hrs_per_month INTEGER, 
	languages VARCHAR(50), 
	other_info VARCHAR(1500), 
	documents VARCHAR(256), 
	status VARCHAR(100), 
	admin_notes VARCHAR(1500), 
	PRIMARY KEY (id)
);
INSERT INTO trainer (id, name, nickname, date_of_birth, pronouns, race_ethnicity, how_did_you_hear, phone, text_or_call, email, education, lifesaver_skills, relevant_exp, heartsaver_interest, gen_avail, hrs_per_month, languages, other_info, documents, status, admin_notes) VALUES (1, 'Ann Wang', 'Annie Wang', '2002-02-08', 'She/her', 'Asian', 'Pitt! ', '12341341', 'Texts', 'anniewang@fakeemail.com', 'Yes, bachelor''s', '', ' EMT and CPR certified!', 'Yes', NULL, 20, 'Chinese', 'I need training! ', NULL, 'Team Lead', 'None');
INSERT INTO trainer (id, name, nickname, date_of_birth, pronouns, race_ethnicity, how_did_you_hear, phone, text_or_call, email, education, lifesaver_skills, relevant_exp, heartsaver_interest, gen_avail, hrs_per_month, languages, other_info, documents, status, admin_notes) VALUES (2, 'John Doe II', 'John Doe', '1999-03-24', 'He/him', '', ' ', '12341324134', 'Calls', 'johndoe@fakeemail.com', 'No', 'Red Cross Certification, Red Cross Instructor', ' ', 'Yes', NULL, 30, 'Spanish', ' ', NULL, 'Team Lead', 'None');
INSERT INTO trainer (id, name, nickname, date_of_birth, pronouns, race_ethnicity, how_did_you_hear, phone, text_or_call, email, education, lifesaver_skills, relevant_exp, heartsaver_interest, gen_avail, hrs_per_month, languages, other_info, documents, status, admin_notes) VALUES (3, 'Jane Doe II', 'Jane Doe', '1998-03-04', 'She/her', '', ' ', '13413241', 'Calls', 'janedoe@fakeemail.com', '', '', ' ', 'No', NULL, 25, '', ' ', NULL, 'Team Lead', 'None');
INSERT INTO trainer (id, name, nickname, date_of_birth, pronouns, race_ethnicity, how_did_you_hear, phone, text_or_call, email, education, lifesaver_skills, relevant_exp, heartsaver_interest, gen_avail, hrs_per_month, languages, other_info, documents, status, admin_notes) VALUES (4, 'Joshua Doe', 'Josh Doe', '1992-03-04', 'They/them', '', ' ', '12341234', 'Texts', 'joshdoe@fakeemail.com', '', 'Red Cross Certification, Red Cross Instructor', ' ', 'Yes', NULL, '', '', ' ', NULL, 'New', NULL);
INSERT INTO trainer (id, name, nickname, date_of_birth, pronouns, race_ethnicity, how_did_you_hear, phone, text_or_call, email, education, lifesaver_skills, relevant_exp, heartsaver_interest, gen_avail, hrs_per_month, languages, other_info, documents, status, admin_notes) VALUES (5, 'Molly McKay', 'Molly McKay', '2002-07-17', 'She/her', '', ' ', '35151234', 'Calls', 'mollymckay@fakeemail.com', '', '', ' ', 'No', NULL, 15, 'Italian', ' ', NULL, 'Basic Trainer', 'None');
INSERT INTO trainer (id, name, nickname, date_of_birth, pronouns, race_ethnicity, how_did_you_hear, phone, text_or_call, email, education, lifesaver_skills, relevant_exp, heartsaver_interest, gen_avail, hrs_per_month, languages, other_info, documents, status, admin_notes) VALUES (6, 'Megan Jovon Ruth Pete', 'Megan Thee Stallion', '1995-01-12', 'She/her', '', ' ', '345324525', 'Calls', 'megstallion@fakeemail.com', '', 'Heartsaver Certification, Heartsaver Instructor', ' ', 'No', NULL, 20, 'French', 'May be on tour. ', NULL, 'Team Lead', 'None');
INSERT INTO trainer (id, name, nickname, date_of_birth, pronouns, race_ethnicity, how_did_you_hear, phone, text_or_call, email, education, lifesaver_skills, relevant_exp, heartsaver_interest, gen_avail, hrs_per_month, languages, other_info, documents, status, admin_notes) VALUES (7, 'Donald Duck', 'Donald Duck', '1968-05-15', 'He/him', 'Duck', ' Website', '35513513241', 'Texts', 'donaldduck@fakeemail.com', 'No', 'Red Cross Certification, Red Cross Instructor, Heartsaver Certification, Heartsaver Instructor', ' Quacking', 'No', NULL, 50, 'Quack', ' May be swimming.', NULL, 'New', NULL);
INSERT INTO trainer (id, name, nickname, date_of_birth, pronouns, race_ethnicity, how_did_you_hear, phone, text_or_call, email, education, lifesaver_skills, relevant_exp, heartsaver_interest, gen_avail, hrs_per_month, languages, other_info, documents, status, admin_notes) VALUES (8, 'Jared Peters', 'Jared Peters', '2001-09-03', 'He/him', '', ' ', '341341324134', 'Calls', 'jaredpeters@fakeemail.com', '', '', ' ', 'No', NULL, 30, 'French', ' ', NULL, 'New', NULL);
INSERT INTO trainer (id, name, nickname, date_of_birth, pronouns, race_ethnicity, how_did_you_hear, phone, text_or_call, email, education, lifesaver_skills, relevant_exp, heartsaver_interest, gen_avail, hrs_per_month, languages, other_info, documents, status, admin_notes) VALUES (9, 'Nancy Burke', 'Nancy Burke', '2002-02-28', 'She/her', 'Chinese', ' ', '123413413', 'Calls', 'nancyburke@fake.com', '', 'BLS Certification', ' ', 'No', NULL, 20, 'Chinese', ' ', NULL, 'New', NULL);
INSERT INTO trainer (id, name, nickname, date_of_birth, pronouns, race_ethnicity, how_did_you_hear, phone, text_or_call, email, education, lifesaver_skills, relevant_exp, heartsaver_interest, gen_avail, hrs_per_month, languages, other_info, documents, status, admin_notes) VALUES (10, 'Alexandra DeRubeis', 'Allie Derubeis', '2001-09-14', 'They/them', '', ' ', '12341341341', 'Calls', 'alliederubeis@fakeemail.com', '', '', ' ', 'No', NULL, 50, 'Italian', ' ', NULL, 'New', NULL);
INSERT INTO trainer (id, name, nickname, date_of_birth, pronouns, race_ethnicity, how_did_you_hear, phone, text_or_call, email, education, lifesaver_skills, relevant_exp, heartsaver_interest, gen_avail, hrs_per_month, languages, other_info, documents, status, admin_notes) VALUES (11, 'Elyssa Allen', 'Elyssa Allen', '2002-01-10', 'She/her', '', ' ', '123412341341', 'Calls', 'elyssaallen@fakeemail.com', '', '', ' ', 'No', NULL, 50, 'French', ' ', NULL, 'New', NULL);

-- Table: trainer_date
CREATE TABLE IF NOT EXISTS trainer_date (id INTEGER NOT NULL, trainerName VARCHAR (50), start_date DATETIME, end_date DATETIME, formatted_start_time VARCHAR (100), formatted_end_time VARCHAR (100), iso_formatted_start_date VARCHAR (100), iso_formatted_end_date VARCHAR (100), trainer_id INTEGER NOT NULL, weekday VARCHAR (20), PRIMARY KEY (id), FOREIGN KEY (trainer_id) REFERENCES trainer (id));
INSERT INTO trainer_date (id, trainerName, start_date, end_date, formatted_start_time, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date, trainer_id, weekday) VALUES (1, 'Ann Wang', '2023-12-26 09:00:00.000000', '2023-12-26 14:00:00.000000', '09:00 AM', '02:00 PM', '2023-12-26T09:00:00-05:00', '2023-12-26T14:00:00-05:00', 1, 'Tuesday');
INSERT INTO trainer_date (id, trainerName, start_date, end_date, formatted_start_time, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date, trainer_id, weekday) VALUES (2, 'Ann Wang', '2023-12-28 09:00:00.000000', '2023-12-28 14:00:00.000000', '09:00 AM', '02:00 PM', '2023-12-28T09:00:00-05:00', '2023-12-28T14:00:00-05:00', 1, 'Thursday');
INSERT INTO trainer_date (id, trainerName, start_date, end_date, formatted_start_time, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date, trainer_id, weekday) VALUES (3, 'Ann Wang', '2023-12-30 09:00:00.000000', '2023-12-30 14:00:00.000000', '09:00 AM', '02:00 PM', '2023-12-30T09:00:00-05:00', '2023-12-30T14:00:00-05:00', 1, 'Saturday');
INSERT INTO trainer_date (id, trainerName, start_date, end_date, formatted_start_time, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date, trainer_id, weekday) VALUES (4, 'John Doe II', '2023-12-25 08:00:00.000000', '2023-12-25 13:30:00.000000', '08:00 AM', '01:30 PM', '2023-12-25T08:00:00-05:00', '2023-12-25T13:30:00-05:00', 2, 'Monday');
INSERT INTO trainer_date (id, trainerName, start_date, end_date, formatted_start_time, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date, trainer_id, weekday) VALUES (5, 'John Doe II', '2023-12-28 09:00:00.000000', '2023-12-28 14:00:00.000000', '09:00 AM', '02:00 PM', '2023-12-28T09:00:00-05:00', '2023-12-28T14:00:00-05:00', 2, 'Thursday');
INSERT INTO trainer_date (id, trainerName, start_date, end_date, formatted_start_time, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date, trainer_id, weekday) VALUES (6, 'John Doe II', '2023-12-31 07:30:00.000000', '2023-12-31 12:00:00.000000', '07:30 AM', '12:00 PM', '2023-12-31T07:30:00-05:00', '2023-12-31T12:00:00-05:00', 2, 'Sunday');
INSERT INTO trainer_date (id, trainerName, start_date, end_date, formatted_start_time, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date, trainer_id, weekday) VALUES (7, 'Jane Doe II', '2023-12-25 10:00:00.000000', '2023-12-25 14:00:00.000000', '10:00 AM', '02:00 PM', '2023-12-25T10:00:00-05:00', '2023-12-25T14:00:00-05:00', 3, 'Monday');
INSERT INTO trainer_date (id, trainerName, start_date, end_date, formatted_start_time, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date, trainer_id, weekday) VALUES (8, 'Jane Doe II', '2023-12-28 11:30:00.000000', '2023-12-28 15:00:00.000000', '11:30 AM', '03:00 PM', '2023-12-28T11:30:00-05:00', '2023-12-28T15:00:00-05:00', 3, 'Thursday');
INSERT INTO trainer_date (id, trainerName, start_date, end_date, formatted_start_time, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date, trainer_id, weekday) VALUES (9, 'Jane Doe II', '2023-12-31 10:30:00.000000', '2023-12-31 14:00:00.000000', '10:30 AM', '02:00 PM', '2023-12-31T10:30:00-05:00', '2023-12-31T14:00:00-05:00', 3, 'Sunday');
INSERT INTO trainer_date (id, trainerName, start_date, end_date, formatted_start_time, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date, trainer_id, weekday) VALUES (10, 'Joshua Doe', '2023-12-25 07:30:00.000000', '2023-12-25 11:30:00.000000', '07:30 AM', '11:30 AM', '2023-12-25T07:30:00-05:00', '2023-12-25T11:30:00-05:00', 4, 'Monday');
INSERT INTO trainer_date (id, trainerName, start_date, end_date, formatted_start_time, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date, trainer_id, weekday) VALUES (11, 'Joshua Doe', '2023-12-27 09:30:00.000000', '2023-12-27 15:00:00.000000', '09:30 AM', '03:00 PM', '2023-12-27T09:30:00-05:00', '2023-12-27T15:00:00-05:00', 4, 'Wednesday');
INSERT INTO trainer_date (id, trainerName, start_date, end_date, formatted_start_time, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date, trainer_id, weekday) VALUES (12, 'Joshua Doe', '2023-12-25 13:30:00.000000', '2023-12-25 17:30:00.000000', '01:30 PM', '05:30 PM', '2023-12-25T13:30:00-05:00', '2023-12-25T17:30:00-05:00', 4, 'Monday');
INSERT INTO trainer_date (id, trainerName, start_date, end_date, formatted_start_time, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date, trainer_id, weekday) VALUES (13, 'Joshua Doe', '2023-12-29 12:00:00.000000', '2023-12-29 17:00:00.000000', '12:00 PM', '05:00 PM', '2023-12-29T12:00:00-05:00', '2023-12-29T17:00:00-05:00', 4, 'Friday');
INSERT INTO trainer_date (id, trainerName, start_date, end_date, formatted_start_time, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date, trainer_id, weekday) VALUES (14, 'Joshua Doe', '2023-12-31 10:00:00.000000', '2023-12-31 15:30:00.000000', '10:00 AM', '03:30 PM', '2023-12-31T10:00:00-05:00', '2023-12-31T15:30:00-05:00', 4, 'Sunday');
INSERT INTO trainer_date (id, trainerName, start_date, end_date, formatted_start_time, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date, trainer_id, weekday) VALUES (15, 'Molly McKay', '2023-12-26 08:30:00.000000', '2023-12-26 12:30:00.000000', '08:30 AM', '12:30 PM', '2023-12-26T08:30:00-05:00', '2023-12-26T12:30:00-05:00', 5, 'Tuesday');
INSERT INTO trainer_date (id, trainerName, start_date, end_date, formatted_start_time, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date, trainer_id, weekday) VALUES (16, 'Molly McKay', '2023-12-28 12:30:00.000000', '2023-12-28 17:00:00.000000', '12:30 PM', '05:00 PM', '2023-12-28T12:30:00-05:00', '2023-12-28T17:00:00-05:00', 5, 'Thursday');
INSERT INTO trainer_date (id, trainerName, start_date, end_date, formatted_start_time, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date, trainer_id, weekday) VALUES (17, 'Molly McKay', '2023-12-30 11:00:00.000000', '2023-12-30 15:00:00.000000', '11:00 AM', '03:00 PM', '2023-12-30T11:00:00-05:00', '2023-12-30T15:00:00-05:00', 5, 'Saturday');
INSERT INTO trainer_date (id, trainerName, start_date, end_date, formatted_start_time, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date, trainer_id, weekday) VALUES (18, 'Molly McKay', '2023-12-31 14:00:00.000000', '2023-12-31 17:30:00.000000', '02:00 PM', '05:30 PM', '2023-12-31T14:00:00-05:00', '2023-12-31T17:30:00-05:00', 5, 'Sunday');
INSERT INTO trainer_date (id, trainerName, start_date, end_date, formatted_start_time, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date, trainer_id, weekday) VALUES (19, 'Molly McKay', '2023-12-25 13:30:00.000000', '2023-12-25 16:00:00.000000', '01:30 PM', '04:00 PM', '2023-12-25T13:30:00-05:00', '2023-12-25T16:00:00-05:00', 5, 'Monday');
INSERT INTO trainer_date (id, trainerName, start_date, end_date, formatted_start_time, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date, trainer_id, weekday) VALUES (20, 'Molly McKay', '2023-12-25 20:30:00.000000', '2023-12-26 00:00:00.000000', '08:30 PM', '12:00 AM', '2023-12-25T20:30:00-05:00', '2023-12-26T00:00:00-05:00', 5, 'Tuesday');
INSERT INTO trainer_date (id, trainerName, start_date, end_date, formatted_start_time, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date, trainer_id, weekday) VALUES (21, 'Molly McKay', '2023-12-25 17:00:00.000000', '2023-12-25 19:00:00.000000', '05:00 PM', '07:00 PM', '2023-12-25T17:00:00-05:00', '2023-12-25T19:00:00-05:00', 5, 'Monday');
INSERT INTO trainer_date (id, trainerName, start_date, end_date, formatted_start_time, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date, trainer_id, weekday) VALUES (22, 'Molly McKay', '2023-12-27 17:00:00.000000', '2023-12-27 23:00:00.000000', '05:00 PM', '11:00 PM', '2023-12-27T17:00:00-05:00', '2023-12-27T23:00:00-05:00', 5, 'Wednesday');
INSERT INTO trainer_date (id, trainerName, start_date, end_date, formatted_start_time, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date, trainer_id, weekday) VALUES (23, 'Molly McKay', '2023-12-30 16:30:00.000000', '2023-12-30 21:30:00.000000', '04:30 PM', '09:30 PM', '2023-12-30T16:30:00-05:00', '2023-12-30T21:30:00-05:00', 5, 'Saturday');
INSERT INTO trainer_date (id, trainerName, start_date, end_date, formatted_start_time, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date, trainer_id, weekday) VALUES (24, 'Megan Jovon Ruth Pete', '2023-12-25 10:00:00.000000', '2023-12-25 14:00:00.000000', '10:00 AM', '02:00 PM', '2023-12-25T10:00:00-05:00', '2023-12-25T14:00:00-05:00', 6, 'Monday');
INSERT INTO trainer_date (id, trainerName, start_date, end_date, formatted_start_time, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date, trainer_id, weekday) VALUES (25, 'Megan Jovon Ruth Pete', '2023-12-27 10:30:00.000000', '2023-12-27 16:00:00.000000', '10:30 AM', '04:00 PM', '2023-12-27T10:30:00-05:00', '2023-12-27T16:00:00-05:00', 6, 'Wednesday');
INSERT INTO trainer_date (id, trainerName, start_date, end_date, formatted_start_time, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date, trainer_id, weekday) VALUES (26, 'Megan Jovon Ruth Pete', '2023-12-29 11:00:00.000000', '2023-12-29 17:00:00.000000', '11:00 AM', '05:00 PM', '2023-12-29T11:00:00-05:00', '2023-12-29T17:00:00-05:00', 6, 'Friday');
INSERT INTO trainer_date (id, trainerName, start_date, end_date, formatted_start_time, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date, trainer_id, weekday) VALUES (27, 'Megan Jovon Ruth Pete', '2023-12-31 10:00:00.000000', '2023-12-31 15:00:00.000000', '10:00 AM', '03:00 PM', '2023-12-31T10:00:00-05:00', '2023-12-31T15:00:00-05:00', 6, 'Sunday');
INSERT INTO trainer_date (id, trainerName, start_date, end_date, formatted_start_time, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date, trainer_id, weekday) VALUES (28, 'Donald Duck', '2023-12-26 08:00:00.000000', '2023-12-26 12:30:00.000000', '08:00 AM', '12:30 PM', '2023-12-26T08:00:00-05:00', '2023-12-26T12:30:00-05:00', 7, 'Tuesday');
INSERT INTO trainer_date (id, trainerName, start_date, end_date, formatted_start_time, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date, trainer_id, weekday) VALUES (29, 'Donald Duck', '2023-12-28 08:00:00.000000', '2023-12-28 11:00:00.000000', '08:00 AM', '11:00 AM', '2023-12-28T08:00:00-05:00', '2023-12-28T11:00:00-05:00', 7, 'Thursday');
INSERT INTO trainer_date (id, trainerName, start_date, end_date, formatted_start_time, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date, trainer_id, weekday) VALUES (30, 'Donald Duck', '2023-12-30 09:00:00.000000', '2023-12-30 13:30:00.000000', '09:00 AM', '01:30 PM', '2023-12-30T09:00:00-05:00', '2023-12-30T13:30:00-05:00', 7, 'Saturday');
INSERT INTO trainer_date (id, trainerName, start_date, end_date, formatted_start_time, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date, trainer_id, weekday) VALUES (31, 'Donald Duck', '2023-12-25 10:00:00.000000', '2023-12-25 14:30:00.000000', '10:00 AM', '02:30 PM', '2023-12-25T10:00:00-05:00', '2023-12-25T14:30:00-05:00', 7, 'Monday');
INSERT INTO trainer_date (id, trainerName, start_date, end_date, formatted_start_time, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date, trainer_id, weekday) VALUES (32, 'Donald Duck', '2023-12-28 14:30:00.000000', '2023-12-28 18:30:00.000000', '02:30 PM', '06:30 PM', '2023-12-28T14:30:00-05:00', '2023-12-28T18:30:00-05:00', 7, 'Thursday');
INSERT INTO trainer_date (id, trainerName, start_date, end_date, formatted_start_time, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date, trainer_id, weekday) VALUES (33, 'Jared Peters', '2023-12-25 08:00:00.000000', '2023-12-25 16:00:00.000000', '08:00 AM', '04:00 PM', '2023-12-25T08:00:00-05:00', '2023-12-25T16:00:00-05:00', 8, 'Monday');
INSERT INTO trainer_date (id, trainerName, start_date, end_date, formatted_start_time, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date, trainer_id, weekday) VALUES (34, 'Jared Peters', '2023-12-31 08:00:00.000000', '2023-12-31 16:00:00.000000', '08:00 AM', '04:00 PM', '2023-12-31T08:00:00-05:00', '2023-12-31T16:00:00-05:00', 8, 'Sunday');
INSERT INTO trainer_date (id, trainerName, start_date, end_date, formatted_start_time, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date, trainer_id, weekday) VALUES (35, 'Jared Peters', '2023-12-28 10:00:00.000000', '2023-12-28 16:00:00.000000', '10:00 AM', '04:00 PM', '2023-12-28T10:00:00-05:00', '2023-12-28T16:00:00-05:00', 8, 'Thursday');
INSERT INTO trainer_date (id, trainerName, start_date, end_date, formatted_start_time, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date, trainer_id, weekday) VALUES (36, 'Jared Peters', '2023-12-27 10:00:00.000000', '2023-12-27 16:00:00.000000', '10:00 AM', '04:00 PM', '2023-12-27T10:00:00-05:00', '2023-12-27T16:00:00-05:00', 8, 'Wednesday');
INSERT INTO trainer_date (id, trainerName, start_date, end_date, formatted_start_time, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date, trainer_id, weekday) VALUES (37, 'Jared Peters', '2023-12-30 10:00:00.000000', '2023-12-30 16:00:00.000000', '10:00 AM', '04:00 PM', '2023-12-30T10:00:00-05:00', '2023-12-30T16:00:00-05:00', 8, 'Saturday');
INSERT INTO trainer_date (id, trainerName, start_date, end_date, formatted_start_time, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date, trainer_id, weekday) VALUES (38, 'Nancy Burke', '2023-12-25 06:00:00.000000', '2023-12-25 23:30:00.000000', '06:00 AM', '11:30 PM', '2023-12-25T06:00:00-05:00', '2023-12-25T23:30:00-05:00', 9, 'Monday');
INSERT INTO trainer_date (id, trainerName, start_date, end_date, formatted_start_time, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date, trainer_id, weekday) VALUES (39, 'Nancy Burke', '2023-12-26 06:00:00.000000', '2023-12-26 23:30:00.000000', '06:00 AM', '11:30 PM', '2023-12-26T06:00:00-05:00', '2023-12-26T23:30:00-05:00', 9, 'Tuesday');
INSERT INTO trainer_date (id, trainerName, start_date, end_date, formatted_start_time, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date, trainer_id, weekday) VALUES (40, 'Nancy Burke', '2023-12-27 06:00:00.000000', '2023-12-27 23:30:00.000000', '06:00 AM', '11:30 PM', '2023-12-27T06:00:00-05:00', '2023-12-27T23:30:00-05:00', 9, 'Wednesday');
INSERT INTO trainer_date (id, trainerName, start_date, end_date, formatted_start_time, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date, trainer_id, weekday) VALUES (41, 'Nancy Burke', '2023-12-28 06:00:00.000000', '2023-12-28 23:30:00.000000', '06:00 AM', '11:30 PM', '2023-12-28T06:00:00-05:00', '2023-12-28T23:30:00-05:00', 9, 'Thursday');
INSERT INTO trainer_date (id, trainerName, start_date, end_date, formatted_start_time, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date, trainer_id, weekday) VALUES (42, 'Nancy Burke', '2023-12-29 06:00:00.000000', '2023-12-29 23:30:00.000000', '06:00 AM', '11:30 PM', '2023-12-29T06:00:00-05:00', '2023-12-29T23:30:00-05:00', 9, 'Friday');
INSERT INTO trainer_date (id, trainerName, start_date, end_date, formatted_start_time, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date, trainer_id, weekday) VALUES (43, 'Nancy Burke', '2023-12-30 06:00:00.000000', '2023-12-30 23:30:00.000000', '06:00 AM', '11:30 PM', '2023-12-30T06:00:00-05:00', '2023-12-30T23:30:00-05:00', 9, 'Saturday');
INSERT INTO trainer_date (id, trainerName, start_date, end_date, formatted_start_time, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date, trainer_id, weekday) VALUES (44, 'Nancy Burke', '2023-12-31 06:00:00.000000', '2023-12-31 23:30:00.000000', '06:00 AM', '11:30 PM', '2023-12-31T06:00:00-05:00', '2023-12-31T23:30:00-05:00', 9, 'Sunday');
INSERT INTO trainer_date (id, trainerName, start_date, end_date, formatted_start_time, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date, trainer_id, weekday) VALUES (45, 'Alexandra DeRubeis', '2023-12-25 06:00:00.000000', '2023-12-26 00:00:00.000000', '06:00 AM', '12:00 AM', '2023-12-25T06:00:00-05:00', '2023-12-26T00:00:00-05:00', 10, 'Monday');
INSERT INTO trainer_date (id, trainerName, start_date, end_date, formatted_start_time, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date, trainer_id, weekday) VALUES (46, 'Alexandra DeRubeis', '2023-12-26 06:00:00.000000', '2023-12-27 00:00:00.000000', '06:00 AM', '12:00 AM', '2023-12-26T06:00:00-05:00', '2023-12-27T00:00:00-05:00', 10, 'Tuesday');
INSERT INTO trainer_date (id, trainerName, start_date, end_date, formatted_start_time, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date, trainer_id, weekday) VALUES (47, 'Alexandra DeRubeis', '2023-12-27 06:00:00.000000', '2023-12-28 00:00:00.000000', '06:00 AM', '12:00 AM', '2023-12-27T06:00:00-05:00', '2023-12-28T00:00:00-05:00', 10, 'Wednesday');
INSERT INTO trainer_date (id, trainerName, start_date, end_date, formatted_start_time, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date, trainer_id, weekday) VALUES (48, 'Alexandra DeRubeis', '2023-12-28 06:00:00.000000', '2023-12-29 00:00:00.000000', '06:00 AM', '12:00 AM', '2023-12-28T06:00:00-05:00', '2023-12-29T00:00:00-05:00', 10, 'Thursday');
INSERT INTO trainer_date (id, trainerName, start_date, end_date, formatted_start_time, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date, trainer_id, weekday) VALUES (49, 'Alexandra DeRubeis', '2023-12-29 06:00:00.000000', '2023-12-30 00:00:00.000000', '06:00 AM', '12:00 AM', '2023-12-29T06:00:00-05:00', '2023-12-30T00:00:00-05:00', 10, 'Friday');
INSERT INTO trainer_date (id, trainerName, start_date, end_date, formatted_start_time, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date, trainer_id, weekday) VALUES (50, 'Alexandra DeRubeis', '2023-12-30 06:00:00.000000', '2023-12-31 00:00:00.000000', '06:00 AM', '12:00 AM', '2023-12-30T06:00:00-05:00', '2023-12-31T00:00:00-05:00', 10, 'Saturday');
INSERT INTO trainer_date (id, trainerName, start_date, end_date, formatted_start_time, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date, trainer_id, weekday) VALUES (51, 'Alexandra DeRubeis', '2023-12-31 06:00:00.000000', '2024-01-01 00:00:00.000000', '06:00 AM', '12:00 AM', '2023-12-31T06:00:00-05:00', '2024-01-01T00:00:00-05:00', 10, 'Sunday');
INSERT INTO trainer_date (id, trainerName, start_date, end_date, formatted_start_time, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date, trainer_id, weekday) VALUES (52, 'Elyssa Allen', '2023-12-25 06:00:00.000000', '2023-12-25 14:00:00.000000', '06:00 AM', '02:00 PM', '2023-12-25T06:00:00-05:00', '2023-12-25T14:00:00-05:00', 11, 'Monday');
INSERT INTO trainer_date (id, trainerName, start_date, end_date, formatted_start_time, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date, trainer_id, weekday) VALUES (53, 'Elyssa Allen', '2023-12-26 08:30:00.000000', '2023-12-26 17:30:00.000000', '08:30 AM', '05:30 PM', '2023-12-26T08:30:00-05:00', '2023-12-26T17:30:00-05:00', 11, 'Tuesday');
INSERT INTO trainer_date (id, trainerName, start_date, end_date, formatted_start_time, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date, trainer_id, weekday) VALUES (54, 'Elyssa Allen', '2023-12-27 09:30:00.000000', '2023-12-27 16:00:00.000000', '09:30 AM', '04:00 PM', '2023-12-27T09:30:00-05:00', '2023-12-27T16:00:00-05:00', 11, 'Wednesday');
INSERT INTO trainer_date (id, trainerName, start_date, end_date, formatted_start_time, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date, trainer_id, weekday) VALUES (55, 'Elyssa Allen', '2023-12-28 10:30:00.000000', '2023-12-28 21:00:00.000000', '10:30 AM', '09:00 PM', '2023-12-28T10:30:00-05:00', '2023-12-28T21:00:00-05:00', 11, 'Thursday');
INSERT INTO trainer_date (id, trainerName, start_date, end_date, formatted_start_time, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date, trainer_id, weekday) VALUES (56, 'Elyssa Allen', '2023-12-29 09:30:00.000000', '2023-12-29 14:30:00.000000', '09:30 AM', '02:30 PM', '2023-12-29T09:30:00-05:00', '2023-12-29T14:30:00-05:00', 11, 'Friday');
INSERT INTO trainer_date (id, trainerName, start_date, end_date, formatted_start_time, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date, trainer_id, weekday) VALUES (57, 'Elyssa Allen', '2023-12-30 10:00:00.000000', '2023-12-30 18:00:00.000000', '10:00 AM', '06:00 PM', '2023-12-30T10:00:00-05:00', '2023-12-30T18:00:00-05:00', 11, 'Saturday');
INSERT INTO trainer_date (id, trainerName, start_date, end_date, formatted_start_time, formatted_end_time, iso_formatted_start_date, iso_formatted_end_date, trainer_id, weekday) VALUES (58, 'Elyssa Allen', '2023-12-31 12:00:00.000000', '2024-01-01 00:00:00.000000', '12:00 PM', '12:00 AM', '2023-12-31T12:00:00-05:00', '2024-01-01T00:00:00-05:00', 11, 'Sunday');

-- Table: user
CREATE TABLE IF NOT EXISTS user (
	id INTEGER NOT NULL, 
	email VARCHAR(150), 
	password VARCHAR(150), 
	first_name VARCHAR(150), 
	PRIMARY KEY (id), 
	UNIQUE (email)
);
INSERT INTO user (id, email, password, first_name) VALUES (1, 'fake@fake.fake', 'sha256$Dj2gA1BGxcw9qSe3$c4f2b6eae04d73f72e521fb83462c9b2a50b52db7c57c6cba2c19e3c9f11075f', 'Annie');

COMMIT TRANSACTION;
PRAGMA foreign_keys = on;
