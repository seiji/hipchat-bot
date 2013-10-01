hipchat-bot
===========

this is hipchat bot test.

### Usage
```ruby
bot = Hinch::Bot.new do
  configure do |c|
    c.jid      = 'your jid'
    c.room     = 'your room'
    c.nick     = 'your nick'
    c.password = 'your password'                                                                                                                                                                                   
  end
end

bot.connect.run
```

