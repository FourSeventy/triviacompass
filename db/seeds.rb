# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


#seed bars

Bar.create([{name: 'The 21\'st Amendment', address: '150 Bowdoin St.', city: 'Boston', state: 'MA', zip: '02108', phone: '6172277100', trivia_time: '8:00', trivia_day: 'Sunday', lat: '42.3583827', long:'-71.0626648'},
            {name: 'Urban Cantina', address: '76 Salem Street', city: 'Boston', state: 'MA', zip: '02113', phone: '8578290863', trivia_time: '6:00', trivia_day: 'Sunday', lat: '42.3636167', long: '-71.0559971'},
            {name: 'Salvatore\'s Theatre District', address: '545 Washington St.', city: 'Boston', state: 'MA', zip: '02111', phone: '6175425555', trivia_time: '6:30pm', trivia_day: 'Monday', lat: '42.3538915', long: '-71.0625755'},
            {name: 'Ducali Pizza', address: '289 Causeway St', city: 'Boston', state: 'MA', zip: '02113', phone: '6177424144', trivia_time: '8:00pm', trivia_day: 'Monday', lat: '42.3671213', long: '-71.0581281'},
            {name: 'Doyles', address: '3484 Washington St', city: 'Jamacia Plain', state: 'MA', zip: '02130', phone: '6175242345', trivia_time: '8:00pm', trivia_day: 'Tuesday', lat: '42.3064259', long: '-71.1072393'},
            {name: 'Porters Bar', address: '173 Portland St', city: 'Boston', state: 'MA', zip: '02114', phone: '6177427678', trivia_time: '7:30pm', trivia_day: 'Tuesday', lat: '42.3643811', long: '-71.0615221'},
            {name: 'Waterfront Cafe', address: '450 Commerical Street', city: 'Boston', state: 'MA', zip: '02109', phone: '6175234055', trivia_time: '8:30pm', trivia_day: 'Wednesday', lat: '42.3661621', long: '-71.0513005'},
            {name: 'McGreevey\'s', address: '911 Boylston St', city: 'Boston', state: 'MA', zip: '02115', phone: '6172620911', trivia_time: '7:00pm', trivia_day: 'Wednesday', lat: '42.3484721', long: '-71.0844275'},
            {name: 'Hennessey\'s Boston', address: '25 Union Street', city: 'Boston', state: 'MA', zip: '02108', phone: '6177422121', trivia_time: '6:00pm', trivia_day: 'Thursday', lat: '42.3604636', long: '-71.0567409'},
            {name: 'Coogan\'s', address: '171 Milk Street', city: 'Boston', state: 'MA', zip: '02109', phone: '6174517415', trivia_time: '7:00pm', trivia_day: 'Thursday', lat: '42.3582517', long: '-71.0533884'}

           ])



