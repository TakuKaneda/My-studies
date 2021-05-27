# メモ

Sample code

- https://github.com/govargo/kubecontorller-book-sample-snippet
- https://github.com/govargo/sample-controller-kubebuilder
- https://github.com/govargo/sample-controller-operatorsdk

## 第1章

- api-server
  - kubectl からのリクエストを処理し、 Object の作成・更新など
  - etcd に唯一アクセスできる
- control loop
  - Desired state と Actual state を比較して、Desired に近づけるロジック

kubernetes はなぜ宣言的か？
障害などが発生した場合でも、望むべき状態を見失わない

### 1.2 Kubernetes の拡張機能

Custom Resource Definition (CRD): 独自の Resource を定義

3つの手法(自由度昇順)

1. Admission Webhook: API request を変更・検証する
   - Mutating Admission Webhook/Validation Admission Webhook
   - Pod の Default 値などはこれで実装
2. CRD: 独自のResourcesを定義
3. API Aggregation: 追加のAPIを実装
   - custom api-server を作る

- CRD と CR を作っても何も起こらない
  - control loop を実行する Controller が存在しないため
  - Custom Controller が CR を管理

### 1.5 CRD の応用機能

- Validation
  - CR の spec を チェックする
  - Apply 時に失敗させられる
  - Kubebuilder などを使う場合は yaml が自動生成される
- Additional Printer Columns
  - kubectl で Object を取得した際に、ターミナルに任意の値を出せる
  - `k get CR` で出せる
- SubResource
  - Resource にエンドポイントを実装
    - Pod では `/api/v1/namespace/<NS>/pods/<name>`
  - status と scale の2種類のみ
  - それ以上は API Aggregation が必要
  - Status SubResource
    - status だけを編集できるように
    - ユーザは spec, controller が status を担当
  - Scale SubResource
    - レプリカ数を増減
- Structural Schema
  - 構造化された CRD format
  - OpenAPI v3.0 validation schema に則った format
  - controller-tools を使って自動生成するので、意識することは少ない
  - 
