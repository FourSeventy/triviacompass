# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


#seed bars

Bar.create([{name: 'Doyles', address: '3484 Washington St', city: 'Jamacia Plain', state: 'MA', zip: '02130', phone: '6175242345', trivia_time: '8:00pm', trivia_day: 'Tuesday'},
            {name: 'Jerry Remy\'s', address: '1265 Boylston St', city: 'Boston', state: 'MA', zip: '02215', phone: '508123456', trivia_time: '7:00pm', trivia_day: 'Monday'},
            {name: 'Tip Tap Room', address: '138 Cambridge St', city: 'Boston', state: 'MA', zip: '02114',phone: '991123456',  trivia_time: '8:00pm', trivia_day: 'Wednesday'}
           ])