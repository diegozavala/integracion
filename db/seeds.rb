# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


#Spree::Core::Engine.load_seed if defined?(Spree::Core)
#Spree::Auth::Engine.load_seed if defined?(Spree::Auth)

puts("Creando api_users...")

api_users = ApiUser.create([{name: 'grupo2' , password: 'b0399d2029f64d445bd131ffaa399a42d2f8e7dc'},
#	{name: 'grupo1' , password: ''},
#	{name: 'grupo3' , password: ''},
	{name: 'grupo4' , password: '373f3f314f442d67ec9512e24b82d550e72a2ec3'},
	{name: 'grupo5' , password: '01b307acba4f54f55aafc33bb06bbbf6ca803e9a'},
  {name: 'grupo6' , password: 'ebdf1bdb858ced98b4adef024c3ec86fbdc141c9'},
	{name: 'grupo7' , password: 'a502ccca911d5c5f2a617de180cbcdc0626d6204'},
	{name: 'grupo8' , password: 'jvLuwdum9GupBZm/vtHZHpWZSCY=\n'}])