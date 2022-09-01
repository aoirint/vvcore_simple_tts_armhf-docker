# vvcore_simple_tts_armhf-docker

```shell
# Dockerイメージのビルド
docker buildx build . --platform=linux/arm/v7 -t vvcore_simple_tts_armhf

# 環境の確認
docker run --rm -it --init --platform=linux/arm/v7 --entrypoint "" vvcore_simple_tts_armhf lscpu

# 出力先ディレクトリの作成（UID:GID=1000:1000）
mkdir -p ./work

# 音声合成の実行
time docker run --rm -it --init --platform=linux/arm/v7 -v "$PWD/work:/work" -w /work vvcore_simple_tts_armhf a
```

