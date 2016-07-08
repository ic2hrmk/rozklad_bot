#!/usr/bin/ruby
$LOAD_PATH << '.'


require 'telegram/bot'
require 'rozklad'
require 'authorization'

TOKEN = Authorization::TOKEN

Telegram::Bot::Client.run TOKEN do |bot|
  bot.listen do |message|
    if !message.text.nil?
      parsed_comand = Rozklad::parse_user_input message.text

      case parsed_comand[0]
      when '/start'
        bot.api.send_message(chat_id: message.chat.id,
              text: "Доброго дня, #{message.from.first_name}!\n" +
                    "/group або /група - отримати інформацію по групах\n" +
                    "/teacher або /викладач - знайти викладача\n")
      when '/group', '/група'
        bot.api.send_message(chat_id: message.chat.id, text: Rozklad::student_schedule(parsed_comand), parse_mode: 'HTML')
      when '/teacher', '/викладач'
        bot.api.send_message(chat_id: message.chat.id, text: Rozklad::search_teacher(parsed_comand), parse_mode: 'HTML')
      else
        bot.api.send_message(chat_id: message.chat.id, text: "Мені шкода, але я не зрозумів Вашу команду...")
      end
    end
  end
end
