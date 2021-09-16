echo "This is a simple Executer Wrapper Script!"
curl http://users.cis.fiu.edu/~ggome002/files/hrami024.csv > hrami024.csv
time ./user_add.exe hrami024.csv
echo 'Done!'