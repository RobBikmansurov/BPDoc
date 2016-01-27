# encoding: utf-8
namespace :bp1step do

  desc 'Set values metrics from local PG SQL'
  task :set_values_PG => :environment do  # заполнить значения метрик, получаемых из локального pgSQL
    # отбирает метрики с типом 'localPG', исполняет SQL-запрос и заносит результат как текущее значение метрики
    logger = Logger.new('log/bp1step.log')  # протокол работы
    logger.info '===== ' + Time.now.strftime('%d.%m.%Y %H:%M:%S') + ' :set_values_PG'

    count = 0
    Metric.where(mtype: 'localPG').each do | metric |  # метрики с типом 'localPG'
      count += 1
      ('2016-01-01'.to_datetime.to_i .. '2016-01-27'.to_datetime.to_i).step(1.day) do |datei|
        date = Time.at(datei)
        sql = Metric.find(metric.id).msql
        sql.gsub!(/\r\n?/, " ") #заменим \n \r на пробелы
        #puts "#{date} #{metric.shortname}: #{sql}"
        #date = Time.current
        sql_period = case metric.depth
          when 1 then "'#{date.beginning_of_year}' AND '#{date.end_of_year}'"   # текущий год
          when 2 then "'#{date.beginning_of_month}' AND '#{date.end_of_month}'" # текущий месяц
          when 3 then "'#{date.beginning_of_day}' AND '#{date.end_of_day}'"     # текущий день
          else "'#{date.beginning_of_hour}' AND '#{date.end_of_hour}'"          # текущий час
        end
        sql.gsub!(/##PERIOD##/, sql_period) #заменим \n \r на пробелы
        begin
          results = ActiveRecord::Base.connection.execute(sql)
        rescue
          logger.info "      ERR: #{sql}"
        end
        if results
          result = results.first
          if result['count'].present?
            new_value = result['count']
            value = MetricValue.where(metric_id: metric.id).where("dtime BETWEEN #{sql_period}").first
            if !value  # не нашли?
              value = MetricValue.new()  # новое значение
              value.metric_id = metric.id
            end
            value.dtime = date  # обновим время записи значения
            value.value = new_value
            value.save
          end
        end
      end
    end
    logger.info "      localPG: #{count} metrics"
  end


  desc 'Set values metrics from MS SQL'
  task :set_values_MSSQL => :environment do  # заполнить значения метрик, получаемых из локального pgSQL
    # отбирает метрики с типом 'localPG', исполняет SQL-запрос и заносит результат как текущее значение метрики
    logger = Logger.new('log/bp1step.log')  # протокол работы
    logger.info '===== ' + Time.now.strftime('%d.%m.%Y %H:%M:%S') + ' :set_values_MSSQL'

    count = 0
    errors = 0
    Metric.where(mtype: 'MSSQL').each do | metric |  # метрики с типом 'MSSQL'
      count += 1
      sql = metric.msql
      sql.gsub!(/\r\n?/, " ") #заменим \n \r на пробелы

      ('2016-01-01'.to_datetime.to_i .. '2016-01-27'.to_datetime.to_i).step(1.day) do |date|
        #date = Time.current
        sql_period = case metric.depth
          when 1 then "'#{date.beginning_of_year}' AND '#{date.end_of_year}'"   # текущий год
          when 2 then "'#{date.beginning_of_month}' AND '#{date.end_of_month}'" # текущий месяц
          when 3 then "'#{date.beginning_of_day}' AND '#{date.end_of_day}'"     # текущий день
          else "'#{date.beginning_of_hour}' AND '#{date.end_of_hour}'"          # текущий час
        end
        sql.gsub!(/##PERIOD##/, sql_period) #заменим \n \r на пробелы
        begin
          results = ActiveRecord::Base.connection.execute(sql)
        rescue
          logger.info "      ERR: #{sql}"
          errors += 1
        end
        if results
          result = results.first
          if result['count'].present?
            new_value = result['count']
            value = MetricValue.where(metric_id: metric.id).where("dtime BETWEEN #{sql_period}").first
            if !value  # не нашли?
              value = MetricValue.new()  # новое значение
              value.metric_id = metric.id
            end
            value.dtime = date  # обновим время записи значения
            value.value = new_value
            value.save
          end
        end
      end
    end
    logger.info "      localPG: #{count} metrics, #{errors} errors"
    p "      localPG: #{count} metrics, #{errors} errors"
  end


end
