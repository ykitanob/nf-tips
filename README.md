# README

これはNextflowを実行した際に遭遇した問題とその回避策についてのメモです。

### (1) 解析ツールがエラーを返す場合と解析サーバーがエラーを返す場合の区別がつかない。
#### ->  スクリプトにエラーハンドリングを記述する
   - error_code/main.nf

##### 試し方：
   -  nextflowをインストールする
   - このリポジトリをpullする
   ``` git clone https://github.com/ykitanob/nf-tips.git```
   - 実行コマンド
   ``` nextflow error_code/main.nf ```
   
##### 実行結果：
   ![alt text](image.png)


### (2) Groovyには「string too long」という既知のエラーがあります。
https://github.com/nextflow-io/nextflow/issues/4689
#### -> MaxFork1を指定して動的にリストを生成するプロセスを追加する

- too_long/too_longerr.nf
   エラーを再現するためのワークフロー（注：WSL2/UbuntuにインストールされたNextflow 24-04では再現しませんでした）
- too_long/main.nf
   エラーを回避するために作成されたワークフロー

##### 試し方：
   -  nextflowをインストールする
   - このリポジトリをpullする
   ``` git clone https://github.com/ykitanob/nf-tips.git```
   - 実行コマンド
   ``` nextflow too_long/main.nf ```
-----


# README

This is a memo about the problems encountered when dealing with Nextflow and their workarounds.
### (1) Unable to differentiate between when the analysis tool returns an error and when the analysis server returns an error.
   → Write error handling in the script
   - error_code_cannot_handle.nf
##### How to try:
   - Install Nextflow
   - Pull this repository
   ``` git clone https://github.com/ykitanob/nf-tips.git```
   - Execute the command
   ``` nextflow error_code_cannot_handle.nf ```
   
##### Execution result:
   ![alt text](image.png)
### (2) There is a known error in Groovy that outputs "string too long".
https://github.com/nextflow-io/nextflow/issues/4689
#### -> Add a process to dynamically generate a list with MaxFork1
- too_longerr.nf
   Workflow for reproducing the error (Note: It did not reproduce in Nextflow 24-04 installed on WSL2/Ubuntu)
- avoid_too_longerr.nf
   Workflow created to avoid the error
##### How to try:
   - Install Nextflow
   - Pull this repository
   ``` git clone https://github.com/ykitanob/nf-tips.git```
   - Execute the command
   ``` nextflow too_long/main.nf ```
