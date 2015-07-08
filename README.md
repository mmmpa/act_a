[![Build Status](https://travis-ci.org/mmmpa/act_a.svg)](https://travis-ci.org/mmmpa/act_a)
[![Coverage Status](https://coveralls.io/repos/mmmpa/act_a/badge.svg?branch=master)](https://coveralls.io/r/mmmpa/act_a?branch=master)
[![Code Climate](https://codeclimate.com/github/mmmpa/act_a/badges/gpa.svg)](https://codeclimate.com/github/mmmpa/act_a)


# ActA

ActAは`ActiveRecord`というか`ActiveModel`のvalidationを指定したもののみ行い、`valid?`を得るものです。

```rb
class Model < ActiveRecord::Base
  validates :str, :txt,
    presence: true

  validate :validate_str

  def validate_str
    errors.add(:str, :validate_str) if str == '失敗する'
  end
end
```

```rb
model = Model.new

model.assign_attributes(str: '文字列').valid?
# false
```

```rb
actor = ActA.(Model)

actor.apply(str: '文字列').valid?
# true
actor.apply(str: '').valid?
# false
```

ただしActAの`valid?`では`validates`で与えられたバリデーションしか行えないので、実際のモデルで行われる`valid?`同等のことをするには`valid_brutally?`を使う。

```rb
actor = ActA.(Model)

actor.apply(str: '失敗する').valid?
# true
actor.apply(str: '失敗する').valid_brutally?
# false
```

# Installation

```rb
gem 'act_a'
```

```
bundle install
```

# Usage

```rb
actor = ActA.(Model)
# <ActA::Actor:0x007f5577929388...

actor.apply(str: '文字列')
# <ActA::Validator:0x007f438907a250...

actor.apply(str: '文字列') == actor.apply(str: '文字列')
# false
```

```rb
actor.apply(str: '文字列').validate!
# not raise exception

actor.apply(str: '文字列', txt: '').validate!
# raise ActiveRecord::RecordInvalid

actor.apply(str: '失敗する').validate_brutally!
# raise ActiveRecord::RecordInvalid
```

```rb
actor.apply(str: '').validate.errors
# #<ActiveModel::Errors:0x007fad97b15368 @base=#<Model id: nil, str: "", txt: nil, created_at: nil, updated_at: nil>, @messages={:str=>["can't be blank"]}>

actor.apply(str: '').validate.messages
# {:str=>["can't be blank"]}

actor.apply(str: '').validate.valid?
# false

actor.apply(str: '文字列').validate.messages
# {}

actor.apply(str: '文字列').validate.valid?
# true
```
