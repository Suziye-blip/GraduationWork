class GamesController < ApplicationController
  def current_answer
    if session[:answer_id]
      @current_answer ||= Hint.find_by(id: session[:answer_id])
    end
  end
  helper_method :current_answer

  def start_new_game
    session[:answer_id] = nil
    session[:subject] = nil
    session[:predicate] = nil
    session[:question_count] = 0
    session[:exclusions] = []
    session[:inclusions] = []

    Hint.delete_all

    age_starts = [10, 20, 30, 40, 50, 60, 70]

    30.times do
      generated_age_start = age_starts.sample
      person = Gimei.unique.name 

      Hint.create!(
        name: person.kanji, 
        gender: person.gender.to_s, 
        age: generated_age_start,
        birthplace: Gimei.address.prefecture.to_s,
        job: FFaker::CompanyJA.position,
      )
    end

    flash[:notice] = "新しいゲームを開始しました。データが更新されました。"
    redirect_to game_path
  end

  def index
    if current_answer.nil?
      @answer = Hint.all.sample
      session[:answer_id] = @answer.id
    end
    
    @q = Hint.ransack(params[:q])
    
    @hints = @q.result(distinct: true)
               .exclude_conditions(session[:exclusions] || [])
               .include_conditions(session[:inclusions] || [])

    session[:question_count] ||= 0
  end

  def check
    @answer = current_answer
    
    if @answer.nil?
      flash[:alert] = "ゲームが初期化されていません。もう一度最初から開始してください。"
      redirect_to games_path and return
    end

    session[:question_count] = session[:question_count].to_i + 1

    question_subject   = params[:subject]
    question_predicate = params[:predicate]

    attribute_map = {
      "出身" => :birthplace,
      "役職" => :job,
      "性別" => :gender,
      "年齢" => :age,
      "名前" => :name,
      "氏名" => :name,
    }  

    target_attribute = attribute_map[question_subject]
    @is_correct = false

    if target_attribute && @answer.respond_to?(target_attribute)
      correct_value = @answer.send(target_attribute) 
      
      if target_attribute == :gender
        @is_correct = (
          (correct_value == "male"   && question_predicate == "男性") ||
          (correct_value == "female" && question_predicate == "女性")
        )
      elsif target_attribute == :age
         @is_correct = (correct_value.to_i == question_predicate.to_i)
      else
        @is_correct = (correct_value.to_s.downcase == question_predicate.downcase)
      end
      
    else
      flash[:alert] = "指定された項目は無効です。"
      redirect_to game_path and return
    end

    session[:subject]   = question_subject
    session[:predicate] = question_predicate

    if @is_correct
      if question_subject == "名前" || question_subject == "氏名"
        render :result and return
      else
        flash[:notice] = "はい"
        session[:inclusions] ||= []
        session[:inclusions] << { subject: question_subject, predicate: question_predicate }
        session[:inclusions].uniq!
      end
    else
      flash[:alert] = "いいえ"

      session[:exclusions] ||= []
      session[:exclusions] << { subject: question_subject, predicate: question_predicate }
      session[:exclusions].uniq!
    end
    
    redirect_to game_path 
  end

  def reset_game
    session[:answer_id] = nil
    session[:subject] = nil
    session[:predicate] = nil
    session[:question_count] = 0
    session[:exclusions] = []
    session[:inclusions] = []
    flash[:notice] = "ゲームをリセットしました。"
    redirect_to game_path
  end
end
