# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Post.delete_all
Post.create(title: 'Post 1',  
	description:      
		%{<p>
			Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse semper
			neque ut tincidunt ornare. Praesent vulputate, neque ut accumsan lobortis,
			ligula leo vulputate dui, ut rutrum ante neque non mi. Vivamus magna enim,
			accumsan at eros sit amet, porttitor tristique lacus. Cum sociis natoque
			penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec vel
			dolor magna. Integer rutrum scelerisque ipsum. In sed gravida justo. Donec
			pretium vehicula justo pulvinar fermentum. Class aptent taciti sociosqu ad
			litora torquent per conubia nostra, per inceptos himenaeos.       </p>},
	image_url:   'http://eofdreams.com/data_images/dreams/dog/dog-06.jpg') 
# . . .

Post.create(title: 'Post 2',     
	description:           
		%{<p>
			Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis blandit, nibh id
			vulputate venenatis, orci dolor faucibus velit, ut imperdiet justo lectus et
			tellus. Integer vitae lacus tempus, luctus elit in, hendrerit lorem. Proin
			bibendum augue a tempor lacinia. Aliquam gravida feugiat sollicitudin.
			Curabitur ut velit eros. Nulla sit amet libero vel tellus dapibus semper.
			Suspendisse sit amet mi molestie diam porta lobortis.      </p>},   
	image_url:
			'http://www.kenshim.com/wp-content/uploads/2009/06/jogging.jpg') 
# . . .

Post.create(title: 'Post 3', 
	description:  
	%{<p>
		Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam a nibh eget dui
			semper fringilla. Integer volutpat faucibus lectus et aliquam. Nam eleifend
			erat enim, sit amet blandit turpis ultricies pretium. Maecenas vulputate
			dapibus nibh quis rhoncus. Nulla eu orci lacinia, blandit libero a, molestie
			ante. Sed molestie nunc at dapibus laoreet. Aliquam nec interdum elit. Nam sit
			amet mauris vulputate lorem sodales venenatis. Maecenas a justo lectus.
			Phasellus sed arcu sed justo dictum scelerisque. Integer molestie est quis
			arcu vulputate semper.

      Phasellus non dui sed tellus bibendum pretium. In hac habitasse platea
			dictumst. Ut feugiat id lectus at rhoncus. Fusce varius bibendum nisl non
			sagittis. Vestibulum euismod porttitor rhoncus. Proin mollis, turpis at rutrum
			pellentesque, lorem ante feugiat elit, et imperdiet mauris velit ut libero.
			Phasellus tincidunt, sem eget varius rhoncus, dui eros interdum mauris, id
			pharetra libero magna condimentum orci. Morbi in semper mauris. Phasellus ac
			eros mi. In hac habitasse platea dictumst. Ut rutrum neque vel neque luctus,
			faucibus ornare diam scelerisque. Proin dolor erat, pretium id ullamcorper ac,
			sollicitudin sit amet lorem. Cras ullamcorper nisl id consequat blandit.</p>},
	image_url:
			'http://www.itilexams.org/wp-content/uploads/2013/02/Pass-Test-
			Marijuana-Detox-Detoxification.jpg')  
# . . .

