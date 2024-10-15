rm tests.log
logfile=tests.log
all_counter=0
passed_counter=0
failed_counter=0
failed_tests=()
for test in $@
do
    echo "---------------------------------------------">>$logfile
    echo "$test START" >> tests.log
    echo "---------------------------------------------">>$logfile
    $test >> tests.log 2>&1
    if [ $? -eq 0 ] ; then
        passed_counter=$((passed_counter+=1))
    else
        failed_counter=$((failed_counter+=1))
        failed_tests=("${failed_tests[@]}" $test)
        #failed_tests+="$test"
    fi
    all_counter=$((all_counter+=1))
    
done

echo "$all_counter tests done"
echo "$passed_counter tests passed"
echo "$failed_counter tests failed"
echo "---------------"
echo "failed tests:"
for failed_test in $failed_tests
do
    echo "-->    $failed_test"
    echo ""
done

