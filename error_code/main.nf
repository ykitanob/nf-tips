// ツールがエラーを返した場合でもどうにかしてnfはfailにならないようにする
params.tool= /path/to/"sample.sh"

process return_error {
    cpus = 1
    errorStrategy 'ignore'
    maxRetries 2
    maxErrors 5
    publishDir "return_error", mode:'copy'
    input:
    val i
    output:
    path("return_error${i}.txt")

    script:
    """
    bash ${params.tool} job${i} > return_error${i}.txt
    
    """
}
process avoid_tool_error{
    cpus = 1
    errorStrategy 'retry'
    maxRetries 2
    maxErrors 5
    publishDir "avoid_tool_error", mode:'copy'
    input:
    val i
    output:
    path("avoid_tool_error${i}.txt")

    script:
    """
    # エラーが返ってきた場合でもexit 0で終了するようにはできる
    bash ${params.tool} job${i} > avoid_tool_error${i}.txt || exit 0\

    """
}

process avoid2_tool_error{
    cpus = 1
    errorStrategy 'retry'
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
    bash ${params.tool} job${i} > avoid_tool_error${i}.txt 

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