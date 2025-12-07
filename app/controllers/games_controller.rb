class GamesController < ApplicationController
  before_action :authenticate_user! 

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
    session[:start_time] = Time.now.to_i

    Hint.delete_all

    age_starts = [18,19,20,21,22,23]
    grade_starts = ["1年生","2年生","3年生","4年生"]
    faculty_starts = ["文学部","経済学部","法学部","教育学部","理学部","工学部","医学部"]

    30.times do
      generated_age_start = age_starts.sample
      generated_grade_start = grade_starts.sample
      generated_faculty_start = faculty_starts.sample
      person = Gimei.unique.name 

      Hint.create!(
        name: person.kanji, 
        gender: person.gender.to_s, 
        age: generated_age_start,
        grade: generated_grade_start,
        address: FFaker::AddressJA.tokyo_ward,
        faculty: generated_faculty_start,
      )
    end

    flash[:notice] = "候補者データが更新されました。"
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
      "学部" => :faculty,
      "住所" => :address,
      "学年" => :grade,
      "性別" => :gender,
      "年齢" => :age,
      "名前" => :name,
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
        end_time = Time.now.to_i
        start_time = session[:start_time].to_i
        @elapsed_time = end_time - start_time

      record_attributes = {
        number_of_time: session[:question_count],
        cleartime: @elapsed_time
      }

      if current_user.present?
        record_attributes[:user_id] = current_user.id
      end

      Record.create!(record_attributes)
      @records = Record.all.order(cleartime: :asc, number_of_time: :asc)

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
