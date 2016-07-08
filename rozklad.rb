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

    begin
      data = JSON.load(open(create_request_for_group(group)))
      raise "Інформація відсутня!" if data["statusCode"] == 404
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

  def self.search_teacher command
    command.delete_at 0

    if command.empty? || command.size > 4
      return "Вкажіть дані у форматі: /teacher <i>початок прізвища</i>"
    end

    initials = command.select { |e| /\A[A-Za-zА-ЯЄІа-яєі']{1,20}\z/ =~ e }
    return "Введені дані мають неприпустимий формат!" if !initials.eql? command

    begin
      data = JSON.load(open(create_request_for_teacher(initials)))
      raise "Інформація відсутня!" if data["statusCode"] == 404
    rescue
      return "Інформація про викладача з такими параметрами не знайдена!"
    end

    return teachers_compilation data
  end

  def self.parse_user_input input
    input.downcase!
    return input.split
  end

  private
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

    def self.teachers_compilation data
      output_data = "За запитом знайдено:"

      data["data"].each do |teacher|
        output_data += "\n\n<b>ПІБ</b>: #{teacher["teacher_name"]}" +
                       "\nid на сайті: #{teacher["teacher_id"]}" +
                       "\nрейтинг: #{teacher["teacher_rating"]}" +
                       "\n<a href='#{teacher["teacher_url"]}'>Відкрити на rozklad.kpi.ua</a>"
      end

      return "<i>Дивно, але на сервері не вистачає даних!</i>\n" if output_data == "За запитом знайдено:"
      return output_data
    end

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

    def self.create_request_for_teacher initials
      uri = Addressable::URI.parse(SITE_ADDRESS + "/v2/teachers/?search={'query':'#{initials.join(' ')}'}")
      return uri.normalize.to_s
    end
end
