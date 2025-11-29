# db/seeds.rb
Hint.destroy_all
puts 'Deleted all existing hints.'

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
