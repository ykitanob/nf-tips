// Nextflow script for too long error
// https://github.com/nextflow-io/nextflow/issues/4689 これが起きた時の暫定対応
//　too_longerr.nfワークフローではエラーを再現することができる。
// このワークフローではエラーを回避するために、ファイルにパスを書き出している。

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
    path("${out_file}.index"), emit: touch_file_index 
   script:
    out_file="${i}.outputfile.txt"
    """
    date > ${out_file}   
    date >${out_file}.index 
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
    // shellにした場合エラーになる。scriptにするとエラーにならない。どうしてもshellにしたい場合だけこのtipsが使える。
    shell:
    """
    for line in ` cat ${file_list}`
    do echo -n " --v " ; echo -n \$line"\"
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
    path(filename_index)
    path("${params.outdir}/${params.pathlist}")
    output:
    val("${filename}"), emit: name
    script:
    """
    echo ${filename}
    echo `pwd`/`ls ${filename}` >> "${params.outdir}/${params.pathlist}"
    echo `pwd`/`ls ${filename}*`   >> "${params.outdir}/${params.pathlist}_check"  #indexが同じディレクトリにあることを確認
    """
}

workflow {
    range = Channel.from(1..1000)
    file=touch_files(range)
    write = write_file(file.touch_file,file.touch_file_index,"${params.outdir}/${params.pathlist}")
    too_long_error("${params.outdir}/${params.pathlist}",write.name.collect())
}

