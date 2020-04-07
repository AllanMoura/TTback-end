class User < ApplicationRecord
  acts_as_paranoid
  has_secure_password # Realiza a encriptação e armazenamento no digest
  has_many :visits, dependent: :destroy #um usuário pode ter diversas visitas, destruir(soft) os filhos

  validates :name,
    presence: true
  # Realizar validação somente quando a variavel password for setada, pois a senha é salva em password_digest
  # Permitindo realizar updates sem a necessidade de reinserir a senha
  validates :password, 
    length: { minimum: 7, maximum: 30 },
    format: { with: /\A[a-zA-z0-9]+\z/, message: "Only Allow Letters and digits" },
    if: :password_set?
    
  validates :password_digest,
    presence: true
  
  validates :email,
    presence: true,
    uniqueness: true,
    format: { with: URI::MailTo::EMAIL_REGEXP , message: "Make sure that it is a valid email format" }

  validates :cpf,
    presence: true,
    uniqueness: true,
    length: {minimum: 11, maximum: 11 },
    format: { with: /\A[0-9]+\z/, message: "CPF must contain only numbers"},
    cpf: true


  private
    #Método para checar se o password está setado e realizar a validação
    def password_set?
      password != nil
    end
end
