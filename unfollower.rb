#!/bin/env ruby
# encoding: utf-8

require 'rubygems'
require 'bundler/setup'
require 'instagram'
require 'date'
require 'socket'
require_relative 'functions'

	#setting
	CLIENT_ID = ""
	CLIENT_SECRET = ""
	ACCESS_TOKEN = ""
	LOGIN = ""
	IP = ""
	MAX_UNFOLLOWS_PER_HOUR = 50  #max 60
	MAX_SLEEP_TIME = 3600 

	current_unfollow_count = 0

	puts "Unfollower instagram v 0.1"
	sleep 3

	#create client for instagram api
	begin
		client = Instagram.client(:client_id => CLIENT_ID, :client_secret => CLIENT_SECRET, :client_ips => IP, :access_token => ACCESS_TOKEN)
		puts "Авторизация инстаграм успешна"
		sleep 1
	rescue Exception => e
		puts "Ошибка авторизации"
		puts e.inspect
	end

	#get list follows current user
	begin
		puts "Получаем список подписок текущего пользователя(может занять продолжительное время)"
		old_follows_username = user_follows(LOGIN)
		sleep 1
	rescue Exception => e
		puts "Ошибки получения списка подписок"
		puts e.inspect
	end

	i = 0
	#unfollowing
	while i < old_follows_username.size

		begin
			users = client.user_search(old_follows_username[i])
    	uid = users[0][:id]
			response = client.unfollow_user(uid)

			case response.outgoing_status
			when "none"
				puts "[#{Time.now}]: Успешно отписались от #{old_follows_username[i]}"
			end

		rescue Exception => e
			puts "Ошибка во время анфоловинга"
			puts e.inspect
		end
		i+= 1
		current_unfollow_count += 1
		timer = rand(10) + 10
		sleep timer

		if current_unfollow_count == MAX_UNFOLLOWS_PER_HOUR
			puts " [#{Time.now}]: Достигнут лимит. Приостанавлеваем работу на #{MAX_SLEEP_TIME}"
			sleep MAX_SLEEP_TIME
		end

	end

	puts "[#{Time.now}]: Работа завершена"



