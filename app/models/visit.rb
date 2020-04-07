class Visit < ApplicationRecord
  acts_as_paranoid
  belongs_to :user
  has_many :answers, dependent: :destroy

  enum status: { PENDENTE: 0, REALIZANDO: 1, REALIZADO: 2}

  validates :date,
    date: true, #Date é um validator customizado
    presence: true

  validates :checkin_at,
    checks: true #Checks é um validator customizado

  validates :checkout_at,
    checks: true


end
