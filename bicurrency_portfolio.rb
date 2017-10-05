require 'net/http'
require 'rexml/document'
require_relative 'lib/cb_rate'

def print_result(d_usd, usd_to_sell, rub_to_sell)
  if d_usd == 0
    puts "Портфель сбалансирован."
    exit
  elsif d_usd > 0
    puts "Вам нужно продать #{usd_to_sell} $"
  else
    puts "Вам нужно продать #{rub_to_sell} руб."
  end
end

URL = "http://www.cbr.ru/scripts/XML_daily.asp"

rate = CbRate.new(URL).to_f
puts "Курс доллара: #{rate}"
puts

sum_rub = 'rub'
sum_usd = 'usd'
regexp = /^\d*(\.)?\d\d?/

until sum_rub.match?(regexp) && sum_usd.match?(regexp)
  puts "Внимание! Можно использовать только цифры;"
  puts "дробная часть (2 знака) отделяется '.'!"
  puts
  puts "Сколько у вас рублей?"
  sum_rub = gets.chomp
  puts "Сколько у вас долларов?"
  sum_usd = gets.chomp
end

d_usd = (sum_usd.to_f - (sum_rub.to_f / rate)).round(2)
usd_to_sell = (d_usd.abs / 2).round(2)

d_rub = (d_usd.abs * rate).round(2)
rub_to_sell =(d_rub / 2).round(2)

print_result(d_usd, usd_to_sell, rub_to_sell)
