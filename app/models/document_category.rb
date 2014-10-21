class DocumentCategory < ActiveRecord::Base
  has_many :documents, dependent: :nullify
  
  validates :name, presence: true, uniqueness: true
  
  def self.default
    first
  end
end
