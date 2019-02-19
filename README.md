# sqoop-commands
Shell script to generate sqoop commands for data transfer between RDBMS and HDFS
Sqoop is a tool used to transfer data between RDBMS and HDFS.
Before running this shell script make sure you have the required database.
sqoop import : RDBMS -> HDFS.
sqoop export : HDFS -> RDBMS.
General format of sqoop import command -> sqoop import --connect jdbc:mysql://<ip address> <database name> --table <musql_table_name> --username <username> --password <password> --target-dir <target directory name>.
For table which doesnot have primary key we should use -m 1 (squential import) option along with the sqoop import command.
Incremental import - used to transfer only the additional rows added to the table. 
sqoop job - creates and saves the import and export commands. It specifies parameters to identify and recall the saved job.
to run the shell script use -> sh <filename>.
 

