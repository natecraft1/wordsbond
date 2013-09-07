class YearsController < ApplicationController
  respond_to :json, only: [:show]
	def new
		@year = Year.new
    puts "************************************ #{@user}"
	end

  # def show
  #   render :json
  # end

  def create
    user = User.find_by_name(params[:name])
    puts "params === #{params}"
    year = Year.new(year_params)
    # year.id = params[:year][:year]
    user.years << year

    unless user.save
      flash[:notice] = user.years.last.errors.full_messages[0]
    end

    redirect_to name_path(user.name, params[:year][:year])

  end
  def update
    puts "params update ===> #{params}"
    user = User.find_by_name(params[:name])
    year = User.find_by_name(params[:name]).years.find_by_year(params[:age])
    year.update_attributes(year_params)
    redirect_to name_path(user.name, params[:year][:year])
    
  end
  def edit
    # @user = User.find_by_name(params[:name])
    @params = params
    puts "params = #{params}"
    # @year = @user.years.find_by_year(params[:age])
  end

	private
    def year_params
      params.require(:year).permit(:what_i_did, :lesson_or_story, :avatar, :year)
    end
end
