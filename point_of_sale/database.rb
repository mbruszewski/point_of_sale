require 'sqlite3'
require 'pry'

DB_NAME = "point_of_sale.db"
IMPORT_PRODUCT_PATH = 'data/products.txt'
DATABASE_SUBCLASS_PATH = 'point_of_sale/database/*.rb'

KLASS_TABLE = ["Database::Product"]

class Database
  attr_accessor :db

  def self.instance
    SQLite3::Database.new DB_NAME
  end
 
  def prepare
    puts "Creating database"
    create_database
    KLASS_TABLE.each do |klass_name|
      klass = Object.const_get(klass_name)
      puts "Creating tables for #{klass_name}"
      create_table(klass)
      puts "Empty the database values for #{klass_name}"
      destroy_values(klass)
      puts "Inserting values for #{klass_name}"
      insert_values(klass)
    end
  end

  private
  def create_database
    @db = Database.instance
  end

  def create_table(klass)
    klass.new.create_table
  end

  def destroy_values(klass)
    klass.new.destroy_values
  end

  def insert_values(klass)
    klass.new.insert_values
  end
end

class Database::Base
  attr_accessor :db

  def initialize
    @db = Database.instance
  end

  def create_table
    puts "Not implemented for a class!!!"
  end

  def self.find_by(hash)
    if hash.count == 1
      Database.instance.execute "SELECT * FROM #{get_table_name} WHERE #{hash.keys.first} = ?", hash.values.first
    else
      raise StandardError.new "You should provide only one key to hash !!!"
    end
  end

  private

  def self.get_table_name
    table_name = self.to_s
    table_name.slice!("Database::")
    table_name.downcase! + "s"
  end
end

class Database::Product < Database::Base
  def create_table
    db.execute <<-SQL
      create table if not exists products (
        name varchar(30),
        barcode int
      );
    SQL
  end

  def insert_values
    File.open(IMPORT_PRODUCT_PATH, "r").read.split("\n").each do |product|
      values = product.split(";")    
      
      db.execute "insert into products values ( ?, ? )", values
    end
  end

  def destroy_values
    db.execute "delete from products"
  end
end