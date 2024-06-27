// Nextflow script for too long error

// なぜか、too longにならない。だめだこりゃ
nextflow.enable.dsl=2
params.outdir="/home/ykitano/avoid_too_long_err/nf-tips"

process touch_files {
    cpus = 1
    errorStrategy 'retry'
    maxRetries 2
    maxErrors 5
    publishDir "touch_files", mode:'copy'
    input:
    val i
    output:
    path("${out_file}"), emit: touch_file
    script:
    out_file="${i}.metcyamecya_ninagaifilenamegatsuiteirutosuru.mottonagaihougayoi.txt"
    """
    find . > ${out_file}    
    """
}

process too_long_error{
    // 1000個のファイルを引数として渡す 
    //  遭遇したエラーは環境依存・バージョン依存かも？これでは再現できていない。。
    cpus = 1
    errorStrategy 'retry'
    maxRetries 2
    maxErrors 5
    publishDir "too_long_error", mode:'copy'
    input:
    path(file_list)
    val(name)
    output:
    path("too_long_error.txt")
    script:
    """
    bash /home/ykitano/avoid_too_long_err/nf-tips/sample.sh ${file_list.collect {" --v $it "}.join()} > too_long_error.txt
    """
}

process write_file{
    cpus ~ 1
    errorStrategy 'retry'
    maxRetries 2
    maxErrors 5
    maxForks 1
    publishDir "too_long_error", mode:'copy'
    input:
    path(filename)
    path("${params.outdir}/too_long_error/file_list.txt")
    output:
    path("file_list.txt") , emit: pathlist
    val("${filename}"), emit: name
    script:
    """
    echo ${filename}
    ls `pwd`/${filename} >> file_list.txt
    """
}

workflow {
    range = Channel.from(1..1000)
    file=touch_files(range)
    write = write_file(file.touch_file,"${params.outdir}/too_long_error/file_list.txt")
    too_long_error("${params.outdir}/too_long_error/file_list.txt",write.name.collect())
}