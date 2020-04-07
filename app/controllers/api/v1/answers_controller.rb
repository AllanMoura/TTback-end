class Api::V1::AnswersController < Api::V1::ApiController
    before_action :convert_params, only: [:create, :update]
    #Método HTTP GET
    #url: */api/v1/answers
    #Retorna todos as answers não-deletados.
    def index
        @answers = Answer.all
        render json: @answers, status: :ok
    end
    #Método HTTP GET
    #url: */api/v1/answers/:id
    #Retorna uma unica answer baseado no id
    def show
        begin
            @answer = Answer.find(params[:id])
            render json: @answer, status: :ok
        rescue ActiveRecord::RecordNotFound => e
            render json: {errors: {message: ["answer with id #{params[:id]} not found"]}}, status: :not_found
        rescue StandardError => e
            render json: {errors: {message: ["Internal Problem while responding"]}}, status: :internal_server_error
        end
    end
    #Método HTTP POST
    #url: */api/v1/answers
    #Cria uma nova answers e retorna o objeto criado com id
    def create
        @answer = Answer.new(answer_params)
        begin
            @question = Question.find(params[:question_id])
            @formulary = Formulary.find(params[:formulary_id])
            if(@question.formulary_id != @formulary.id)
                render json: {errors: 
                    {message: 
                        ["question with id #{params[:question_id]} does not belongs to formulary with id #{params[:formulary_id]}"]
                    }
                }, status: :unauthorized
                return
            end
        rescue ActiveRecord::RecordNotFound => e
            #Não é realizado nenhuma atividade aqui pois se o question não existir, o
            #método save irá identificar e adicionar a lista de erros.
        end
        if @answer.save
            render json: @answer, status: :ok
            return
        end
        render json: {errors: @answer.errors}, status: :bad_request
    end
    #Método HTTP PUT
    #url: */api/v1/answers/:id
    #Recebe como parametro quaisquer atributos de answer e atualiza o modelo
    def update
        begin
            @answer = Answer.find(params[:id])
            if @answer.update(answer_params)
                render json: @answer, status: :ok
                return
            end
            render json: {errors: @answer.errors}, status: :bad_request
        rescue ActiveRecord::RecordNotFound => e
            render json: {errors: {message: ["answer with id #{params[:id]} not found"]}}, status: :not_found
        rescue StandardError => e
            render json: {errors: {message: ["Internal Problem while responding"]}}, status: :internal_server_error
        end
    end
    #Método HTTP DELETE
    #url: */api/v1/answers/:id
    #Realiza o soft delete através do paranoia do modelo.
    def destroy
        begin 
            @answer = Answer.find(params[:id])
            @answer.destroy
            render json: {}, status: :no_content
        rescue ActiveRecord::RecordNotFound => e
            render json: {errors: {message: ["answer with id #{params[:id]} not found"]}}, status: :not_found
        rescue StandardError => e
            render json: {errors: {message: ["Internal Problem while responding"]}}, status: :internal_server_error
        end
    end

    private
        def convert_params
            begin
                params[:answered_at] == nil ? nil : params[:answered_at] = params[:answered_at].to_datetime
            rescue Date::Error => e
                render json: {errors: {answered_at: ["Invalid date"]}}, status: :bad_request
                return
            end
        end

        def answer_params
            params.permit(:content, :formulary_id, :question_id, :visit_id, :answered_at)
        end
end
