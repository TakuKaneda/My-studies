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
  - `k get <CR_NAME>` で出せる
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
- Pruning
  - CR のマニフェストに定義されていない spec フィールドを破棄
  - CRD が structural schema である前提
  - client & server で validation → etcd に保存されない
- Defaulting
  - CR のマニフェストの spec にデフォルト値
  - structural schema & pruning が必要
- Conversion
  - Version の異なる CRD の互換
  - v1beta <-> v1alpha <-> v1

### 1.6 Controller と CRD を自作するために必要なもの

複数手法ガルが、代表的なものは以下

1. Kubernetes Way (client-go + code-generator)
2. Kubebuilder
3. Operator SDK

- kubernetes way (client-go + code-generator)
  - 伝統的
    - 既存の実装方法
  - Sample Controller
    - CC を作る際にはじめに参考にすべき
    - これもそのライブラリで実装
  - 覚えること多く難しい
- kubebuilder
  - operator 用のフレームワーク
  - ロジックだけに集中できる
  - kubebuilder だけで controller, operator などの一式が揃う
- Operator SDK
  - Operator Framework の一種
  - kubebuilder と同様の機能

> controller と operator の違いとは？\
> それぞれの明確な定義無し！ただし、以下の違い
>
> - controller: CR の管理を行い、control loop を実行する
> - operator: CRD と CC のセット

## 第2章 client-go と周辺知識

- Kind: API Object の種類
  - Kind: Pod
- Resource: Kind と同じ意味で利用
  - pods, services
- Object: API Object の実態

- `client-go`
  - k8s のクライアントライブラリ
  - master (api-server) へのアクセスに利用
- `apimachinery`
  - API Object, API kile Obj 用の機能を備えたライブラリ

> `client-go` のバージョンに注意

Run sample code

- `clientset`: k8s の resource に対する client の集合体
  - standard resource にはアクセス可能だが
  - CR には不可
- `code-generator`: CR にアクセスするため

覚えておくべき components

- Informer: Object の監視と in-cache-memory にデータ格納
  - Watch api で added, modified などの event を監視
  - 毎回アクセスではなく、cache を利用
- Listener: in-cache-memory からデータ取得
- Workqueue: Controller が処理するアイテムを登録するキュー
- runtime.Object: 全 API Object 共通の Interface
- Scheme: Kubernetes API と Go Types の架け橋

WorkQueue

- DeltaFIFO とは別のもう一つの Queue
- Event 発生時に DeltaFIFO から pop したアイテムがキューに追加
- Reconciliation Loop のアイテムを貯めるのに利用
- kubernetes way でやるなら必要

runtime.Object

- k8s の API Object は `runtime.Object` Interface を満たす必要あり
  - GroupVersionKind (GVK)
    - API Group, Version, Kind のセット
    - ex) apps, v1, Deployment
    - RESTMapper: GroupVersionKind -> GroupVersionResource
  - Deep copy
    - in-cache-memory のデータを copy して利用

TypeMeta/ObjectMeta

- TypeMeta
  - Kind/APIVersion を持つ struct
- ObjectMeta
  - Name, Namespace, label などを持つ struct

```yaml
apiVersion: v1 # TypeMeta
kind: Pod      # TypeMeta
metadata:      # ObjectMeta
  name: nginx  # ObjectMeta
  labels:      # ObjectMeta
    run: nginx # ObjectMeta
```

Scheme

- k8s API の GVK と Go Types をひもづける
