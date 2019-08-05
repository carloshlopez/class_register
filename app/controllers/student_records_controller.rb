class StudentRecordsController < ApplicationController
  before_action :set_student_record, only: [:show, :edit, :update, :destroy]

  # GET /student_records
  # GET /student_records.json
  def index
    @student_records = StudentRecord.all
  end

  # GET /student_records/1
  # GET /student_records/1.json
  def show
  end

  # GET /student_records/new
  def new
    @student_record = StudentRecord.new
  end

  # GET /student_records/1/edit
  def edit
  end

  # POST /student_records
  # POST /student_records.json
  def create
    @student_record = StudentRecord.new(student_record_params)

    respond_to do |format|
      if @student_record.save
        format.html { redirect_to @student_record, notice: 'Student record was successfully created.' }
        format.json { render :show, status: :created, location: @student_record }
      else
        format.html { render :new }
        format.json { render json: @student_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /student_records/1
  # PATCH/PUT /student_records/1.json
  def update
    respond_to do |format|
      if @student_record.update(student_record_params)
        format.html { redirect_to @student_record, notice: 'Student record was successfully updated.' }
        format.json { render :show, status: :ok, location: @student_record }
      else
        format.html { render :edit }
        format.json { render json: @student_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /student_records/1
  # DELETE /student_records/1.json
  def destroy
    @student_record.destroy
    respond_to do |format|
      format.html { redirect_to student_records_url, notice: 'Student record was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student_record
      @student_record = StudentRecord.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def student_record_params
      params.require(:student_record).permit(:desc, :points, :attended, :student_id, :chapter_id)
    end
end
