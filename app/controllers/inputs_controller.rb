class InputsController < ApplicationController
  def index
    @inputs = Input.all.paginate(page: params[:page], per_page: 10).order('created_at DESC')
    @images = Dir.glob("app/assets/images/animations/*.gif")
  end

  def collect
    @input = Input.new Input.collect

    if @input.save
      redirect_to inputs_path, notice: 'Input collected!'
    else
      redirect_to inputs_path, notice: 'Input not collected :('
    end
  end
end

