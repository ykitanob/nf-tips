# README.md

これはNextflowを実行した際に遭遇した問題とその回避策についてのメモです。

(1) 解析ツールがエラーを返す場合と解析サーバーがエラーを返す場合の区別がつかない。
    → スクリプトにエラーハンドリングを記述する
   - error_code/main.nf

！未解決(2) Groovyには「string too long」という既知のエラーがあります。https://github.com/nextflow-io/nextflow/issues/4689

- too_longerr.nf
   エラーを再現するためのワークフロー（注：WSL2/UbuntuにインストールされたNextflow 24-04では再現しませんでした）
- too_long/main.nf
   エラーを回避するために作成されたワークフロー


-----

This is a memo about the problems encountered when dealing with Nextflow and their workarounds.

(1) Unable to differentiate between when the analysis tool returns an error and when the analysis server returns an error.
    → Write error handling in the script
   - error_code_cannot_handle.nf

!! unsolved (2) There is a known error in Groovy that outputs "string too long".
https://github.com/nextflow-io/nextflow/issues/4689

- too_longerr.nf
   Workflow for reproducing the error (Note: It did not reproduce in Nextflow 24-04 installed on WSL2/Ubuntu)
- avoid_too_longerr.nf
   Workflow created to avoid the error
