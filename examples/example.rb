require 'poczta_polska'

package_id = 'testp0'
# this package ID generates test data

tr = PocztaPolska.tracker

begin
  pkg = tr.check(package_id)

  puts "A package was sent from #{pkg.office_from} to #{pkg.office_to}."

  pkg.events.each do |event|
    datetime = event.time.strftime("%F, %R")
    puts "Finally:" if event.final?
    puts "Time: #{datetime}"
    puts "Event: #{event.name}"
    puts "Post office: #{event.office}"
    puts
  end

rescue PocztaPolska::UnknownPackageError
  puts "The package couldn't be found"
rescue PocztaPolska::WrongPackageError
  puts "The package ID is wrong"
end
