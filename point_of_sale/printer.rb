class Printer
  def print(products)
    File.open(OUTPUT_FILE, "w") do |file|
      products.each do |product|
        file.write product.join(" | ")
        file.write "\n"
      end
    end

    puts "Saving output to file #{OUTPUT_FILE}"
  end
end