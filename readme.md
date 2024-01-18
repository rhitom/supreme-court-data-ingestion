# SUPREME COURT DATABASE # 
Scraping, preprocessing, and loading data from Washinton University's historical supreme court dataset. 
Creating a schema for a database that can be used to build webpages for each case since 1791.


You'll find:
* An Python script that ingests, preprocesses, and loads data into the bp-dummy database
* A schema outlining the final database design
* A folder containing raw csv files and raw key tables 
* Three csv files for the main data tables 

## BP SCOTUS Database ##
The database is designed around three main data tables, which contain information on every case that has been argued before the U.S. Supreme Court from 1771-2022. Between the three tables, we have information across 24 total variables including voting outcomes, justice opinion, and the issue argued. All three tables are searchable by unique id, and information related to each case is identifiable using the caseId.

### SCOTUS_CASES ###
'scotus_cases' contains information relevant to the details of the case, including petitioner, respondent, citations and voting information.

### SCOTUS_TERMS ###
'scotus_terms' holds information about the chief justice and the term in which the case was argued.

### SCOTUS_JUSTICES ###
'scotus_justices' pertains to the justices on the court and how each justice voted.
 
## KEYS ##

Due to the normalization of several variables in the raw csvs, we decided to use eight key tables to reference variables with more than 15 normalizations. Variables with less than 15 normalizations were manually decoded in the ingestion script. 

KEY TABLES: scotus_case_votes, scotus_decision_directions, scotus_decision_types, scotus_disposition_types, scotus_issue_areas, scotus_issues, scotus_jurisdictions, scotus_litigants, scotus_opinion_types, scotus_vote_types
