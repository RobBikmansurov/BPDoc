# encoding: utf-8
namespace :bp1step do

  desc 'Сontrol of expiring duedate or soon deadline tasks'
  task :check_tasks_duedate => :environment do  # проверить задачи, не исполненные в срок
    logger = Logger.new('log/bp1step.log')  # протокол работы
    logger.info '===== ' + Time.now.strftime('%d.%m.%Y %H:%M:%S') + ' :check_overdue_tasks'

    count = 0
    count_soon_deadline = 0
    tasks = Task.soon_deadline | Task.overdue
    tasks.each do | task |  # задачи в статусе < Завершено с наступающим сроком исполнения или просроченные
      days = task.duedate - Date.current
      emails = ''
      emails = "#{task.author.email}" if days < 0 and task.author   # автор
      users = ''
      task.user_task.each do |user_task|  # исполнители
        if user_task.user
          emails += ', ' if !emails.blank?
          emails += "#{user_task.user.email}"
          users += "#{user_task.user.displayname}"
        end
      end
      logger.info "      #{emails}"
      emails = 'robb@bankperm.ru'
      if days < 0
        count += 1
        logger.info "      ##{task.id}\tсрок! #{task.duedate.strftime("%d.%m.%y")}: #{(-days).to_i}\t#{emails}"
        TaskMailer.check_overdue_tasks(task, emails).deliver_now if !emails.blank?
      else
        if [0, 1, 2, 5].include?(days)
          count_soon_deadline += 1
          logger.info "      ##{task.id}\tскоро #{task.duedate.strftime("%d.%m.%y")}: #{days.to_i}\t#{emails}"
          TaskMailer.soon_deadline_tasks(task, emails, days, users).deliver_now if !emails.blank?
      end
      end
    end
    logger.info "      #{count} tasks is duedate and #{count_soon_deadline} soon deadlinetasks"
  end



end
