class CpfValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
        unless valid_cpf?(value)
            record.errors[attribute] << (options[:message] || "is not a valid CPF")
        end
    end
  
    private
        #Método para verificar a validação do CPF
        #Para calcular o primeiro digito de verificação, multiplica os primeiros 9 digitos do cpf por 10
        #até 2 em ordem decrescente, exemplo: primeiro digito multiplacado por 10, segundo por 9, terceiro
        #por 8, etc...
        #soma os valores encontrados, realiza um mod de 11 do valor e subtrai o mod do valor 11
        #Para o segundo digito, o método se permanece, exceto que o multiplicador começa por 11 e o primeiro
        #digito verificador também faz parte.
        def valid_cpf?(cpf)
            #Caso o CPF tamanho da string cpf seja diferente de 11, é um cpf inválido, não podendo
            #checar a validação do cpf.
            if ( cpf == nil || cpf.length != 11 ) 
                return false
            end
            #Realizar o somatório dos primeiros 9 números multiplicados pelos seus modificadores.
            sum = 0
            for index in 0..8 do
                sum = sum + (cpf[index].to_i * (10 - index))
            end
            #Buscar o resto da divisão do somatório por 11
            firstDigit = sum % 11
            #Caso a sobra seja menor que 2, o valor será 0, se não, 11 menos a sobra
            if(firstDigit < 2)
                firstDigit = 0
            else
            firstDigit = 11 - firstDigit
            end
            #Checar o resultado com o 10º digito, se for igual, permanece checando, caso seja diferente
            #ja é invalidado
            if(firstDigit != cpf[9].to_i)
                return false
            end
            #Realizar o somatório dos primeiros 10 digitos multiplicados pelos seus modificadores
            sum = 0
            for index in 0..9 do
                sum = sum + (cpf[index].to_i * (11 - index))
            end
            secondDigit = sum % 11
            if (secondDigit < 2)
                secondDigit = 0
            else
            secondDigit = 11 - secondDigit
            end
            if(secondDigit != cpf[10].to_i)
                return false
            end
            return true;
        end
end
  