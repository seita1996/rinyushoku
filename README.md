# 離乳食スケジューラ

[![Brakeman Scan](https://github.com/seita1996/rinyushoku/actions/workflows/brakeman.yml/badge.svg)](https://github.com/seita1996/rinyushoku/actions/workflows/brakeman.yml)
[![CodeQL](https://github.com/seita1996/rinyushoku/actions/workflows/codeql.yml/badge.svg)](https://github.com/seita1996/rinyushoku/actions/workflows/codeql.yml)
[![ER Diagram](https://github.com/seita1996/rinyushoku/actions/workflows/er.yml/badge.svg)](https://github.com/seita1996/rinyushoku/actions/workflows/er.yml)
[![Ruby on Rails CI](https://github.com/seita1996/rinyushoku/actions/workflows/rubyonrails.yml/badge.svg)](https://github.com/seita1996/rinyushoku/actions/workflows/rubyonrails.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

離乳食のスケジュールを管理するシステムです

現時点でログイン機能はなく、自宅のサーバーでホストする前提となっています

## 機能概要

- 小児科が空いていない日曜・祝日に新規食材が重ならないよう、テンプレートをもとにスケジュールを自動作成します
  - 新規食材が重なった休日の離乳食は、直前のスケジュールの繰り返しとなります
  - 祝日は日本の休日に準拠します
  - 年末年始など、日曜・祝日以外で新規食材を食べさせたくない日は「カスタム休日」として設定できます
- テンプレートはCSV形式でインポート可能です
  - [テンプレートCSV例](https://github.com/seita1996/rinyushoku/blob/main/spec/fixtures/files/rinyushoku_success.csv)
  - CSV A列は、離乳食開始日を day:1 として何日目の食事にあたるかを整数で登録します
  - CSV B列以降は、食べさせる食材と量を自由に追加可能です
  - 複数行にわたりdayに同じ数が入っている（たとえばday:2が2行連続している）場合、それぞれの行が上から「1回食」「2回食」としてインポートされます
- 作成された離乳食スケジュールは、日付を絞り込み検索できます
  - 離乳食スケジュール検索期間に必要な全ての食材を集計できます
- 直近3日間のスケジュールを返す簡易なAPIを提供しています
  - アプリケーション同様、認証はかけていません
  - hostname/api/v1/schedules で利用できます
  - [homeboard](https://github.com/seita1996/homeboard)のFree Spaceにスケジュールを配置できます（※この場合、homeboardもホームサーバーにホストする必要があります）

## 開発環境構築

```
$ docker-compose build
$ docker-compose up -d
```

localhost:3000 へアクセス

## 仕様

- [Database](https://seita1996.github.io/rinyushoku/)

## デプロイ

```
$ cap home deploy
```
