echo "Enter database name"
read database_name
rm -f sqoopcommands.txt
primaryKey=""
database_test=$(echo "use  $database_name" | mysql -u root)
echo $database_name >> sqoopcommands.txt
if [ "$database_test" == "" ]
then 
  rm -f listOfTables.txt
  sqoop list-tables --connect jdbc:mysql://localhost/$database_name >> listOfTables.txt 2>/dev/null
  while read tablename
  do
    echo "---------------------------" >> sqoopcommands.txt
    echo "$tablename" >> sqoopcommands.txt
    primaryKey=$(echo "show keys from $database_name.$tablename where key_name='PRIMARY'" | mysql -u root)
    if [ ! -z "primaryKey" ]
    then
     repeted_transfer=$((hadoop fs -ls /user/training/$tablename && echo "yes") || echo "no")
     if [[ $repeted_transfer == *"no"* ]]
     then
        echo "sqoop import --connect jdbc:mysql://localhost/$database_name --table ${tablename}" >> sqoopcommands.txt
     else
        echo "trying for incremental approach execute the following  sqoop job" >> sqoopcommands.txt
        echo "sqoop job --create <job_name> import --connect jdbc:mysql://localhost/$database_name --table $tablename --check-column <column_name> --incremental append --last-value 0" >> sqoopcommands.txt
        echo "sqoop job --exec <job_name>" >> sqoopcommands.txt
     fi 
    fi
    if [ ! "$primaryKey" ]
    then
     echo "sqoop import --connect jdbc:mysql://localhost/$database_name --table ${tablename} -m 1 " >> sqoopcommands.txt
    fi
  done < listOfTables.txt
fi
