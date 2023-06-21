require 'csv'
class Post < ApplicationRecord
  belongs_to :category
  has_one_attached :image, dependent: :destroy
  paginates_per 2

  validates :title, presence: { message: "Post title can't be blank" },
                    length: { minimum: 10, too_short: '%<count>s characters is the minimum allowed', maximum: 30, too_long: '%<count>s characters is the maximum allowed'}
  validates :content, presence: { message: "Content can't be blank" }, length: { minimum: 50, too_short: '%<count>s characters is the minimum allowed' }
  # validates :category_id, presence: true
  validates :category_id, presence: { message: 'choose one category!' }
  validates :image, attached: true,
                    processable_image: true,
                    content_type: ['image/png', 'image/jpeg', 'image/jpg']

  def self.to_csv
    attributes = %w[id title content category_id]

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.find_each do |post|
        csv << attributes.map { |attr| post.send(attr) }
      end
    end
  end

  def self.import(file)
    opened_file = File.open(file)
    options = { headers: true, col_sep: ',' }
    begin
      CSV.foreach(opened_file, **options) do |row|
        post = Post.create(title: row['title'], content: row['content'], category_id: row['category_id'])

        post.image.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'images.png')),
                          filename: 'images.png', content_type: 'image/png')
        raise StandardError, 'error' unless post.save
      end
    rescue StandardError => e
      e.message
    end
  end
end
