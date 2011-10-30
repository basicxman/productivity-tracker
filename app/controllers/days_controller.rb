class DaysController < ApplicationController
  include DaysHelper

  respond_to :js

  def change_quota
    @day = user.days.find(params[:id])
    @day.update_attribute(:quota, params[:quota].to_f)
  end 

  def display_month
    num_date
  end

  def fill_dates
    user.fill_future(number_to_date(params[:month].to_i, params[:year].to_i))
    num_date
    render :display_month
  end

  private

  def num_date
    @date = { :month => params[:month].to_i, :year => params[:year].to_i }
  end
end
