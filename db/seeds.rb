# db/seeds.rb
Hint.destroy_all
puts 'Deleted all existing hints.'

60.times do
  person = Gimei.unique.name 

  Hint.create!(
    name: person.kanji, 
    gender: person.gender.to_s, 
    age: rand(18..70),
    birthplace: Gimei.address.prefecture.to_s,
    job: FFaker::JobJA.title,
  )
end
