DB_NAME = "point_of_sale.db"
IMPORT_PRODUCT_PATH = 'data/products.txt'
DATABASE_SUBCLASS_PATH = 'point_of_sale/database/*.rb'
KLASS_TABLE = ["Database::Product"]
OUTPUT_FILE = "output.txt"

Dir["./point_of_sale/*.rb"].each { |file| require file }

class PointOfSale
  attr_accessor :products_scanned

  def initialize
    @products_scanned = []
  end

  def start
    Database.new.prepare
    puts "start"
    repeat_console
  end

  private
  def repeat_console
    choice = 0
    while choice != 2 do
      puts "Press buttons below to:"
      puts "1. Scan product"
      puts "2. Exit"
      choice = gets.to_i
      if choice == 1
        scan_product
      elsif choice == 2
        print_products
      end
    end
    puts "Thank you for using our system. All yours scans are exported to file."
  end

  def scan_product
    scan = Scanner.new.scan
    products = Database::Product.find_by(barcode: scan)
    if products.count > 0
      product = products.first
      Display.new.display(product)
      products_scanned << product
    else
      puts "Cant find product with such a barcode"
    end
  end

  def print_products
    Printer.new.print(products_scanned)
  end
end

PointOfSale.new.start