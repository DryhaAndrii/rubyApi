10.times do |i|
    Item.create!(
      name: "Товар #{i+1}",
      description: "Описание товара #{i+1}",
      price: rand(100..1000)
    )
  end