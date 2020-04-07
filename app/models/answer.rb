class Answer < ApplicationRecord
  acts_as_paranoid
  
  belongs_to :formulary
  belongs_to :question
  belongs_to :visit

  validates :content, presence: true
  validates :answered_at, presence: true
end
