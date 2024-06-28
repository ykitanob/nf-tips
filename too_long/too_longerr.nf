// Nextflow script for too long error
nextflow.enable.dsl=2
params.outdir=System.getProperty("user.dir") // path to current directory
params.pathlist="final.list.txt" //filename

process touch_files {
    cpus = 1
    errorStrategy 'retry'
    maxRetries 2
    maxErrors 5
    publishDir "${params.outdir}", mode:'copy'
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
    output:
    path("kaisekikekka.txt")
    script:
    """
    cat ${file_list.collect {" --v $it "}.join()} > kaisekikekka.txt
    #ls ${params.outdir}/${file_list} > kaisekikekka.txt
    """
}


workflow {
    range = Channel.from(1..1000)

    file=touch_files(range)
    too_long_error(file.touch_file.collect())

}