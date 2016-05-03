class MyoFilesController < ApplicationController
  before_action :set_myo_file, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @myo_files = MyoFile.all
    respond_with(@myo_files)
  end

  def show
    respond_with(@myo_file)
  end

  def new
    @myo_file = MyoFile.new
    respond_with(@myo_file)
  end

  def edit
  end

  def create
    @myo_file = MyoFile.new(myo_file_params)
    @myo_file.save
    respond_with(@myo_file)
  end

  def update
    @myo_file.update(myo_file_params)
    respond_with(@myo_file)
  end

  def destroy
    @myo_file.destroy
    respond_with(@myo_file)
  end

  private
    def set_myo_file
      @myo_file = MyoFile.find(params[:id])
    end

    def myo_file_params
      params.require(:myo_file).permit(:trac_visit_id, :file)
    end
end
