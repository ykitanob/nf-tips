// Nextflow script for too long error
// https://github.com/nextflow-io/nextflow/issues/4689 これが起きた時の暫定対応
// なぜか、too longのエラーは再現できない。 （N E X T F L O W   ~  version 24.04.2で実行した場合）
// エラーに遭遇したのはv23.10なので、バージョン更新して現地環境でためす。直っているのかもしれない（？）
nextflow.enable.dsl=2
params.outdir="" // path to outdir
params.pathlist="final.list.txt" //filename

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
    date > ${out_file}    
    """
}

process too_long_error{
    // 1000個～のファイルを引数として渡す 
    //  遭遇したエラーは環境依存・バージョン依存かも？再現できていない
    cpus = 1
    errorStrategy 'retry'
    maxRetries 2
    maxErrors 5
    publishDir "${params.outdir}", mode:'copy'
    input:
    path(file_list)
    val(name)
    output:
    path("kaisekikekka.txt")
    script:
    """
    for line in ` cat ${file_list}`
    do cat \$line
    done  > kaisekikekka.txt
    """
}

process write_file{
    cpus ~ 1
    errorStrategy 'retry'
    maxRetries 2
    maxErrors 5
    maxForks 1
    publishDir "${params.outdir}", mode:'copy'
    input:
    path(filename)
    path("${params.outdir}/${params.pathlist}")
    output:
    val("${filename}"), emit: name
    script:
    """
    echo ${filename}
    ls `pwd`/${filename} >> "${params.outdir}/${params.pathlist}"
    """
}

workflow {
    range = Channel.from(1..1000)
    file=touch_files(range)
    write = write_file(file.touch_file,"${params.outdir}/${params.pathlist}")
    too_long_error("${params.outdir}/${params.pathlist}",write.name.collect())
}

