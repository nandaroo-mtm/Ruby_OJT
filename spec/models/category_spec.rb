require 'rails_helper'

RSpec.describe Category, type: :model do
  def create_category
    category = Category.new({name: 'testing category'}) 
    return category
  end

  it "is valid with valid attributes" do
    c = create_category
    expect(c).to be_valid
  end

  it "is valid with valid attributes" do
    c = create_category
    c.name = nil
    expect(c).to_not be_valid
  end
end
