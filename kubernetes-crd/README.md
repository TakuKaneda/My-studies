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
