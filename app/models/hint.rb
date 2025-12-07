class Hint < ApplicationRecord

  # Ransackによる検索・ソートを許可するカラムを定義 (Ransackの要件)
  def self.ransackable_attributes(auth_object = nil)
    ["id", "name", "age", "gender", "grade", "faculty","address", "created_at", "updated_at"]
  end
  
  # Ransackで検索可能な関連（アソシエーション）を定義 (現時点では関連がないため空欄)
  def self.ransackable_associations(auth_object = nil)
    [] 
  end

  def human_readable_gender
    case gender
    when 'male'
      '男性'
    when 'female'
      '女性'
    else
      gender # male/female 以外の場合はそのまま表示
    end
  end

  # 除外条件（「いいえ」だった条件）を受け取って絞り込むためのカスタムスコープ
  scope :exclude_conditions, ->(exclusions) do
    chain = self
    exclusions.each do |exclusion|
      # Ransackのハッシュ形式に合わせてキーをシンボルではなく文字列でアクセス
      subject = exclusion["subject"]
      predicate = exclusion["predicate"]
      
      attribute_map = {
        "学部" => :faculty, "学年" => :grade, "性別" => :gender,
        "年齢" => :age, "名前" => :name, "住所" => :address,
      }
      target_attribute = attribute_map[subject]

      if target_attribute
        # DBの値の形式に変換して除外クエリを構築 (where.not を使用)
        if target_attribute == :gender && (predicate == "男性" || predicate == "女性")
          db_value = (predicate == "男性") ? "male" : "female"
          chain = chain.where.not(target_attribute => db_value)
        else
          chain = chain.where.not(target_attribute => predicate)
        end
      end
    end
    chain
  end

  scope :include_conditions, ->(inclusions) do
    chain = self
    inclusions.each do |inclusion|
      subject = inclusion["subject"]
      predicate = inclusion["predicate"]
      
      attribute_map = {
        "学部" => :faculty, "学年" => :grade, "性別" => :gender,
        "年齢" => :age, "名前" => :name, "住所" => :address,
      }
      target_attribute = attribute_map[subject]

      if target_attribute
        # DBの値の形式に変換して包含クエリを構築 (where を使用)
        if target_attribute == :gender && (predicate == "男性" || predicate == "女性")
          db_value = (predicate == "男性") ? "male" : "female"
          chain = chain.where(target_attribute => db_value)
        else
          chain = chain.where(target_attribute => predicate)
        end
      end
    end
    chain
  end
end
