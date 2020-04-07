class Api::V1::QuestionsController < Api::V1::ApiController
    before_action :convert_params, only: [:create, :update]
    #Método HTTP GET
    #url: */api/v1/questions
    #Retorna todos as questões não-deletadas.
    def index
        @questions = Question.all
        render json: @questions, status: :ok
    end
    #Método HTTP GET
    #url: */api/v1/questions/:id
    #Retorna uma única question baseado no id
    def show
        begin
            @question = Question.find(params[:id])
            render json: @question, status: :ok
        rescue ActiveRecord::RecordNotFound => e
            render json: {errors: {message: ["question with id #{params[:id]} not found"]}}, status: :not_found
        rescue StandardError => e
            render json: {errors: {message: ["Internal Problem while responding"]}}, status: :internal_server_error
        end
    end
    #Método HTTP POST
    #url: */api/v1/questions
    #Cria uma nova question e retorna o objeto criado com id
    def create
        begin
            @question = Question.new(question_params)
        rescue ArgumentError => e
            render json: {errors: {status: ["Invalid question type"]}}, status: :bad_request
            return
        end
        
        if @question.save
            params[:image] == nil ? {}: @question.content = url_for(@question.image)
            @question.save
            render json: @question, status: :created
            return
        end

        render json: {errors: @question.errors}, status: :bad_request
    end
    #Método HTTP PUT
    #url: */api/v1/questions/:id
    #Recebe como parametro quaisquer atributos de question e atualiza o modelo
    def update
        begin
            @question = Question.find(params[:id])
            if @question.update(question_params)
                params[:image] == nil ? {}: @question.content = url_for(@question.image)
                @question.save
                render json: @question, status: :ok
                return 
            end
            render json: {errors: @question.errors}, status: :bad_request

        rescue ActiveRecord::RecordNotFound => e
            render json: {errors: {message: ["question with id #{params[:id]} not found"]}}, status: :not_found
        rescue StandardError => e
            render json: {errors: {message: ["Internal Problem while responding"]}}, status: :internal_server_error
        end
    end
    #Método HTTP DELETE
    #url: */api/v1/users/:id
    #Realiza o soft delete através do paranoia do modelo.
    def destroy
        begin 
            @question = Question.find(params[:id])
            @question.destroy
            render json: {}, status: :no_content
        rescue ActiveRecord::RecordNotFound => e
            render json: {errors: {message: ["question with id #{params[:id]} not found"]}}, status: :not_found
        rescue StandardError => e
            render json: {errors: {message: ["Internal Problem while responding"]}}, status: :internal_server_error
        end
    end

    private
        def convert_params
            params[:question_type] == nil ? nil : params[:question_type] = params[:question_type].to_i
        end
        def question_params
            params.permit(:name, :question_type, :content, :formulary_id, :image)
        end
end
