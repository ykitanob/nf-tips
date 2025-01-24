// ツールがエラーを返した場合でもどうにかしてnfはfailにならないようにする
// Even if the tool returns an error, find a way to prevent nf from failing

// 2つのプロセスがエラーになるはず。
// Two processes should fail.
process return_error {
    cpus = 1
    errorStrategy 'ignore'
    maxRetries 2
    maxErrors 5
    publishDir "return_error", mode:'copy'
    input:
    val i
    output:
    path("avoid_tool_error${i}.txt")

    script:
    """
    function run_tool {
    if [ job${i} == "job1" ]
    then
        echo "job failed" > avoid_tool_error${i}.txt 
        return 128
    elif [ job${i} == "job4" ]
    then
        echo "job failed"
        echo "exit code 3 to 124 are tool error" > avoid_tool_error${i}.txt 
        return 4
    else
        echo "Job success" > avoid_tool_error${i}.txt 
    fi 
    }
    
    run_tool 

    
    """
}

// すべてのプロセスがexit0となり、failになるプロセスが無いはず。
//All processes should exit with code 0, and there should be no failing processes.
process avoid_tool_error{
    cpus = 1
    errorStrategy 'ignore'//'retry'
    maxRetries 2
    maxErrors 5
    publishDir "avoid_tool_error", mode:'copy'
    input:
    val i
    output:
    path("avoid_tool_error${i}.txt")

    script:
    """
    function run_tool {
    if [ job${i} == "job1" ]
    then
        echo "job failed" > avoid_tool_error${i}.txt 
        return 128
    elif [ job${i} == "job4" ]
    then
        echo "job failed"
        echo "exit code 3 to 124 are tool error" > avoid_tool_error${i}.txt 
        return 4
    else
        echo "Job success" > avoid_tool_error${i}.txt 
    fi 
    }
    
    run_tool || exit 0

    """
}

// exit codeが125より大きい（プログラムのエラー以外）はfailになるはず。failになるのは１つ
// All processes should exit with code 0, and there should be no failing processes.
process avoid2_tool_error{
    cpus = 1
    errorStrategy "ignore"//'retry'
    maxRetries 5
    maxErrors 5
    publishDir "avoid2_tool_error", mode:'copy'
    input:
    val i
    output:
    path("avoid_tool_error${i}.txt")

    script:
    """
    trap 'if [[ \$? -ge 3 && \$? -le 124 ]]; then exit 0; else exit \$?; fi' ERR

    function run_tool {
    if [ job${i} == "job1" ]
    then
        echo "job failed" > avoid_tool_error${i}.txt 
        return 128
    elif [ job${i} == "job4" ]
    then
        echo "job failed"
        echo "exit code 3 to 124 are tool error" > avoid_tool_error${i}.txt 
        return 4
    else
        echo "Job success" > avoid_tool_error${i}.txt 
    fi 
    }
    
    run_tool 


    """
}
//   # function error_handling {
//   #     original_exit_code=$?   
//   #     if [[ $original_exit_code != 1 ]]; then
//   #         echo $original_exit_code > /tmp/process_failed_flag
//   #         exit $original_exit_code
//   #     fi
//   # }


workflow {
    range = Channel.from(1..5)
    return_error(range)
    avoid_tool_error(range)
    avoid2_tool_error(range)
}   