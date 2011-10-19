class DaysController < ApplicationController
  respond_to :js

  def change_quota
    @day = user.days.find(params[:id])
    @day.update_attribute(:quota, params[:quota].to_f)
    respond_to do |f|
      f.js
    end
  end 
end
