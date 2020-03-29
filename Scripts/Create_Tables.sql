CREATE TABLE IF NOT EXISTS Lab_Members  (
    unique_Id    INTEGER ,
    Full_Name    VARCHAR (50) NOT NULL,
    Web_Page     VARCHAR (50),
    E_mail       VARCHAR (50) NOT NULL UNIQUE,
    Phone_Number INTEGER      NOT NULL,
    Short_CV     VARCHAR (1000),
    Rank         VARCHAR (50),
    Member_Type  VARCHAR (22) NOT NULL,
    PRIMARY KEY (
        unique_Id AUTOINCREMENT
    ),
    CHECK (Member_Type IN ('Dep_Member', 'Researcher', 'Graduate', 'Undergraduate', 'Candidate_Lecturer')),
    CHECK (Rank = NULL OR Member_Type = 'Dep_Member')
);

CREATE TABLE IF NOT EXISTS Classes (
    Title            VARCHAR (50),
    Semester_Offered INTEGER NOT NULL,
    Is_Graduate      BOOLEAN NOT NULL,
    PRIMARY KEY (
        Title
    )
);

CREATE TABLE IF NOT EXISTS Announcements (
    announcement_Id INTEGER,
    Date_Posted     DATE NOT NULL,
    Content         VARCHAR (1000) NOT NULL,
    PRIMARY KEY (
        announcement_Id AUTOINCREMENT
    )
);

CREATE TABLE IF NOT EXISTS Research_Projects (
    Project_Title VARCHAR (50),
    Funder      VARCHAR (50),
    Budget      NUMERIC (8, 2),
    Start_Date  DATE NOT NULL,
    End_Date    DATE,
    Completed   BOOLEAN,
    PRIMARY KEY (
        Project_Title
    ),
    CHECK (End_Date = NULL OR Start_Date <= End_Date)
);

CREATE TABLE IF NOT EXISTS Publications (
    Publication_Title   VARCHAR (50),
    Publisher           VARCHAR (50) NOT NULL,
    Category            VARCHAR (22) NOT NULL,
    Topic               VARCHAR (50) NOT NULL,
    Year_Published      NUMERIC(4,0), CHECK (Year_Published > 1900),
    PRIMARY KEY (
        Publication_Title
    ),
    CHECK (Category IN ('Article', 'Conference_Proceedings', 'Book'))
);

CREATE TABLE IF NOT EXISTS Has_Authored (
    unique_Id        INTEGER,
    Publication_Title   INTEGER,
    PRIMARY KEY (
        unique_Id, Publication_Title
    ),
    
    FOREIGN KEY (unique_Id)
        REFERENCES Lab_Members
            ON DELETE CASCADE,
   
    FOREIGN KEY (Publication_Title)
        REFERENCES Publications
            ON DELETE CASCADE           
);

CREATE TABLE IF NOT EXISTS Has_Supervised (
    unique_Id        INTEGER,
    Project_Title    INTEGER,
    PRIMARY KEY (
        unique_Id, Project_Title
    ),
    
    FOREIGN KEY (unique_Id)
        REFERENCES Lab_Members
            ON DELETE CASCADE,
   
    FOREIGN KEY (Project_Title)
        REFERENCES Research_Projects
            ON DELETE CASCADE
            ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Teaches (
    unique_Id        INTEGER,
    Title            INTEGER,
    PRIMARY KEY (
        unique_Id, Title
    ),
    
    FOREIGN KEY (unique_Id)
        REFERENCES Lab_Members
            ON DELETE CASCADE,
   
    FOREIGN KEY (Title)
        REFERENCES Classes
            ON DELETE CASCADE
            ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Current_Project (
    unique_Id           INTEGER,
    Date                DATE, 
    Time_Created        TIME, 
    Total_Proj          INTEGER, 
    Total_Budget        INTEGER,
    PRIMARY KEY (
            unique_Id AUTOINCREMENT
    )
);

CREATE INDEX Member_Name ON Lab_Members(Full_Name);

CREATE TRIGGER Update_Current_Projects AFTER INSERT ON Research_Projects
    BEGIN
        INSERT INTO Current_Project(Date, Time_Created, Total_Proj, Total_Budget) 
        VALUES (CURRENT_DATE, CURRENT_TIME,
               (SELECT COUNT(*) FROM Research_Projects WHERE Completed = 0),
               (SELECT SUM(Budget) FROM Research_Projects WHERE Completed = 0));
    END;

CREATE TRIGGER Update_Current_Projects_2 AFTER UPDATE ON Research_Projects WHEN OLD.Completed = 0 AND NEW.Completed = 1
    BEGIN
        INSERT INTO Current_Project(Date, Time_Created, Total_Proj, Total_Budget) 
        VALUES (CURRENT_DATE, CURRENT_TIME,
               (SELECT COUNT(*) FROM Research_Projects WHERE Completed = 0),
               (SELECT SUM(Budget) FROM Research_Projects WHERE Completed = 0));
    END;