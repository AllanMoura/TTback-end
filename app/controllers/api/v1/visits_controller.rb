class Api::V1::VisitsController < Api::V1::ApiController
    before_action :convert_params, only: [:create, :update]

    #Método HTTP GET
    #url: */api/v1/visits
    #Retorna todos as visitas não-deletados.
    def index
        @visits = Visit.all
        render json: @visits, status: :ok
    end
    #Método HTTP GET
    #url: */api/v1/visits/:id
    #Retorna uma visita não-deletada.
    def show
        begin
            @visit = Visit.find(params[:id])
            render json: @visit, status: :ok
        rescue ActiveRecord::RecordNotFound => e
            render json: {errors: {message: ["visit with id #{params[:id]} not found"]}}, status: :not_found
        rescue StandardError => e
            render json: {errors: {message: ["Internal Problem while responding"]}}, status: :internal_server_error
        end
    end
    #Método HTTP POST
    #url: */api/v1/visits
    #Cria uma nova visita e retorna o modelo criado com id
    def create
        begin
            @visit = Visit.new(visit_params)
        rescue ArgumentError => e
            render json: {errors: {status: ["Invalid status"]}}, status: :bad_request
            return
        end
        
        if @visit.save
            render json: @visit, status: :created
            return
        end
        
        render json: {errors: @visit.errors}, status: :bad_request
    end

    #Método HTTP PUT
    #url: */api/v1/visits/:id
    #Recebe como parametro quaisquer atributos de visit e atualiza o modelo
    def update
        begin
            @visit = Visit.find(params[:id])
            if @visit.update(visit_params)
                render json: @visit, status: :ok
                return
            end
            render json: {errors: @visit.errors}, status: :bad_request

        rescue ArgumentError => e
            render json: {errors: {status: ["Invalid status"]}}, status: :bad_request
        rescue ActiveRecord::RecordNotFound => e
            render json: {errors: {message: ["visit with id #{params[:id]} not found"]}}, status: :not_found
        rescue StandardError => e
            render json: {errors: {message: ["Internal Problem while responding"]}}, status: :internal_server_error
        end
    end
    #Método HTTP DELETE
    #url: */api/v1/visits/:id
    #Realiza o soft delete através do paranoia do modelo.
    def destroy
        begin 
            @visit = Visit.find(params[:id])
            @visit.destroy
            render json: {}, status: :no_content
        rescue ActiveRecord::RecordNotFound => e
            render json: {errors: {message: ["visit with id #{params[:id]} not found"]}}, status: :not_found
        rescue StandardError => e
            render json: {errors: {message: ["Internal Problem while responding"]}}, status: :internal_server_error
        end
    end

    private
        def convert_params
            begin
                params[:date] == nil ? nil : params[:date] = params[:date].to_date
                params[:status] == nil ? nil : params[:status] = params[:status].to_i
                params[:checkin_at] == nil ? nil : params[:checkin_at] = params[:checkin_at].to_datetime
                params[:checkout_at] == nil ? nil : params[:checkout_at] = params[:checkout_at].to_datetime
            rescue Date::Error => e
                render json: {errors: {date: ["Invalid date"]}}, status: :bad_request
                return
            end
        end

        def visit_params
            params.permit(:date, :status, :checkin_at, :checkout_at, :user_id)
        end
end
