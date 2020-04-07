class Api::V1::FormulariesController < Api::V1::ApiController
    #Método HTTP GET
    #url: */api/v1/formularies
    #Retorna todos os formularios não-deletados.
    def index
        @formularies = Formulary.all
        render json: @formularies, status: :ok
    end
    #Método HTTP GET
    #url: */api/v1/formularies/:id
    #Retorna um único formulário baseado no id
    def show
        begin
            @formulary = Formulary.find(params[:id])
            render json: @formulary, status: :ok
        rescue ActiveRecord::RecordNotFound => e
            render json: {errors: {message: ["formulary with id #{params[:id]} not found"]}}, status: :not_found
        rescue StandardError => e
            render json: {errors: {message: ["Internal Problem while responding"]}}, status: :internal_server_error
        end
    end
    #Método HTTP POST
    #url: */api/v1/formularies
    #Cria um novo formulário e retorna o objeto criado com id
    def create
        @formulary = Formulary.new(formulary_params)
        if @formulary.save
            render json: @formulary, status: :ok
            return
        end
        render json: {errors: @formulary.errors}, status: :bad_request
    end
    #Método HTTP PUT
    #url: */api/v1/formularies/:id
    #Recebe como parametro quaisquer atributos de formulario e atualiza o modelo
    def update
        begin
            @formulary = Formulary.find(params[:id])
            if @formulary.update(formulary_params)
                render json: @formulary, status: :ok
                return
            end
            render json: {errors: @formulary.errors}, status: :bad_request

        rescue ActiveRecord::RecordNotFound => e
            render json: {errors: {message: ["formulary with id #{params[:id]} not found"]}}, status: :not_found
        rescue StandardError => e
            render json: {errors: {message: ["Internal Problem while responding"]}}, status: :internal_server_error
        end
    end
    #Método HTTP DELETE
    #url: */api/v1/formularies/:id
    #Realiza o soft delete através do paranoia do modelo.
    def destroy
        begin
            @formulary = Formulary.find(params[:id])
            @formulary.destroy
            render json: {}, status: :no_content
        rescue ActiveRecord::RecordNotFound => e
            render json: {errors: {message: ["formulary with id #{params[:id]} not found"]}}, status: :not_found
        rescue StandardError => e
            render json: {errors: {message: ["Internal Problem while responding"]}}, status: :internal_server_error
        end
    end

    private
        def formulary_params
            params.permit(:name)
        end
end
