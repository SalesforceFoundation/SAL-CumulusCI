BEGIN TRANSACTION;
CREATE TABLE academic_programs (
	sf_id VARCHAR(255) NOT NULL, 
	name VARCHAR(255), 
	department_id VARCHAR(255), 
	record_type VARCHAR(255), 
	PRIMARY KEY (sf_id)
);
INSERT INTO "academic_programs" VALUES('0011700000wy0GzAAI','BS Economics','0011700000wy0GkAAI','Academic_Program');
INSERT INTO "academic_programs" VALUES('0011700000wy0H0AAI','BS Computer Science','0011700000wy0GxAAI','Academic_Program');
CREATE TABLE admin_accounts (
	sf_id VARCHAR(255) NOT NULL, 
	country VARCHAR(255), 
	street VARCHAR(255), 
	state VARCHAR(255), 
	city VARCHAR(255), 
	zip VARCHAR(255), 
	name VARCHAR(255), 
	record_type VARCHAR(255), 
	PRIMARY KEY (sf_id)
);
INSERT INTO "admin_accounts" VALUES('0011700000vnE3DAAU','','','','','','Student Administrative Account','Administrative');
INSERT INTO "admin_accounts" VALUES('0011700000wy0seAAA','','','','','','Instructor Administrative Account','Administrative');
CREATE TABLE advisee_cases (
	sf_id VARCHAR(255) NOT NULL,
	subject VARCHAR(255), 
	status VARCHAR(255), 
	contact_id VARCHAR(255), 
	record_type VARCHAR(255), 
	PRIMARY KEY (sf_id)
);
INSERT INTO "advisee_cases" VALUES('50017000007CQDbAAO','Steven Student Advisee Record','Active Enrolled','0031700000uiL9PAAU','AdviseeRecord');
CREATE TABLE affiliations (
	sf_id VARCHAR(255) NOT NULL, 
	hed__startdate__c VARCHAR(255), 
	hed__enddate__c VARCHAR(255), 
	hed__primary__c VARCHAR(255), 
	hed__role__c VARCHAR(255), 
	hed__status__c VARCHAR(255), 
	contact_id VARCHAR(255), 
	program_id VARCHAR(255), 
	PRIMARY KEY (sf_id)
);
INSERT INTO "affiliations" VALUES('a0117000008xrKwAAI','2019-09-04','2019-12-16','false','Faculty','Current','0031700000vQBmsAAG','0011700000wy0GlAAI');
INSERT INTO "affiliations" VALUES('a0117000008xrJUAAY','2018-09-04','','true','Student','Current','0031700000uiL9PAAU','0011700000wy0GkAAI');
INSERT INTO "affiliations" VALUES('a0117000008xrQWAAY','2019-09-04','2019-12-16','false','Faculty','Current','0031700000vQBmsAAG','0011700000wy0GkAAI');
INSERT INTO "affiliations" VALUES('a0117000008xrJ5AAI','','','true','','Current','0031700000uiL9PAAU','0011700000wy0GzAAI');
INSERT INTO "affiliations" VALUES('a0117000008xrLzAAI','2019-09-04','2019-12-16','false','Faculty','Current','0031700000vQBmsAAG','0011700000wy0GrAAI');
CREATE TABLE case_team_roles (
	sf_id VARCHAR(255) NOT NULL, 
	name VARCHAR(255), 
	public VARCHAR(255), 
	PRIMARY KEY (sf_id)
);
INSERT INTO "case_team_roles" VALUES('0B7170000004IMDCA2','Academics Advisor','true');
INSERT INTO "case_team_roles" VALUES('0B7170000004IMICA2','Career Coacher','true');
INSERT INTO "case_team_roles" VALUES('0B7170000004IMNCA2','Financial Aid Counselors','true');
INSERT INTO "case_team_roles" VALUES('0B7170000004IMSCA2','Studies Abroad Coordinator','true');
CREATE TABLE case_team_template_members (
	sf_id VARCHAR(255) NOT NULL, 
	member_id VARCHAR(255), 
	team_id VARCHAR(255), 
	role_id VARCHAR(255), 
	PRIMARY KEY (sf_id)
);
INSERT INTO "case_team_template_members" VALUES('0B5170000004DAHCA2','00517000003IPzTAAW','0B4170000004DAMCA2','0B7170000004IMICA2');
INSERT INTO "case_team_template_members" VALUES('0B5170000004DAICA2','00517000003ISxHAAW','0B4170000004DAMCA2','0B7170000004IMICA2');
CREATE TABLE case_team_template_records (
	sf_id VARCHAR(255) NOT NULL, 
	case_id VARCHAR(255), 
	template_id VARCHAR(255), 
	PRIMARY KEY (sf_id)
);
CREATE TABLE case_team_templates (
	sf_id VARCHAR(255) NOT NULL, 
	name VARCHAR(255), 
	PRIMARY KEY (sf_id)
);
INSERT INTO "case_team_templates" VALUES('0B4170000004DAMCA2','Academic Services Team');
CREATE TABLE contacts (
	sf_id VARCHAR(255) NOT NULL, 
	salutation VARCHAR(255), 
	first_name VARCHAR(255), 
	last_name VARCHAR(255), 
	email VARCHAR(255), 
	alternate_email VARCHAR(255), 
	preferred_email VARCHAR(255), 
	phone VARCHAR(255), 
	job_title VARCHAR(255), 
	hed__universityemail__c VARCHAR(255), 
	hed__workemail__c VARCHAR(255), 
	account_id VARCHAR(255), 
	primary_program_id VARCHAR(255), 
	PRIMARY KEY (sf_id)
);
INSERT INTO "contacts" VALUES('0031700000uiL9PAAU','Ms.','Steven','Student','steven@connectedu.edu','','University Email','(650) 555-1212','','steven@connectedu.edu','','0011700000vnE3DAAU','0011700000wy0GzAAI');
INSERT INTO "contacts" VALUES('0031700000vQBmsAAG','','Ingmar','Instructor','','','','','','','','0011700000wy0seAAA','');
CREATE TABLE educational_institutions (
	sf_id VARCHAR(255) NOT NULL, 
	name VARCHAR(255), 
	record_type VARCHAR(255), 
	PRIMARY KEY (sf_id)
);
INSERT INTO "educational_institutions" VALUES('0011700000wy0GfAAI','Connected Campus University','Educational_Institution');
CREATE TABLE facilities (
	sf_id VARCHAR(255) NOT NULL, 
	name VARCHAR(255),
	PRIMARY KEY (sf_id)
);
INSERT INTO "facilities" VALUES('a0D8A000001r2QMUAY','Campus One-Stop');
CREATE TABLE program_enrollments (
	sf_id VARCHAR(255) NOT NULL, 
	admin_date VARCHAR(255), 
	grad_year VARCHAR(255), 
	contact_id VARCHAR(255), 
	program_id VARCHAR(255), 
	PRIMARY KEY (sf_id)
);
INSERT INTO "program_enrollments" VALUES('a0F1700000HaTCyEAN','','','0031700000uiL9PAAU','0011700000wy0GzAAI');
CREATE TABLE queue_cases (
	sf_id VARCHAR(255) NOT NULL, 
	subject VARCHAR(255), 
	status VARCHAR(255), 
	contact_id VARCHAR(255), 
	record_type VARCHAR(255), 
	PRIMARY KEY (sf_id)
);
INSERT INTO "queue_cases" VALUES('50017000007fnpIAAQ','','Queued','0031700000uiL9PAAU','AdvisingQueue');
INSERT INTO "queue_cases" VALUES('50017000007fpIDAAY','','Queued','0031700000uiL9PAAU','AdvisingQueue');
INSERT INTO "queue_cases" VALUES('50017000007fs3JAAQ','','Queued','0031700000uiL9PAAU','AdvisingQueue');
CREATE TABLE queue_waiting_room_resources (
	sf_id VARCHAR(255) NOT NULL, 
	user_id VARCHAR(255), 
	advisingpool_id VARCHAR(255), 
	waitingroom_id VARCHAR(255), 
    sortorder INTEGER,
	PRIMARY KEY (sf_id)
);
INSERT INTO "queue_waiting_room_resources" VALUES('a0V8A000002DjaCUAS','','a0Q0U000005eYJrUAM','a0D8A000001r2QMUAY',1);
INSERT INTO "queue_waiting_room_resources" VALUES('a0V8A000002DjZYUA0','0058A0000029Cl4QAE','','a0D8A000001r2QMUAY',2);
CREATE TABLE sfal__advisingpool__c (
	sf_id VARCHAR(255) NOT NULL, 
	name VARCHAR(255), 
	sfal__caseteamname__c VARCHAR(255), 
	sfal__description__c VARCHAR(255), 
	sfal__account__c VARCHAR(255), 
	PRIMARY KEY (sf_id)
);
INSERT INTO "sfal__advisingpool__c" VALUES('a0Q0U000005eYJrUAM','Campus Two-Stop','','The Campus Two-Stop gives you the tools and information you need to register, pay your bill, or apply for financial aid allowing you to stay focused on being a student.','');
INSERT INTO "sfal__advisingpool__c" VALUES('a0Q0U000005eYKBUA2','Academic Services Center','Academic Services Team','We provide career advising expertise to students and alumni regarding the job-search process, interviewing, resume, and letter writing, and all other facets of career planning.Come meet with us today!','');
CREATE TABLE success_teams (
	sf_id VARCHAR(255) NOT NULL, 
	case_team_name VARCHAR(255), 
	name VARCHAR(255), 
	record_type VARCHAR(255), 
	PRIMARY KEY (sf_id)
);
INSERT INTO "success_teams" VALUES('0011700000vnE3DAAU','','Student Administrative Account','Administrative');
INSERT INTO "success_teams" VALUES('0011700000wy0seAAA','','Instructor Administrative Account','Administrative');
CREATE TABLE university_departments (
	sf_id VARCHAR(255) NOT NULL, 
	name VARCHAR(255), 
	record_type VARCHAR(255), 
	PRIMARY KEY (sf_id)
);
INSERT INTO "university_departments" VALUES('0011700000wy0GkAAI','Economics Department','University_Department');
INSERT INTO "university_departments" VALUES('0011700000wy0GlAAI','English Department','University_Department');
INSERT INTO "university_departments" VALUES('0011700000wy0GmAAI','Mathematics Department','University_Department');
INSERT INTO "university_departments" VALUES('0011700000wy0GnAAI','Astrophysics Department','University_Department');
INSERT INTO "university_departments" VALUES('0011700000wy0GoAAI','Botany Department','University_Department');
INSERT INTO "university_departments" VALUES('0011700000wy0GpAAI','Environmental and Earth Sciences','University_Department');
INSERT INTO "university_departments" VALUES('0011700000wy0GqAAI','Music Department','University_Department');
INSERT INTO "university_departments" VALUES('0011700000wy0GrAAI','Chemistry Department','University_Department');
INSERT INTO "university_departments" VALUES('0011700000wy0GsAAI','Physics Department','University_Department');
INSERT INTO "university_departments" VALUES('0011700000wy0GtAAI','Philosophy Department','University_Department');
INSERT INTO "university_departments" VALUES('0011700000wy0GuAAI','Theater Department','University_Department');
INSERT INTO "university_departments" VALUES('0011700000wy0GvAAI','Biology Department','University_Department');
INSERT INTO "university_departments" VALUES('0011700000wy0GwAAI','Art Department','University_Department');
INSERT INTO "university_departments" VALUES('0011700000wy0GxAAI','Computer Science Department','University_Department');
INSERT INTO "university_departments" VALUES('0011700000wy0GyAAI','Orientation','University_Department');
COMMIT;
