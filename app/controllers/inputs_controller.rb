class InputsController < ApplicationController
  def index
    @inputs = Input.all.paginate(page: params[:page], per_page: 10).order('created_at DESC')
   
    @images_info = []
    images = Dir.glob("public/images/animations/*.gif")
    images.each do |image|
      image_info = {}
      date = image.split('/').last.gsub(".gif","")
      image_info[:date] = date
      image_info[:path] = "images/animations/#{date}.gif"
      @images_info << image_info
    end
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

