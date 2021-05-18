# 実践 Terraform

sample codes

[https://github.com/tmknom/example-pragmatic-terraform](https://github.com/tmknom/example-pragmatic-terraform)

Setting

```zsh
export AWS_DEFAULT_REGION=ap-northeast-1
```

## 2 基本操作

```zsh
terraform init
terraform plan
terraform apply
terraform destroy
```

`.tfstate`: Terraform が作成し、現在の状況を記録する

## 全体設計

第5章から Web システムの全体設計をする

* 第5章「権限管理」：IAMポリシー、IAMロール
* 第6章「ストレージ」：S3
* 第7章「ネットワーク」：VPC、NATゲートウェイ、セキュリティグループ
* 第8章「ロードバランサーとDNS」：ALB、Route53、ACM
* 第9章「コンテナオーケストレーション」：ECS Fargate
* 第10章「バッチ」：ECSScheduledTasks
* 第11章「鍵管理」：KMS
* 第12章「設定管理」：SSMパラメータストア
* 第13章「データストア」：RDS、ElastiCache
* 第14章「デプロイメントパイプライン」：ECR、CodeBuild、CodePipeline
* 第15章「SSHレスオペレーション」：EC2、SessionManager
* 第16章「ロギング」：CloudWatchLogs、KinesisDataFirehose
