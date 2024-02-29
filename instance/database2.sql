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
	start_date VARCHAR(100), 
	end_date VARCHAR(100), 
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

-- Table: event_date_association
CREATE TABLE IF NOT EXISTS event_date_association (
	event_id INTEGER, 
	event_date_id INTEGER, 
	FOREIGN KEY(event_id) REFERENCES event (id), 
	FOREIGN KEY(event_date_id) REFERENCES event_date (id)
);

-- Table: preferred_event_date_association
CREATE TABLE IF NOT EXISTS preferred_event_date_association (
	event_id INTEGER, 
	event_date_id INTEGER, 
	FOREIGN KEY(event_id) REFERENCES event (id), 
	FOREIGN KEY(event_date_id) REFERENCES event_date (id)
);

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

-- Table: trainer_date
CREATE TABLE IF NOT EXISTS trainer_date (id INTEGER NOT NULL, trainerName VARCHAR (50), start_date DATETIME, end_date DATETIME, formatted_start_time VARCHAR (100), formatted_end_time VARCHAR (100), iso_formatted_start_date VARCHAR (100), iso_formatted_end_date VARCHAR (100), trainer_id INTEGER NOT NULL, weekday VARCHAR (20), PRIMARY KEY (id), FOREIGN KEY (trainer_id) REFERENCES trainer (id));

-- Table: user
CREATE TABLE IF NOT EXISTS user (
	id INTEGER NOT NULL, 
	email VARCHAR(150), 
	password VARCHAR(150), 
	first_name VARCHAR(150), 
	PRIMARY KEY (id), 
	UNIQUE (email)
);

COMMIT TRANSACTION;
PRAGMA foreign_keys = on;
