require 'sqlite3'

IMPORT_PRODUCT_PATH = 'data/products.txt'

class Database
  attr_accessor :db
 
  def prepare
    puts "Creating database"
    create_database
    puts "Creating tables"
    create_tables
    puts "Empty the database values"
    destroy_values
    puts "Inserting values"
    insert_values
  end

  private
  def create_database
    @db = SQLite3::Database.new "point_of_sale.db"
  end

  def create_products_table
    rows = db.execute <<-SQL
      create table if not exists products (
        name varchar(30),
        barcode int
      );
    SQL
  end

  def create_tables
    create_products_table
  end

  def insert_products
    File.open(IMPORT_PRODUCT_PATH, "r").read.split("\n").each do |product|
      product_values = product.split(";")    
      
      db.execute "insert into products values ( ?, ? )", product_values
    end
  end

  def insert_values
    insert_products
  end

  def destroy_values
    db.execute "delete from products"
  end
end