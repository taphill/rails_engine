require 'csv'

# cmd = "pg_restore --verbose --clean --no-acl --no-owner -h localhost -U $(whoami) -d rails_engine_development db/data/rails-engine-development.pgdump"
# puts "Loading PostgreSQL Data dump into local database with command:"
# puts cmd
# system(cmd)

items_data = CSV.read('./db/data/items.csv', headers: true)

items_data.each do |item|
  id = item['id'].to_i
  mid = item['merchant_id'].to_i
  name = item['name']
  description = item['description']
  price = item['unit_price'].to_i / 100.0

  Item.create!(id: id, merchant_id: mid, name: name, description: description, unit_price: price)
end

ActiveRecord::Base.connection.tables.each do |t|
  ActiveRecord::Base.connection.reset_pk_sequence!(t)
end
