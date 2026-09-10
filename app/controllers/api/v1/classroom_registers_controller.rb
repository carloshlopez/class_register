module Api
  module V1
    class ClassroomRegistersController < BaseController
      # GET /api/v1/classroom_registers
      def index
        @classroom_registers = ClassroomRegister.all
      end

      # GET /api/v1/classroom_registers/1
      def show
        @classroom_register = ClassroomRegister.find(params[:id])
      end

      # POST /api/v1/classroom_registers
      def create
        @classroom_register = ClassroomRegister.new(classroom_register_params)

        if @classroom_register.save
          render :show, status: :created
        else
          render json: @classroom_register.errors, status: :unprocessable_content
        end
      end

      private

      def classroom_register_params
        params.require(:classroom_register).permit(
          :happened_at, :attendees, :description, :chapter_id, :teacher_id,
          :registered_by, :audio, images: []
        )
      end
    end
  end
end
