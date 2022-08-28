# Currency Exchanger

### Описание

Приложение написано в рамках выполнения [тестового задания](https://github.com/aristofun/webdevdao/blob/master/test_assignments/currency_exchange_rails_api.md)

### Ruby version

```
ruby 3.1.2
```

### Rails version

```
rails 7.0.3.1
```

Postgresql version

```
postgresql 12.12
```

## Первый запуск

```
gem install bundler
bundle install
bundle exec rails db:create
bundle exec rails db:migrate
copy .env.template .env
```

Заполнить переменные окружения в `.env`

### Загрузить данные с [OpenExchangeRates](https://openexchangerates.org/)

```
bundle exec rake currencies:update
```

### Запуск сервера

```
bundle exec rails s
```

### Тесты

```
bundle exec rspec
```

## Документация API

Примеры запросов доступны по адресу http://localhost:3000/api-docs
