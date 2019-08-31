class ClassroomRegistersController < ApplicationController
  before_action :set_classroom_register, only: [:show, :edit, :update, :destroy]

  # GET /classroom_registers
  # GET /classroom_registers.json
  def index
    @classroom_registers = ClassroomRegister.all
  end

  # GET /classroom_registers/1
  # GET /classroom_registers/1.json
  def show
  end

  # GET /classroom_registers/new
  def new
    @classroom_register = ClassroomRegister.new
  end

  # GET /classroom_registers/1/edit
  def edit
  end

  # POST /classroom_registers
  # POST /classroom_registers.json
  def create
    @classroom_register = ClassroomRegister.new(classroom_register_params)

    respond_to do |format|
      if @classroom_register.save
        format.html { redirect_to @classroom_register, notice: 'Classroom register was successfully created.' }
        format.json { render :show, status: :created, location: @classroom_register }
      else
        format.html { render :new }
        format.json { render json: @classroom_register.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /classroom_registers/1
  # PATCH/PUT /classroom_registers/1.json
  def update
    respond_to do |format|
      if @classroom_register.update(classroom_register_params)
        format.html { redirect_to @classroom_register, notice: 'Classroom register was successfully updated.' }
        format.json { render :show, status: :ok, location: @classroom_register }
      else
        format.html { render :edit }
        format.json { render json: @classroom_register.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /classroom_registers/1
  # DELETE /classroom_registers/1.json
  def destroy
    @classroom_register.destroy
    respond_to do |format|
      format.html { redirect_to classroom_registers_url, notice: 'Classroom register was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_classroom_register
      @classroom_register = ClassroomRegister.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def classroom_register_params
      params.require(:classroom_register).permit(:happened_at, :attendees, :description, :chapter_id, :teacher_id, :audio, images: [])
    end
end
