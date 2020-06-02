class FiscalsController < ApplicationController
  def index
  end

  def new
    @fiscal = Fiscal.find_by(user_id: current_user.id)
  end

  def create
    @fiscal = Fiscal.new
    @fiscal.user_id = current_user.id
    @fiscal.fiscal_year = Date.new(params[:year].to_i, params[:month].to_i, 1)
    if @fiscal.save
      flash[:notcie]="会計年度が新規登録されました。"
      redirect_to("/fiscals/#{current_user.id}/new")
    else
      render("fiscals/new")
    end
  end

  def edit
    @fiscal = Fiscal.find_by(user_id: current_user.id)
    if @fiscal == nil
      redirect_to("/fiscals/#{current_user.id}/new")
    end

  end

  def update
    @fiscal = Fiscal.find_by(user_id: current_user.id)
    @fiscal.fiscal_year = Date.new(params[:year].to_i, params[:month].to_i, 1)
    if @fiscal.save(validate: false)
      flash[:notice]="会計年度が更新されました。"
      redirect_to("/fiscals/#{current_user.id}/edit")
    else
      render("fiscals/edit")
    end

  end




end

