require 'telegram/bot'

TOKEN = '230213563:AAHJRBX4vBjomVT0gwKx6PTUL0U1vJpKA7w'

module Rozklad
  require 'json'
  require 'open-uri'
  require 'addressable/uri'

  SITE_ADDRESS = "http://api.rozklad.org.ua"

  DAYS = ["понеділок", "вівторок", "середа", "четвер", "п'ятниця", "субота"]
  DAYS_CROPPED = ["пн", "вт", "ср", "чт", "пт", "сб"]

  def self.student_schedule command
    return "Вкажіть дані у форматі: /group група день\n<i>Якщо не буде вказано день - виведеться розклад на поточний тиждень.</i>" if command.count == 1 || command.count > 3
    command.delete_at 0

    group = command.find { |e| /\A[А-ЯЄІа-яєі]{2}[-][0-9]{2}\z/ =~ e }
      return "Невірно введена група! Повинна бути у форматі 'іс-32'" if group.nil?
    command.delete group

    if command.count == 1
      day = DAYS.index command[0].to_s.downcase
      day = DAYS_CROPPED.index command[0].to_s.downcase if day.nil?
    end

    return "Група не знайдена!" if !is_group_available group

    data = JSON.load(open(create_request_for_group(group)))
    begin
      raise 'Information not found!' if data["statusCode"] == 404
    rescue
      return "Помилка з'єднання з сервером #{SITE_ADDRESS}! Спробуйте пізніше!"
    end

    answer = "Група <b>#{group}</b>, поточний тиждень\n"

    if !day.nil?
        answer += "День: "  + DAYS[day] + "\n" + day_schedule(data, day)
    else
        answer += "Розклад на весь тиждень\n"
      for i in 0..5
        answer += "День: <b>"  + DAYS[i] + "</b>\n" + day_schedule(data, i)
      end
    end
    return answer
  end

  def self.day_schedule data, day
    output_data = ""

    data["data"].each do |lesson|
      if lesson["day_number"] == "#{day + 1}"
        output_data += lesson["lesson_number"] + ". " + lesson["lesson_name"] + " - <i>" + lesson["lesson_room"] + "</i>\n"
      end
    end

    return "<i>На цей день розклад відсутній!</i>\n" if output_data == ""
    return output_data
  end

  def self.parse_user_input input
    input.downcase!
    return input.split
  end

  private
    def self.is_group_available group
      begin
        uri = Addressable::URI.parse(SITE_ADDRESS + "/v2/groups/" + group)
        in_stock = JSON.load(open(uri.normalize.to_s))

      rescue StandardError
        puts "Unnable to fetch data from #{SITE_ADDRESS} for #{group}"
        return false
      end

      return true
    end

    def self.create_request_for_group group
      begin
        week_number = JSON.load(open(SITE_ADDRESS + "/v2/weeks"))

      rescue StandardError
        puts "Unnable to fetch data from #{SITE_ADDRESS}"
        return
      end

      link = SITE_ADDRESS + "/v2/groups/" + group.to_s + "/lessons?filter={'lesson_week': #{week_number["data"].to_i}}"

      uri = Addressable::URI.parse(link)
      return uri.normalize.to_s
    end
end

Telegram::Bot::Client.run TOKEN do |bot|
  bot.listen do |message|
    if !message.text.nil?
      parsed_comand = Rozklad::parse_user_input message.text
      if parsed_comand[0] == '/start'
        bot.api.send_message(chat_id: message.chat.id, text: "Доброго дня, #{message.from.first_name}!\n/group - отримати інформацію по групах")
      elsif parsed_comand[0] == '/group'
        bot.api.send_message(chat_id: message.chat.id, text: Rozklad::student_schedule(parsed_comand), parse_mode: 'HTML')
      else
        bot.api.send_message(chat_id: message.chat.id, text: "Мені шкода, але я не зрозумів Вашу команду...")
      end
    end
  end
end
