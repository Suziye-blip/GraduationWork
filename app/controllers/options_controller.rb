class OptionsController < ApplicationController
  def show
    # 現在の設定値を取得（デフォルトは30）
    @candidate_count = session[:candidate_count] || 30
  end

  def update
    # フォームから送られてきた数値をセッションに保存
    session[:candidate_count] = params[:candidate_count].to_i
    flash[:notice] = "候補者数を #{session[:candidate_count]} 名に設定しました。"
    redirect_to option_path
  end
end
