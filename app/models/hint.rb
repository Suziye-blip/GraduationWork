class Hint < ApplicationRecord
  def human_readable_gender
    if gender == 'male'
      '男性'
    elsif gender == 'female'
      '女性'
    end
  end
end
