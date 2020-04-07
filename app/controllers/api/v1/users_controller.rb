class Api::V1::UsersController < Api::V1::ApiController
    #Método HTTP GET
    #url: */api/v1/users
    #Retorna todos os usuários não-deletados.
    def index
        @users = User.all
        render json: @users, status: :ok
    end
    #Método HTTP GET
    #url: */api/v1/users/:id
    #Retorna um único usuário baseado no id
    def show
        begin
            @user = User.find(params[:id])
            render json: @user, status: :ok
            #render json: @user, include: ['visits'], status: :ok # Retornaria as associações também
        rescue ActiveRecord::RecordNotFound => e
            render json: {errors: {message: ["user with id #{params[:id]} not found"]}}, status: :not_found
        rescue StandardError => e
            render json: {errors: {message: ["Internal Problem while responding"]}}, status: :internal_server_error
        end
    end
    #Método HTTP POST
    #url: */api/v1/users
    #Cria um novo usuário e retorna o objeto criado com id
    def create
        begin
            @user = User.new(user_params)
        
            if @user.save
                render json: @user, status: :created
                return #O método render não finaliza a função, por isso o return
            end

            render json: {errors: @user.errors}, status: :bad_request
        rescue ActiveRecord::RecordNotUnique => e
            render json: {errors: {message: ["user with cpf #{params[:cpf]} already exists but deleted"]}}, status: :bad_request
        end
    end
    #Método HTTP PUT
    #url: */api/v1/users/:id
    #Recebe como parametro quaisquer atributos de usuário e atualiza o modelo
    def update
        begin
            @user = User.find(params[:id])
            if @user.update(user_params)
                render json: @user, status: :ok
                return 
            end
            render json: {errors: @user.errors}, status: :bad_request

        rescue ActiveRecord::RecordNotFound => e
            render json: {errors: {message: ["user with id #{params[:id]} not found"]}}, status: :not_found
        rescue StandardError => e
            render json: {errors: {message: ["Internal Problem while responding"]}}, status: :internal_server_error
        end
    end
    #Método HTTP DELETE
    #url: */api/v1/users/:id
    #Realiza o soft delete através do paranoia do modelo.
    def destroy
        begin 
            @user = User.find(params[:id])
            @user.destroy
            render json: {}, status: :no_content
        rescue ActiveRecord::RecordNotFound => e
            render json: {errors: {message: ["user with id #{params[:id]} not found"]}}, status: :not_found
        rescue StandardError => e
            render json: {errors: {message: ["Internal Problem while responding"]}}, status: :internal_server_error
        end
    end
    private
        #Função que permite a busca dos atributos de usuário
        def user_params
            params.permit(:name, :password, :email, :cpf)
        end

end
