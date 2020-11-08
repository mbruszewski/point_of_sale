Dir["./point_of_sale/*.rb"].each { |file| require file }

class PointOfSale
  def self.start
    Database.new.prepare
    puts "start"
    repeat_console
  end

  def repeat_console
    while i==1 do
      puts "Press buttons below to:"
      puts "1. Scan product"
      puts "2. Exit"
    end
  end
end

PointOfSale.start