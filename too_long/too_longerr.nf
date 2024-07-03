// Nextflow script for too long error
nextflow.enable.dsl=2
params.outdir=System.getProperty("user.dir") // path to current directory
params.pathlist="final.list.txt" //filename

process touch_files {
    cpus = 1
    errorStrategy 'retry'
    maxRetries 2
    maxErrors 5
    publishDir "touch_files", mode:'copy'
  //  executor 'slurm'
  //  queue 'default-partition'
    input:
    val i
    output:
    path("${out_file}"), emit: touch_file
    path("${out_file}"), emit: touch_file_index 
   script:
    out_file="${i}.metcyamecya_ninagaifilenamegatsuiteirutosuru.mottonagaihougayoi.txt"
    """
    date > ${out_file}   
    date >${out_file}.index 
    """
}

process too_long_error{
    // 1000個～のファイルを引数として渡す 
    //  明示的にコマンドで利用しないが、インプットファイルと同一ディレクトリにあることがそうていされているインデックスをinputで渡すと発生する。インデックスなしだとtoo long errorは発生しなかった。
    cpus = 1
    errorStrategy 'retry'
    maxRetries 2
    maxErrors 5
   // executor 'slurm'
   // queue 'default-partition'
    publishDir "${params.outdir}", mode:'symlink'
    input:
    path(file_list)
    path(file_list_index)
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
    too_long_error(file.touch_file.collect(),file.touch_file_index.collect())

}
