class InputsController < ApplicationController
  def index
    @inputs = Input.all
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
