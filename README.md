# テーブル設計

## users テーブル

| Column             | Type   | Options     |
| ------------------ | ------ | ----------- |
| nickname           | string | null: false |
| email              | string | null: false, unique: true |
| encrypted_password | string | null: false |

### Association

- has_many :posts
- has_many :comments

## posts テーブル

https://developer.spotify.com/documentation/web-api/reference/get-multiple-shows

| Column | Type   | Options     |
| ------ | ------ | ----------- |
| name   | string | null: false |
| name   | string | null: false |
| name   | string | null: false |
| name   | string | null: false |
| name   | string | null: false |

### Association

- belongs_to :room
- belongs_to :user

## messages テーブル

| Column  | Type       | Options                        |
| ------- | ---------- | ------------------------------ |
| content | string     |                                |
| user    | references | null: false, foreign_key: true |
| room    | references | null: false, foreign_key: true |

### Association

- belongs_to :room
- belongs_to :user