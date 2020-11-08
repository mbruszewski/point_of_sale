Dir["./point_of_sale/*.rb"].each { |file| require file }

class PointOfSale
  def self.start
    Database.new.prepare
    puts "start"
    repeat_console
  end

  private
  def self.repeat_console
    choice = 0
    while choice != 2 do
      puts "Press buttons below to:"
      puts "1. Scan product"
      puts "2. Exit"
      choice = gets.to_i
    end
    puts "Thank you for using our system. All yours scans are exported to file."
  end
end

PointOfSale.start