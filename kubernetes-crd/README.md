# メモ

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
