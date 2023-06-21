require 'csv'
class Category < ApplicationRecord
  has_many :posts, dependent: :destroy
  validates_associated :posts
  validates :name, presence: true

  def self.to_csv
    attributes = %w[id name]

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.find_each do |category|
        csv << attributes.map { |attr| category.send(attr) }
      end
    end
  end

  def self.import(file)
    opened_file = File.open(file)
    options = { headers: true, col_sep: ',' }
    begin
      CSV.foreach(opened_file, **options) do |row|
        # map the CSV columns to your database columns
        category_hash = {}
        category_hash[:name] = row['name']

        category = Category.create(category_hash)
        raise StandardError, 'error' unless category.save
      end
    rescue StandardError => e
      e.message
    end
  end
end
