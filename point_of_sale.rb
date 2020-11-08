Dir["./point_of_sale/*.rb"].each { |file| require file }

class PointOfSale
  def self.start
    Database.new.prepare
    puts "start"
  end
end

PointOfSale.start