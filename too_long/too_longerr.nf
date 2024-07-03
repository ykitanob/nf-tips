// Nextflow script for too long error
nextflow.enable.dsl=2
params.outdir=System.getProperty("user.dir") // path to current directory
params.pathlist="final.list.txt" //filename
params.input="uuid_fortest.txt"


Channel
   .from(file(params.input))
   .splitText()
   .map { it.trim() }
   .set {inputid}


process touch_files {
    cpus = 1
    errorStrategy 'retry'
    maxRetries 2
    maxErrors 5
    publishDir "touch_files", mode:'copy'
  //  executor 'slurm'
  //  queue 'default-partition'
    publishDir 'touch_files'

    input:
    val i
    output:
    path("${out_file}"), emit: touch_file
    path("${out_file}.index"), emit: touch_file_index 
   script:
    out_file="${i}.metcyamecya_ninagaifilenamegatsuiteirutosuru.mottonagaihougayoi.txt"
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
    maxErrors 1
    //executor 'slurm'
    //queue 'default-partition'
    publishDir "${params.outdir}", mode:'symlink'
    input:
    path(file_list)
    path(file_list_index)
    output:
    path("kaisekikekka.txt")
    // shellにした場合エラーになる。scriptにするとエラーにならない。どうしてもshellにしたい場合だけこのtipsが使える。
    shell:
    """
    echo ${file_list.collect {" --v $it "}.join()} > kaisekikekka.txt
    """
}


workflow {
    range = Channel.from(1..3000)

    file=touch_files(inputid)
    too_long_error(file.touch_file.collect(),file.touch_file_index.collect())

}
