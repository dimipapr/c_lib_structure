RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
echo "">tests/stderr.log
echo "">tests/stdout.log
all_counter=0
passed_counter=0
failed_counter=0
failed_tests=()
for i in $@
do
    # echo "---------------------------------------------">>$logfile
    # echo "$test START" >> tests.log
    # echo "---------------------------------------------">>$logfile
    # $test >> tests.log 2>&1
    # if [ $? -eq 0 ] ; then
    #     passed_counter=$((passed_counter+=1))
    # else
    #     failed_counter=$((failed_counter+=1))
    #     failed_tests=("${failed_tests[@]}" $test)
    #     #failed_tests+="$test"
    # fi
    # all_counter=$((all_counter+=1))
    if test -f $i
    then
        if ./$i >>./tests/stdout.log 2>>./tests/stderr.log 
        then
            echo -e "$i ${GREEN}PASS${NC}"
        else
            echo -e "$i ${RED}FAIL${NC}"
            echo "--------stderr--------" 
            tail ./tests/stderr.log
            echo "--------stderr--------" 

            exit 1
        fi
    fi
    
done

echo "$all_counter tests done"
echo -e "${GREEN}ALL TESTS PASSED${NC}"
# echo "$passed_counter tests passed"
# echo "$failed_counter tests failed"
# echo "---------------"
# echo "failed tests:"
# for failed_test in $failed_tests
# do
#     echo "-->    $failed_test"
#     echo ""
# done

