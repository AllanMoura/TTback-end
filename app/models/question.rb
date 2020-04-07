class Question < ApplicationRecord
  acts_as_paranoid
  belongs_to :formulary
  has_many :answers, dependent: :destroy

  has_one_attached :image

  enum question_type: { TEXT: 0, IMAGE: 1}

  validates :name, presence: true, uniqueness: true
end
