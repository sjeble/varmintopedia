class Version < ActiveRecord::Base
  belongs_to :editor, class_name: "User"
  belongs_to :article
  has_many :categorizations, through: :article, :dependent => :destroy
  has_many :categories, through: :categorizations

  validates_presence_of :title, :body

  attr_writer :category_names

  after_save :assign_categories

  def category_names
    @category_names || categories.map(&:name).join(' ')
  end
    
  private
  
  def assign_categories
    if @category_names
      self.categories = @category_names.split(/\s+/).map do |name|
        Category.find_or_create_by(name: name)
      end
    end
  end
end