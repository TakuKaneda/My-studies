# tutorial for datastore

https://cloud.google.com/datastore/docs/tools/datastore-emulator

Docs https://pkg.go.dev/cloud.google.com/go/datastore

- install jdk

Start emulator

```bash
❯ gcloud beta emulators datastore start --project test

❯ (gcloud beta emulators datastore env-init)
export DATASTORE_DATASET=test
export DATASTORE_EMULATOR_HOST=localhost:8081
export DATASTORE_EMULATOR_HOST_PATH=localhost:8081/datastore
export DATASTORE_HOST=http://localhost:8081
export DATASTORE_PROJECT_ID=test
```